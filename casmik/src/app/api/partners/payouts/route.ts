import { NextResponse } from 'next/server';
import { getDatabase } from '@/lib/mongodb';
import { partners as defaultPartners, Partner } from '@/lib/casmikData';
import { notifyPartnerOrder } from '@/lib/partnerEvents';

export const dynamic = 'force-dynamic';

export interface PayoutTransaction {
  id: string;
  partnerId: string;
  orderId?: string;
  orderNumber?: string;
  amount: number;
  type: 'withdrawal' | 'commission' | 'spot_credit' | 'spot_payout' | 'float_topup';
  status: 'completed' | 'processing' | 'pending';
  method: 'bank_transfer' | 'instant_upi' | 'cash';
  referenceId: string;
  accountDetails: {
    bankName: string;
    accountNumber: string;
    ifscCode: string;
    holderName: string;
  };
  notes?: string;
  createdAt: string;
}

const payoutsStore: PayoutTransaction[] = [];

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const partnerId = searchParams.get('partnerId')?.trim() || 'partner-001';

    let partner: any = null;
    let partnerOrders: any[] = [];
    let dbPayouts: PayoutTransaction[] = [];

    try {
      const db = await getDatabase();
      const partnersCol = db.collection('partners');
      partner = await partnersCol.findOne({
        $or: [{ id: partnerId }, { email: partnerId }, { phone: partnerId }],
      });

      const ordersCol = db.collection('orders');
      partnerOrders = await ordersCol
        .find({
          $or: [
            { partnerId: partnerId },
            { assignedPartnerId: partnerId },
            ...(partner?.id ? [{ partnerId: partner.id }, { assignedPartnerId: partner.id }] : []),
          ],
        })
        .toArray();

      const payoutsCol = db.collection('payouts');
      const cursor = await payoutsCol
        .find({
          $or: [
            { partnerId: partnerId },
            ...(partner?.id ? [{ partnerId: partner.id }] : []),
          ],
        })
        .sort({ createdAt: -1 })
        .toArray();

      dbPayouts = cursor.map((doc: any) => ({
        id: doc.id || doc._id.toString(),
        partnerId: doc.partnerId,
        orderId: doc.orderId,
        orderNumber: doc.orderNumber,
        amount: doc.amount,
        type: doc.type || 'withdrawal',
        status: doc.status || 'completed',
        method: doc.method || 'instant_upi',
        referenceId: doc.referenceId || `TXN-${doc._id.toString().slice(-6)}`,
        accountDetails: doc.accountDetails || {
          bankName: 'Verified Account',
          accountNumber: '••••',
          ifscCode: '',
          holderName: partner?.name || 'Partner',
        },
        notes: doc.notes || '',
        createdAt: doc.createdAt || new Date().toISOString(),
      }));
    } catch (dbErr) {
      console.warn('MongoDB query warning in payouts GET:', dbErr);
    }

    if (!partner) {
      partner = defaultPartners.find((p) => p.id === partnerId) || defaultPartners[0];
    }

    const completedOrders = partnerOrders.filter(
      (o) => o.status === 'completed' || o.status === 'paid'
    );
    const totalLiquidated = completedOrders.reduce(
      (sum, o) => sum + Number(o.finalPrice || o.amount || o.quotedPrice || 0),
      0
    );

    const mergedPayouts = [...dbPayouts, ...payoutsStore.filter((p) => p.partnerId === partner?.id)];

    const bankDetails = {
      bankName: partner?.documents?.bankName || partner?.bankName || 'Verified Bank Account',
      accountNumber: partner?.documents?.accountNumber
        ? `•••• ${partner.documents.accountNumber.slice(-4)}`
        : (partner?.accountNumber ? `•••• ${partner.accountNumber.slice(-4)}` : '•••• 4892'),
      ifscCode: partner?.documents?.ifscCode || partner?.ifscCode || 'HDFC0001234',
      accountHolderName: partner?.name || 'Authorized Partner',
      isVerified: partner?.documents?.verified ?? true,
    };

    return NextResponse.json({
      success: true,
      wallet: {
        partnerId: partner?.id || partnerId,
        partnerName: partner?.name,
        storeName: partner?.storeName,
        availableBalance: partner?.availableBalance ?? 0,
        totalEarnings: totalLiquidated,
        pendingPayout: partner?.pendingPayout ?? 0,
        bankDetails,
      },
      payouts: mergedPayouts,
      stats: {
        totalLiquidated,
        spotPayoutsCount: completedOrders.length,
        pendingApprovalCount: mergedPayouts.filter((p) => p.status === 'pending').length,
      },
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch partner payouts' },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    let body: any;
    try {
      body = await request.json();
    } catch {
      try {
        const text = await request.text();
        body = JSON.parse(text);
      } catch {
        body = {};
      }
    }

    const partnerId = (body.partnerId || 'partner-001').trim();
    const orderId = body.orderId?.toString().trim();
    const orderNumber = body.orderNumber?.toString().trim();
    const amount = Number(body.amount);
    const isSpotPayout = Boolean(orderId || body.type === 'spot_payout' || body.type === 'spot_credit');
    const method = body.method === 'instant_upi'
      ? 'instant_upi'
      : (body.method === 'cash' ? 'cash' : 'bank_transfer');
    const notes = body.notes || (isSpotPayout ? `Spot payout for Order #${orderNumber || orderId}` : 'Float withdrawal to verified bank');

    if (!amount || isNaN(amount) || amount <= 0) {
      return NextResponse.json(
        { success: false, message: 'Invalid payout amount' },
        { status: 400 }
      );
    }

    let partner: any = null;
    let db: any = null;

    try {
      db = await getDatabase();
      const partnersCol = db.collection('partners');
      partner = await partnersCol.findOne({
        $or: [{ id: partnerId }, { email: partnerId }, { phone: partnerId }],
      });
    } catch (dbErr) {
      console.warn('MongoDB partner lookup note:', dbErr);
    }

    if (!partner) {
      partner = defaultPartners.find((p) => p.id === partnerId) || defaultPartners[0];
    }

    const refId = body.referenceId || `TXN-${Math.random().toString(36).substring(2, 9).toUpperCase()}`;

    const newTxn: PayoutTransaction = {
      id: `pay-${Date.now().toString().slice(-6)}`,
      partnerId: partner.id || partnerId,
      orderId,
      orderNumber,
      amount,
      type: isSpotPayout ? 'spot_payout' : 'withdrawal',
      status: 'completed',
      method,
      referenceId: refId,
      accountDetails: {
        bankName: body.bankName || partner.bankName || 'Verified Account',
        accountNumber: body.accountNumber || '••••',
        ifscCode: body.ifscCode || partner.ifscCode || '',
        holderName: body.customerName || partner.name || 'Payee',
      },
      notes,
      createdAt: new Date().toISOString(),
    };

    payoutsStore.unshift(newTxn);

    // If orderId is provided, mark order as completed & paid in MongoDB
    if (orderId && db) {
      try {
        const ordersCol = db.collection('orders');
        await ordersCol.updateOne(
          { $or: [{ id: orderId }, { orderNumber: orderId }, { orderNumber: orderNumber }] },
          {
            $set: {
              status: 'completed',
              paymentStatus: 'paid',
              finalPrice: amount,
              paidAt: new Date().toISOString(),
              payoutReferenceId: refId,
              payoutMethod: method,
              updatedAt: new Date().toISOString(),
            },
          }
        );

        const updatedOrder = await ordersCol.findOne({
          $or: [{ id: orderId }, { orderNumber: orderId }, { orderNumber: orderNumber }],
        });

        if (updatedOrder && partner.id) {
          notifyPartnerOrder(partner.id, updatedOrder);
        }
      } catch (orderUpdateErr) {
        console.warn('Error updating order on spot payout:', orderUpdateErr);
      }
    }

    // Save payout to MongoDB
    if (db) {
      try {
        const payoutsCol = db.collection('payouts');
        await payoutsCol.insertOne({ ...newTxn, createdAt: new Date() });
      } catch (payoutInsertErr) {
        console.warn('Error saving payout to MongoDB:', payoutInsertErr);
      }
    }

    return NextResponse.json({
      success: true,
      message: isSpotPayout
        ? `Spot payout of ₹${amount.toLocaleString('en-IN')} disbursed successfully! Order moved to Completed.`
        : `Withdrawal request for ₹${amount.toLocaleString('en-IN')} confirmed!`,
      payout: newTxn,
      wallet: {
        availableBalance: partner.availableBalance ?? 0,
        totalEarnings: (partner.totalEarnings ?? 0) + (isSpotPayout ? amount : 0),
        pendingPayout: partner.pendingPayout ?? 0,
      },
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to process payout' },
      { status: 500 }
    );
  }
}

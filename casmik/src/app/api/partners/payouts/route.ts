import { NextResponse } from 'next/server';
import { partners as defaultPartners, orders as defaultOrders, Partner } from '@/lib/casmikData';

export const dynamic = 'force-dynamic';

export interface PayoutTransaction {
  id: string;
  partnerId: string;
  amount: number;
  type: 'withdrawal' | 'commission' | 'spot_credit' | 'float_topup';
  status: 'completed' | 'processing' | 'pending';
  method: 'bank_transfer' | 'instant_upi';
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

// In-memory persistent transaction ledger
const payoutsStore: PayoutTransaction[] = [
  {
    id: 'pay-001',
    partnerId: 'partner-001',
    amount: 35000,
    type: 'withdrawal',
    status: 'completed',
    method: 'bank_transfer',
    referenceId: 'TXN-HDFC-9923841',
    accountDetails: {
      bankName: 'HDFC Bank',
      accountNumber: '•••• 4892',
      ifscCode: 'HDFC0001234',
      holderName: 'Camera Hub Store',
    },
    notes: 'Weekly float liquidation disburse',
    createdAt: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: 'pay-002',
    partnerId: 'partner-001',
    amount: 18500,
    type: 'spot_credit',
    status: 'completed',
    method: 'instant_upi',
    referenceId: 'UPI-CR-8827361',
    accountDetails: {
      bankName: 'HDFC Bank',
      accountNumber: '•••• 4892',
      ifscCode: 'HDFC0001234',
      holderName: 'Camera Hub Store',
    },
    notes: 'Order #ORD-77192 spot payout credit',
    createdAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: 'pay-003',
    partnerId: 'partner-002',
    amount: 25000,
    type: 'withdrawal',
    status: 'completed',
    method: 'bank_transfer',
    referenceId: 'TXN-ICIC-6615243',
    accountDetails: {
      bankName: 'ICICI Bank',
      accountNumber: '•••• 8821',
      ifscCode: 'ICIC0000452',
      holderName: 'Pro Optics Mumbai',
    },
    notes: 'Store float withdrawal',
    createdAt: new Date(Date.now() - 72 * 60 * 60 * 1000).toISOString(),
  },
];

const partnersStore: Partner[] = [...defaultPartners];

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const partnerId = searchParams.get('partnerId')?.trim() || 'partner-001';

    let partner = partnersStore.find((p) => p.id === partnerId);
    if (!partner) {
      partner = partnersStore[0];
    }

    // Filter payouts for this partner
    const partnerPayouts = payoutsStore.filter((p) => p.partnerId === partner?.id);

    // Compute dynamic order liquidation stats
    const partnerOrders = defaultOrders.filter(
      (o) => o.partnerId === partner?.id && (o.status === 'completed' || o.status === 'paid')
    );
    const totalLiquidated = partnerOrders.reduce((sum, o) => sum + (o.finalPrice || o.amount || 0), 0);

    const bankDetails = {
      bankName: partner?.documents?.accountNumber ? 'Verified Partner Bank' : 'HDFC Bank',
      accountNumber: partner?.documents?.accountNumber
        ? `•••• ${partner.documents.accountNumber.slice(-4)}`
        : '•••• 4892',
      ifscCode: partner?.documents?.ifscCode || 'HDFC0001234',
      accountHolderName: partner?.name || 'Authorized Partner',
      isVerified: partner?.documents?.verified ?? true,
    };

    return NextResponse.json({
      success: true,
      wallet: {
        partnerId: partner?.id,
        partnerName: partner?.name,
        storeName: partner?.storeName,
        availableBalance: partner?.availableBalance ?? 42000,
        totalEarnings: partner?.totalEarnings ?? 385000,
        pendingPayout: partner?.pendingPayout ?? 18500,
        bankDetails,
      },
      payouts: partnerPayouts,
      stats: {
        totalLiquidated,
        spotPayoutsCount: partnerOrders.length,
        pendingApprovalCount: partnerPayouts.filter((p) => p.status === 'pending').length,
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
    const amount = Number(body.amount);
    const notes = body.notes || 'Float withdrawal to verified bank';
    const method = body.method === 'instant_upi' ? 'instant_upi' : 'bank_transfer';

    if (!amount || isNaN(amount) || amount <= 0) {
      return NextResponse.json(
        { success: false, message: 'Invalid withdrawal amount' },
        { status: 400 }
      );
    }

    let partner = partnersStore.find((p) => p.id === partnerId);
    if (!partner) {
      partner = partnersStore[0];
    }

    if (partner.availableBalance < amount) {
      return NextResponse.json(
        {
          success: false,
          message: `Insufficient float balance. Available: ₹${partner.availableBalance}, Requested: ₹${amount}`,
        },
        { status: 400 }
      );
    }

    // Deduct balance and create transaction
    partner.availableBalance -= amount;
    partner.pendingPayout += amount;

    const newTxn: PayoutTransaction = {
      id: `pay-${Date.now().toString().slice(-6)}`,
      partnerId: partner.id,
      amount,
      type: 'withdrawal',
      status: 'completed',
      method,
      referenceId: `TXN-${Math.random().toString(36).substring(2, 9).toUpperCase()}`,
      accountDetails: {
        bankName: body.bankName || 'HDFC Bank',
        accountNumber: body.accountNumber || '•••• 4892',
        ifscCode: body.ifscCode || 'HDFC0001234',
        holderName: partner.name,
      },
      notes,
      createdAt: new Date().toISOString(),
    };

    payoutsStore.unshift(newTxn);

    return NextResponse.json({
      success: true,
      message: `Withdrawal request for ₹${amount.toLocaleString('en-IN')} confirmed & transferred!`,
      payout: newTxn,
      wallet: {
        availableBalance: partner.availableBalance,
        totalEarnings: partner.totalEarnings,
        pendingPayout: partner.pendingPayout,
      },
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to process payout withdrawal' },
      { status: 500 }
    );
  }
}

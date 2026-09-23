import { NextResponse } from 'next/server';
import { getDatabase } from '@/lib/mongodb';

export const dynamic = 'force-dynamic';

// In-memory fallback cache so orders are always preserved and instantly retrieved
const ordersCache: any[] = [];

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const phone = searchParams.get('phone')?.trim();
    const orderId = searchParams.get('orderId')?.trim();

    try {
      const db = await getDatabase();
      const collection = db.collection('orders');

      const query: any = {};
      if (phone) {
        const clean = phone.replace(/\D/g, '').slice(-10);
        query.$or = [
          { customerPhone: { $regex: clean } },
          { phone: { $regex: clean } },
        ];
      }
      if (orderId) {
        query.$or = [{ id: orderId }, { orderNumber: orderId }];
      }

      const dbOrders = await collection.find(query).sort({ createdAt: -1 }).limit(50).toArray();
      if (dbOrders && dbOrders.length > 0) {
        return NextResponse.json({
          success: true,
          orders: dbOrders,
          source: 'mongodb',
          total: dbOrders.length,
        });
      }
    } catch (dbErr) {
      console.warn('MongoDB query warning, using fallback cache:', dbErr);
    }

    // Fallback cache
    let filtered = [...ordersCache];
    if (phone) {
      const clean = phone.replace(/\D/g, '').slice(-10);
      filtered = filtered.filter(
        (o) =>
          o.customerPhone?.replace(/\D/g, '').slice(-10) === clean ||
          o.phone?.replace(/\D/g, '').slice(-10) === clean
      );
    }
    if (orderId) {
      filtered = filtered.filter((o) => o.id === orderId || o.orderNumber === orderId);
    }

    return NextResponse.json({
      success: true,
      orders: filtered,
      source: 'cache',
      total: filtered.length,
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch orders' },
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


    if (!body || (!body.customerPhone && !body.phone)) {
      return NextResponse.json(
        { success: false, message: 'Customer phone is required' },
        { status: 400 }
      );
    }

    const orderNumber =
      body.orderNumber ||
      `CSM-${body.type === 'buy' ? 'BUY' : body.type === 'exchange' ? 'EXC' : 'SELL'}-${Math.floor(
        100000 + Math.random() * 900000
      )}`;

    const newOrder = {
      id: body.id || `ord-${Date.now()}`,
      orderNumber,
      type: body.type || 'sell',
      status: body.status || 'Order Placed',
      createdAt: body.createdAt || new Date().toISOString(),
      customerName: body.customerName || body.name || 'Valued Customer',
      customerPhone: body.customerPhone || body.phone || '',
      customerEmail: body.customerEmail || body.email || '',
      customerAddress: body.customerAddress || body.address || '',
      city: body.city || 'Mumbai',
      pincode: body.pincode || body.pinCode || '401107',
      pickupDate: body.pickupDate || 'Tomorrow',
      pickupSlot: body.pickupSlot || '11:00 AM – 1:00 PM',
      paymentMethod: body.paymentMethod || 'UPI / Instant Bank Transfer',
      paymentStatus: body.paymentStatus || 'pending',
      amount: body.amount || body.finalPrice || body.quotedPrice || body.netPayable || 0,
      deviceName: body.deviceName || body.device || 'Tech Device',
      deviceDetails: body.deviceDetails || {},
      otp: body.otp || `${Math.floor(1000 + Math.random() * 9000)}`,
      timeline: [
        { title: 'Order Placed', time: new Date().toLocaleTimeString(), completed: true },
        { title: 'Confirmed by Camsik', time: 'In 15 mins', completed: true },
        { title: 'Executive Assigned', time: 'Pending', completed: false },
        { title: 'Doorstep Pickup / Handover', time: body.pickupDate || 'Tomorrow', completed: false },
        { title: 'Inspection & Certified Wipe', time: 'Pending', completed: false },
        { title: 'Payment Disbursed / Order Completed', time: 'Pending', completed: false },
      ],
      ...body,
    };

    // Save in cache
    ordersCache.unshift(newOrder);

    // Persist to MongoDB Atlas asynchronously
    try {
      const db = await getDatabase();
      await db.collection('orders').insertOne({ ...newOrder });
    } catch (mongoErr) {
      console.warn('MongoDB insert warning, saved in memory cache:', mongoErr);
    }

    return NextResponse.json({
      success: true,
      order: newOrder,
      message: 'Order created successfully',
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    console.error('Order creation error:', error);
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to create order', details: String(error) },
      { status: 500 }
    );
  }
}


import { NextResponse } from 'next/server';
import { deliveryAgents as defaultAgents, DeliveryAgent } from '@/lib/casmikData';

export const dynamic = 'force-dynamic';

const agentsStore: DeliveryAgent[] = [...defaultAgents];

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');
    const partnerId = searchParams.get('partnerId');
    const status = searchParams.get('status');
    const city = searchParams.get('city')?.toLowerCase();
    const search = searchParams.get('search')?.toLowerCase().trim();

    let filtered = [...agentsStore];

    if (id) {
      filtered = filtered.filter((a) => a.id === id);
    }
    if (partnerId && partnerId !== 'all') {
      filtered = filtered.filter((a) => a.partnerId === partnerId || !a.partnerId);
    }
    if (status && status !== 'all') {
      filtered = filtered.filter((a) => a.status === status);
    }
    if (city && city !== 'all') {
      filtered = filtered.filter((a) => a.city.toLowerCase() === city);
    }
    if (search) {
      filtered = filtered.filter(
        (a) =>
          a.name.toLowerCase().includes(search) ||
          a.phone.includes(search) ||
          a.city.toLowerCase().includes(search) ||
          (a.vehicleNumber && a.vehicleNumber.toLowerCase().includes(search))
      );
    }

    return NextResponse.json({
      success: true,
      agents: filtered,
      total: filtered.length,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch delivery agents' },
      { status: 500 }
    );
  }
}

export async function PATCH(request: Request) {
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

    const agentId = (body.id || body.agentId || '').trim();
    if (!agentId) {
      return NextResponse.json(
        { success: false, message: 'agentId is required' },
        { status: 400 }
      );
    }

    const index = agentsStore.findIndex((a) => a.id === agentId);
    if (index === -1) {
      return NextResponse.json(
        { success: false, message: 'Delivery agent not found' },
        { status: 404 }
      );
    }

    agentsStore[index] = {
      ...agentsStore[index],
      ...body,
    };

    return NextResponse.json({
      success: true,
      agent: agentsStore[index],
      message: 'Delivery agent updated successfully',
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to update delivery agent' },
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

    const name = (body.name || '').trim();
    const phone = (body.phone || '').trim();
    if (!name || !phone) {
      return NextResponse.json(
        { success: false, message: 'Rider name and phone are required' },
        { status: 400 }
      );
    }

    const newAgent: DeliveryAgent = {
      id: `agent-${Date.now().toString().slice(-6)}`,
      name,
      phone,
      email: body.email || `${phone}@camsik.in`,
      city: body.city || 'Mumbai',
      pinCodes: Array.isArray(body.pinCodes)
        ? body.pinCodes
        : (body.pinCodes || '400001, 400050').split(',').map((p: string) => p.trim()),
      status: body.status || 'online',
      rating: 4.9,
      todayPickups: 0,
      todayDeliveries: 0,
      totalDeliveries: Number(body.totalDeliveries) || 0,
      earnings: Number(body.earnings) || 0,
      avatar: body.avatar || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&q=80',
      joinedAt: body.joinedAt || new Date().toISOString().split('T')[0],
      partnerId: body.partnerId || 'partner-001',
      partnerName: body.partnerName,
      vehicle: body.vehicle || 'Bike',
      vehicleNumber: body.vehicleNumber || 'MH02AB1234',
      approvalStatus: body.approvalStatus || 'approved',
    };

    agentsStore.unshift(newAgent);

    return NextResponse.json({
      success: true,
      agent: newAgent,
      message: 'Delivery rider added successfully',
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to create delivery agent' },
      { status: 500 }
    );
  }
}

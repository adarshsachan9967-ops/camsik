import { NextResponse } from 'next/server';
import { deliveryAgents as defaultAgents, DeliveryAgent } from '@/lib/casmikData';

export const dynamic = 'force-dynamic';

const agentsStore: DeliveryAgent[] = [...defaultAgents];

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');
    const status = searchParams.get('status');
    const city = searchParams.get('city')?.toLowerCase();
    const search = searchParams.get('search')?.toLowerCase().trim();

    let filtered = [...agentsStore];

    if (id) {
      filtered = filtered.filter((a) => a.id === id);
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

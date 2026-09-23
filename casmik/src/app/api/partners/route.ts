import { NextResponse } from 'next/server';
import { partners as defaultPartners, Partner } from '@/lib/casmikData';

export const dynamic = 'force-dynamic';

const partnersStore: Partner[] = [...defaultPartners];

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const id = searchParams.get('id');
    const status = searchParams.get('status');
    const city = searchParams.get('city')?.toLowerCase();
    const search = searchParams.get('search')?.toLowerCase().trim();

    let filtered = [...partnersStore];

    if (id) {
      filtered = filtered.filter((p) => p.id === id);
    }
    if (status && status !== 'all') {
      filtered = filtered.filter((p) => p.status === status);
    }
    if (city && city !== 'all') {
      filtered = filtered.filter((p) => p.city.toLowerCase() === city);
    }
    if (search) {
      filtered = filtered.filter(
        (p) =>
          p.name.toLowerCase().includes(search) ||
          p.storeName.toLowerCase().includes(search) ||
          p.phone.includes(search) ||
          p.city.toLowerCase().includes(search)
      );
    }

    return NextResponse.json({
      success: true,
      partners: filtered,
      total: filtered.length,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch partners' },
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

    const partnerId = (body.id || body.partnerId || '').trim();
    if (!partnerId) {
      return NextResponse.json(
        { success: false, message: 'partnerId is required' },
        { status: 400 }
      );
    }

    const index = partnersStore.findIndex((p) => p.id === partnerId);
    if (index === -1) {
      return NextResponse.json(
        { success: false, message: 'Partner not found' },
        { status: 404 }
      );
    }

    partnersStore[index] = {
      ...partnersStore[index],
      ...body,
    };

    return NextResponse.json({
      success: true,
      partner: partnersStore[index],
      message: 'Partner updated successfully',
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to update partner' },
      { status: 500 }
    );
  }
}

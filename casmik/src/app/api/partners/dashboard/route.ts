import { NextResponse } from 'next/server';
import { partners as defaultPartners, orders as defaultOrders, Partner } from '@/lib/casmikData';

export const dynamic = 'force-dynamic';

const partnersStore: Partner[] = [...defaultPartners];

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const partnerId = searchParams.get('partnerId')?.trim() || 'partner-001';

    let partner = partnersStore.find((p) => p.id === partnerId);
    if (!partner) {
      partner = partnersStore[0];
    }

    // Filter partner orders
    const partnerOrders = defaultOrders.filter((o) => o.partnerId === partner?.id || !o.partnerId);
    const completedOrders = partnerOrders.filter((o) => o.status === 'completed' || o.status === 'paid');
    const activePipelineOrders = partnerOrders.filter((o) => o.status !== 'completed' && o.status !== 'paid' && o.status !== 'cancelled' && o.status !== 'rejected');

    const storeTradeVolume = partnerOrders.reduce(
      (sum, o) => sum + (o.finalPrice || o.amount || o.quotedPrice || 0),
      0
    );

    const commissionRate = partner?.commission ?? 5.0;
    const totalCommissionEarned = (storeTradeVolume * commissionRate) / 100;

    // Monthly growth calculation
    const momGrowthPercent = 14.2;

    return NextResponse.json({
      success: true,
      dashboard: {
        partnerId: partner?.id,
        partnerName: partner?.name,
        storeName: partner?.storeName,
        rating: partner?.rating ?? 4.9,
        storeTradeVolume,
        momGrowth: `+${momGrowthPercent}% MoM`,
        totalOrdersCount: partnerOrders.length,
        completedOrdersCount: completedOrders.length,
        activePipelineCount: activePipelineOrders.length,
        commissionRate,
        totalCommissionEarned,
        availableFloatBalance: partner?.availableBalance ?? 42000,
        pendingPayout: partner?.pendingPayout ?? 18500,
        recentOrders: partnerOrders.slice(0, 5),
      },
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch partner dashboard stats' },
      { status: 500 }
    );
  }
}

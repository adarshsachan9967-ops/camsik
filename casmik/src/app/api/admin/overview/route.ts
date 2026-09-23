import { NextResponse } from 'next/server';
import { orders as defaultOrders, partners, deliveryAgents } from '@/lib/casmikData';
import { defaultRefurbishedProducts } from '@/lib/refurbishedCatalog';

export const dynamic = 'force-dynamic';

export async function GET() {
  try {
    const totalOrders = defaultOrders.length;
    const totalRevenue = defaultOrders.reduce((sum, o) => sum + (o.finalPrice || o.quotedPrice || 0), 0);
    const completedOrders = defaultOrders.filter((o) => o.status === 'completed' || o.status === 'paid').length;
    const pendingOrders = defaultOrders.filter((o) => o.status !== 'completed' && o.status !== 'cancelled' && o.status !== 'rejected').length;

    const sellOrders = defaultOrders.filter((o) => o.type === 'sell').length;
    const buyOrders = defaultOrders.filter((o) => o.type === 'buy').length;
    const exchangeOrders = defaultOrders.filter((o) => o.type === 'exchange').length;
    const repairOrders = defaultOrders.filter((o) => o.type === 'repair').length;

    const activePartners = partners.filter((p) => p.status === 'active').length;
    const onlineAgents = deliveryAgents.filter((a) => a.status === 'online').length;
    const totalInventory = defaultRefurbishedProducts.length;

    const recentOrders = defaultOrders.slice(0, 5);

    return NextResponse.json({
      success: true,
      stats: {
        totalOrders,
        totalRevenue,
        completedOrders,
        pendingOrders,
        sellOrders,
        buyOrders,
        exchangeOrders,
        repairOrders,
        activePartners,
        totalPartners: partners.length,
        onlineAgents,
        totalAgents: deliveryAgents.length,
        totalInventory,
      },
      recentOrders,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to calculate admin overview' },
      { status: 500 }
    );
  }
}

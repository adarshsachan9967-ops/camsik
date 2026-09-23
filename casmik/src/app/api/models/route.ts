import { NextResponse } from 'next/server';
import { deviceModels, brands } from '@/lib/casmikData';

export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const categoryId = searchParams.get('categoryId');
    const brandId = searchParams.get('brandId');
    const search = searchParams.get('search')?.toLowerCase().trim();

    let filtered = deviceModels.filter((m) => m.active);

    if (categoryId && categoryId !== 'all') {
      filtered = filtered.filter((m) => m.categoryId === categoryId);
    }

    if (brandId && brandId !== 'all') {
      filtered = filtered.filter((m) => m.brandId === brandId);
    }

    if (search) {
      filtered = filtered.filter((m) =>
        m.name.toLowerCase().includes(search) ||
        m.slug.toLowerCase().includes(search) ||
        (m.alt && m.alt.toLowerCase().includes(search))
      );
    }

    // Associated brands
    const activeBrands = categoryId && categoryId !== 'all'
      ? brands.filter((b) => b.categoryId === categoryId && b.active)
      : brands.filter((b) => b.active);

    return NextResponse.json({
      success: true,
      models: filtered,
      brands: activeBrands,
      total: filtered.length,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch device models' },
      { status: 500 }
    );
  }
}

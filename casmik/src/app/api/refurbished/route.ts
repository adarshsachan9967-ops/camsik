import { NextResponse } from 'next/server';
import { defaultRefurbishedProducts, RefurbishedProduct } from '@/lib/refurbishedCatalog';

export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const category = searchParams.get('category');
    const condition = searchParams.get('condition');
    const modelId = searchParams.get('modelId');
    const search = searchParams.get('search')?.toLowerCase().trim();

    let products: RefurbishedProduct[] = [...defaultRefurbishedProducts];

    if (category && category !== 'all') {
      products = products.filter(
        (p) => p.category.toLowerCase() === category.toLowerCase()
      );
    }

    if (condition && condition !== 'all') {
      products = products.filter(
        (p) => p.condition.toLowerCase() === condition.toLowerCase()
      );
    }

    if (modelId) {
      products = products.filter((p) => p.modelId === modelId);
    }

    if (search) {
      products = products.filter(
        (p) =>
          p.model.toLowerCase().includes(search) ||
          p.brand.toLowerCase().includes(search) ||
          p.specs.toLowerCase().includes(search)
      );
    }

    return NextResponse.json({
      success: true,
      products,
      total: products.length,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch refurbished products' },
      { status: 500 }
    );
  }
}

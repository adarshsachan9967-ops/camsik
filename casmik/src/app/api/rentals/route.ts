import { NextResponse } from 'next/server';
import { defaultRentalCameras, RentalCamera } from '@/lib/rentalCatalog';
import { getDatabase } from '@/lib/mongodb';

export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const category = searchParams.get('category');
    const brand = searchParams.get('brand');
    const search = searchParams.get('search')?.toLowerCase().trim();

    let cameras: RentalCamera[] = [...defaultRentalCameras];

    try {
      const db = await getDatabase();
      const dbCameras = await db.collection('rental_cameras').find({}).toArray();
      if (dbCameras && dbCameras.length > 0) {
        // Merge or replace defaults with DB items
        const dbMap = new Map(dbCameras.map((c: any) => [c.id || c.modelId, c]));
        cameras = cameras.map((c) => dbMap.get(c.id) || c);
        // Add any non-default DB cameras
        for (const [id, c] of dbMap.entries()) {
          if (!cameras.some((cam) => cam.id === id)) {
            cameras.push(c as any);
          }
        }
      }
    } catch (e) {
      // In-memory fallback
    }

    if (category && category !== 'all') {
      cameras = cameras.filter(
        (c) => c.category.toLowerCase() === category.toLowerCase()
      );
    }

    if (brand && brand !== 'all') {
      cameras = cameras.filter(
        (c) => c.brand.toLowerCase() === brand.toLowerCase()
      );
    }

    if (search) {
      cameras = cameras.filter(
        (c) =>
          c.model.toLowerCase().includes(search) ||
          c.brand.toLowerCase().includes(search) ||
          c.specs.toLowerCase().includes(search) ||
          c.category.toLowerCase().includes(search)
      );
    }

    return NextResponse.json({
      success: true,
      count: cameras.length,
      cameras,
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Failed to fetch rentals' },
      { status: 500 }
    );
  }
}

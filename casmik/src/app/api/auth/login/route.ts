import { NextResponse } from 'next/server';
import { findUserByIdentifier } from '@/lib/userStore';

export const dynamic = 'force-dynamic';

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

    const identifier = (body.identifier || body.phone || body.email || '').trim();
    const cleanPhone = identifier.replace(/\D/g, '').slice(-10);
    const password = (body.password || '').trim();

    if (!identifier) {
      return NextResponse.json(
        { success: false, message: 'Please enter your mobile number or email address' },
        { status: 400 }
      );
    }

    if (!password) {
      return NextResponse.json(
        { success: false, message: 'Please enter your account password' },
        { status: 400 }
      );
    }

    const user = await findUserByIdentifier(identifier);

    if (!user) {
      return NextResponse.json(
        { success: false, message: 'Account not found. Please check your credentials or create a new account.' },
        { status: 404 }
      );
    }

    // Verify password strictly
    if (!user.passwordHash || user.passwordHash !== password) {
      return NextResponse.json(
        { success: false, message: 'Incorrect password. Please enter the correct password.' },
        { status: 401 }
      );
    }

    return NextResponse.json({
      success: true,
      message: 'Logged in successfully',
      user: {
        id: user.id,
        name: user.name || 'Camsik Customer',
        phone: user.phone || cleanPhone,
        email: user.email || `${cleanPhone}@camsik.in`,
        createdAt: user.createdAt || new Date().toISOString(),
      },
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, message: error?.message || 'Login failed. Please try again.' },
      { status: 500 }
    );
  }
}

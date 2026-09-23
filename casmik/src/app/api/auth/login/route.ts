import { NextResponse } from 'next/server';
import { findUserByIdentifier } from '@/lib/userStore';
import { partners, deliveryAgents } from '@/lib/casmikData';

export const dynamic = 'force-dynamic';

const VALID_ADMIN_EMAILS = [
  'casmikadmin9967@gmail.com',
  'admin@casmik.com',
  'admin@camsik.com',
];
const ADMIN_PASSWORD = 'Casmik@9967';

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
    const cleanEmail = identifier.toLowerCase();
    const password = (body.password || '').trim();
    const requestedRole = (body.role || '').toLowerCase().trim();

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

    // 1. ADMIN CHECK
    if (requestedRole === 'admin' || VALID_ADMIN_EMAILS.includes(cleanEmail)) {
      if (VALID_ADMIN_EMAILS.includes(cleanEmail) && password === ADMIN_PASSWORD) {
        return NextResponse.json({
          success: true,
          role: 'admin',
          message: 'Admin authenticated successfully',
          user: {
            id: 'admin-super-01',
            name: 'Camsik Super Admin',
            email: cleanEmail,
            role: 'admin',
            createdAt: new Date().toISOString(),
          },
        });
      }
      if (requestedRole === 'admin') {
        return NextResponse.json(
          { success: false, message: 'Invalid admin credentials' },
          { status: 401 }
        );
      }
    }

    // 2. PARTNER CHECK
    if (
      requestedRole === 'partner' ||
      cleanEmail === 'partner@camsik.com' ||
      cleanEmail === 'partner@casmik.com' ||
      cleanEmail === 'contact@camerahub.in'
    ) {
      const partner = partners.find(
        (p) =>
          p.email.toLowerCase() === cleanEmail ||
          p.phone.replace(/\D/g, '').slice(-10) === cleanPhone
      );

      if (partner || cleanEmail === 'partner@camsik.com' || cleanEmail === 'partner@casmik.com') {
        const activePartner = partner || partners[0];
        return NextResponse.json({
          success: true,
          role: 'partner',
          message: 'Partner authenticated successfully',
          partner: activePartner,
          user: {
            id: activePartner.id,
            name: activePartner.name,
            storeName: activePartner.storeName,
            phone: activePartner.phone,
            email: activePartner.email,
            role: 'partner',
            city: activePartner.city,
            joinedAt: activePartner.joinedAt,
          },
        });
      }

      if (requestedRole === 'partner') {
        return NextResponse.json(
          { success: false, message: 'No registered partner account found with these credentials' },
          { status: 404 }
        );
      }
    }

    // 3. DELIVERY AGENT CHECK
    if (
      requestedRole === 'delivery' ||
      cleanEmail === 'delivery@camsik.com' ||
      cleanEmail === 'delivery@casmik.com'
    ) {
      const agent = deliveryAgents.find(
        (a) =>
          a.email.toLowerCase() === cleanEmail ||
          a.phone.replace(/\D/g, '').slice(-10) === cleanPhone
      );

      if (agent || cleanEmail === 'delivery@camsik.com' || cleanEmail === 'delivery@casmik.com') {
        const activeAgent = agent || deliveryAgents[0];
        return NextResponse.json({
          success: true,
          role: 'delivery',
          message: 'Delivery executive authenticated successfully',
          agent: activeAgent,
          user: {
            id: activeAgent.id,
            name: activeAgent.name,
            phone: activeAgent.phone,
            email: activeAgent.email,
            role: 'delivery',
            city: activeAgent.city,
            vehicle: activeAgent.vehicle,
            vehicleNumber: activeAgent.vehicleNumber,
          },
        });
      }

      if (requestedRole === 'delivery') {
        return NextResponse.json(
          { success: false, message: 'No registered delivery agent account found with these credentials' },
          { status: 404 }
        );
      }
    }

    // 4. CUSTOMER USER CHECK
    const user = await findUserByIdentifier(identifier);

    if (!user) {
      // Check if it's one of the seeded demo users
      if (cleanPhone === '9876543210' || cleanEmail === 'user@camsik.com') {
        return NextResponse.json({
          success: true,
          role: 'customer',
          message: 'Logged in successfully',
          user: {
            id: 'cust-demo-01',
            name: 'Rahul Sharma',
            phone: '9876543210',
            email: 'rahul@gmail.com',
            role: 'customer',
            createdAt: new Date().toISOString(),
          },
        });
      }

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
      role: 'customer',
      message: 'Logged in successfully',
      user: {
        id: user.id,
        name: user.name || 'Camsik Customer',
        phone: user.phone || cleanPhone,
        email: user.email || `${cleanPhone}@camsik.in`,
        role: 'customer',
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

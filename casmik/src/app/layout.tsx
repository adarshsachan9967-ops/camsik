import React from 'react';
import type { Metadata, Viewport } from 'next';
import { Plus_Jakarta_Sans } from 'next/font/google';
import '../styles/tailwind.css';
import { Toaster } from 'sonner';
import { AuthProvider } from '@/contexts/AuthContext';

const plusJakartaSans = Plus_Jakarta_Sans({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  variable: '--font-plus-jakarta-sans',
  display: 'swap',
});

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
};

export const metadata: Metadata = {
  title: 'Camsik — Sell Used DSLR, Lenses, Video & Action Cameras | Instant Cash & Free Doorstep Pickup',
  description: 'Sell your old or used DSLR camera, mirrorless lenses, 4K video camcorders, action cameras & gimbals at the best market price. Instant AI valuation, free doorstep pickup, and instant cash transfer across India.',
  keywords: 'sell old camera, sell dslr camera, sell camera lens, sell used mirrorless, camsik electronics, camera buyback, canon, nikon, sony alpha, lumix, gopro, dji osmo',
  icons: {
    icon: [{ url: '/favicon.ico', type: 'image/x-icon' }],
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className={plusJakartaSans.variable}>
      <body className={plusJakartaSans.className}>
        <AuthProvider>
          {children}
        </AuthProvider>
        <Toaster position="bottom-right" richColors closeButton />
      </body>
    </html>
  );
}
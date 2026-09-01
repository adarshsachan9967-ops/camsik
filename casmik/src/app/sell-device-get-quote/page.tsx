import React from 'react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import SellDeviceWorkflow from '@/app/sell-device-get-quote/components/SellDeviceWorkflow';

export default function SellDevicePage() {
  return (
    <main className="min-h-screen bg-surface">
      <CustomerHeader />
      <SellDeviceWorkflow />
      <CustomerFooter />
    </main>
  );
}
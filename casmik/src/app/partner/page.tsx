'use client';
import React, { useState } from 'react';
import PartnerLayout from './components/PartnerLayout';
import PartnerDashboard from './components/PartnerDashboard';
import PartnerOrders from './components/PartnerOrders';
import PartnerInspection from './components/PartnerInspection';
import PartnerPayouts from './components/PartnerPayouts';
import SupportTicketsPanel from '@/components/SupportTicketsPanel';
import PartnerProfile from './components/PartnerProfile';

export type PartnerSection = 'dashboard' | 'orders' | 'inspection' | 'payouts' | 'customers' | 'reports' | 'settings' | 'support' | 'profile';

export default function PartnerPage() {
  const [activeSection, setActiveSection] = useState<PartnerSection>('dashboard');

  const renderSection = () => {
    switch (activeSection) {
      case 'dashboard': return <PartnerDashboard />;
      case 'orders': return <PartnerOrders />;
      case 'inspection': return <PartnerInspection />;
      case 'payouts': return <PartnerPayouts />;
      case 'support': return <SupportTicketsPanel panelType="partner" userName="Rajesh Kumar" />;
      case 'profile': return <PartnerProfile />;
      default: return <PartnerDashboard />;
    }
  };

  return (
    <PartnerLayout activeSection={activeSection} onSectionChange={setActiveSection}>
      {renderSection()}
    </PartnerLayout>
  );
}

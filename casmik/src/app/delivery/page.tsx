'use client';
import React, { useState } from 'react';
import DeliveryLayout from './components/DeliveryLayout';
import DeliveryDashboard from './components/DeliveryDashboard';
import DeliveryTasks from './components/DeliveryTasks';
import DeliveryEarnings from './components/DeliveryEarnings';
import DeliveryProfile from './components/DeliveryProfile';
import SupportTicketsPanel from '@/components/SupportTicketsPanel';

export type DeliverySection = 'dashboard' | 'tasks' | 'earnings' | 'profile' | 'support';

export default function DeliveryPage() {
  const [activeSection, setActiveSection] = useState<DeliverySection>('dashboard');

  const renderSection = () => {
    switch (activeSection) {
      case 'dashboard': return <DeliveryDashboard />;
      case 'tasks': return <DeliveryTasks />;
      case 'earnings': return <DeliveryEarnings />;
      case 'profile': return <DeliveryProfile />;
      case 'support': return <SupportTicketsPanel panelType="delivery" userName="Ravi Kumar" />;
      default: return <DeliveryDashboard />;
    }
  };

  return (
    <DeliveryLayout activeSection={activeSection} onSectionChange={setActiveSection}>
      {renderSection()}
    </DeliveryLayout>
  );
}

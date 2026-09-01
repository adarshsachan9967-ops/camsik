'use client';
import React, { useState } from 'react';
import AdminPanelLayout from './components/AdminPanelLayout';
import AdminOverview from './components/AdminOverview';
import AdminCategories from './components/AdminCategories';
import AdminBrands from './components/AdminBrands';
import AdminModels from './components/AdminModels';
import AdminOrders from './components/AdminOrders';
import AdminPartners from './components/AdminPartners';
import AdminDelivery from './components/AdminDelivery';
import AdminPricing from './components/AdminPricing';
import AdminCustomers from './components/AdminCustomers';
import AdminPayouts from './components/AdminPayouts';
import AdminCMS from './components/AdminCMS';
import AdminReports from './components/AdminReports';
import AdminSettings from './components/AdminSettings';
import AdminNotifications from './components/AdminNotifications';
import AdminPushNotifications from './components/AdminPushNotifications';
import AdminRefurbished from './components/AdminRefurbished';
import AdminRepairIssues from './components/AdminRepairIssues';
import AdminInventory from './components/AdminInventory';
import AdminSupportTickets from './components/AdminSupportTickets';
import AdminCoupons from './components/AdminCoupons';

export type AdminSection = 'overview' | 'orders' | 'categories' | 'brands' | 'models' | 'pricing' | 'partners' | 'delivery' | 'customers' | 'payouts' | 'cms' | 'reports' | 'settings' | 'notifications' | 'push_notifications' | 'refurbished' | 'repair_issues' | 'inventory' | 'support_tickets' | 'coupons';

export default function AdminPage() {
  const [activeSection, setActiveSection] = useState<AdminSection>('overview');

  const renderSection = () => {
    switch (activeSection) {
      case 'overview': return <AdminOverview />;
      case 'orders': return <AdminOrders />;
      case 'categories': return <AdminCategories />;
      case 'brands': return <AdminBrands />;
      case 'models': return <AdminModels />;
      case 'pricing': return <AdminPricing />;
      case 'partners': return <AdminPartners />;
      case 'delivery': return <AdminDelivery />;
      case 'customers': return <AdminCustomers />;
      case 'payouts': return <AdminPayouts />;
      case 'cms': return <AdminCMS />;
      case 'reports': return <AdminReports />;
      case 'settings': return <AdminSettings />;
      case 'notifications': return <AdminNotifications />;
      case 'push_notifications': return <AdminPushNotifications />;
      case 'refurbished': return <AdminRefurbished />;
      case 'repair_issues': return <AdminRepairIssues />;
      case 'inventory': return <AdminInventory />;
      case 'support_tickets': return <AdminSupportTickets />;
      case 'coupons': return <AdminCoupons />;
      default: return <AdminOverview />;
    }
  };

  return (
    <AdminPanelLayout activeSection={activeSection} onSectionChange={setActiveSection}>
      {renderSection()}
    </AdminPanelLayout>
  );
}

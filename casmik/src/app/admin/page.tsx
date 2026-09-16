'use client';
import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
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
  const router = useRouter();
  const [isAuthorized, setIsAuthorized] = useState<boolean | null>(null);
  const [activeSection, setActiveSection] = useState<AdminSection>('overview');

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const auth = localStorage.getItem('casmik_admin_auth');
      if (auth !== 'true') {
        router.replace('/admin/login');
      } else {
        setIsAuthorized(true);
      }
    }
  }, [router]);

  if (isAuthorized !== true) {
    return (
      <div className="min-h-screen bg-[#0f1117] flex flex-col items-center justify-center text-white select-none">
        <div className="w-14 h-14 rounded-2xl bg-primary/20 border border-primary/30 flex items-center justify-center mb-4 shadow-xl shadow-primary/20">
          <div className="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin" />
        </div>
        <p className="text-base font-bold text-white tracking-wide">CAMSIK Admin Security</p>
        <p className="text-xs text-white/50 mt-1">Verifying administrative access...</p>
      </div>
    );
  }

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

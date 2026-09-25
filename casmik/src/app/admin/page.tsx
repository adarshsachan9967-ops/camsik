'use client';
import React, { useState, useEffect } from 'react';
import Link from 'next/link';
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
import AdminRentalCameras from './components/AdminRentalCameras';

export type AdminSection = 'overview' | 'orders' | 'categories' | 'brands' | 'models' | 'pricing' | 'partners' | 'delivery' | 'customers' | 'payouts' | 'cms' | 'reports' | 'settings' | 'notifications' | 'push_notifications' | 'refurbished' | 'repair_issues' | 'inventory' | 'support_tickets' | 'coupons' | 'rental_cameras' | 'rental_orders';

export interface AdminNavigationOptions {
  filterStatus?: string;
  filterType?: string;
  orderId?: string;
  tab?: string;
}

export default function AdminPage() {
  const router = useRouter();
  const [isAuthorized, setIsAuthorized] = useState<boolean | null>(null);
  const [activeSection, setActiveSection] = useState<AdminSection>('overview');
  const [ordersFilterStatus, setOrdersFilterStatus] = useState<string>('all');
  const [ordersFilterType, setOrdersFilterType] = useState<string>('all');
  const [selectedOrderId, setSelectedOrderId] = useState<string | null>(null);

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
      <div className="min-h-screen bg-slate-950 flex flex-col items-center justify-center p-4 text-white select-none">
        <div className="bg-slate-900 border border-slate-800 rounded-3xl p-8 max-w-sm w-full text-center space-y-4 shadow-2xl">
          <div className="w-14 h-14 rounded-2xl bg-purple-500/20 border border-purple-500/30 flex items-center justify-center mx-auto text-purple-400 shadow-xl shadow-purple-500/20">
            <div className="w-6 h-6 border-2 border-purple-400 border-t-transparent rounded-full animate-spin" />
          </div>
          <div className="space-y-1">
            <h2 className="text-lg font-black text-white">CAMSIK Admin Security</h2>
            <p className="text-xs text-slate-400">Verifying super admin authorization...</p>
          </div>
          <p className="text-[11px] text-slate-500">Redirecting to Super Admin Login...</p>
        </div>
      </div>
    );
  }

  const handleNavigate = (section: AdminSection, options?: AdminNavigationOptions) => {
    setActiveSection(section);
    if (options?.filterStatus !== undefined) {
      setOrdersFilterStatus(options.filterStatus);
    }
    if (options?.filterType !== undefined) {
      setOrdersFilterType(options.filterType);
    }
    if (options?.orderId !== undefined) {
      setSelectedOrderId(options.orderId);
    }
  };

  const renderSection = () => {
    switch (activeSection) {
      case 'overview':
        return <AdminOverview onNavigate={handleNavigate} />;
      case 'orders':
        return (
          <AdminOrders
            initialFilterStatus={ordersFilterStatus}
            initialFilterType={ordersFilterType}
            initialOrderId={selectedOrderId}
            onClearFilters={() => {
              setOrdersFilterStatus('all');
              setOrdersFilterType('all');
              setSelectedOrderId(null);
            }}
          />
        );
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
      case 'rental_cameras':
      case 'rental_orders':
        return <AdminRentalCameras />;
      default: return <AdminOverview onNavigate={handleNavigate} />;
    }
  };

  const handleLogout = () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('casmik_admin_auth');
      window.location.href = '/admin/login';
    }
  };

  return (
    <AdminPanelLayout activeSection={activeSection} onSectionChange={setActiveSection}>
      {renderSection()}
    </AdminPanelLayout>
  );
}

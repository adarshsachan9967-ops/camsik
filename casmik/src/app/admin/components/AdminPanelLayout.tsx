'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import type { AdminSection } from '../page';
import { LayoutDashboard, ShoppingBag, Tag, Globe, Package, Calculator, Users, Handshake, Truck, FileText, BarChart3, Settings, ChevronLeft, ChevronRight, Bell, Menu, X, CreditCard, Send, LogOut, Wrench, Warehouse, MessageSquare, Percent, RefreshCw } from 'lucide-react';
import NotificationBell from '@/components/NotificationBell';

interface NavItem { id: AdminSection; icon: React.ElementType; label: string; badge?: string | number; badgeColor?: string; }
interface NavGroup { group: string; items: NavItem[]; }

const navGroups: NavGroup[] = [
  { group: 'Overview', items: [{ id: 'overview', icon: LayoutDashboard, label: 'Dashboard' }] },
  { group: 'Orders', items: [
    { id: 'orders', icon: ShoppingBag, label: 'All Orders', badge: 47, badgeColor: 'bg-red-500' },
  ]},
  { group: 'Catalog', items: [
    { id: 'categories', icon: Tag, label: 'Categories' },
    { id: 'brands', icon: Globe, label: 'Brands' },
    { id: 'models', icon: Package, label: 'Models' },
    { id: 'refurbished', icon: RefreshCw, label: 'Refurbished Devices' },
    { id: 'repair_issues', icon: Wrench, label: 'Repair Issues' },
    { id: 'pricing', icon: Calculator, label: 'Pricing Engine' },
  ]},
  { group: 'Inventory', items: [
    { id: 'inventory', icon: Warehouse, label: 'Inventory' },
  ]},
  { group: 'People', items: [
    { id: 'customers', icon: Users, label: 'Customers' },
    { id: 'partners', icon: Handshake, label: 'Partners', badge: 3, badgeColor: 'bg-yellow-500' },
    { id: 'delivery', icon: Truck, label: 'Delivery Agents' },
  ]},
  { group: 'Finance', items: [
    { id: 'payouts', icon: CreditCard, label: 'Wallet & Payouts', badge: '₹2.4L', badgeColor: 'bg-orange-500' },
    { id: 'coupons', icon: Percent, label: 'Coupons & Offers' },
  ]},
  { group: 'Support', items: [
    { id: 'support_tickets', icon: MessageSquare, label: 'Support Tickets', badge: 5, badgeColor: 'bg-red-500' },
  ]},
  { group: 'Content & Tools', items: [
    { id: 'cms', icon: FileText, label: 'CMS' },
    { id: 'reports', icon: BarChart3, label: 'Reports' },
    { id: 'notifications', icon: Bell, label: 'Notifications', badge: 5, badgeColor: 'bg-red-500' },
    { id: 'push_notifications', icon: Send, label: 'Push Notifications' },
    { id: 'settings', icon: Settings, label: 'Settings' },
  ]},
];

interface Props { activeSection: AdminSection; onSectionChange: (s: AdminSection) => void; children: React.ReactNode; }

export default function AdminPanelLayout({ activeSection, onSectionChange, children }: Props) {
  const router = useRouter();
  const [collapsed, setCollapsed] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  const handleLogout = () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('casmik_admin_auth');
      localStorage.removeItem('casmik_admin_email');
      localStorage.removeItem('casmik_admin_logged_at');
      sessionStorage.clear();
    }
    router.replace('/admin/login');
  };

  const sectionLabel = (s: AdminSection): string => {
    const map: Partial<Record<AdminSection, string>> = {
      overview: 'Dashboard', push_notifications: 'Push Notifications', repair_issues: 'Repair Issues',
      support_tickets: 'Support Tickets', refurbished: 'Refurbished Devices', inventory: 'Inventory',
      coupons: 'Coupons & Offers', models: 'Device Models',
    };
    return map[s] || s.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
  };

  const SidebarContent = () => (
    <>
      <div className={`flex items-center h-16 border-b border-white/10 flex-shrink-0 ${collapsed ? 'justify-center px-0' : 'px-4 gap-3'}`}>
        <div className="w-8 h-8 rounded-xl bg-primary flex items-center justify-center flex-shrink-0">
          <span className="text-white font-black text-sm">C</span>
        </div>
        {!collapsed && (
          <div>
            <p className="font-black text-white text-sm leading-none">CAMSIK</p>
            <p className="text-xs text-white/40 leading-none mt-0.5">Super Admin</p>
          </div>
        )}
      </div>
      <nav className="flex-1 overflow-y-auto py-3 scrollbar-hide">
        {navGroups.map((group) => (
          <div key={group.group} className="mb-1">
            {!collapsed && <p className="px-4 py-1.5 text-xs font-bold text-white/30 uppercase tracking-widest">{group.group}</p>}
            {group.items.map((item) => {
              const active = activeSection === item.id;
              return (
                <button key={item.id} onClick={() => { onSectionChange(item.id); setMobileOpen(false); }}
                  className={`w-full flex items-center mx-2 rounded-xl transition-all duration-150 mb-0.5 ${collapsed ? 'justify-center w-12 h-10 p-0' : 'gap-2.5 px-3 py-2.5'} ${active ? 'bg-primary text-white shadow-lg shadow-primary/30' : 'text-white/60 hover:bg-white/10 hover:text-white'}`}
                  style={{ width: collapsed ? '3rem' : 'calc(100% - 1rem)' }}
                >
                  <item.icon size={17} className="flex-shrink-0" />
                  {!collapsed && (
                    <>
                      <span className="text-sm font-medium flex-1 text-left truncate">{item.label}</span>
                      {item.badge !== undefined && (
                        <span className={`text-xs font-bold px-1.5 py-0.5 rounded-md text-white ${item.badgeColor || 'bg-primary'}`}>{item.badge}</span>
                      )}
                    </>
                  )}
                </button>
              );
            })}
          </div>
        ))}
      </nav>
      <div className={`border-t border-white/10 p-3 flex items-center flex-shrink-0 ${collapsed ? 'flex-col gap-2 justify-center' : 'gap-3'}`}>
        <div className="w-8 h-8 rounded-full bg-primary flex items-center justify-center flex-shrink-0 text-white text-xs font-bold shadow-sm shadow-primary/40">A</div>
        {!collapsed && (
          <div className="flex-1 min-w-0">
            <p className="text-xs font-semibold text-white truncate">Adarsh Kumar</p>
            <p className="text-xs text-white/40 truncate">Super Admin</p>
          </div>
        )}
        <button
          onClick={handleLogout}
          className="text-white/40 hover:text-red-400 p-1.5 rounded-lg hover:bg-white/5 transition-colors"
          title="Sign out of Admin Panel"
        >
          <LogOut size={16} />
        </button>
      </div>
    </>
  );

  return (
    <div className="flex h-screen bg-[#f8f9fb] overflow-hidden font-sans">
      {/* Desktop sidebar */}
      <aside className={`relative flex-shrink-0 bg-[#0f1117] text-white flex flex-col transition-all duration-300 hidden md:flex ${collapsed ? 'w-16' : 'w-60'}`}>
        <SidebarContent />
        <button onClick={() => setCollapsed(c => !c)}
          className="absolute -right-3 top-20 w-6 h-6 rounded-full bg-white border border-gray-200 shadow-md flex items-center justify-center text-gray-500 hover:text-gray-800 z-10">
          {collapsed ? <ChevronRight size={12} /> : <ChevronLeft size={12} />}
        </button>
      </aside>

      {/* Mobile sidebar overlay */}
      {mobileOpen && (
        <div className="fixed inset-0 z-50 md:hidden">
          <div className="absolute inset-0 bg-black/50" onClick={() => setMobileOpen(false)} />
          <aside className="absolute left-0 top-0 bottom-0 w-64 bg-[#0f1117] text-white flex flex-col">
            <SidebarContent />
          </aside>
        </div>
      )}

      {/* Main content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Topbar */}
        <header className="h-16 bg-white border-b border-gray-100 flex items-center px-4 lg:px-6 gap-4 flex-shrink-0">
          <button onClick={() => setMobileOpen(true)} className="md:hidden p-2 rounded-lg hover:bg-gray-100">
            <Menu size={20} />
          </button>
          <div className="flex-1">
            <h1 className="text-base font-bold text-gray-900 capitalize">{sectionLabel(activeSection)}</h1>
          </div>
          <div className="flex items-center gap-3">
            {/* Live Notifications Bell with Audio */}
            <NotificationBell
              role="admin"
              onNavigateSection={(s) => onSectionChange(s as AdminSection)}
              onNavigateToOrder={() => onSectionChange('orders')}
            />
            <Link href="/" className="text-xs font-medium text-primary hover:underline">← Customer Site</Link>
            <button
              onClick={handleLogout}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold text-gray-700 hover:text-red-600 hover:bg-red-50 border border-gray-200 transition-colors"
              title="Sign out of Admin Panel"
            >
              <LogOut size={13} />
              <span>Logout</span>
            </button>
          </div>
        </header>
        <main className="flex-1 overflow-y-auto p-4 lg:p-6">{children}</main>
      </div>
    </div>
  );
}

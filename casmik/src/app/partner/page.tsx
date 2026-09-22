'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import PartnerLayout from './components/PartnerLayout';
import PartnerDashboard from './components/PartnerDashboard';
import PartnerOrders from './components/PartnerOrders';
import PartnerInspection from './components/PartnerInspection';
import PartnerPayouts from './components/PartnerPayouts';
import SupportTicketsPanel from '@/components/SupportTicketsPanel';
import PartnerProfile from './components/PartnerProfile';
import PartnerCustomers from './components/PartnerCustomers';
import PartnerReports from './components/PartnerReports';
import PartnerSettings from './components/PartnerSettings';
import { Clock, ShieldAlert, RefreshCw, LogOut, ArrowRight } from 'lucide-react';
import { partners, Partner } from '@/lib/casmikData';

export type PartnerSection = 'dashboard' | 'orders' | 'inspection' | 'payouts' | 'customers' | 'reports' | 'settings' | 'support' | 'profile';

export default function PartnerPage() {
  const [activeSection, setActiveSection] = useState<PartnerSection>('dashboard');
  const [session, setSession] = useState<Partner | null>(null);
  const [loading, setLoading] = useState(true);
  const [inspectingOrderId, setInspectingOrderId] = useState<string | null>(null);

  const handleStartInspection = (orderId: string) => {
    setInspectingOrderId(orderId);
    if (typeof window !== 'undefined') {
      localStorage.setItem('casmik_active_inspection_id', orderId);
    }
    setActiveSection('inspection');
  };

  const checkAuth = () => {
    if (typeof window === 'undefined') return;
    try {
      const storedSession = localStorage.getItem('casmik_partner_session');
      if (!storedSession) {
        setSession(null);
        setLoading(false);
        return;
      }
      const currentPartner: Partner = JSON.parse(storedSession);

      // Check against current database for live approval updates
      const savedPartners = localStorage.getItem('casmik_partners_v1');
      if (savedPartners) {
        const list: Partner[] = JSON.parse(savedPartners);
        const match = list.find(p => p.id === currentPartner.id || p.email === currentPartner.email);
        if (match) {
          localStorage.setItem('casmik_partner_session', JSON.stringify(match));
          setSession(match);
          setLoading(false);
          return;
        }
      }

      setSession(currentPartner);
    } catch {
      setSession(null);
    }
    setLoading(false);
  };

  useEffect(() => {
    checkAuth();
  }, []);

  const handleLogout = () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('casmik_partner_session');
      window.location.href = '/partner/login';
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#f8f9fb] flex items-center justify-center">
        <div className="text-center">
          <div className="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-sm font-medium text-gray-500">Checking partner authorization...</p>
        </div>
      </div>
    );
  }

  // Not logged in -> Show prompt or redirect
  if (!session) {
    const handleQuickDemoLogin = () => {
      const activePartner = partners.find(p => p.status === 'active') || partners[0];
      if (typeof window !== 'undefined') {
        localStorage.setItem('casmik_partner_session', JSON.stringify(activePartner));
      }
      setSession(activePartner);
    };

    return (
      <div className="min-h-screen bg-slate-950 text-slate-100 flex items-center justify-center p-4">
        <div className="bg-slate-900 rounded-3xl shadow-2xl p-6 max-w-sm w-full text-center border border-slate-800 space-y-4">
          <div className="w-14 h-14 bg-blue-500/10 rounded-2xl flex items-center justify-center mx-auto text-blue-400 border border-blue-500/20">
            <ShieldAlert size={28} />
          </div>
          <div className="space-y-1">
            <h2 className="text-lg font-black text-white">Partner Portal Access</h2>
            <p className="text-slate-400 text-xs">
              Sign in with your verified merchant account or test instantly with a demo store.
            </p>
          </div>

          <div className="space-y-2.5 pt-2">
            <button
              onClick={handleQuickDemoLogin}
              className="w-full py-3 bg-blue-600 hover:bg-blue-500 text-white rounded-2xl font-bold text-xs transition-all flex items-center justify-center gap-2 shadow-lg shadow-blue-600/30 active:scale-95"
            >
              <span>Instant Test in Chrome (Apex Cameras)</span>
              <ArrowRight size={14} />
            </button>

            <Link
              href="/partner/login"
              className="w-full py-2.5 bg-slate-800 hover:bg-slate-700 text-slate-200 rounded-2xl font-semibold text-xs transition-colors block border border-slate-700"
            >
              Sign In with Credentials
            </Link>

            <Link
              href="/"
              className="w-full py-2 text-slate-400 hover:text-slate-200 text-[11px] font-medium block"
            >
              Back to Casmik Home
            </Link>
          </div>
        </div>
      </div>
    );
  }

  // Pending Admin Approval screen
  if (session.status === 'pending') {
    return (
      <div className="min-h-screen bg-gradient-to-br from-amber-50/50 via-white to-primary/5 flex items-center justify-center p-4">
        <div className="bg-white rounded-3xl shadow-xl p-8 max-w-lg w-full text-center border border-amber-100">
          <div className="w-20 h-20 bg-amber-100 rounded-full flex items-center justify-center mx-auto mb-5 text-amber-600 animate-pulse">
            <Clock size={40} />
          </div>
          <span className="inline-block px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider bg-amber-100 text-amber-800 mb-3">
            Pending Super Admin Approval
          </span>
          <h2 className="text-2xl font-black text-gray-900 mb-2">Application Under Review</h2>
          <p className="text-gray-500 text-sm mb-6">
            Hello <strong>{session.name}</strong>, your partner application for <strong>{session.storeName}</strong> has been submitted. Camsik Super Admin is currently verifying your details and store documents.
          </p>

          <div className="bg-gray-50 rounded-2xl p-4 text-left mb-6 space-y-2.5 text-xs text-gray-600">
            <div className="flex justify-between border-b border-gray-200/60 pb-2">
              <span className="text-gray-400">Partner ID:</span>
              <span className="font-bold text-gray-900">{session.id}</span>
            </div>
            <div className="flex justify-between border-b border-gray-200/60 pb-2">
              <span className="text-gray-400">Registered Email:</span>
              <span className="font-semibold text-gray-800">{session.email}</span>
            </div>
            <div className="flex justify-between border-b border-gray-200/60 pb-2">
              <span className="text-gray-400">Registered Phone:</span>
              <span className="font-semibold text-gray-800">{session.phone}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-400">City / State:</span>
              <span className="font-semibold text-gray-800">{session.city}, {session.state}</span>
            </div>
          </div>

          <div className="flex gap-3">
            <button
              onClick={checkAuth}
              className="flex-1 py-3 bg-primary text-white rounded-2xl font-bold text-xs hover:bg-primary/90 transition-colors flex items-center justify-center gap-2"
            >
              <RefreshCw size={14} /> Refresh Status
            </button>
            <button
              onClick={handleLogout}
              className="py-3 px-5 bg-gray-100 text-gray-700 rounded-2xl font-bold text-xs hover:bg-gray-200 transition-colors flex items-center gap-1.5"
            >
              <LogOut size={14} /> Log Out
            </button>
          </div>
        </div>
      </div>
    );
  }

  const renderSection = () => {
    switch (activeSection) {
      case 'dashboard': return <PartnerDashboard onNavigate={setActiveSection} />;
      case 'orders': return <PartnerOrders onStartInspection={handleStartInspection} />;
      case 'inspection': return <PartnerInspection initialOrderId={inspectingOrderId} onBackToOrders={() => setActiveSection('orders')} />;
      case 'payouts': return <PartnerPayouts />;
      case 'customers': return <PartnerCustomers onNavigate={setActiveSection} />;
      case 'reports': return <PartnerReports />;
      case 'settings': return <PartnerSettings partner={session} onUpdateSession={setSession} />;
      case 'support': return <SupportTicketsPanel panelType="partner" userName={session?.name || "Partner"} />;
      case 'profile': return <PartnerProfile partner={session} onUpdateSession={setSession} />;
      default: return <PartnerDashboard onNavigate={setActiveSection} />;
    }
  };

  return (
    <PartnerLayout activeSection={activeSection} onSectionChange={setActiveSection} currentPartner={session}>
      {renderSection()}
    </PartnerLayout>
  );
}


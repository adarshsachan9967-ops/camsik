'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import type { DeliverySection } from '../page';
import { LayoutDashboard, Package, DollarSign, User, Bell, MessageSquare } from 'lucide-react';
import { deliveryAgents } from '@/lib/casmikData';

const agent = deliveryAgents[0];

interface NavItem { id: DeliverySection; icon: React.ElementType; label: string; badge?: number; }
const navItems: NavItem[] = [
  { id: 'dashboard', icon: LayoutDashboard, label: 'Dashboard' },
  { id: 'tasks', icon: Package, label: 'My Tasks', badge: 5 },
  { id: 'earnings', icon: DollarSign, label: 'Earnings' },
  { id: 'support', icon: MessageSquare, label: 'Support' },
  { id: 'profile', icon: User, label: 'Profile' },
];

interface Props { activeSection: DeliverySection; onSectionChange: (s: DeliverySection) => void; children: React.ReactNode; }

export default function DeliveryLayout({ activeSection, onSectionChange, children }: Props) {
  const [isOnline, setIsOnline] = useState(agent.status !== 'offline');
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  return (
    <div className="flex flex-col h-screen bg-[#f8f9fb] overflow-hidden font-sans">
      {/* Top Header */}
      <header className="bg-white border-b border-gray-100 flex-shrink-0">
        <div className="flex items-center px-4 h-16 gap-4">
          <div className="flex items-center gap-3 flex-1">
            <div className="w-8 h-8 rounded-xl bg-primary flex items-center justify-center">
              <span className="text-white font-black text-sm">C</span>
            </div>
            <div>
              <p className="font-black text-gray-900 text-sm leading-none">CAMSIK</p>
              <p className="text-xs text-gray-400 leading-none">Delivery Agent</p>
            </div>
          </div>

          {/* Online/Offline Toggle */}
          <div className="flex items-center gap-2">
            <span className="text-xs font-bold text-gray-500">{isOnline ? 'Online' : 'Offline'}</span>
            <button onClick={() => setIsOnline(o => !o)}
              className={`relative w-12 h-6 rounded-full transition-all duration-300 ${isOnline ? 'bg-green-500' : 'bg-gray-300'}`}>
              <div className={`absolute top-0.5 w-5 h-5 rounded-full bg-white shadow-md transition-all duration-300 ${isOnline ? 'left-6' : 'left-0.5'}`} />
            </button>
          </div>

          <button className="relative p-2 rounded-xl hover:bg-gray-100">
            <Bell size={18} className="text-gray-600" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full" />
          </button>

          <div className="flex items-center gap-2">
            <img src={agent.avatar} alt={agent.name} className="w-8 h-8 rounded-full object-cover" />
            <div className="hidden sm:block">
              <p className="text-xs font-bold text-gray-900 leading-none">{agent.name}</p>
              <p className="text-xs text-gray-400 leading-none">⭐ {agent.rating}</p>
            </div>
          </div>

          <Link href="/admin" className="hidden sm:block text-xs text-gray-400 hover:text-primary">Admin</Link>
          <Link href="/partner" className="hidden sm:block text-xs text-gray-400 hover:text-primary">Partner</Link>
          <Link href="/delivery/login" className="hidden sm:block text-xs font-semibold text-primary border border-primary/30 rounded-lg px-2 py-1 hover:bg-primary/5">Sign In</Link>
        </div>

        {/* Status Bar */}
        <div className={`px-4 py-2 text-xs font-bold text-center transition-all ${isOnline ? 'bg-green-500 text-white' : 'bg-gray-200 text-gray-600'}`}>
          {isOnline ? '🟢 You are ONLINE — Ready to receive tasks' : '⚫ You are OFFLINE — Go online to receive tasks'}
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-y-auto p-4 lg:p-6">{children}</main>

      {/* Bottom Navigation */}
      <nav className="bg-white border-t border-gray-100 flex-shrink-0">
        <div className="flex">
          {navItems.map((item) => {
            const active = activeSection === item.id;
            return (
              <button key={item.id} onClick={() => onSectionChange(item.id)}
                className={`flex-1 flex flex-col items-center gap-1 py-3 transition-all relative ${active ? 'text-primary' : 'text-gray-400 hover:text-gray-600'}`}>
                {item.badge && item.badge > 0 && (
                  <span className="absolute top-2 right-1/4 w-4 h-4 bg-red-500 text-white text-xs font-black rounded-full flex items-center justify-center">{item.badge}</span>
                )}
                <item.icon size={20} />
                <span className="text-xs font-semibold">{item.label}</span>
                {active && <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-6 h-0.5 bg-primary rounded-full" />}
              </button>
            );
          })}
        </div>
      </nav>
    </div>
  );
}

'use client';
import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import {
  Bell,
  Package,
  Handshake,
  Truck,
  CheckCircle,
  X,
  Filter,
  Volume2,
  VolumeX,
  Play,
  Trash2,
  ExternalLink,
  Sparkles,
  CreditCard,
  RefreshCw,
  Clock,
} from 'lucide-react';
import {
  CasmikNotification,
  getStoredNotifications,
  markAllNotificationsRead,
  markNotificationRead,
  clearAllNotifications,
  addNotificationListener,
  playNotificationSound,
  isSoundMuted,
  setSoundMuted,
  triggerNotification,
  requestBrowserNotificationPermission,
} from '@/lib/notifications';

export default function AdminNotifications() {
  const [notifications, setNotifications] = useState<CasmikNotification[]>([]);
  const [filter, setFilter] = useState<'all' | 'new_booking' | 'status_update' | 'payout'>('all');
  const [showUnreadOnly, setShowUnreadOnly] = useState(false);
  const [muted, setMuted] = useState(false);
  const [soundFeedback, setSoundFeedback] = useState(false);

  const loadNotifications = () => {
    setNotifications(getStoredNotifications('admin'));
    setMuted(isSoundMuted());
  };

  useEffect(() => {
    loadNotifications();

    const unsubscribe = addNotificationListener((notif) => {
      if (notif.targetRole === 'admin' || notif.targetRole === 'all') {
        loadNotifications();
      }
    });

    return unsubscribe;
  }, []);

  const handleTestSound = () => {
    playNotificationSound(true);
    setSoundFeedback(true);
    setTimeout(() => setSoundFeedback(false), 1200);
  };

  const handleToggleMute = () => {
    const nextState = !muted;
    setSoundMuted(nextState);
    setMuted(nextState);
  };

  const handleMarkAllRead = () => {
    markAllNotificationsRead('admin');
    loadNotifications();
  };

  const handleMarkRead = (id: string) => {
    markNotificationRead(id);
    loadNotifications();
  };

  const handleClearAll = () => {
    if (confirm('Clear all admin notifications?')) {
      clearAllNotifications();
      loadNotifications();
    }
  };

  const handleCreateSampleNotification = (type: 'new_booking' | 'status_update' | 'payout') => {
    const randNum = Math.floor(100 + Math.random() * 900);
    if (type === 'new_booking') {
      triggerNotification({
        type: 'new_booking',
        targetRole: 'all',
        title: `🎉 New Booking: #CSM-2024-${randNum}`,
        shortDetails: `Aarav Mehta booked pickup for iPhone 15 Pro Max 256GB (₹84,500) · Slot: Today 3-5 PM`,
        orderNumber: `CSM-2024-${randNum}`,
        deviceName: 'iPhone 15 Pro Max',
        customerName: 'Aarav Mehta',
        price: 84500,
        status: 'assigned',
      });
    } else if (type === 'status_update') {
      triggerNotification({
        type: 'status_update',
        targetRole: 'all',
        title: `Order #CSM-2024-${randNum} Picked Up`,
        shortDetails: `Partner Camsik Certified Hub picked up Sony Alpha A7 IV (Rahul Verma) and started diagnostic inspection.`,
        orderNumber: `CSM-2024-${randNum}`,
        deviceName: 'Sony Alpha A7 IV',
        customerName: 'Rahul Verma',
        price: 135000,
        status: 'picked_up',
      });
    } else {
      triggerNotification({
        type: 'payout',
        targetRole: 'all',
        title: `💳 Spot Payout Disbursed: ₹62,000`,
        shortDetails: `Payout completed for Order #CSM-2024-${randNum} (MacBook Air M2) via UPI. Order locked as Completed.`,
        orderNumber: `CSM-2024-${randNum}`,
        deviceName: 'MacBook Air M2',
        customerName: 'Priya Sharma',
        price: 62000,
        status: 'completed',
      });
    }
    loadNotifications();
  };

  const filtered = notifications.filter((n) => {
    const matchesFilter = filter === 'all' || n.type === filter;
    const matchesUnread = !showUnreadOnly || !n.read;
    return matchesFilter && matchesUnread;
  });

  const unreadCount = notifications.filter((n) => !n.read).length;

  const getTypeStyle = (type: CasmikNotification['type']) => {
    switch (type) {
      case 'new_booking':
        return {
          icon: Package,
          color: 'text-blue-600',
          bg: 'bg-blue-100',
          border: 'border-blue-200',
          label: 'New Booking',
        };
      case 'status_update':
        return {
          icon: Handshake,
          color: 'text-amber-600',
          bg: 'bg-amber-100',
          border: 'border-amber-200',
          label: 'Status Update',
        };
      case 'payout':
        return {
          icon: CreditCard,
          color: 'text-emerald-600',
          bg: 'bg-emerald-100',
          border: 'border-emerald-200',
          label: 'Spot Payout',
        };
      default:
        return {
          icon: Bell,
          color: 'text-purple-600',
          bg: 'bg-purple-100',
          border: 'border-purple-200',
          label: 'System',
        };
    }
  };

  return (
    <div className="space-y-6">
      {/* Top Header Card */}
      <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-3 mb-1">
              <div className="w-10 h-10 rounded-2xl bg-primary/10 flex items-center justify-center text-primary">
                <Bell size={22} className="animate-pulse" />
              </div>
              <div>
                <h2 className="text-2xl font-black text-slate-900 tracking-tight">Notification Center</h2>
                <p className="text-xs sm:text-sm text-slate-500">
                  Real-time audio chimes & cross-device status sync for Admin, Partner, and User
                </p>
              </div>
            </div>
          </div>

          {/* Sound Controls & Actions */}
          <div className="flex items-center gap-2 flex-wrap">
            <button
              onClick={handleTestSound}
              className={`flex items-center gap-2 px-3.5 py-2 rounded-xl text-xs font-bold transition-all border ${
                soundFeedback
                  ? 'bg-emerald-500 text-white border-emerald-500 scale-105 shadow-md shadow-emerald-500/20'
                  : 'bg-white hover:bg-slate-50 text-slate-800 border-slate-200 hover:border-slate-300'
              }`}
              title="Play harmonic bell chime preview"
            >
              <Play size={13} className={soundFeedback ? 'animate-spin' : 'text-emerald-600 fill-emerald-600'} />
              <span>{soundFeedback ? 'Playing Chime...' : 'Test Sound Chime'}</span>
            </button>

            <button
              onClick={handleToggleMute}
              className={`flex items-center gap-2 px-3.5 py-2 rounded-xl text-xs font-bold transition-all border ${
                muted
                  ? 'bg-rose-50 text-rose-600 border-rose-200 hover:bg-rose-100'
                  : 'bg-slate-100 text-slate-700 border-transparent hover:bg-slate-200'
              }`}
              title={muted ? 'Unmute notification sound' : 'Mute notification sound'}
            >
              {muted ? <VolumeX size={15} /> : <Volume2 size={15} className="text-emerald-600" />}
              <span>{muted ? 'Sound Muted' : 'Sound Active'}</span>
            </button>

            <button
              onClick={() => requestBrowserNotificationPermission()}
              className="px-3.5 py-2 rounded-xl bg-purple-50 hover:bg-purple-100 text-purple-700 border border-purple-200 text-xs font-bold transition-colors"
            >
              Enable Browser Push
            </button>

            {unreadCount > 0 && (
              <button
                onClick={handleMarkAllRead}
                className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary/90 shadow-sm transition-colors"
              >
                <CheckCircle size={14} />
                <span>Mark All Read ({unreadCount})</span>
              </button>
            )}

            {notifications.length > 0 && (
              <button
                onClick={handleClearAll}
                className="p-2 rounded-xl text-slate-400 hover:text-rose-600 hover:bg-rose-50 border border-transparent hover:border-rose-100 transition-colors"
                title="Clear all notifications"
              >
                <Trash2 size={16} />
              </button>
            )}
          </div>
        </div>

        {/* Quick Simulator Bar */}
        <div className="mt-5 pt-4 border-t border-slate-100 flex items-center justify-between flex-wrap gap-2 text-xs">
          <span className="font-semibold text-slate-500">Live Simulator (Simulate alerts across tabs):</span>
          <div className="flex items-center gap-2">
            <button
              onClick={() => handleCreateSampleNotification('new_booking')}
              className="px-2.5 py-1.5 bg-blue-50 hover:bg-blue-100 text-blue-700 rounded-lg font-bold transition-colors"
            >
              + Sim New Booking
            </button>
            <button
              onClick={() => handleCreateSampleNotification('status_update')}
              className="px-2.5 py-1.5 bg-amber-50 hover:bg-amber-100 text-amber-700 rounded-lg font-bold transition-colors"
            >
              + Sim Status Advance
            </button>
            <button
              onClick={() => handleCreateSampleNotification('payout')}
              className="px-2.5 py-1.5 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 rounded-lg font-bold transition-colors"
            >
              + Sim Payout Done
            </button>
          </div>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {[
          {
            label: 'New Bookings',
            value: notifications.filter((n) => n.type === 'new_booking').length,
            icon: Package,
            color: 'text-blue-600',
            bg: 'bg-blue-50',
          },
          {
            label: 'Status Updates',
            value: notifications.filter((n) => n.type === 'status_update').length,
            icon: Handshake,
            color: 'text-amber-600',
            bg: 'bg-amber-50',
          },
          {
            label: 'Completed Payouts',
            value: notifications.filter((n) => n.type === 'payout').length,
            icon: CreditCard,
            color: 'text-emerald-600',
            bg: 'bg-emerald-50',
          },
        ].map((s) => {
          const Icon = s.icon;
          return (
            <div key={s.label} className={`${s.bg} rounded-2xl p-4 border border-black/5`}>
              <div className="flex items-center justify-between mb-1">
                <p className="text-xs font-bold text-slate-600 uppercase tracking-wider">{s.label}</p>
                <div className={`p-1.5 rounded-lg bg-white/80 ${s.color}`}>
                  <Icon size={16} />
                </div>
              </div>
              <p className={`text-2xl font-black ${s.color}`}>{s.value}</p>
            </div>
          );
        })}
      </div>

      {/* Filter Tabs & Toggle */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex gap-1.5 bg-slate-100 p-1 rounded-2xl">
          {[
            { id: 'all', label: 'All Alerts' },
            { id: 'new_booking', label: 'Bookings' },
            { id: 'status_update', label: 'Status' },
            { id: 'payout', label: 'Payouts' },
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setFilter(tab.id as any)}
              className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition-all ${
                filter === tab.id
                  ? 'bg-white text-slate-900 shadow-sm'
                  : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        <button
          onClick={() => setShowUnreadOnly((prev) => !prev)}
          className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold border transition-all ${
            showUnreadOnly
              ? 'bg-primary text-white border-primary shadow-sm'
              : 'bg-white text-slate-700 border-slate-200 hover:border-slate-300'
          }`}
        >
          <Filter size={12} />
          <span>Unread Only ({unreadCount})</span>
        </button>
      </div>

      {/* Notification List */}
      <div className="space-y-3">
        {filtered.map((n) => {
          const config = getTypeStyle(n.type);
          const Icon = config.icon;
          const timeAgo = Math.floor((Date.now() - n.timestamp) / 60000);
          const timeLabel =
            timeAgo < 1 ? 'Just now' : timeAgo < 60 ? `${timeAgo}m ago` : `${Math.floor(timeAgo / 60)}h ago`;

          return (
            <div
              key={n.id}
              className={`flex items-start gap-4 p-4 sm:p-5 rounded-2xl border transition-all ${
                !n.read
                  ? 'bg-gradient-to-r from-emerald-50/50 via-white to-white border-emerald-300 shadow-sm'
                  : 'bg-white border-slate-200/80 hover:border-slate-300'
              }`}
            >
              <div
                className={`w-11 h-11 rounded-2xl ${config.bg} ${config.border} border flex items-center justify-center flex-shrink-0 mt-0.5`}
              >
                <Icon size={20} className={config.color} />
              </div>

              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap mb-1">
                  <span
                    className={`text-[10px] font-black uppercase tracking-wider px-2 py-0.5 rounded-md ${config.bg} ${config.color}`}
                  >
                    {config.label}
                  </span>
                  {n.orderNumber && (
                    <span className="text-xs font-mono font-bold text-slate-600 bg-slate-100 px-2 py-0.5 rounded-md">
                      #{n.orderNumber}
                    </span>
                  )}
                  {!n.read && (
                    <span className="inline-flex items-center gap-1 text-[10px] font-black text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-full">
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-ping" />
                      NEW
                    </span>
                  )}
                  <span className="text-[11px] text-slate-400 ml-auto flex items-center gap-1">
                    <Clock size={11} />
                    {timeLabel}
                  </span>
                </div>

                <h4 className="text-sm font-bold text-slate-900 leading-snug mb-1">{n.title}</h4>
                <p className="text-xs text-slate-600 leading-relaxed">{n.shortDetails}</p>

                {n.price && (
                  <div className="mt-2.5 inline-flex items-center gap-2 px-2.5 py-1 bg-slate-50 border border-slate-200 rounded-lg text-xs">
                    <span className="text-slate-500 font-medium">Order Value:</span>
                    <span className="font-bold text-emerald-600">₹{n.price.toLocaleString('en-IN')}</span>
                  </div>
                )}
              </div>

              {/* Actions */}
              <div className="flex items-center gap-1.5 flex-shrink-0 self-start">
                {!n.read && (
                  <button
                    onClick={() => handleMarkRead(n.id)}
                    className="p-2 rounded-xl text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 transition-colors"
                    title="Mark read"
                  >
                    <CheckCircle size={16} />
                  </button>
                )}
              </div>
            </div>
          );
        })}

        {filtered.length === 0 && (
          <div className="text-center py-16 bg-white rounded-3xl border border-dashed border-slate-200 p-8">
            <div className="w-14 h-14 mx-auto mb-3 rounded-2xl bg-slate-100 flex items-center justify-center text-slate-400">
              <Bell size={26} />
            </div>
            <h3 className="text-base font-bold text-slate-800">No Notifications</h3>
            <p className="text-xs text-slate-500 max-w-sm mx-auto mt-1 mb-4">
              When a new booking is made or an order status is updated by Partner or Admin, alerts will appear here in real-time with sound chime.
            </p>
            <button
              onClick={() => handleCreateSampleNotification('new_booking')}
              className="px-4 py-2 bg-primary text-white text-xs font-bold rounded-xl hover:bg-primary/90 transition-colors"
            >
              Simulate Test Notification
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

'use client';
import React, { useState, useEffect, useRef } from 'react';
import { 
  Bell, 
  X, 
  CheckCheck, 
  Volume2, 
  VolumeX, 
  Package, 
  ClipboardCheck, 
  CreditCard, 
  Truck, 
  Sparkles, 
  Info, 
  Trash2,
  ExternalLink,
  Play
} from 'lucide-react';
import { 
  CasmikNotification, 
  NotificationRole, 
  getStoredNotifications, 
  markNotificationAsRead, 
  markAllNotificationsAsRead, 
  deleteNotification, 
  playNotificationSound, 
  isSoundMuted, 
  setSoundMuted,
  requestBrowserNotificationPermission
} from '@/lib/notifications';

interface NotificationBellProps {
  role: NotificationRole;
  onNavigateToOrder?: (orderNumber: string) => void;
  onNavigateSection?: (section: string) => void;
}

export default function NotificationBell({ role, onNavigateToOrder, onNavigateSection }: NotificationBellProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [notifications, setNotifications] = useState<CasmikNotification[]>([]);
  const [muted, setMuted] = useState(false);
  const [filter, setFilter] = useState<'all' | 'unread' | 'orders' | 'payouts'>('all');
  const [hasNewAlert, setHasNewAlert] = useState(false);
  const [toastAlert, setToastAlert] = useState<CasmikNotification | null>(null);

  const containerRef = useRef<HTMLDivElement>(null);

  const refreshNotifications = () => {
    setNotifications(getStoredNotifications(role));
    setMuted(isSoundMuted());
  };

  useEffect(() => {
    refreshNotifications();

    // BroadcastChannel listener across tabs
    let channel: BroadcastChannel | null = null;
    if (typeof window !== 'undefined' && 'BroadcastChannel' in window) {
      channel = new BroadcastChannel('casmik_notifications_channel');
      channel.onmessage = (event) => {
        const notif = event.data as CasmikNotification;
        if (role === 'all' || notif.targetRole === 'all' || notif.targetRole === role) {
          refreshNotifications();
          setHasNewAlert(true);
          setToastAlert(notif);
          playNotificationSound();
          setTimeout(() => setHasNewAlert(false), 3000);
          setTimeout(() => setToastAlert(null), 6500);
        }
      };
    }

    // Local custom event listener for same-tab triggers
    const handleLocalNotif = (e: any) => {
      const notif = e.detail as CasmikNotification;
      if (role === 'all' || notif.targetRole === 'all' || notif.targetRole === role) {
        refreshNotifications();
        setHasNewAlert(true);
        setToastAlert(notif);
        setTimeout(() => setHasNewAlert(false), 3000);
        setTimeout(() => setToastAlert(null), 6500);
      }
    };

    const handleUpdate = () => refreshNotifications();

    window.addEventListener('casmik_notification_received', handleLocalNotif);
    window.addEventListener('casmik_notification_updated', handleUpdate);
    window.addEventListener('casmik_sound_setting_changed', handleUpdate);

    // Close on outside click
    const handleOutsideClick = (e: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleOutsideClick);

    return () => {
      if (channel) channel.close();
      window.removeEventListener('casmik_notification_received', handleLocalNotif);
      window.removeEventListener('casmik_notification_updated', handleUpdate);
      window.removeEventListener('casmik_sound_setting_changed', handleUpdate);
      document.removeEventListener('mousedown', handleOutsideClick);
    };
  }, [role]);

  const unreadCount = notifications.filter(n => !n.read).length;

  const handleToggleMute = (e: React.MouseEvent) => {
    e.stopPropagation();
    const next = !muted;
    setMuted(next);
    setSoundMuted(next);
    if (!next) {
      playNotificationSound();
    }
  };

  const handleTestChime = (e: React.MouseEvent) => {
    e.stopPropagation();
    playNotificationSound();
    requestBrowserNotificationPermission();
  };

  const handleMarkAllRead = (e: React.MouseEvent) => {
    e.stopPropagation();
    markAllNotificationsAsRead(role);
    refreshNotifications();
  };

  const handleItemClick = (notif: CasmikNotification) => {
    markNotificationAsRead(notif.id);
    refreshNotifications();
    setIsOpen(false);

    if (notif.orderNumber && onNavigateToOrder) {
      onNavigateToOrder(notif.orderNumber);
    } else if (notif.type === 'payout' && onNavigateSection) {
      onNavigateSection('payouts');
    } else if (onNavigateSection) {
      onNavigateSection('orders');
    }
  };

  const filtered = notifications.filter(n => {
    if (filter === 'unread') return !n.read;
    if (filter === 'orders') return n.type === 'new_booking' || n.type === 'status_update' || n.type === 'inspection';
    if (filter === 'payouts') return n.type === 'payout';
    return true;
  });

  const getNotifIcon = (type: CasmikNotification['type']) => {
    switch (type) {
      case 'new_booking':
        return { icon: <Package size={15} className="text-emerald-600" />, bg: 'bg-emerald-100' };
      case 'status_update':
        return { icon: <Truck size={15} className="text-blue-600" />, bg: 'bg-blue-100' };
      case 'inspection':
        return { icon: <ClipboardCheck size={15} className="text-amber-600" />, bg: 'bg-amber-100' };
      case 'payout':
        return { icon: <CreditCard size={15} className="text-purple-600" />, bg: 'bg-purple-100' };
      default:
        return { icon: <Info size={15} className="text-gray-600" />, bg: 'bg-gray-100' };
    }
  };

  const formatTimeAgo = (iso: string) => {
    const diff = Math.floor((Date.now() - new Date(iso).getTime()) / 1000);
    if (diff < 60) return 'Just now';
    if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
    return `${Math.floor(diff / 86400)}d ago`;
  };

  return (
    <div className="relative" ref={containerRef}>
      {/* BELL BUTTON */}
      <button
        type="button"
        onClick={() => {
          setIsOpen(!isOpen);
          requestBrowserNotificationPermission();
        }}
        className={`relative p-2.5 rounded-xl transition-all cursor-pointer ${
          isOpen ? 'bg-primary/10 text-primary' : 'hover:bg-gray-100 text-gray-600'
        } ${hasNewAlert ? 'animate-bounce text-primary' : ''}`}
        title="Live Notifications"
      >
        <Bell size={18} />
        {unreadCount > 0 && (
          <span className="absolute top-1 right-1 min-w-[18px] h-[18px] bg-red-500 text-white text-[10px] font-black rounded-full flex items-center justify-center px-1 shadow-sm animate-pulse">
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
      </button>

      {/* FLOATING IN-APP POPUP TOAST (WHEN NEW ALERT ARRIVES) */}
      {toastAlert && (
        <div 
          onClick={() => {
            handleItemClick(toastAlert);
            setToastAlert(null);
          }}
          className="fixed bottom-6 right-6 z-50 max-w-sm w-full bg-gray-900 text-white p-4 rounded-2xl shadow-2xl border border-gray-700 animate-in fade-in slide-in-from-bottom-5 cursor-pointer hover:bg-gray-800 transition-all font-sans"
        >
          <div className="flex items-start gap-3">
            <div className="w-8 h-8 rounded-xl bg-primary/20 text-primary flex items-center justify-center flex-shrink-0 mt-0.5">
              <Bell size={16} className="animate-wiggle" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center justify-between gap-1 mb-0.5">
                <p className="text-xs font-black text-white truncate">{toastAlert.title}</p>
                <span className="text-[10px] text-gray-400 flex-shrink-0">Just now</span>
              </div>
              <p className="text-xs text-gray-300 leading-snug line-clamp-2">{toastAlert.shortDetails}</p>
              <div className="mt-2 flex items-center gap-2">
                <span className="text-[10px] font-bold text-primary flex items-center gap-1 hover:underline">
                  View Details <ExternalLink size={10} />
                </span>
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    setToastAlert(null);
                  }}
                  className="text-[10px] text-gray-500 hover:text-gray-300 ml-auto p-1"
                >
                  Dismiss
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* NOTIFICATIONS POPOVER MODAL */}
      {isOpen && (
        <div className="absolute right-0 top-12 w-84 sm:w-96 bg-white rounded-2xl shadow-2xl border border-gray-100 z-50 overflow-hidden font-sans animate-in fade-in zoom-in-95">
          {/* Header */}
          <div className="p-3.5 bg-gradient-to-r from-gray-50 via-white to-gray-50 border-b border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <h3 className="font-black text-gray-900 text-sm">Notifications</h3>
              {unreadCount > 0 && (
                <span className="px-2 py-0.5 text-[10px] font-extrabold bg-red-100 text-red-700 rounded-full">
                  {unreadCount} new
                </span>
              )}
            </div>

            {/* Quick Actions in Header */}
            <div className="flex items-center gap-1">
              {/* Sound Test / Play Chime */}
              <button
                type="button"
                onClick={handleTestChime}
                title="Test Sound Chime"
                className="p-1.5 rounded-lg text-gray-500 hover:text-primary hover:bg-gray-100 transition-colors flex items-center gap-1 text-[11px] font-bold"
              >
                <Play size={11} className="fill-current" /> Chime
              </button>

              {/* Sound Toggle (Mute/Unmute) */}
              <button
                type="button"
                onClick={handleToggleMute}
                title={muted ? 'Unmute Sound' : 'Mute Sound'}
                className={`p-1.5 rounded-lg transition-colors ${
                  muted ? 'text-gray-400 hover:bg-gray-100' : 'text-emerald-600 hover:bg-emerald-50'
                }`}
              >
                {muted ? <VolumeX size={15} /> : <Volume2 size={15} />}
              </button>

              {/* Mark All Read */}
              {unreadCount > 0 && (
                <button
                  type="button"
                  onClick={handleMarkAllRead}
                  title="Mark All Read"
                  className="p-1.5 rounded-lg text-gray-500 hover:text-emerald-600 hover:bg-gray-100 transition-colors"
                >
                  <CheckCheck size={15} />
                </button>
              )}

              {/* Close Popover */}
              <button
                type="button"
                onClick={() => setIsOpen(false)}
                className="p-1.5 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-colors"
              >
                <X size={15} />
              </button>
            </div>
          </div>

          {/* Filter Tabs */}
          <div className="flex gap-1 p-2 bg-gray-50/70 border-b border-gray-100 text-xs overflow-x-auto scrollbar-hide">
            {[
              { id: 'all', label: `All (${notifications.length})` },
              { id: 'unread', label: `Unread (${unreadCount})` },
              { id: 'orders', label: 'Orders' },
              { id: 'payouts', label: 'Payouts' },
            ].map(tab => (
              <button
                key={tab.id}
                type="button"
                onClick={() => setFilter(tab.id as any)}
                className={`px-2.5 py-1 rounded-lg font-bold text-[11px] transition-all whitespace-nowrap cursor-pointer ${
                  filter === tab.id
                    ? 'bg-white text-primary shadow-sm border border-gray-200/80'
                    : 'text-gray-500 hover:text-gray-900'
                }`}
              >
                {tab.label}
              </button>
            ))}
          </div>

          {/* Notification List */}
          <div className="divide-y divide-gray-50 max-h-80 overflow-y-auto">
            {filtered.map(notif => {
              const { icon, bg } = getNotifIcon(notif.type);
              return (
                <div
                  key={notif.id}
                  onClick={() => handleItemClick(notif)}
                  className={`p-3.5 hover:bg-gray-50/90 transition-colors cursor-pointer group flex items-start gap-3 relative ${
                    !notif.read ? 'bg-primary/5' : ''
                  }`}
                >
                  {/* Icon Avatar */}
                  <div className={`w-8 h-8 rounded-xl ${bg} flex items-center justify-center flex-shrink-0 mt-0.5 shadow-sm`}>
                    {icon}
                  </div>

                  {/* Body */}
                  <div className="flex-1 min-w-0 pr-6">
                    <div className="flex items-center justify-between gap-1 mb-0.5">
                      <p className="text-xs font-black text-gray-900 truncate">{notif.title}</p>
                      <span className="text-[10px] text-gray-400 font-medium flex-shrink-0">
                        {formatTimeAgo(notif.timestamp)}
                      </span>
                    </div>

                    <p className="text-xs text-gray-600 leading-snug font-normal">
                      {notif.shortDetails}
                    </p>

                    {notif.price && (
                      <p className="text-[11px] font-extrabold text-emerald-700 mt-1">
                        Amount: ₹{notif.price.toLocaleString('en-IN')}
                      </p>
                    )}
                  </div>

                  {/* Delete / Dismiss Icon */}
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      deleteNotification(notif.id);
                      refreshNotifications();
                    }}
                    className="absolute right-2.5 top-3.5 opacity-0 group-hover:opacity-100 text-gray-400 hover:text-red-600 p-1 rounded transition-opacity"
                    title="Delete notification"
                  >
                    <Trash2 size={13} />
                  </button>

                  {/* Unread indicator pip */}
                  {!notif.read && (
                    <span className="absolute right-3.5 top-1/2 -translate-y-1/2 w-2 h-2 rounded-full bg-primary" />
                  )}
                </div>
              );
            })}

            {filtered.length === 0 && (
              <div className="py-10 text-center text-gray-400">
                <Sparkles size={28} className="mx-auto mb-2 text-gray-300" />
                <p className="text-xs font-bold text-gray-600">All caught up!</p>
                <p className="text-[11px] text-gray-400 mt-0.5">No notifications in this filter view</p>
              </div>
            )}
          </div>

          {/* Footer */}
          <div className="p-2.5 bg-gray-50 border-t border-gray-100 text-center flex items-center justify-between text-[11px] text-gray-500 px-4">
            <span className="flex items-center gap-1">
              <Volume2 size={12} className={muted ? 'text-gray-400' : 'text-emerald-600'} />
              Audio Chime: <strong>{muted ? 'Muted' : 'Active'}</strong>
            </span>
            <button
              type="button"
              onClick={handleMarkAllRead}
              className="font-bold text-primary hover:underline cursor-pointer"
            >
              Clear Unread
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

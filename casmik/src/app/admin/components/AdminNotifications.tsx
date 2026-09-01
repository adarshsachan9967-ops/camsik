'use client';
import React, { useState } from 'react';
import { Bell, Package, Handshake, Truck, CheckCircle, X, Filter } from 'lucide-react';
import Icon from '@/components/ui/AppIcon';


const allNotifications = [
  { id: 1, type: 'order', title: 'New Sell Order', msg: 'Rahul Sharma placed a sell order for iPhone 16 Pro Max 256GB', time: '2 min ago', read: false, priority: 'high' },
  { id: 2, type: 'partner', title: 'Partner Signup', msg: 'DigiWorld (Delhi) submitted signup documents for approval', time: '15 min ago', read: false, priority: 'high' },
  { id: 3, type: 'delivery', title: 'Delivery Agent Onboarded', msg: 'Priya Sharma (Delhi) has registered as a delivery agent', time: '1 hour ago', read: false, priority: 'medium' },
  { id: 4, type: 'order', title: 'Inspection Completed', msg: 'TechHub Store completed inspection for order CSM-2024-014', time: '2 hours ago', read: true, priority: 'medium' },
  { id: 5, type: 'partner', title: 'Payout Request', msg: 'TechHub Store (Rajesh Kumar) requested payout of ₹28,500', time: '3 hours ago', read: true, priority: 'medium' },
  { id: 6, type: 'order', title: 'Order Completed', msg: 'Order CSM-2024-001 completed. Payment of ₹76,500 processed.', time: '5 hours ago', read: true, priority: 'low' },
  { id: 7, type: 'delivery', title: 'Pickup Completed', msg: 'Ravi Kumar completed pickup for order CSM-2024-019', time: '6 hours ago', read: true, priority: 'low' },
  { id: 8, type: 'partner', title: 'Bank Transfer Submitted', msg: 'MobileHub Store submitted bank transfer receipt for ₹50,000', time: '8 hours ago', read: true, priority: 'high' },
  { id: 9, type: 'order', title: 'New Buy Order', msg: 'Rohit Gupta placed a buy order for OnePlus 11 256GB', time: '1 day ago', read: true, priority: 'low' },
  { id: 10, type: 'delivery', title: 'Agent Online', msg: 'Suresh Nair (Mumbai) is now online and available for tasks', time: '1 day ago', read: true, priority: 'low' },
];

const typeConfig = {
  order: { icon: Package, color: 'text-blue-600', bg: 'bg-blue-100', label: 'Order' },
  partner: { icon: Handshake, color: 'text-purple-600', bg: 'bg-purple-100', label: 'Partner' },
  delivery: { icon: Truck, color: 'text-green-600', bg: 'bg-green-100', label: 'Delivery' },
};

export default function AdminNotifications() {
  const [notifications, setNotifications] = useState(allNotifications);
  const [filter, setFilter] = useState<'all' | 'order' | 'partner' | 'delivery'>('all');
  const [showUnreadOnly, setShowUnreadOnly] = useState(false);

  const filtered = notifications.filter(n =>
    (filter === 'all' || n.type === filter) &&
    (!showUnreadOnly || !n.read)
  );

  const unreadCount = notifications.filter(n => !n.read).length;

  const markAllRead = () => setNotifications(prev => prev.map(n => ({ ...n, read: true })));
  const markRead = (id: number) => setNotifications(prev => prev.map(n => n.id === id ? { ...n, read: true } : n));
  const deleteNotif = (id: number) => setNotifications(prev => prev.filter(n => n.id !== id));

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black text-gray-900">Notifications</h2>
          <p className="text-sm text-gray-500">{unreadCount} unread notifications</p>
        </div>
        {unreadCount > 0 && (
          <button onClick={markAllRead} className="flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-xl text-sm font-semibold hover:bg-gray-200">
            <CheckCircle size={14} /> Mark All Read
          </button>
        )}
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-4">
        {[
          { label: 'Order Notifications', value: notifications.filter(n => n.type === 'order').length, icon: Package, color: 'text-blue-600', bg: 'bg-blue-50' },
          { label: 'Partner Notifications', value: notifications.filter(n => n.type === 'partner').length, icon: Handshake, color: 'text-purple-600', bg: 'bg-purple-50' },
          { label: 'Delivery Notifications', value: notifications.filter(n => n.type === 'delivery').length, icon: Truck, color: 'text-green-600', bg: 'bg-green-50' },
        ].map(s => {
          const Icon = s.icon;
          return (
            <div key={s.label} className={`${s.bg} rounded-2xl p-4`}>
              <div className="flex items-center gap-2 mb-1">
                <Icon size={16} className={s.color} />
                <p className={`text-2xl font-black ${s.color}`}>{s.value}</p>
              </div>
              <p className="text-xs text-gray-600">{s.label}</p>
            </div>
          );
        })}
      </div>

      {/* Filters */}
      <div className="flex items-center gap-3 flex-wrap">
        <div className="flex gap-1 bg-gray-100 rounded-xl p-1">
          {(['all', 'order', 'partner', 'delivery'] as const).map(f => (
            <button key={f} onClick={() => setFilter(f)}
              className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-all capitalize ${filter === f ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}>
              {f}
            </button>
          ))}
        </div>
        <button onClick={() => setShowUnreadOnly(s => !s)}
          className={`flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-bold border transition-all ${showUnreadOnly ? 'bg-primary text-white border-primary' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-300'}`}>
          <Filter size={12} /> Unread Only
        </button>
      </div>

      {/* Notification List */}
      <div className="space-y-2">
        {filtered.map(n => {
          const config = typeConfig[n.type as keyof typeof typeConfig];
          const Icon = config.icon;
          return (
            <div key={n.id} className={`flex items-start gap-4 p-4 rounded-2xl border transition-all ${!n.read ? 'bg-primary/5 border-primary/20' : 'bg-white border-gray-100'} hover:shadow-sm`}>
              <div className={`w-10 h-10 rounded-xl ${config.bg} flex items-center justify-center flex-shrink-0`}>
                <Icon size={18} className={config.color} />
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-0.5">
                  <p className="text-sm font-bold text-gray-900">{n.title}</p>
                  <span className={`text-xs font-bold px-1.5 py-0.5 rounded-full ${config.bg} ${config.color}`}>{config.label}</span>
                  {n.priority === 'high' && <span className="text-xs font-bold px-1.5 py-0.5 rounded-full bg-red-100 text-red-600">High</span>}
                  {!n.read && <span className="w-2 h-2 rounded-full bg-primary flex-shrink-0" />}
                </div>
                <p className="text-xs text-gray-600">{n.msg}</p>
                <p className="text-xs text-gray-400 mt-1">{n.time}</p>
              </div>
              <div className="flex items-center gap-1 flex-shrink-0">
                {!n.read && (
                  <button onClick={() => markRead(n.id)} className="p-1.5 rounded-lg hover:bg-gray-100 text-gray-400 hover:text-green-600 transition-colors" title="Mark as read">
                    <CheckCircle size={14} />
                  </button>
                )}
                <button onClick={() => deleteNotif(n.id)} className="p-1.5 rounded-lg hover:bg-red-50 text-gray-400 hover:text-red-500 transition-colors" title="Delete">
                  <X size={14} />
                </button>
              </div>
            </div>
          );
        })}
        {filtered.length === 0 && (
          <div className="text-center py-12 text-gray-400">
            <Bell size={32} className="mx-auto mb-2 opacity-40" />
            <p className="text-sm">No notifications found</p>
          </div>
        )}
      </div>
    </div>
  );
}

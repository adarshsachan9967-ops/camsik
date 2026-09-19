'use client';
import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { createClient } from '@/lib/supabase/client';
import type { Order, OrderStatus } from '@/lib/casmikData';
import { 
  MapPin, 
  Phone, 
  CheckCircle, 
  Camera, 
  X, 
  Navigation, 
  Package, 
  Truck, 
  Wifi, 
  WifiOff, 
  Eye, 
  Search, 
  Clock, 
  Calendar, 
  ArrowUpRight, 
  Copy, 
  Check, 
  ShieldCheck, 
  AlertCircle,
  Filter,
  SlidersHorizontal,
  ChevronRight,
  ExternalLink,
  UploadCloud
} from 'lucide-react';
import LiveOrderTracker from '@/components/LiveOrderTracker';
import { orders } from '@/lib/casmikData';
import { triggerNotification } from '@/lib/notifications';

const DELIVERY_AGENT_ID = 'delivery-001';

interface DBOrder {
  id: string;
  order_number: string;
  order_type: string;
  status: string;
  customer_name: string;
  customer_phone: string;
  customer_address: string;
  pin_code: string;
  city: string;
  device_name: string;
  quoted_price: number;
  partner_name: string | null;
  pickup_date: string | null;
  pickup_slot: string | null;
  created_at: string;
  updated_at: string;
}

function dbToOrder(o: DBOrder): Order {
  return {
    id: o.id,
    orderNumber: o.order_number,
    type: o.order_type as Order['type'],
    status: o.status as OrderStatus,
    customerId: '',
    customerName: o.customer_name,
    customerPhone: o.customer_phone,
    customerEmail: '',
    customerAddress: o.customer_address || '',
    pinCode: o.pin_code || '',
    city: o.city || '',
    deviceName: o.device_name,
    deviceBrand: '',
    deviceModel: '',
    deviceStorage: '',
    deviceColor: '',
    quotedPrice: o.quoted_price || 0,
    finalPrice: 0,
    partnerId: null,
    partnerName: o.partner_name,
    deliveryAgentId: DELIVERY_AGENT_ID,
    deliveryAgentName: 'Raghu Sharma',
    pickupDate: o.pickup_date || '',
    pickupSlot: o.pickup_slot || '',
    createdAt: o.created_at,
    updatedAt: o.updated_at,
    paymentStatus: 'pending',
    inspectionScore: null,
    notes: '',
  };
}

function getStoredDeliveryTasks(): Order[] {
  if (typeof window === 'undefined') return [];
  try {
    const raw = localStorage.getItem('casmik_orders_v1');
    const all: Order[] = raw ? JSON.parse(raw) : orders;
    return all.filter(o => o.deliveryAgentId === DELIVERY_AGENT_ID || o.deliveryAgentId === 'agent-101' || !o.deliveryAgentId);
  } catch {
    return orders.filter(o => o.deliveryAgentId === DELIVERY_AGENT_ID || o.deliveryAgentId === 'agent-101' || !o.deliveryAgentId);
  }
}

function saveLocalTasks(tasks: Order[]) {
  if (typeof window === 'undefined') return;
  try {
    const raw = localStorage.getItem('casmik_orders_v1');
    const all: Order[] = raw ? JSON.parse(raw) : orders;
    const taskMap = new Map(tasks.map(t => [t.id, t]));
    const updated = all.map(o => taskMap.has(o.id) ? { ...o, ...taskMap.get(o.id) } : o);
    localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
  } catch {}
}

export default function DeliveryTasks() {
  const [taskList, setTaskList] = useState<Order[]>(getStoredDeliveryTasks);
  const [loading, setLoading] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [activeTask, setActiveTask] = useState<Order | null>(null);
  const [selectedTask, setSelectedTask] = useState<Order | null>(null);
  const [otpInput, setOtpInput] = useState('');
  const [otpVerified, setOtpVerified] = useState(false);
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [activeTab, setActiveTab] = useState<'list' | 'live'>('list');
  const [searchQuery, setSearchQuery] = useState('');
  const [sortBy, setSortBy] = useState<'default' | 'price_desc' | 'slot'>('default');
  const [copiedId, setCopiedId] = useState<string | null>(null);
  const [capturedPhotos, setCapturedPhotos] = useState<string[]>([]);
  const supabase = createClient();

  const fetchTasks = useCallback(async () => {
    try {
      const { data, error } = await supabase
        .from('orders')
        .select('*')
        .eq('delivery_agent_id', DELIVERY_AGENT_ID)
        .order('created_at', { ascending: false });
      if (error) {
        if (error.code?.startsWith('42')) throw error;
        setTaskList(getStoredDeliveryTasks());
        return;
      }
      if (data && data.length > 0) {
        setTaskList(data.map(dbToOrder));
      } else {
        setTaskList(getStoredDeliveryTasks());
      }
    } catch {
      setTaskList(getStoredDeliveryTasks());
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchTasks();

    const channel = supabase
      .channel('delivery-tasks-realtime')
      .on('postgres_changes', {
        event: '*', schema: 'public', table: 'orders',
        filter: `delivery_agent_id=eq.${DELIVERY_AGENT_ID}`
      }, (payload) => {
        if (payload.eventType === 'INSERT') {
          setTaskList(prev => [dbToOrder(payload.new as DBOrder), ...prev]);
        } else if (payload.eventType === 'UPDATE') {
          setTaskList(prev => prev.map(t => t.id === (payload.new as DBOrder).id ? dbToOrder(payload.new as DBOrder) : t));
        } else if (payload.eventType === 'DELETE') {
          setTaskList(prev => prev.filter(t => t.id !== (payload.old as any).id));
        }
      })
      .subscribe(status => setIsConnected(status === 'SUBSCRIBED'));

    return () => { supabase.removeChannel(channel); };
  }, [fetchTasks]);

  const copyToClipboard = (text: string, id: string) => {
    if (typeof navigator !== 'undefined') {
      navigator.clipboard.writeText(text);
      setCopiedId(id);
      setTimeout(() => setCopiedId(null), 2000);
    }
  };

  const handleStartPickup = async (task: Order) => {
    const updated = taskList.map(t => t.id === task.id ? { ...t, status: 'pickup_scheduled' as OrderStatus } : t);
    setTaskList(updated);
    saveLocalTasks(updated);

    try {
      await supabase.from('orders').update({ status: 'pickup_scheduled' }).eq('id', task.id);
    } catch {}

    triggerNotification({
      type: 'status_update',
      targetRole: 'all',
      title: '🚚 Executive En Route',
      shortDetails: `Agent is navigating to pickup ${task.orderNumber} (${task.deviceName}) from ${task.customerName}.`,
      orderId: task.id,
      orderNumber: task.orderNumber,
      deviceName: task.deviceName,
      customerName: task.customerName,
      status: 'pickup_scheduled'
    });
  };

  const handleVerifyOTP = async () => {
    if ((otpInput === '1234' || otpInput.length === 4) && activeTask) {
      setOtpVerified(true);
      const updated = taskList.map(t => t.id === activeTask.id ? { ...t, status: 'picked_up' as OrderStatus } : t);
      setTaskList(updated);
      saveLocalTasks(updated);

      try {
        await supabase.from('orders').update({ status: 'picked_up' }).eq('id', activeTask.id);
      } catch {}

      triggerNotification({
        type: 'status_update',
        targetRole: 'all',
        title: '📦 Device Picked Up & Secured',
        shortDetails: `${activeTask.orderNumber} (${activeTask.deviceName}) collected from ${activeTask.customerName}. Moving to verification hub.`,
        orderId: activeTask.id,
        orderNumber: activeTask.orderNumber,
        deviceName: activeTask.deviceName,
        customerName: activeTask.customerName,
        status: 'picked_up'
      });
    }
  };

  const handleComplete = async (task: Order) => {
    const updated = taskList.map(t => t.id === task.id ? { ...t, status: 'completed' as OrderStatus } : t);
    setTaskList(updated);
    saveLocalTasks(updated);

    try {
      await supabase.from('orders').update({ status: 'completed' }).eq('id', task.id);
    } catch {}

    triggerNotification({
      type: 'status_update',
      targetRole: 'all',
      title: '✅ Delivery & Handover Complete',
      shortDetails: `Order ${task.orderNumber} successfully deposited at partner hub. Payout incentive unlocked!`,
      orderId: task.id,
      orderNumber: task.orderNumber,
      deviceName: task.deviceName,
      customerName: task.customerName,
      status: 'completed'
    });
    setActiveTask(null);
  };

  // Filter and search
  const filtered = useMemo(() => {
    return taskList.filter(t => {
      const matchesFilter = filterStatus === 'all' || 
        (filterStatus === 'assigned' && (t.status === 'assigned' || t.status === 'accepted')) ||
        (filterStatus === 'pickup_scheduled' && t.status === 'pickup_scheduled') ||
        (filterStatus === 'picked_up' && t.status === 'picked_up') ||
        (filterStatus === 'completed' && t.status === 'completed');

      if (!matchesFilter) return false;

      if (!searchQuery.trim()) return true;
      const q = searchQuery.toLowerCase();
      return (
        t.orderNumber?.toLowerCase().includes(q) ||
        t.deviceName?.toLowerCase().includes(q) ||
        t.customerName?.toLowerCase().includes(q) ||
        t.customerPhone?.toLowerCase().includes(q) ||
        t.city?.toLowerCase().includes(q) ||
        t.pinCode?.includes(q)
      );
    }).sort((a, b) => {
      if (sortBy === 'price_desc') return (b.quotedPrice || 0) - (a.quotedPrice || 0);
      if (sortBy === 'slot') return (a.pickupSlot || '').localeCompare(b.pickupSlot || '');
      return 0;
    });
  }, [taskList, filterStatus, searchQuery, sortBy]);

  // Operational metrics
  const stats = useMemo(() => {
    const assigned = taskList.filter(t => ['assigned', 'accepted'].includes(t.status)).length;
    const scheduled = taskList.filter(t => t.status === 'pickup_scheduled').length;
    const pickedUp = taskList.filter(t => t.status === 'picked_up').length;
    const completed = taskList.filter(t => t.status === 'completed').length;
    return { assigned, scheduled, pickedUp, completed, total: taskList.length };
  }, [taskList]);

  const tabs = [
    { id: 'all', label: 'All Tasks', count: stats.total },
    { id: 'assigned', label: 'Assigned', count: stats.assigned },
    { id: 'pickup_scheduled', label: 'En Route', count: stats.scheduled },
    { id: 'picked_up', label: 'In Transit', count: stats.pickedUp },
    { id: 'completed', label: 'Completed', count: stats.completed },
  ];

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center py-28 text-slate-400">
        <div className="w-10 h-10 border-3 border-primary border-t-transparent rounded-full animate-spin mb-3" />
        <p className="text-sm font-semibold">Synchronizing task queue...</p>
      </div>
    );
  }

  return (
    <div className="w-full space-y-6">
      {/* ─── TOP CONTROL BAR ────────────────────────────────────────── */}
      <div className="bg-white rounded-3xl p-5 sm:p-6 border border-slate-200/80 shadow-sm">
        <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-3">
              <h2 className="text-2xl font-black text-slate-900 tracking-tight">Executive Task Queue</h2>
              <span className={`inline-flex items-center gap-1.5 text-xs font-bold px-3 py-1 rounded-full ${
                isConnected ? 'bg-emerald-50 text-emerald-700 border border-emerald-200' : 'bg-slate-100 text-slate-600'
              }`}>
                {isConnected ? <Wifi size={12} className="text-emerald-600" /> : <WifiOff size={12} />}
                {isConnected ? 'Real-Time Sync' : 'Offline Buffer'}
              </span>
            </div>
            <p className="text-slate-500 text-sm mt-1">
              Manage door-to-door customer pickups, device handovers, and doorstep OTP verification.
            </p>
          </div>

          {/* View Mode Toggle */}
          <div className="flex items-center gap-2 self-start lg:self-auto">
            <button
              onClick={() => setActiveTab('list')}
              className={`flex items-center gap-2 px-4 py-2.5 rounded-2xl text-xs font-bold transition-all cursor-pointer ${
                activeTab === 'list'
                  ? 'bg-slate-900 text-white shadow-md shadow-slate-900/10'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              <Package size={15} /> Task Grid ({taskList.length})
            </button>
            <button
              onClick={() => setActiveTab('live')}
              className={`flex items-center gap-2 px-4 py-2.5 rounded-2xl text-xs font-bold transition-all cursor-pointer ${
                activeTab === 'live'
                  ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/20'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping inline-block" />
              Live Route Radar
            </button>
          </div>
        </div>

        {/* ─── 4-METRIC OPS SUMMARY CARDS ───────────────────────────── */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 sm:gap-4 mt-6 pt-6 border-t border-slate-100">
          <div className="bg-slate-50/80 rounded-2xl p-4 border border-slate-100">
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-bold text-slate-500">Ready Pickups</span>
              <span className="w-2 h-2 rounded-full bg-blue-500" />
            </div>
            <p className="text-2xl font-black text-slate-900">{stats.assigned}</p>
            <p className="text-[11px] text-slate-400 mt-0.5">Assigned to your bike</p>
          </div>

          <div className="bg-amber-50/60 rounded-2xl p-4 border border-amber-100/70">
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-bold text-amber-700">En Route</span>
              <span className="w-2 h-2 rounded-full bg-amber-500 animate-pulse" />
            </div>
            <p className="text-2xl font-black text-amber-900">{stats.scheduled}</p>
            <p className="text-[11px] text-amber-700/70 mt-0.5">Trips in progress</p>
          </div>

          <div className="bg-indigo-50/60 rounded-2xl p-4 border border-indigo-100/70">
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-bold text-indigo-700">In Transit</span>
              <Package size={14} className="text-indigo-600" />
            </div>
            <p className="text-2xl font-black text-indigo-900">{stats.pickedUp}</p>
            <p className="text-[11px] text-indigo-700/70 mt-0.5">Devices on bike to hub</p>
          </div>

          <div className="bg-emerald-50/60 rounded-2xl p-4 border border-emerald-100/70">
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-bold text-emerald-700">Completed</span>
              <CheckCircle size={14} className="text-emerald-600" />
            </div>
            <p className="text-2xl font-black text-emerald-900">{stats.completed}</p>
            <p className="text-[11px] text-emerald-700/70 mt-0.5">Delivered to partner</p>
          </div>
        </div>
      </div>

      {activeTab === 'live' ? (
        <div className="bg-white rounded-3xl p-6 border border-slate-200/80 shadow-sm">
          <LiveOrderTracker panel="delivery" deliveryAgentId={DELIVERY_AGENT_ID} title="Real-Time Fleet & Pickup Tracker" />
        </div>
      ) : (
        <>
          {/* ─── FILTERS & SEARCH ROW ────────────────────────────────────── */}
          <div className="flex flex-col md:flex-row items-stretch md:items-center justify-between gap-3">
            {/* Filter Pills */}
            <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
              {tabs.map(tab => (
                <button
                  key={tab.id}
                  onClick={() => setFilterStatus(tab.id)}
                  className={`flex-shrink-0 flex items-center gap-2 px-4 py-2.5 rounded-2xl text-xs font-bold transition-all cursor-pointer ${
                    filterStatus === tab.id
                      ? 'bg-primary text-white shadow-md shadow-primary/20 scale-[1.02]'
                      : 'bg-white border border-slate-200 text-slate-600 hover:border-primary/40 hover:bg-slate-50'
                  }`}
                >
                  <span>{tab.label}</span>
                  <span className={`px-2 py-0.5 rounded-full text-[10px] font-black ${
                    filterStatus === tab.id ? 'bg-white/20 text-white' : 'bg-slate-100 text-slate-600'
                  }`}>
                    {tab.count}
                  </span>
                </button>
              ))}
            </div>

            {/* Search Input & Sort Dropdown */}
            <div className="flex items-center gap-2">
              <div className="relative flex-1 sm:w-64">
                <Search size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  placeholder="Search device, customer, PIN..."
                  value={searchQuery}
                  onChange={e => setSearchQuery(e.target.value)}
                  className="w-full pl-9 pr-8 py-2.5 bg-white border border-slate-200 rounded-2xl text-xs font-medium focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 transition-all"
                />
                {searchQuery && (
                  <button onClick={() => setSearchQuery('')} className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 p-1">
                    <X size={13} />
                  </button>
                )}
              </div>

              <select
                value={sortBy}
                onChange={e => setSortBy(e.target.value as any)}
                aria-label="Sort task list"
                className="bg-white border border-slate-200 rounded-2xl px-3 py-2.5 text-xs font-bold text-slate-700 focus:outline-none focus:border-primary cursor-pointer"
              >
                <option value="default">Sort: Default</option>
                <option value="price_desc">Value: High to Low</option>
                <option value="slot">Slot: Time Window</option>
              </select>
            </div>
          </div>

          {/* ─── FULL WIDTH 3-COLUMN TASK GRID ───────────────────────────── */}
          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
            {filtered.map(task => {
              const isAssigned = task.status === 'assigned' || task.status === 'accepted';
              const isEnRoute = task.status === 'pickup_scheduled';
              const isPickedUp = task.status === 'picked_up';
              const isDone = task.status === 'completed';

              const mapUrl = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(
                (task.customerAddress || '') + ' ' + (task.city || '') + ' ' + (task.pinCode || '')
              )}`;

              return (
                <div
                  key={task.id}
                  onClick={() => setSelectedTask(task)}
                  className="bg-white rounded-3xl border border-slate-200/80 shadow-sm hover:shadow-xl hover:border-primary/50 transition-all duration-300 flex flex-col justify-between overflow-hidden group cursor-pointer"
                >
                  <div className="p-5 sm:p-6 space-y-4">
                    {/* Header Row */}
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-mono text-xs font-bold text-slate-400 group-hover:text-primary transition-colors">
                            {task.orderNumber}
                          </span>
                          <button
                            type="button"
                            onClick={(e) => {
                              e.stopPropagation();
                              copyToClipboard(task.orderNumber, task.id);
                            }}
                            className="text-slate-400 hover:text-slate-700 transition-colors"
                            title="Copy Order ID"
                          >
                            {copiedId === task.id ? <Check size={12} className="text-emerald-600" /> : <Copy size={12} />}
                          </button>
                        </div>
                        <h3 className="text-base font-black text-slate-900 group-hover:text-primary transition-colors mt-0.5 line-clamp-1">
                          {task.deviceName}
                        </h3>
                      </div>

                      <div className="text-right flex flex-col items-end">
                        <span className="text-base font-black text-emerald-700">
                          ₹{task.quotedPrice?.toLocaleString('en-IN')}
                        </span>
                        <span className={`text-[10px] font-black uppercase tracking-wider px-2 py-0.5 rounded-full mt-1 ${
                          task.type === 'sell' ? 'bg-emerald-100 text-emerald-800' :
                          task.type === 'buy' ? 'bg-blue-100 text-blue-800' :
                          'bg-amber-100 text-amber-800'
                        }`}>
                          {task.type}
                        </span>
                      </div>
                    </div>

                    {/* Status & Schedule Bar */}
                    <div className="flex items-center justify-between text-xs bg-slate-50 rounded-2xl p-2.5 border border-slate-100">
                      <div className="flex items-center gap-1.5 text-slate-600 font-semibold">
                        <Calendar size={13} className="text-primary" />
                        <span>{task.pickupDate || 'Today'}</span>
                      </div>
                      <div className="flex items-center gap-1.5 text-slate-600 font-semibold">
                        <Clock size={13} className="text-primary" />
                        <span>{task.pickupSlot || '10:00 AM - 1:00 PM'}</span>
                      </div>
                    </div>

                    {/* Customer & Location Card */}
                    <div className="bg-slate-50/70 rounded-2xl p-3.5 border border-slate-100/80 space-y-2">
                      <div className="flex items-center justify-between">
                        <p className="text-xs font-black text-slate-900 flex items-center gap-1.5">
                          <span>{task.customerName}</span>
                          <ShieldCheck size={13} className="text-emerald-600" />
                        </p>
                        <span className="text-[11px] font-mono font-semibold text-slate-500">
                          PIN: {task.pinCode || '400050'}
                        </span>
                      </div>
                      <div className="flex items-start gap-2 text-xs text-slate-600">
                        <MapPin size={14} className="text-primary flex-shrink-0 mt-0.5" />
                        <p className="line-clamp-2 leading-relaxed">
                          {task.customerAddress ? `${task.customerAddress}, ${task.city}` : 'Customer residential address provided'}
                        </p>
                      </div>
                    </div>

                    {/* Lifecycle Visual Progress */}
                    <div className="space-y-1.5 pt-1">
                      <div className="flex justify-between text-[11px] font-bold text-slate-400">
                        <span className={isAssigned || isEnRoute || isPickedUp || isDone ? 'text-primary' : ''}>Assigned</span>
                        <span className={isEnRoute || isPickedUp || isDone ? 'text-amber-600' : ''}>En Route</span>
                        <span className={isPickedUp || isDone ? 'text-indigo-600' : ''}>Picked Up</span>
                        <span className={isDone ? 'text-emerald-600' : ''}>Done</span>
                      </div>
                      <div className="h-1.5 w-full bg-slate-100 rounded-full overflow-hidden flex">
                        <div className={`h-full transition-all duration-500 ${
                          isDone ? 'w-full bg-emerald-500' :
                          isPickedUp ? 'w-3/4 bg-indigo-500' :
                          isEnRoute ? 'w-1/2 bg-amber-500' : 'w-1/4 bg-primary'
                        }`} />
                      </div>
                    </div>
                  </div>

                  {/* ─── ACTION BUTTONS BAR ───────────────────────────── */}
                  <div className="p-4 bg-slate-50/60 border-t border-slate-100 flex items-center gap-2" onClick={e => e.stopPropagation()}>
                    <button
                      type="button"
                      onClick={() => setSelectedTask(task)}
                      className="p-2.5 rounded-xl bg-white border border-slate-200 text-slate-600 hover:text-slate-900 hover:bg-slate-100 transition-colors"
                      title="Inspect Details"
                    >
                      <Eye size={15} />
                    </button>

                    <a
                      href={`tel:${task.customerPhone}`}
                      className="p-2.5 rounded-xl bg-white border border-slate-200 text-emerald-600 hover:bg-emerald-50 hover:border-emerald-300 transition-colors"
                      title={`Call ${task.customerPhone}`}
                    >
                      <Phone size={15} />
                    </a>

                    <a
                      href={mapUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="p-2.5 rounded-xl bg-white border border-slate-200 text-blue-600 hover:bg-blue-50 hover:border-blue-300 transition-colors"
                      title="Open GPS Navigation"
                    >
                      <Navigation size={15} />
                    </a>

                    {/* Dynamic Primary CTA */}
                    {isAssigned && (
                      <button
                        type="button"
                        onClick={() => handleStartPickup(task)}
                        className="flex-1 flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-gradient-to-r from-primary to-emerald-600 text-white text-xs font-black shadow-md shadow-primary/20 hover:opacity-95 transition-all cursor-pointer"
                      >
                        <Truck size={14} /> Start Navigation
                      </button>
                    )}

                    {isEnRoute && (
                      <button
                        type="button"
                        onClick={() => {
                          setActiveTask(task);
                          setOtpInput('');
                          setOtpVerified(false);
                        }}
                        className="flex-1 flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 text-white text-xs font-black shadow-md shadow-blue-600/20 hover:opacity-95 transition-all cursor-pointer"
                      >
                        <Package size={14} /> Verify Customer OTP
                      </button>
                    )}

                    {isPickedUp && (
                      <button
                        type="button"
                        onClick={() => handleComplete(task)}
                        className="flex-1 flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 text-white text-xs font-black shadow-md shadow-emerald-600/20 hover:opacity-95 transition-all cursor-pointer"
                      >
                        <CheckCircle size={14} /> Deposit to Hub
                      </button>
                    )}

                    {isDone && (
                      <div className="flex-1 flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-emerald-50 text-emerald-800 text-xs font-bold border border-emerald-200/80">
                        <CheckCircle size={14} className="text-emerald-600" /> Settled
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>

          {filtered.length === 0 && (
            <div className="bg-white rounded-3xl border border-slate-200/80 p-12 text-center text-slate-400">
              <Package size={48} className="mx-auto mb-3 opacity-30 text-slate-400" />
              <p className="text-lg font-black text-slate-700">No matching orders found</p>
              <p className="text-xs text-slate-400 max-w-sm mx-auto mt-1">
                There are no tasks matching the selected filters or search keyword. Try clearing your search or switching categories.
              </p>
              <button
                onClick={() => { setFilterStatus('all'); setSearchQuery(''); }}
                className="mt-4 px-4 py-2 bg-slate-100 text-slate-700 rounded-xl text-xs font-bold hover:bg-slate-200 transition-colors"
              >
                Reset All Filters
              </button>
            </div>
          )}
        </>
      )}

      {/* ─── MODAL 1: OTP VERIFICATION & INSPECTION PICKUP ──────────────────────── */}
      {activeTask && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setActiveTask(null)} />
          <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-md p-6 sm:p-7 z-10 border border-slate-100 animate-in fade-in zoom-in-95 duration-200">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100">
              <div>
                <span className="text-[11px] font-black text-primary uppercase tracking-wider">Pickup Confirmation</span>
                <h3 className="text-lg font-black text-slate-900">Doorstep OTP & Handover</h3>
              </div>
              <button
                onClick={() => setActiveTask(null)}
                className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-500 transition-colors"
              >
                <X size={16} />
              </button>
            </div>

            {!otpVerified ? (
              <div className="space-y-5 pt-4">
                {/* Target Device Summary */}
                <div className="bg-slate-50 rounded-2xl p-4 border border-slate-100 flex items-center justify-between">
                  <div>
                    <span className="text-[10px] font-bold text-slate-400 uppercase">Device & Customer</span>
                    <p className="font-black text-slate-900 text-sm mt-0.5">{activeTask.deviceName}</p>
                    <p className="text-xs text-slate-500">{activeTask.customerName} · {activeTask.customerPhone}</p>
                  </div>
                  <span className="text-base font-black text-emerald-700">₹{activeTask.quotedPrice?.toLocaleString('en-IN')}</span>
                </div>

                <div className="space-y-2">
                  <label className="text-xs font-bold text-slate-700 block">
                    Ask Customer for 4-Digit Pickup OTP:
                  </label>
                  <input
                    type="text"
                    maxLength={4}
                    value={otpInput}
                    onChange={e => setOtpInput(e.target.value.replace(/\D/g, ''))}
                    placeholder="• • • •"
                    className="w-full py-3.5 px-4 text-center font-mono text-3xl font-black tracking-[1em] bg-slate-50 border-2 border-slate-200 rounded-2xl focus:outline-none focus:border-primary focus:bg-white transition-all text-slate-900"
                    autoFocus
                  />
                  <div className="flex items-center justify-between text-xs text-slate-400 pt-1">
                    <span>Customer received via SMS</span>
                    <span className="font-semibold text-primary">Demo OTP: 1234</span>
                  </div>
                </div>

                {/* Pre-Inspection Checklist */}
                <div className="bg-blue-50/70 rounded-2xl p-3.5 border border-blue-100 text-xs text-blue-900 space-y-1.5">
                  <p className="font-bold flex items-center gap-1.5">
                    <ShieldCheck size={14} className="text-blue-600" /> Physical Handover Checklist:
                  </p>
                  <p className="text-blue-700">✓ Verify customer identity with registered name</p>
                  <p className="text-blue-700">✓ Check device powers on and iCloud/Google accounts signed out</p>
                  <p className="text-blue-700">✓ Place phone safely into Camsik Anti-Shock bubble pouch</p>
                </div>

                <button
                  type="button"
                  onClick={handleVerifyOTP}
                  disabled={otpInput.length < 4}
                  className="w-full py-4 bg-gradient-to-r from-primary to-emerald-600 text-white rounded-2xl font-black text-sm hover:opacity-95 transition-all shadow-lg shadow-primary/20 disabled:opacity-50 disabled:shadow-none cursor-pointer"
                >
                  Confirm OTP & Collect Device
                </button>
              </div>
            ) : (
              <div className="py-6 text-center space-y-4">
                <div className="w-16 h-16 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto shadow-inner">
                  <CheckCircle size={36} />
                </div>
                <div>
                  <h4 className="text-xl font-black text-slate-900">Device Verified & Secured!</h4>
                  <p className="text-xs text-slate-500 mt-1 max-w-xs mx-auto">
                    {activeTask.deviceName} is marked picked up and added to your active transit manifest.
                  </p>
                </div>

                <div className="p-3 bg-slate-50 rounded-2xl border border-dashed border-slate-200 text-left space-y-2">
                  <p className="text-xs font-bold text-slate-700">Optional: Capture Device Condition</p>
                  <div className="flex gap-2">
                    <label className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-bold text-slate-700 hover:bg-slate-100 cursor-pointer transition-colors">
                      <Camera size={14} className="text-primary" /> Snap Front/Back
                      <input
                        type="file"
                        accept="image/*"
                        capture="environment"
                        className="hidden"
                        onChange={e => {
                          const file = e.target.files?.[0];
                          if (file) {
                            const url = URL.createObjectURL(file);
                            setCapturedPhotos(prev => [...prev, url]);
                          }
                        }}
                      />
                    </label>
                  </div>
                  {capturedPhotos.length > 0 && (
                    <div className="flex gap-2 pt-1 overflow-x-auto">
                      {capturedPhotos.map((p, idx) => (
                        <img key={idx} src={p} alt="proof" className="w-12 h-12 rounded-lg object-cover border border-slate-200" />
                      ))}
                    </div>
                  )}
                </div>

                <button
                  onClick={() => {
                    setActiveTask(null);
                    setOtpVerified(false);
                    setOtpInput('');
                  }}
                  className="w-full py-3.5 bg-slate-900 text-white rounded-2xl font-bold text-sm hover:bg-slate-800 transition-colors cursor-pointer"
                >
                  Return to Task Queue
                </button>
              </div>
            )}
          </div>
        </div>
      )}

      {/* ─── MODAL 2: FULL TASK DETAILS & ESCALATION ────────────────────── */}
      {selectedTask && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm" onClick={() => setSelectedTask(null)} />
          <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-xl p-6 sm:p-7 z-10 max-h-[90vh] overflow-y-auto border border-slate-100 animate-in fade-in zoom-in-95 duration-200 space-y-5">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100">
              <div>
                <span className="text-[11px] font-bold text-slate-400">Order Manifest Information</span>
                <h3 className="text-xl font-black text-slate-900">{selectedTask.orderNumber}</h3>
              </div>
              <button
                onClick={() => setSelectedTask(null)}
                className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-500 transition-colors"
              >
                <X size={16} />
              </button>
            </div>

            {/* Device Block */}
            <div className="bg-slate-50 rounded-2xl p-4 border border-slate-100 flex items-center justify-between">
              <div>
                <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Quoted Device</span>
                <h4 className="text-base font-black text-slate-900 mt-0.5">{selectedTask.deviceName}</h4>
                <p className="text-xs text-slate-500 mt-0.5">
                  {selectedTask.deviceColor || 'Standard'} · {selectedTask.deviceStorage || 'Original'}
                </p>
              </div>
              <div className="text-right">
                <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Payout</span>
                <p className="text-xl font-black text-emerald-700">₹{selectedTask.quotedPrice?.toLocaleString('en-IN')}</p>
              </div>
            </div>

            {/* Customer & Location */}
            <div className="bg-slate-50 rounded-2xl p-4 border border-slate-100 space-y-3">
              <div className="flex items-center justify-between">
                <div>
                  <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Customer</span>
                  <p className="font-bold text-slate-900 text-sm mt-0.5">{selectedTask.customerName}</p>
                </div>
                <a
                  href={`tel:${selectedTask.customerPhone}`}
                  className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-100 text-emerald-800 rounded-xl text-xs font-bold hover:bg-emerald-200 transition-colors"
                >
                  <Phone size={13} /> {selectedTask.customerPhone}
                </a>
              </div>

              <div className="pt-2 border-t border-slate-200/60">
                <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Pickup Address</span>
                <p className="text-xs font-medium text-slate-700 mt-1 leading-relaxed">
                  📍 {selectedTask.customerAddress || 'Address on file'}, {selectedTask.city} - {selectedTask.pinCode}
                </p>
              </div>
            </div>

            {/* Slot & Timeline */}
            <div className="grid grid-cols-2 gap-3">
              <div className="bg-blue-50/70 border border-blue-100 rounded-2xl p-3.5">
                <span className="text-[11px] font-bold text-blue-800 block mb-1">Appointment Slot</span>
                <p className="text-sm font-black text-slate-900">{selectedTask.pickupDate || 'Today'}</p>
                <p className="text-xs text-slate-500 mt-0.5">{selectedTask.pickupSlot || '10:00 AM - 1:00 PM'}</p>
              </div>

              <div className="bg-emerald-50/70 border border-emerald-100 rounded-2xl p-3.5">
                <span className="text-[11px] font-bold text-emerald-800 block mb-1">Current Lifecycle</span>
                <p className="text-sm font-black capitalize text-slate-900">
                  {selectedTask.status.replace(/_/g, ' ')}
                </p>
                <p className="text-xs text-slate-500 mt-0.5">Assigned Agent: {selectedTask.deliveryAgentName}</p>
              </div>
            </div>

            {/* Action Bar */}
            <div className="pt-3 border-t border-slate-100 flex gap-3">
              <a
                href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(
                  (selectedTask.customerAddress || '') + ' ' + (selectedTask.city || '') + ' ' + (selectedTask.pinCode || '')
                )}`}
                target="_blank"
                rel="noopener noreferrer"
                className="flex-1 py-3.5 bg-blue-600 text-white rounded-2xl text-xs font-black text-center hover:bg-blue-700 transition-colors flex items-center justify-center gap-1.5 shadow-md shadow-blue-600/20"
              >
                <Navigation size={14} /> Navigate in Google Maps
              </a>

              <button
                onClick={() => {
                  const target = selectedTask;
                  setSelectedTask(null);
                  setActiveTask(target);
                }}
                className="flex-1 py-3.5 bg-primary text-white rounded-2xl text-xs font-black hover:opacity-95 transition-opacity flex items-center justify-center gap-1.5 shadow-md shadow-primary/20"
              >
                <Package size={14} /> Open OTP Keypad
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

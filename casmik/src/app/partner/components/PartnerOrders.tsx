'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { orders as defaultOrders, getOrderStatusColor, getOrderStatusLabel, getTypeColor } from '@/lib/casmikData';
import type { Order, OrderStatus } from '@/lib/casmikData';
import { Search, CheckCircle, XCircle, Eye, Phone, MapPin, X, Truck, Wifi, WifiOff, ChevronDown, SlidersHorizontal, ClipboardCheck, Sparkles } from 'lucide-react';
import LiveOrderTracker from '@/components/LiveOrderTracker';

const PARTNER_ID = 'partner-002';

const STATUS_OPTIONS: { value: OrderStatus; label: string }[] = [
  { value: 'assigned', label: 'New / Assigned' },
  { value: 'accepted', label: 'Order Accepted' },
  { value: 'pickup_scheduled', label: 'Pickup Scheduled' },
  { value: 'picked_up', label: 'Picked Up' },
  { value: 'in_transit', label: 'In Transit' },
  { value: 'inspection', label: 'Under Inspection' },
  { value: 'completed', label: 'Order Completed' },
  { value: 'cancelled', label: 'Cancelled' },
];

const getStoredPartnerOrders = (): Order[] => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_partner_orders_v1') || localStorage.getItem('casmik_orders_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) {
          return parsed.filter((o: Order) => o.partnerId === PARTNER_ID || !o.partnerId || o.partnerId === 'partner-001');
        }
      }
    } catch (e) {}
  }
  return defaultOrders.filter(o => o.partnerId === PARTNER_ID || !o.partnerId || o.partnerId === 'partner-001');
};

interface DBOrder {
  id: string;
  order_number: string;
  order_type: string;
  status: string;
  customer_name: string;
  customer_phone: string;
  customer_email: string;
  customer_address: string;
  pin_code: string;
  city: string;
  device_name: string;
  device_brand: string;
  device_model: string;
  device_storage: string;
  device_color: string;
  quoted_price: number;
  final_price: number;
  partner_id: string | null;
  partner_name: string | null;
  delivery_agent_id: string | null;
  delivery_agent_name: string | null;
  pickup_date: string | null;
  pickup_slot: string | null;
  payment_status: string;
  inspection_score: number | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

function dbToOrder(o: DBOrder): Order {
  return {
    id: o.id, orderNumber: o.order_number, type: o.order_type as Order['type'],
    status: o.status as OrderStatus, customerId: '', customerName: o.customer_name,
    customerPhone: o.customer_phone, customerEmail: o.customer_email || '',
    customerAddress: o.customer_address || '', pinCode: o.pin_code || '', city: o.city || '',
    deviceName: o.device_name, deviceBrand: o.device_brand || '', deviceModel: o.device_model || '',
    deviceStorage: o.device_storage || '', deviceColor: o.device_color || '',
    quotedPrice: o.quoted_price || 0, finalPrice: o.final_price || 0,
    partnerId: o.partner_id, partnerName: o.partner_name,
    deliveryAgentId: o.delivery_agent_id, deliveryAgentName: o.delivery_agent_name,
    pickupDate: o.pickup_date || '', pickupSlot: o.pickup_slot || '',
    createdAt: o.created_at, updatedAt: o.updated_at,
    paymentStatus: o.payment_status as Order['paymentStatus'],
    inspectionScore: o.inspection_score, notes: o.notes || '',
  };
}

interface PartnerOrdersProps {
  onStartInspection?: (orderId: string) => void;
}

export default function PartnerOrders({ onStartInspection }: PartnerOrdersProps) {
  const [orderList, setOrderList] = useState<Order[]>(getStoredPartnerOrders);
  const [loading, setLoading] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [query, setQuery] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [activeTab, setActiveTab] = useState<'list' | 'live'>('list');
  const [statusToast, setStatusToast] = useState<{ message: string; actionLabel?: string; onAction?: () => void } | null>(null);
  const supabase = createClient();

  const fetchOrders = useCallback(async () => {
    try {
      const { data, error } = await supabase
        .from('orders')
        .select('*')
        .eq('partner_id', PARTNER_ID)
        .order('created_at', { ascending: false });
      if (!error && data && data.length > 0) {
        setOrderList(data.map(dbToOrder));
        setIsConnected(true);
        return;
      }
    } catch (err: any) {
      console.log('Partner orders remote notice:', err.message);
    } finally {
      setLoading(false);
    }
    setOrderList(getStoredPartnerOrders());
  }, [supabase]);

  useEffect(() => {
    fetchOrders();

    const channel = supabase
      .channel('partner-orders-realtime')
      .on('postgres_changes', {
        event: '*', schema: 'public', table: 'orders',
        filter: `partner_id=eq.${PARTNER_ID}`
      }, (payload) => {
        if (payload.eventType === 'INSERT') {
          setOrderList(prev => [dbToOrder(payload.new as DBOrder), ...prev]);
        } else if (payload.eventType === 'UPDATE') {
          setOrderList(prev => prev.map(o => o.id === (payload.new as DBOrder).id ? dbToOrder(payload.new as DBOrder) : o));
          setSelectedOrder(prev => prev?.id === (payload.new as DBOrder).id ? dbToOrder(payload.new as DBOrder) : prev);
        } else if (payload.eventType === 'DELETE') {
          setOrderList(prev => prev.filter(o => o.id !== (payload.old as any).id));
        }
      })
      .subscribe(status => setIsConnected(status === 'SUBSCRIBED'));

    return () => { supabase.removeChannel(channel); };
  }, [fetchOrders]);

  // Master status change handler: updates UI immediately, saves persistently, and syncs
  const handleStatusChange = async (orderId: string, newStatus: OrderStatus) => {
    // 1. Immediately update orderList in state
    setOrderList(prev => {
      const updated = prev.map(o => o.id === orderId ? { ...o, status: newStatus } : o);
      if (typeof window !== 'undefined') {
        localStorage.setItem('casmik_partner_orders_v1', JSON.stringify(updated));
      }
      return updated;
    });

    // 2. Update selectedOrder if it's currently open in modal
    setSelectedOrder(prev => prev && prev.id === orderId ? { ...prev, status: newStatus } : prev);

    // 3. Update global orders in localStorage
    if (typeof window !== 'undefined') {
      try {
        const savedGlobal = localStorage.getItem('casmik_orders_v1');
        if (savedGlobal) {
          const list = JSON.parse(savedGlobal);
          if (Array.isArray(list)) {
            const updated = list.map((o: any) => o.id === orderId ? { ...o, status: newStatus } : o);
            localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
          }
        }
      } catch {}
    }

    // 4. Show success toast notification with optional immediate action
    const label = getOrderStatusLabel(newStatus);
    if (newStatus === 'accepted') {
      setStatusToast({
        message: `Order marked as Accepted! Ready for device inspection.`,
        actionLabel: 'Start Inspection →',
        onAction: () => {
          handleStatusChange(orderId, 'inspection');
          onStartInspection?.(orderId);
        }
      });
    } else {
      setStatusToast({
        message: `Order status updated to "${label}"`,
      });
    }
    setTimeout(() => setStatusToast(null), 4500);

    // 5. Try remote supabase update
    try {
      await supabase.from('orders').update({ status: newStatus }).eq('id', orderId);
    } catch (err: any) {
      console.log('Remote status update note:', err.message);
    }
  };

  const handleAccept = (id: string) => handleStatusChange(id, 'accepted');
  const handleReject = (id: string) => handleStatusChange(id, 'rejected');
  const handlePickup = (id: string) => handleStatusChange(id, 'picked_up');

  const filtered = orderList.filter(o =>
    (o.orderNumber.toLowerCase().includes(query.toLowerCase()) || o.customerName.toLowerCase().includes(query.toLowerCase())) &&
    (filterStatus === 'all' || o.status === filterStatus)
  );

  const tabs = [
    { id: 'all', label: 'All', count: orderList.length },
    { id: 'assigned', label: 'New', count: orderList.filter(o => o.status === 'assigned').length },
    { id: 'accepted', label: 'Accepted', count: orderList.filter(o => o.status === 'accepted').length },
    { id: 'picked_up', label: 'Picked Up', count: orderList.filter(o => o.status === 'picked_up').length },
    { id: 'inspection', label: 'Inspection', count: orderList.filter(o => o.status === 'inspection').length },
    { id: 'completed', label: 'Completed', count: orderList.filter(o => o.status === 'completed').length },
  ];

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-5">
      {/* Toast Notification */}
      {statusToast && (
        <div className="fixed bottom-6 right-6 z-50 bg-gray-900 text-white px-4 py-3 rounded-2xl shadow-2xl flex items-center gap-3 text-xs font-bold border border-gray-700 animate-in fade-in slide-in-from-bottom-2">
          <CheckCircle size={16} className="text-green-400 flex-shrink-0" />
          <span>{statusToast.message}</span>
          {statusToast.actionLabel && statusToast.onAction && (
            <button
              onClick={statusToast.onAction}
              className="ml-2 px-3 py-1 bg-indigo-600 hover:bg-indigo-500 text-white rounded-lg text-xs font-bold transition-all shadow-md cursor-pointer flex items-center gap-1 flex-shrink-0"
            >
              <ClipboardCheck size={12} /> {statusToast.actionLabel}
            </button>
          )}
        </div>
      )}

      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="text-xl font-black text-gray-900 flex items-center gap-2">
            Order Management
            <span className="inline-flex items-center gap-1.5 text-xs font-bold px-2.5 py-0.5 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200">
              <CheckCircle size={11} className="text-emerald-600" />
              {isConnected ? 'Live Synced' : `Active Store Orders (${orderList.length})`}
            </span>
          </h2>
          <p className="text-sm text-gray-500">Manage your assigned orders and update order statuses</p>
        </div>
      </div>

      {/* View Tabs */}
      <div className="flex gap-2">
        {[{ id: 'list', label: '📋 My Orders' }, { id: 'live', label: '🔴 Live Tracker' }].map(tab => (
          <button key={tab.id} onClick={() => setActiveTab(tab.id as any)}
            className={`px-4 py-2 rounded-xl text-sm font-bold transition-all ${
              activeTab === tab.id ? 'bg-primary text-white shadow-lg shadow-primary/20' : 'bg-white border border-gray-200 text-gray-600 hover:border-primary/40'
            }`}>
            {tab.label}
          </button>
        ))}
      </div>

      {activeTab === 'live' ? (
        <LiveOrderTracker panel="partner" partnerId={PARTNER_ID} title="Partner Live Order Tracker" />
      ) : (
        <>
          {/* Status Tabs */}
          <div className="flex gap-2 overflow-x-auto scrollbar-hide pb-1">
            {tabs.map(tab => (
              <button key={tab.id} onClick={() => setFilterStatus(tab.id)}
                className={`flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-all flex-shrink-0 ${filterStatus === tab.id ? 'bg-primary text-white shadow-lg shadow-primary/20' : 'bg-white border border-gray-200 text-gray-600 hover:border-primary/40'}`}>
                {tab.label}
                {tab.count > 0 && <span className={`px-1.5 py-0.5 rounded-full text-xs font-black ${filterStatus === tab.id ? 'bg-white/20 text-white' : 'bg-gray-100 text-gray-600'}`}>{tab.count}</span>}
              </button>
            ))}
          </div>

          <div className="relative">
            <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Search orders..."
              className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white" />
          </div>

          <div className="space-y-3">
            {filtered.map((order) => (
              <div
                key={order.id}
                onClick={() => setSelectedOrder(order)}
                className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 hover:shadow-md hover:border-primary/40 transition-all cursor-pointer group"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <div className="flex items-center gap-2 mb-1 flex-wrap">
                      <span className="text-xs font-black text-gray-500 group-hover:text-primary transition-colors">{order.orderNumber}</span>
                      <span className={`text-xs font-bold px-2 py-0.5 rounded-lg capitalize ${getTypeColor(order.type)}`}>{order.type}</span>
                      <span className={`text-xs font-semibold px-2 py-0.5 rounded-lg ${getOrderStatusColor(order.status)}`}>{getOrderStatusLabel(order.status)}</span>
                    </div>
                    <p className="text-sm font-bold text-gray-900 group-hover:text-primary transition-colors">{order.deviceName}</p>
                  </div>
                  <p className="text-lg font-black text-gray-900">₹{order.quotedPrice.toLocaleString('en-IN')}</p>
                </div>

                <div className="grid grid-cols-2 gap-3 mb-3 text-xs">
                  <div className="flex items-center gap-1.5 text-gray-600">
                    <div className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold text-xs flex-shrink-0">
                      {order.customerName ? order.customerName[0] : 'C'}
                    </div>
                    <div>
                      <p className="font-semibold text-gray-800">{order.customerName}</p>
                      <p className="text-gray-400">{order.customerPhone}</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-1.5 text-gray-600">
                    <MapPin size={12} className="mt-0.5 flex-shrink-0 text-primary" />
                    <div>
                      <p className="font-semibold text-gray-800">{order.city}</p>
                      <p className="text-gray-400">PIN: {order.pinCode}</p>
                    </div>
                  </div>
                </div>

                <div className="flex items-center justify-between text-xs text-gray-500 mb-3 bg-gray-50/70 px-3 py-1.5 rounded-xl">
                  <span>📅 Pickup: <strong>{order.pickupDate || 'Flexible'}</strong></span>
                  <span>🕐 {order.pickupSlot || '10:00 AM - 1:00 PM'}</span>
                </div>

                {/* Card Actions Bar: Accept, Details, Call, and Direct Change Status Dropdown */}
                <div className="flex flex-wrap items-center gap-2 pt-2 border-t border-gray-100" onClick={(e) => e.stopPropagation()}>
                  <button
                    type="button"
                    onClick={() => setSelectedOrder(order)}
                    className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-bold text-gray-700 hover:bg-primary hover:text-white hover:border-primary transition-colors cursor-pointer"
                  >
                    <Eye size={13} /> Details
                  </button>

                  <a
                    href={`tel:${order.customerPhone}`}
                    className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-bold text-gray-700 hover:bg-green-50 hover:text-green-700 hover:border-green-300 transition-colors cursor-pointer"
                  >
                    <Phone size={13} /> Call
                  </a>

                  {/* Action buttons depending on order status */}
                  {order.status !== 'accepted' && order.status !== 'completed' && order.status !== 'picked_up' && order.status !== 'inspection' ? (
                    <button
                      type="button"
                      onClick={() => handleAccept(order.id)}
                      className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-green-600 text-white text-xs font-bold hover:bg-green-700 transition-colors shadow-sm shadow-green-600/20 cursor-pointer"
                    >
                      <CheckCircle size={13} /> Accept Order
                    </button>
                  ) : order.status === 'accepted' ? (
                    <div className="flex items-center gap-1.5 flex-wrap">
                      <button
                        type="button"
                        onClick={() => {
                          handleStatusChange(order.id, 'inspection');
                          onStartInspection?.(order.id);
                        }}
                        className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-indigo-600 text-white text-xs font-bold hover:bg-indigo-700 transition-colors shadow-sm shadow-indigo-600/20 cursor-pointer"
                      >
                        <ClipboardCheck size={13} /> Start Inspection
                      </button>
                      <button
                        type="button"
                        onClick={() => handlePickup(order.id)}
                        className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-gray-100 text-gray-700 text-xs font-bold hover:bg-gray-200 transition-colors cursor-pointer"
                      >
                        <Truck size={13} /> Start Pickup
                      </button>
                    </div>
                  ) : order.status === 'inspection' ? (
                    <button
                      type="button"
                      onClick={() => onStartInspection?.(order.id)}
                      className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-amber-500 text-white text-xs font-bold hover:bg-amber-600 transition-colors shadow-sm shadow-amber-500/20 cursor-pointer"
                    >
                      <ClipboardCheck size={13} /> Continue Inspection
                    </button>
                  ) : order.status === 'picked_up' ? (
                    <button
                      type="button"
                      onClick={() => {
                        handleStatusChange(order.id, 'inspection');
                        onStartInspection?.(order.id);
                      }}
                      className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-indigo-600 text-white text-xs font-bold hover:bg-indigo-700 transition-colors shadow-sm shadow-indigo-600/20 cursor-pointer"
                    >
                      <ClipboardCheck size={13} /> Start Inspection
                    </button>
                  ) : null}

                  {/* Change Order Status Dropdown */}
                  <div className="flex items-center gap-1.5 ml-auto">
                    <span className="text-[11px] font-bold text-gray-500 hidden sm:inline">Change Status:</span>
                    <div className="relative">
                      <select
                        value={order.status}
                        onChange={(e) => handleStatusChange(order.id, e.target.value as OrderStatus)}
                        className="text-xs font-bold bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-xl pl-2.5 pr-7 py-2 text-gray-800 hover:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20 cursor-pointer appearance-none shadow-sm transition-all"
                      >
                        {STATUS_OPTIONS.map(opt => (
                          <option key={opt.value} value={opt.value}>
                            {opt.label}
                          </option>
                        ))}
                      </select>
                      <ChevronDown size={13} className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
                    </div>
                  </div>
                </div>
              </div>
            ))}
            {filtered.length === 0 && (
              <div className="text-center py-12 text-gray-400">
                <p className="text-4xl mb-2">📭</p>
                <p className="text-sm font-semibold">No orders found</p>
              </div>
            )}
          </div>

          {selectedOrder && (
            <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
              <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={() => setSelectedOrder(null)} />
              <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-lg p-6 z-10 max-h-[90vh] overflow-y-auto border border-gray-100">
                <div className="flex items-center justify-between pb-4 mb-4 border-b border-gray-100">
                  <div>
                    <span className="text-xs font-bold text-gray-400">Order Details</span>
                    <h3 className="text-lg font-black text-gray-900">{selectedOrder.orderNumber}</h3>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className={`text-xs font-bold px-2.5 py-1 rounded-lg capitalize ${getTypeColor(selectedOrder.type)}`}>
                      {selectedOrder.type}
                    </span>
                    <button onClick={() => setSelectedOrder(null)} className="p-2 rounded-xl hover:bg-gray-100 text-gray-400 hover:text-gray-700 cursor-pointer">
                      <X size={18} />
                    </button>
                  </div>
                </div>

                <div className="space-y-4">
                  {/* Status Banner */}
                  <div className="flex items-center justify-between p-3.5 bg-gray-50 rounded-2xl">
                    <div>
                      <p className="text-xs text-gray-500 font-medium">Order Status</p>
                      <p className="font-bold text-sm text-gray-900 mt-0.5">{getOrderStatusLabel(selectedOrder.status)}</p>
                    </div>
                    <span className={`text-xs font-bold px-3 py-1 rounded-xl ${getOrderStatusColor(selectedOrder.status)}`}>
                      {selectedOrder.status.replace(/_/g, ' ')}
                    </span>
                  </div>

                  {/* CHANGE ORDER STATUS SECTION IN MODAL */}
                  <div className="bg-gradient-to-br from-primary/5 via-white to-gray-50 border border-primary/20 rounded-2xl p-4 shadow-sm">
                    <div className="flex items-center justify-between mb-3">
                      <p className="text-xs font-black text-gray-900 flex items-center gap-1.5">
                        <SlidersHorizontal size={14} className="text-primary" /> Change Order Status
                      </p>
                      <span className={`text-[11px] font-bold px-2.5 py-0.5 rounded-full ${getOrderStatusColor(selectedOrder.status)}`}>
                        Current: {getOrderStatusLabel(selectedOrder.status)}
                      </span>
                    </div>

                    <p className="text-xs text-gray-500 mb-2.5">Click any status to instantly update:</p>

                    {/* Quick Action Pills */}
                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 mb-3">
                      <button
                        type="button"
                        onClick={() => handleStatusChange(selectedOrder.id, 'accepted')}
                        className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border cursor-pointer ${
                          selectedOrder.status === 'accepted'
                            ? 'bg-blue-600 text-white border-blue-600 shadow-sm'
                            : 'bg-white text-blue-700 border-blue-200 hover:bg-blue-50'
                        }`}
                      >
                        ✓ Accept
                      </button>
                      <button
                        type="button"
                        onClick={() => handleStatusChange(selectedOrder.id, 'picked_up')}
                        className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border cursor-pointer ${
                          selectedOrder.status === 'picked_up'
                            ? 'bg-purple-600 text-white border-purple-600 shadow-sm'
                            : 'bg-white text-purple-700 border-purple-200 hover:bg-purple-50'
                        }`}
                      >
                        🚚 Picked Up
                      </button>
                      <button
                        type="button"
                        onClick={() => {
                          handleStatusChange(selectedOrder.id, 'inspection');
                          setSelectedOrder(null);
                          onStartInspection?.(selectedOrder.id);
                        }}
                        className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border cursor-pointer ${
                          selectedOrder.status === 'inspection'
                            ? 'bg-amber-600 text-white border-amber-600 shadow-sm'
                            : 'bg-white text-amber-700 border-amber-200 hover:bg-amber-50'
                        }`}
                      >
                        🔍 Start Inspection
                      </button>
                      <button
                        type="button"
                        onClick={() => handleStatusChange(selectedOrder.id, 'completed')}
                        className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border cursor-pointer ${
                          selectedOrder.status === 'completed'
                            ? 'bg-green-600 text-white border-green-600 shadow-sm'
                            : 'bg-white text-green-700 border-green-200 hover:bg-green-50'
                        }`}
                      >
                        🎉 Complete
                      </button>
                    </div>

                    {/* Dropdown Selector */}
                    <div className="flex items-center gap-2 pt-2 border-t border-gray-200/60">
                      <label htmlFor="modal-status-select" className="text-xs font-semibold text-gray-700 whitespace-nowrap">
                        Select Any Status:
                      </label>
                      <div className="relative flex-1">
                        <select
                          id="modal-status-select"
                          value={selectedOrder.status}
                          onChange={(e) => handleStatusChange(selectedOrder.id, e.target.value as OrderStatus)}
                          className="w-full text-xs font-bold bg-white border border-gray-300 rounded-xl pl-3 pr-8 py-2 text-gray-800 focus:outline-none focus:ring-2 focus:ring-primary/20 appearance-none cursor-pointer"
                        >
                          {STATUS_OPTIONS.map(opt => (
                            <option key={opt.value} value={opt.value}>
                              {opt.label}
                            </option>
                          ))}
                        </select>
                        <ChevronDown size={14} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
                      </div>
                    </div>
                  </div>

                  {/* Device Info */}
                  <div className="bg-gray-50 rounded-2xl p-4">
                    <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-2">Device Information</p>
                    <p className="font-black text-gray-900 text-base">{selectedOrder.deviceName}</p>
                    <p className="text-xs text-gray-500 mt-1">
                      {selectedOrder.deviceBrand} · {selectedOrder.deviceModel} · {selectedOrder.deviceStorage} · {selectedOrder.deviceColor}
                    </p>
                  </div>

                  {/* Customer Info */}
                  <div className="bg-gray-50 rounded-2xl p-4">
                    <div className="flex items-center justify-between mb-2">
                      <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">Customer Details</p>
                      <a
                        href={`tel:${selectedOrder.customerPhone}`}
                        className="inline-flex items-center gap-1.5 px-3 py-1 bg-green-100 text-green-700 rounded-lg text-xs font-bold hover:bg-green-200 transition-colors"
                      >
                        <Phone size={12} /> Call Customer
                      </a>
                    </div>
                    <p className="font-bold text-gray-900 text-sm">{selectedOrder.customerName}</p>
                    <p className="text-xs text-gray-500 mt-0.5">{selectedOrder.customerPhone} {selectedOrder.customerEmail ? `· ${selectedOrder.customerEmail}` : ''}</p>
                    <p className="text-xs text-gray-700 mt-2 bg-white p-2.5 rounded-xl border border-gray-200/70">
                      📍 {selectedOrder.customerAddress}, {selectedOrder.city} - {selectedOrder.pinCode}
                    </p>
                  </div>

                  {/* Schedule & Price */}
                  <div className="grid grid-cols-2 gap-3">
                    <div className="bg-blue-50/70 border border-blue-100 rounded-2xl p-3.5">
                      <p className="text-xs font-bold text-blue-700 mb-1">Pickup Slot</p>
                      <p className="font-bold text-gray-900 text-sm">{selectedOrder.pickupDate || 'Today'}</p>
                      <p className="text-xs text-gray-500">{selectedOrder.pickupSlot || '10 AM - 1 PM'}</p>
                    </div>
                    <div className="bg-emerald-50/70 border border-emerald-100 rounded-2xl p-3.5">
                      <p className="text-xs font-bold text-emerald-700 mb-1">Quoted Price</p>
                      <p className="text-xl font-black text-emerald-700">₹{selectedOrder.quotedPrice.toLocaleString('en-IN')}</p>
                      {selectedOrder.finalPrice > 0 && selectedOrder.finalPrice !== selectedOrder.quotedPrice && (
                        <p className="text-xs text-gray-500">Final: ₹{selectedOrder.finalPrice.toLocaleString('en-IN')}</p>
                      )}
                    </div>
                  </div>

                  {selectedOrder.notes && (
                    <div className="bg-amber-50/60 border border-amber-100 rounded-2xl p-3.5">
                      <p className="text-xs font-bold text-amber-800 mb-1">Notes / Instructions</p>
                      <p className="text-xs text-amber-900">{selectedOrder.notes}</p>
                    </div>
                  )}

                  {/* Order Actions inside Modal */}
                  <div className="pt-2 border-t border-gray-100 flex flex-wrap gap-2">
                    {selectedOrder.status !== 'accepted' && selectedOrder.status !== 'completed' && selectedOrder.status !== 'inspection' && selectedOrder.status !== 'picked_up' && (
                      <button
                        type="button"
                        onClick={() => handleAccept(selectedOrder.id)}
                        className="flex-1 py-3 bg-green-600 text-white rounded-xl text-xs font-bold hover:bg-green-700 transition-colors shadow-sm cursor-pointer flex items-center justify-center gap-1.5"
                      >
                        <CheckCircle size={14} /> Accept Order
                      </button>
                    )}
                    {selectedOrder.status === 'accepted' && (
                      <>
                        <button
                          type="button"
                          onClick={() => {
                            handleStatusChange(selectedOrder.id, 'inspection');
                            setSelectedOrder(null);
                            onStartInspection?.(selectedOrder.id);
                          }}
                          className="flex-1 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-bold transition-colors shadow-sm cursor-pointer flex items-center justify-center gap-1.5"
                        >
                          <ClipboardCheck size={14} /> Start Inspection
                        </button>
                        <button
                          type="button"
                          onClick={() => handlePickup(selectedOrder.id)}
                          className="flex-1 py-3 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary/90 transition-colors shadow-sm cursor-pointer flex items-center justify-center gap-1.5"
                        >
                          <Truck size={14} /> Start Pickup
                        </button>
                      </>
                    )}
                    {selectedOrder.status === 'picked_up' && (
                      <button
                        type="button"
                        onClick={() => {
                          handleStatusChange(selectedOrder.id, 'inspection');
                          setSelectedOrder(null);
                          onStartInspection?.(selectedOrder.id);
                        }}
                        className="flex-1 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-bold transition-colors shadow-sm cursor-pointer flex items-center justify-center gap-1.5"
                      >
                        <ClipboardCheck size={14} /> Start Inspection
                      </button>
                    )}
                    {selectedOrder.status === 'inspection' && (
                      <button
                        type="button"
                        onClick={() => {
                          setSelectedOrder(null);
                          onStartInspection?.(selectedOrder.id);
                        }}
                        className="flex-1 py-3 bg-amber-500 hover:bg-amber-600 text-white rounded-xl text-xs font-bold transition-colors shadow-sm cursor-pointer flex items-center justify-center gap-1.5"
                      >
                        <ClipboardCheck size={14} /> Continue Inspection
                      </button>
                    )}
                    <button
                      onClick={() => setSelectedOrder(null)}
                      className="px-6 py-3 border border-gray-200 text-gray-700 rounded-xl text-xs font-bold hover:bg-gray-50 transition-colors cursor-pointer"
                    >
                      Close
                    </button>
                  </div>
                </div>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}

'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { orders as defaultOrders, getOrderStatusColor, getOrderStatusLabel, getTypeColor } from '@/lib/casmikData';
import type { Order, OrderStatus } from '@/lib/casmikData';
import { Search, CheckCircle, XCircle, Eye, Phone, MapPin, X, Truck, Wifi, WifiOff, ChevronDown, SlidersHorizontal, ClipboardCheck, Sparkles, Lock, CreditCard, ArrowRight, ShieldAlert } from 'lucide-react';
import LiveOrderTracker from '@/components/LiveOrderTracker';
import { triggerNotification } from '@/lib/notifications';

const PARTNER_ID = 'partner-002';

const STATUS_PROGRESSION: Record<string, number> = {
  assigned: 1,
  new: 1,
  created: 1,
  accepted: 2,
  pickup_scheduled: 3,
  picked_up: 4,
  in_transit: 5,
  inspection: 6,
  completed: 7,
  cancelled: 99,
};

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

const getAllowedForwardStatuses = (currentStatus: OrderStatus) => {
  if (currentStatus === 'completed') {
    return [{ value: 'completed' as OrderStatus, label: 'Order Completed' }];
  }
  const currentRank = STATUS_PROGRESSION[currentStatus] || 1;
  return STATUS_OPTIONS.filter(opt => {
    const optRank = STATUS_PROGRESSION[opt.value] || 1;
    if (opt.value === 'cancelled') return currentRank < 7;
    return optRank >= currentRank;
  });
};

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

  // Payout Disbursal Modal State
  const [payoutOrder, setPayoutOrder] = useState<Order | null>(null);
  const [payoutMethod, setPayoutMethod] = useState<'upi' | 'imps' | 'cash'>('upi');
  const [payoutRef, setPayoutRef] = useState('');
  const [isProcessingPayout, setIsProcessingPayout] = useState(false);

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

  // Master status change handler: enforces forward-only progression and completed lock
  const handleStatusChange = async (orderId: string, newStatus: OrderStatus) => {
    const currentOrder = orderList.find(o => o.id === orderId);
    if (!currentOrder) return;

    // Strict lock: once completed, cannot change anything!
    if (currentOrder.status === 'completed') {
      setStatusToast({
        message: `⚠️ This order is completed & locked. No further changes can be made.`,
      });
      setTimeout(() => setStatusToast(null), 4000);
      return;
    }

    // Forward-only rule: cannot go back to an earlier step
    const currentRank = STATUS_PROGRESSION[currentOrder.status] || 1;
    const newRank = STATUS_PROGRESSION[newStatus] || 1;

    if (newStatus !== 'cancelled' && newRank < currentRank) {
      setStatusToast({
        message: `⚠️ Order progress is forward-only. You cannot move back to a previous status.`,
      });
      setTimeout(() => setStatusToast(null), 4000);
      return;
    }

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
        message: `Order status advanced to "${label}"`,
      });
    }
    setTimeout(() => setStatusToast(null), 4500);

    // 4.1. Trigger real-time notification with sound chime across Admin, Partner, and User
    triggerNotification({
      type: 'status_update',
      targetRole: 'all',
      title: `Order #${currentOrder.orderNumber} Status Updated`,
      shortDetails: `Status advanced to "${label}" for ${currentOrder.deviceName} (${currentOrder.customerName || 'Customer'})`,
      orderNumber: currentOrder.orderNumber,
      deviceName: currentOrder.deviceName,
      customerName: currentOrder.customerName,
      price: currentOrder.finalPrice || currentOrder.quotedPrice,
      status: newStatus,
    });

    // 5. Try remote supabase update
    try {
      await supabase.from('orders').update({ status: newStatus }).eq('id', orderId);
    } catch (err: any) {
      console.log('Remote status update note:', err.message);
    }
  };

  // Complete Payout & Lock Order permanently
  const handleDisbursePayout = async () => {
    if (!payoutOrder) return;
    setIsProcessingPayout(true);
    const amount = payoutOrder.finalPrice > 0 ? payoutOrder.finalPrice : payoutOrder.quotedPrice;

    const updatedOrder: Order = {
      ...payoutOrder,
      status: 'completed',
      paymentStatus: 'paid',
      finalPrice: amount,
      notes: `${payoutOrder.notes || ''} [Payout of ₹${amount.toLocaleString('en-IN')} disbursed via ${payoutMethod.toUpperCase()}${payoutRef ? ` Ref: ${payoutRef}` : ''}]`.trim(),
      updatedAt: new Date().toISOString(),
    };

    setOrderList(prev => {
      const updated = prev.map(o => o.id === payoutOrder.id ? updatedOrder : o);
      if (typeof window !== 'undefined') {
        localStorage.setItem('casmik_partner_orders_v1', JSON.stringify(updated));
      }
      return updated;
    });

    if (selectedOrder?.id === payoutOrder.id) {
      setSelectedOrder(updatedOrder);
    }

    if (typeof window !== 'undefined') {
      try {
        const savedGlobal = localStorage.getItem('casmik_orders_v1');
        if (savedGlobal) {
          const list = JSON.parse(savedGlobal);
          if (Array.isArray(list)) {
            const updated = list.map((o: any) => o.id === payoutOrder.id ? updatedOrder : o);
            localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
          }
        }
      } catch {}
    }

    try {
      await supabase.from('orders').update({
        status: 'completed',
        payment_status: 'paid',
        final_price: amount,
        notes: updatedOrder.notes,
        updated_at: updatedOrder.updatedAt,
      }).eq('id', payoutOrder.id);
    } catch (err: any) {
      console.log('Remote payout update note:', err.message);
    }

    setIsProcessingPayout(false);
    const targetOrderNumber = payoutOrder.orderNumber;
    setPayoutOrder(null);
    setStatusToast({
      message: `🎉 Payout of ₹${amount.toLocaleString('en-IN')} complete! Order ${targetOrderNumber} moved to Completed and permanently locked.`,
    });
    setTimeout(() => setStatusToast(null), 5000);

    // Trigger payout notification with chime sound
    triggerNotification({
      type: 'payout',
      targetRole: 'all',
      title: `💳 Payout Disbursed: ₹${amount.toLocaleString('en-IN')}`,
      shortDetails: `Spot payout of ₹${amount.toLocaleString('en-IN')} successfully completed for #${targetOrderNumber} (${payoutOrder.deviceName}) via ${payoutMethod.toUpperCase()}. Order is now Completed & Locked.`,
      orderNumber: targetOrderNumber,
      deviceName: payoutOrder.deviceName,
      customerName: payoutOrder.customerName,
      price: amount,
      status: 'completed',
    });
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
                      {order.inspectionScore !== null && order.inspectionScore !== undefined && (
                        <span className="text-[11px] font-bold px-2 py-0.5 rounded-md bg-teal-50 text-teal-700 border border-teal-200">
                          Score: {order.inspectionScore}%
                        </span>
                      )}
                    </div>
                    <p className="text-sm font-bold text-gray-900 group-hover:text-primary transition-colors">{order.deviceName}</p>
                  </div>

                  {/* Pricing: Show Updated Inspection Price if available */}
                  {order.finalPrice > 0 ? (
                    <div className="text-right">
                      <span className="text-[10px] font-extrabold uppercase tracking-wider text-emerald-800 bg-emerald-100/90 px-2 py-0.5 rounded-full border border-emerald-300 inline-block mb-0.5">
                        Inspected Payout
                      </span>
                      <p className="text-xl font-black text-emerald-600">
                        ₹{order.finalPrice.toLocaleString('en-IN')}
                      </p>
                      {order.finalPrice !== order.quotedPrice ? (
                        <p className="text-[11px] text-gray-400 line-through">
                          Quote: ₹{order.quotedPrice.toLocaleString('en-IN')}
                        </p>
                      ) : (
                        <p className="text-[11px] text-emerald-700 font-semibold">100% Valuation</p>
                      )}
                    </div>
                  ) : (
                    <div className="text-right">
                      <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block mb-0.5">Quoted Price</span>
                      <p className="text-lg font-black text-gray-900">₹{order.quotedPrice.toLocaleString('en-IN')}</p>
                    </div>
                  )}
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

                {/* Card Actions Bar: Accept, Details, Call, Disburse Payout, and Forward-Only Status Dropdown */}
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
                    <div className="flex items-center gap-1.5 flex-wrap">
                      {order.finalPrice > 0 ? (
                        <button
                          type="button"
                          onClick={() => setPayoutOrder(order)}
                          className="flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-emerald-600 text-white text-xs font-black hover:bg-emerald-700 transition-colors shadow-md shadow-emerald-600/20 cursor-pointer"
                        >
                          <CreditCard size={13} /> Disburse Payout (₹{order.finalPrice.toLocaleString('en-IN')})
                        </button>
                      ) : null}
                      <button
                        type="button"
                        onClick={() => onStartInspection?.(order.id)}
                        className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-amber-500 text-white text-xs font-bold hover:bg-amber-600 transition-colors shadow-sm shadow-amber-500/20 cursor-pointer"
                      >
                        <ClipboardCheck size={13} /> {order.finalPrice > 0 ? 'Review Inspection' : 'Continue Inspection'}
                      </button>
                    </div>
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

                  {/* Status Indicator or Forward-Only Dropdown */}
                  {order.status === 'completed' ? (
                    <div className="flex items-center gap-1.5 ml-auto px-3 py-1.5 bg-emerald-50 text-emerald-800 text-xs font-black rounded-xl border border-emerald-200 shadow-sm">
                      <Lock size={12} className="text-emerald-600" />
                      <span>Completed &amp; Locked</span>
                    </div>
                  ) : (
                    <div className="flex items-center gap-1.5 ml-auto">
                      <span className="text-[11px] font-bold text-gray-500 hidden sm:inline">Advance:</span>
                      <div className="relative">
                        <select
                          value={order.status}
                          onChange={(e) => handleStatusChange(order.id, e.target.value as OrderStatus)}
                          className="text-xs font-bold bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-xl pl-2.5 pr-7 py-2 text-gray-800 hover:border-primary focus:outline-none focus:ring-2 focus:ring-primary/20 cursor-pointer appearance-none shadow-sm transition-all"
                        >
                          {getAllowedForwardStatuses(order.status).map(opt => (
                            <option key={opt.value} value={opt.value}>
                              {opt.label}
                            </option>
                          ))}
                        </select>
                        <ChevronDown size={13} className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
                      </div>
                    </div>
                  )}
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

                  {/* CHANGE ORDER STATUS SECTION OR PERMANENT LOCKED BANNER */}
                  {selectedOrder.status === 'completed' ? (
                    <div className="bg-emerald-50 border border-emerald-300 rounded-2xl p-4 shadow-sm">
                      <div className="flex items-center gap-2 mb-1.5">
                        <div className="w-7 h-7 rounded-full bg-emerald-600 text-white flex items-center justify-center font-bold text-xs flex-shrink-0">
                          ✓
                        </div>
                        <div>
                          <h4 className="text-sm font-black text-emerald-900">Order Completed &amp; Payout Finalized</h4>
                          <p className="text-[11px] text-emerald-700 font-semibold">Payment Status: Paid · Archival Record Locked</p>
                        </div>
                        <span className="ml-auto px-2.5 py-1 bg-emerald-200/90 text-emerald-900 text-[10px] font-extrabold rounded-md uppercase tracking-wider flex items-center gap-1">
                          <Lock size={11} /> Locked
                        </span>
                      </div>
                      <p className="text-xs text-emerald-800 leading-relaxed mt-2">
                        Customer payout of <strong>₹{(selectedOrder.finalPrice || selectedOrder.quotedPrice).toLocaleString('en-IN')}</strong> has been finalized and disbursed. This order is in terminal completed state and cannot be modified or reverted.
                      </p>
                    </div>
                  ) : (
                    <div className="bg-gradient-to-br from-primary/5 via-white to-gray-50 border border-primary/20 rounded-2xl p-4 shadow-sm">
                      <div className="flex items-center justify-between mb-3">
                        <p className="text-xs font-black text-gray-900 flex items-center gap-1.5">
                          <SlidersHorizontal size={14} className="text-primary" /> Advance Order Status
                        </p>
                        <span className={`text-[11px] font-bold px-2.5 py-0.5 rounded-full ${getOrderStatusColor(selectedOrder.status)}`}>
                          Current: {getOrderStatusLabel(selectedOrder.status)}
                        </span>
                      </div>

                      <p className="text-xs text-gray-500 mb-2.5">Progress is forward-only (completed stages are locked):</p>

                      {/* Quick Action Pills - Forward Only */}
                      <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 mb-3">
                        {/* 1. Accept */}
                        <button
                          type="button"
                          disabled={STATUS_PROGRESSION[selectedOrder.status] >= 2}
                          onClick={() => handleStatusChange(selectedOrder.id, 'accepted')}
                          className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border ${
                            STATUS_PROGRESSION[selectedOrder.status] > 2
                              ? 'bg-gray-100 text-gray-400 border-gray-200 cursor-not-allowed'
                              : selectedOrder.status === 'accepted'
                              ? 'bg-blue-600 text-white border-blue-600 shadow-sm cursor-default'
                              : 'bg-white text-blue-700 border-blue-200 hover:bg-blue-50 cursor-pointer'
                          }`}
                        >
                          {STATUS_PROGRESSION[selectedOrder.status] >= 2 ? '✓ Accepted' : '✓ Accept'}
                        </button>

                        {/* 2. Picked Up */}
                        <button
                          type="button"
                          disabled={STATUS_PROGRESSION[selectedOrder.status] >= 4}
                          onClick={() => handleStatusChange(selectedOrder.id, 'picked_up')}
                          className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border ${
                            STATUS_PROGRESSION[selectedOrder.status] > 4
                              ? 'bg-gray-100 text-gray-400 border-gray-200 cursor-not-allowed'
                              : selectedOrder.status === 'picked_up'
                              ? 'bg-purple-600 text-white border-purple-600 shadow-sm cursor-default'
                              : STATUS_PROGRESSION[selectedOrder.status] < 2
                              ? 'bg-gray-50 text-gray-400 border-gray-200 cursor-not-allowed'
                              : 'bg-white text-purple-700 border-purple-200 hover:bg-purple-50 cursor-pointer'
                          }`}
                        >
                          {STATUS_PROGRESSION[selectedOrder.status] >= 4 ? '✓ Picked Up' : '🚚 Picked Up'}
                        </button>

                        {/* 3. Start Inspection */}
                        <button
                          type="button"
                          disabled={STATUS_PROGRESSION[selectedOrder.status] > 6}
                          onClick={() => {
                            handleStatusChange(selectedOrder.id, 'inspection');
                            setSelectedOrder(null);
                            onStartInspection?.(selectedOrder.id);
                          }}
                          className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border ${
                            selectedOrder.status === 'inspection'
                              ? 'bg-amber-600 text-white border-amber-600 shadow-sm cursor-pointer'
                              : STATUS_PROGRESSION[selectedOrder.status] < 2
                              ? 'bg-gray-50 text-gray-400 border-gray-200 cursor-not-allowed'
                              : 'bg-white text-amber-700 border-amber-200 hover:bg-amber-50 cursor-pointer'
                          }`}
                        >
                          🔍 Inspection
                        </button>

                        {/* 4. Complete / Payout */}
                        <button
                          type="button"
                          onClick={() => {
                            setPayoutOrder(selectedOrder);
                          }}
                          className={`py-2 px-2.5 rounded-xl text-xs font-bold transition-all border cursor-pointer ${
                            selectedOrder.status === 'inspection' && selectedOrder.finalPrice > 0
                              ? 'bg-emerald-600 text-white border-emerald-600 shadow-sm hover:bg-emerald-700'
                              : 'bg-white text-emerald-700 border-emerald-200 hover:bg-emerald-50'
                          }`}
                        >
                          💳 Payout
                        </button>
                      </div>

                      {/* Forward-Only Dropdown Selector */}
                      <div className="flex items-center gap-2 pt-2 border-t border-gray-200/60">
                        <label htmlFor="modal-status-select" className="text-xs font-semibold text-gray-700 whitespace-nowrap">
                          Advance Status:
                        </label>
                        <div className="relative flex-1">
                          <select
                            id="modal-status-select"
                            value={selectedOrder.status}
                            onChange={(e) => handleStatusChange(selectedOrder.id, e.target.value as OrderStatus)}
                            className="w-full text-xs font-bold bg-white border border-gray-300 rounded-xl pl-3 pr-8 py-2 text-gray-800 focus:outline-none focus:ring-2 focus:ring-primary/20 appearance-none cursor-pointer"
                          >
                            {getAllowedForwardStatuses(selectedOrder.status).map(opt => (
                              <option key={opt.value} value={opt.value}>
                                {opt.label}
                              </option>
                            ))}
                          </select>
                          <ChevronDown size={14} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
                        </div>
                      </div>
                    </div>
                  )}

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

                  {/* Schedule & Price (Highlight Updated Inspection Price) */}
                  <div className="grid grid-cols-2 gap-3">
                    <div className="bg-blue-50/70 border border-blue-100 rounded-2xl p-3.5">
                      <p className="text-xs font-bold text-blue-700 mb-1">Pickup Slot</p>
                      <p className="font-bold text-gray-900 text-sm">{selectedOrder.pickupDate || 'Today'}</p>
                      <p className="text-xs text-gray-500">{selectedOrder.pickupSlot || '10 AM - 1 PM'}</p>
                    </div>
                    <div className="bg-emerald-50/70 border border-emerald-100 rounded-2xl p-3.5">
                      <p className="text-xs font-bold text-emerald-700 mb-1">
                        {selectedOrder.finalPrice > 0 ? 'Updated Inspection Price' : 'Quoted Price'}
                      </p>
                      <p className="text-xl font-black text-emerald-700">
                        ₹{(selectedOrder.finalPrice > 0 ? selectedOrder.finalPrice : selectedOrder.quotedPrice).toLocaleString('en-IN')}
                      </p>
                      {selectedOrder.finalPrice > 0 && selectedOrder.finalPrice !== selectedOrder.quotedPrice && (
                        <div className="text-[11px] text-gray-500 mt-1 flex flex-col">
                          <span className="line-through text-gray-400">Quote: ₹{selectedOrder.quotedPrice.toLocaleString('en-IN')}</span>
                          <span className="text-red-600 font-bold">
                            Deductions: -₹{(selectedOrder.quotedPrice - selectedOrder.finalPrice).toLocaleString('en-IN')}
                          </span>
                        </div>
                      )}
                      {selectedOrder.inspectionScore !== null && selectedOrder.inspectionScore !== undefined && (
                        <p className="text-[11px] font-bold text-teal-700 mt-1">
                          Diagnostic Score: {selectedOrder.inspectionScore}%
                        </p>
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
                    {selectedOrder.status === 'inspection' && selectedOrder.finalPrice > 0 && (
                      <button
                        type="button"
                        onClick={() => {
                          setPayoutOrder(selectedOrder);
                        }}
                        className="flex-1 py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-black transition-colors shadow-md shadow-emerald-600/20 cursor-pointer flex items-center justify-center gap-1.5"
                      >
                        <CreditCard size={14} /> Disburse Payout (₹{selectedOrder.finalPrice.toLocaleString('en-IN')})
                      </button>
                    )}

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
                    {selectedOrder.status === 'inspection' && !selectedOrder.finalPrice && (
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

          {/* DISBURSE PAYOUT MODAL */}
          {payoutOrder && (
            <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
              <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={() => setPayoutOrder(null)} />
              <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-md p-6 z-10 border border-gray-100">
                <div className="flex items-center justify-between pb-3 mb-4 border-b border-gray-100">
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold">
                      <CreditCard size={18} />
                    </div>
                    <div>
                      <h3 className="font-black text-gray-900 text-base">Disburse Spot Payout</h3>
                      <p className="text-xs text-gray-500">{payoutOrder.orderNumber}</p>
                    </div>
                  </div>
                  <button
                    onClick={() => setPayoutOrder(null)}
                    className="p-1.5 rounded-xl hover:bg-gray-100 text-gray-400 hover:text-gray-700 cursor-pointer"
                  >
                    <X size={18} />
                  </button>
                </div>

                {/* Payout Summary Box */}
                <div className="bg-gradient-to-br from-emerald-600 to-teal-700 text-white rounded-2xl p-4 mb-4 shadow-md">
                  <div className="flex justify-between items-center text-xs text-emerald-100 mb-1">
                    <span>Payable to Customer</span>
                    {payoutOrder.inspectionScore !== null && (
                      <span className="bg-white/20 px-2 py-0.5 rounded font-bold">
                        Score: {payoutOrder.inspectionScore}%
                      </span>
                    )}
                  </div>
                  <p className="text-3xl font-black">
                    ₹{(payoutOrder.finalPrice > 0 ? payoutOrder.finalPrice : payoutOrder.quotedPrice).toLocaleString('en-IN')}
                  </p>
                  <p className="text-xs text-emerald-100 mt-2">
                    {payoutOrder.customerName} · {payoutOrder.deviceName}
                  </p>
                </div>

                {/* Payment Method Selection */}
                <div className="space-y-3 mb-4">
                  <p className="text-xs font-bold text-gray-700 uppercase tracking-wide">Select Payment Mode</p>
                  <div className="grid grid-cols-3 gap-2">
                    {[
                      { id: 'upi', label: 'Instant UPI', icon: '⚡' },
                      { id: 'imps', label: 'IMPS Bank', icon: '🏦' },
                      { id: 'cash', label: 'Spot Cash', icon: '💵' },
                    ].map(m => (
                      <button
                        key={m.id}
                        type="button"
                        onClick={() => setPayoutMethod(m.id as any)}
                        className={`p-2.5 rounded-xl text-xs font-bold border transition-all flex flex-col items-center gap-1 cursor-pointer ${
                          payoutMethod === m.id
                            ? 'bg-emerald-50 border-emerald-500 text-emerald-800 shadow-sm ring-1 ring-emerald-500'
                            : 'bg-gray-50 border-gray-200 text-gray-700 hover:bg-gray-100'
                        }`}
                      >
                        <span className="text-base">{m.icon}</span>
                        <span>{m.label}</span>
                      </button>
                    ))}
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-gray-600 mb-1">
                      Transaction Reference / UTR (Optional)
                    </label>
                    <input
                      type="text"
                      value={payoutRef}
                      onChange={(e) => setPayoutRef(e.target.value)}
                      placeholder={payoutMethod === 'cash' ? 'Cash handover note' : 'UPI UTR / IMPS ref ID'}
                      className="w-full px-3 py-2 text-xs border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 bg-gray-50"
                    />
                  </div>
                </div>

                <div className="p-3 bg-amber-50 rounded-xl border border-amber-200 text-xs text-amber-800 mb-4 flex items-start gap-2">
                  <Lock size={14} className="mt-0.5 flex-shrink-0 text-amber-600" />
                  <span>
                    <strong>Important:</strong> Once payout is confirmed, this order will shift to <strong>Completed</strong> and will be permanently locked. No further status changes can be made.
                  </span>
                </div>

                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => setPayoutOrder(null)}
                    className="flex-1 py-3 border border-gray-200 text-gray-700 rounded-xl text-xs font-bold hover:bg-gray-50 transition-colors cursor-pointer"
                  >
                    Cancel
                  </button>
                  <button
                    type="button"
                    disabled={isProcessingPayout}
                    onClick={handleDisbursePayout}
                    className="flex-1 py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-black shadow-md shadow-emerald-600/20 transition-all flex items-center justify-center gap-1.5 cursor-pointer disabled:opacity-50"
                  >
                    {isProcessingPayout ? 'Processing...' : `Confirm & Complete Payout`}
                  </button>
                </div>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}

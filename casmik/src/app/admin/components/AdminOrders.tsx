'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { orders as defaultOrders, partners, deliveryAgents, getOrderStatusLabel, getOrderStatusColor, getTypeColor } from '@/lib/casmikData';
import type { Order, OrderStatus, DeliveryAgent } from '@/lib/casmikData';
import { 
  Search, 
  Eye, 
  UserCheck, 
  X, 
  AlertCircle, 
  Wifi, 
  WifiOff, 
  RefreshCw, 
  CheckCircle2, 
  ChevronDown, 
  SlidersHorizontal, 
  CheckCircle,
  Truck,
  Phone,
  Calendar,
  Clock,
  ShieldCheck,
  MapPin,
  Sparkles
} from 'lucide-react';
import LiveOrderTracker from '@/components/LiveOrderTracker';
import { triggerNotification } from '@/lib/notifications';

const STATUS_OPTIONS: { value: OrderStatus; label: string }[] = [
  { value: 'created', label: 'Order Created' },
  { value: 'assigned', label: 'New / Assigned' },
  { value: 'accepted', label: 'Order Accepted' },
  { value: 'pickup_scheduled', label: 'Pickup Scheduled' },
  { value: 'picked_up', label: 'Picked Up' },
  { value: 'in_transit', label: 'In Transit' },
  { value: 'inspection', label: 'Under Inspection' },
  { value: 'completed', label: 'Order Completed' },
  { value: 'cancelled', label: 'Cancelled' },
  { value: 'rejected', label: 'Rejected' },
];

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
    id: o.id,
    orderNumber: o.order_number,
    type: o.order_type as Order['type'],
    status: o.status as OrderStatus,
    customerId: '',
    customerName: o.customer_name,
    customerPhone: o.customer_phone,
    customerEmail: o.customer_email || '',
    customerAddress: o.customer_address || '',
    pinCode: o.pin_code || '',
    city: o.city || '',
    deviceName: o.device_name,
    deviceBrand: o.device_brand || '',
    deviceModel: o.device_model || '',
    deviceStorage: o.device_storage || '',
    deviceColor: o.device_color || '',
    quotedPrice: o.quoted_price || 0,
    finalPrice: o.final_price || 0,
    partnerId: o.partner_id,
    partnerName: o.partner_name,
    deliveryAgentId: o.delivery_agent_id,
    deliveryAgentName: o.delivery_agent_name,
    deliveryAgentPhone: (o as any).delivery_agent_phone || null,
    deviceCollected: (o as any).device_collected || false,
    collectedAt: (o as any).collected_at || null,
    deviceImei: (o as any).device_imei || null,
    inspectionNotes: (o as any).inspection_notes || null,
    pickupDate: o.pickup_date || '',
    pickupSlot: o.pickup_slot || '',
    createdAt: o.created_at,
    updatedAt: o.updated_at,
    paymentStatus: o.payment_status as Order['paymentStatus'],
    inspectionScore: o.inspection_score,
    notes: o.notes || '',
  };
}

const getStoredOrders = (): Order[] => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_orders_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch (e) {
      console.warn('Failed to parse local orders', e);
    }
  }
  return defaultOrders;
};

const getAvailableDeliveryAgents = (): DeliveryAgent[] => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_delivery_agents_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch {}
  }
  return deliveryAgents;
};

interface AdminOrdersProps {
  initialFilterStatus?: string;
  initialFilterType?: string;
  initialOrderId?: string | null;
  onClearFilters?: () => void;
}

export default function AdminOrders({
  initialFilterStatus = 'all',
  initialFilterType = 'all',
  initialOrderId = null,
  onClearFilters,
}: AdminOrdersProps = {}) {
  const [orderList, setOrderList] = useState<Order[]>(getStoredOrders);
  const [loading, setLoading] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [query, setQuery] = useState('');
  const [filterType, setFilterType] = useState(initialFilterType || 'all');
  const [filterStatus, setFilterStatus] = useState(initialFilterStatus || 'all');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [assignModal, setAssignModal] = useState<Order | null>(null);
  const [selectedPartner, setSelectedPartner] = useState('');

  // Delivery Person Assignment Modal State
  const [assignDeliveryModal, setAssignDeliveryModal] = useState<Order | null>(null);
  const [selectedDeliveryAgentId, setSelectedDeliveryAgentId] = useState('');
  const [scheduledPickupDate, setScheduledPickupDate] = useState('');
  const [scheduledPickupSlot, setScheduledPickupSlot] = useState('');

  const [activeTab, setActiveTab] = useState<'list' | 'live'>('list');
  const supabase = createClient();

  // Listen for storage and custom events for instant cross-tab & cross-role reactive updates
  useEffect(() => {
    const handleSync = () => {
      const fresh = getStoredOrders();
      setOrderList(fresh);
      setSelectedOrder(prev => prev ? (fresh.find(o => o.id === prev.id) || prev) : null);
    };
    window.addEventListener('casmik_orders_updated', handleSync);
    window.addEventListener('casmik_partner_orders_updated', handleSync);
    window.addEventListener('storage', handleSync);
    return () => {
      window.removeEventListener('casmik_orders_updated', handleSync);
      window.removeEventListener('casmik_partner_orders_updated', handleSync);
      window.removeEventListener('storage', handleSync);
    };
  }, []);

  useEffect(() => {
    if (initialFilterStatus) {
      setFilterStatus(initialFilterStatus);
    }
  }, [initialFilterStatus]);

  useEffect(() => {
    if (initialFilterType) {
      setFilterType(initialFilterType);
    }
  }, [initialFilterType]);

  useEffect(() => {
    if (initialOrderId && orderList.length > 0) {
      const found = orderList.find(o => o.id === initialOrderId || o.orderNumber === initialOrderId);
      if (found) {
        setSelectedOrder(found);
      }
    }
  }, [initialOrderId, orderList]);

  const fetchOrders = useCallback(async () => {
    try {
      const { data, error } = await supabase
        .from('orders')
        .select('*')
        .order('created_at', { ascending: false });
      if (!error && data && data.length > 0) {
        const mapped = data.map(dbToOrder);
        setOrderList(mapped);
        if (typeof window !== 'undefined') {
          localStorage.setItem('casmik_orders_v1', JSON.stringify(mapped));
        }
        setIsConnected(true);
        return;
      }
    } catch (err: any) {
      console.log('Orders fetch remote notice, active on persistent local store:', err.message);
    }

    // Fallback to local store or defaults
    const fallback = getStoredOrders();
    setOrderList(fallback);
    if (typeof window !== 'undefined' && !localStorage.getItem('casmik_orders_v1')) {
      localStorage.setItem('casmik_orders_v1', JSON.stringify(fallback));
    }
  }, [supabase]);

  useEffect(() => {
    fetchOrders();

    const channel = supabase
      .channel('admin-orders-realtime')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'orders' }, (payload) => {
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
  }, [fetchOrders, supabase]);

  const filtered = orderList.filter(o =>
    (o.orderNumber.toLowerCase().includes(query.toLowerCase()) ||
     o.customerName.toLowerCase().includes(query.toLowerCase()) ||
     o.deviceName.toLowerCase().includes(query.toLowerCase()) ||
     (o.city && o.city.toLowerCase().includes(query.toLowerCase()))) &&
    (filterType === 'all' || o.type === filterType) &&
    (filterStatus === 'all' || 
     (filterStatus === 'pending'
       ? ['created', 'assigned', 'accepted', 'pickup_scheduled'].includes(o.status)
       : o.status === filterStatus))
  );

  const handleAssign = async () => {
    if (!assignModal || !selectedPartner) return;
    const partner = partners.find(p => p.id === selectedPartner);
    const updated = orderList.map(o =>
      o.id === assignModal.id
        ? { ...o, partnerId: selectedPartner, partnerName: partner?.storeName || '', status: 'assigned' as OrderStatus }
        : o
    );
    setOrderList(updated);
    if (typeof window !== 'undefined') {
      localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
    }

    try {
      await supabase
        .from('orders')
        .update({ partner_id: selectedPartner, partner_name: partner?.storeName || '', status: 'assigned' })
        .eq('id', assignModal.id);
    } catch (err: any) {
      console.log('Assign error:', err.message);
    }

    // Trigger notification to partner, admin and customer
    triggerNotification({
      type: 'status_update',
      targetRole: 'all',
      title: `Order #${assignModal.orderNumber} Assigned to Partner`,
      shortDetails: `Admin assigned Order #${assignModal.orderNumber} (${assignModal.deviceName}) to partner "${partner?.storeName || 'Camsik Partner'}" for pickup & processing.`,
      orderNumber: assignModal.orderNumber,
      deviceName: assignModal.deviceName,
      customerName: assignModal.customerName,
      price: assignModal.quotedPrice,
      status: 'assigned',
    });

    setAssignModal(null);
    setSelectedPartner('');
  };

  const handleAssignDelivery = async () => {
    if (!assignDeliveryModal || !selectedDeliveryAgentId) return;
    const allAgents = getAvailableDeliveryAgents();
    const agent = allAgents.find(a => a.id === selectedDeliveryAgentId);
    if (!agent) return;

    const pickupDate = scheduledPickupDate || assignDeliveryModal.pickupDate || 'Today';
    const pickupSlot = scheduledPickupSlot || assignDeliveryModal.pickupSlot || '10:00 AM - 1:00 PM';

    const updatedOrder: Order = {
      ...assignDeliveryModal,
      deliveryAgentId: agent.id,
      deliveryAgentName: agent.name,
      deliveryAgentPhone: agent.phone,
      status: 'pickup_scheduled' as OrderStatus,
      pickupDate,
      pickupSlot,
      updatedAt: new Date().toISOString(),
    };

    const updated = orderList.map(o => o.id === assignDeliveryModal.id ? updatedOrder : o);
    setOrderList(updated);
    if (selectedOrder?.id === assignDeliveryModal.id) {
      setSelectedOrder(updatedOrder);
    }

    if (typeof window !== 'undefined') {
      localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
      try {
        const partnerOrders = localStorage.getItem('casmik_partner_orders_v1');
        if (partnerOrders) {
          const list = JSON.parse(partnerOrders);
          if (Array.isArray(list)) {
            const upPartner = list.map((o: Order) => o.id === assignDeliveryModal.id ? updatedOrder : o);
            localStorage.setItem('casmik_partner_orders_v1', JSON.stringify(upPartner));
          }
        }
      } catch {}
      window.dispatchEvent(new Event('casmik_orders_updated'));
      window.dispatchEvent(new Event('casmik_partner_orders_updated'));
    }

    try {
      await fetch('/api/orders', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          orderId: assignDeliveryModal.id,
          deliveryAgentId: agent.id,
          deliveryAgentName: agent.name,
          deliveryAgentPhone: agent.phone,
          status: 'pickup_scheduled',
          pickupDate,
          pickupSlot,
        }),
      });
    } catch (e) {
      console.warn('API update notice:', e);
    }

    try {
      await supabase
        .from('orders')
        .update({
          delivery_agent_id: agent.id,
          delivery_agent_name: agent.name,
          status: 'pickup_scheduled',
          pickup_date: pickupDate,
          pickup_slot: pickupSlot,
        })
        .eq('id', assignDeliveryModal.id);
    } catch (err: any) {
      console.log('Supabase delivery assign notice:', err.message);
    }

    triggerNotification({
      type: 'status_update',
      targetRole: 'all',
      title: `Order #${assignDeliveryModal.orderNumber} Assigned to Delivery Agent`,
      shortDetails: `Admin assigned Order #${assignDeliveryModal.orderNumber} (${assignDeliveryModal.deviceName}) to delivery executive "${agent.name}" (${agent.phone}) for doorstep pickup.`,
      orderNumber: assignDeliveryModal.orderNumber,
      deviceName: assignDeliveryModal.deviceName,
      customerName: assignDeliveryModal.customerName,
      price: assignDeliveryModal.quotedPrice,
      status: 'pickup_scheduled',
    });

    setAssignDeliveryModal(null);
    setSelectedDeliveryAgentId('');
  };

  const handleStatusChange = async (orderId: string, newStatus: OrderStatus) => {
    const targetOrder = orderList.find(o => o.id === orderId);
    const updated = orderList.map(o => o.id === orderId ? { ...o, status: newStatus } : o);
    setOrderList(updated);
    if (typeof window !== 'undefined') {
      localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
    }
    setSelectedOrder(prev => prev && prev.id === orderId ? { ...prev, status: newStatus } : prev);

    if (targetOrder) {
      const label = getOrderStatusLabel(newStatus);
      triggerNotification({
        type: 'status_update',
        targetRole: 'all',
        title: `Admin Updated Order #${targetOrder.orderNumber}`,
        shortDetails: `Status of Order #${targetOrder.orderNumber} (${targetOrder.deviceName}) updated to "${label}".`,
        orderNumber: targetOrder.orderNumber,
        deviceName: targetOrder.deviceName,
        customerName: targetOrder.customerName,
        price: targetOrder.finalPrice || targetOrder.quotedPrice,
        status: newStatus,
      });
    }

    try {
      await supabase.from('orders').update({ status: newStatus }).eq('id', orderId);
    } catch (err: any) {
      console.log('Admin status update note:', err.message);
    }
  };

  const stats = {
    total: orderList.length,
    pending: orderList.filter(o => ['created', 'assigned'].includes(o.status)).length,
    active: orderList.filter(o => ['accepted', 'pickup_scheduled', 'picked_up', 'inspection'].includes(o.status)).length,
    completed: orderList.filter(o => o.status === 'completed' || o.status === 'paid').length,
  };

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="text-xl font-black text-gray-900 flex items-center gap-2">
            Orders Management
            <span className={`inline-flex items-center gap-1 text-xs font-bold px-2.5 py-0.5 rounded-full ${
              isConnected ? 'bg-green-100 text-green-700' : 'bg-emerald-50 text-emerald-700 border border-emerald-200'
            }`}>
              {isConnected ? <Wifi size={10} /> : <CheckCircle2 size={11} />}
              {isConnected ? 'Live Supabase' : `Active (${orderList.length} Orders)`}
            </span>
          </h2>
          <p className="text-sm text-gray-500">All orders across sell, buy, exchange & repair</p>
        </div>
        <div className="flex gap-2">
          <button onClick={fetchOrders} className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
            <RefreshCw size={13} /> Refresh
          </button>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-2">
        {[{ id: 'list', label: '📋 Orders List' }, { id: 'live', label: '🔴 Live Tracker' }].map(tab => (
          <button key={tab.id} onClick={() => setActiveTab(tab.id as any)}
            className={`px-4 py-2 rounded-xl text-sm font-bold transition-all ${
              activeTab === tab.id ? 'bg-primary text-white shadow-lg shadow-primary/20' : 'bg-white border border-gray-200 text-gray-600 hover:border-primary/40'
            }`}>
            {tab.label}
          </button>
        ))}
      </div>

      {activeTab === 'live' ? (
        <LiveOrderTracker panel="admin" title="Admin Live Order Tracker" maxItems={50} />
      ) : (
        <>
          {/* Stats Cards (Interactive Click-to-filter) */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {[
              { label: 'Total Orders', value: stats.total, icon: '📦', color: 'bg-blue-50 text-blue-700', statusKey: 'all' },
              { label: 'Pending', value: stats.pending, icon: '⏳', color: 'bg-yellow-50 text-yellow-700', statusKey: 'pending' },
              { label: 'Active', value: stats.active, icon: '🔄', color: 'bg-purple-50 text-purple-700', statusKey: 'accepted' },
              { label: 'Completed', value: stats.completed, icon: '✅', color: 'bg-green-50 text-green-700', statusKey: 'completed' },
            ].map(s => (
              <div
                key={s.label}
                onClick={() => setFilterStatus(s.statusKey)}
                className={`bg-white rounded-2xl p-4 border shadow-sm cursor-pointer hover:shadow-md transition-all hover:scale-[1.02] ${
                  filterStatus === s.statusKey
                    ? 'border-primary ring-2 ring-primary/20 bg-primary/5'
                    : 'border-gray-100 hover:border-gray-300'
                }`}
                title={`Click to filter by ${s.label}`}
              >
                <div className="flex items-center gap-3">
                  <span className="text-2xl">{s.icon}</span>
                  <div>
                    <p className="text-2xl font-black text-gray-900">{s.value}</p>
                    <p className="text-xs font-semibold text-gray-500">{s.label}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* Active Filter Banner */}
          {(filterStatus !== 'all' || filterType !== 'all' || query) && (
            <div className="flex items-center justify-between px-4 py-2.5 rounded-xl bg-primary/10 border border-primary/20 text-xs font-bold text-primary">
              <span className="flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-primary animate-pulse" />
                Filtered View: {filterStatus !== 'all' ? `Status: "${filterStatus.replace(/_/g, ' ')}"` : ''} {filterType !== 'all' ? `· Type: "${filterType}"` : ''} {query ? `· Search: "${query}"` : ''} ({filtered.length} results)
              </span>
              <button
                onClick={() => {
                  setFilterStatus('all');
                  setFilterType('all');
                  setQuery('');
                  if (onClearFilters) onClearFilters();
                }}
                className="hover:underline font-black text-xs text-gray-800 bg-white px-2.5 py-1 rounded-lg border border-primary/30"
              >
                Clear All Filters ✕
              </button>
            </div>
          )}

          {/* Filters */}
          <div className="flex flex-wrap gap-3">
            <div className="relative flex-1 min-w-48">
              <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Search orders, customers, devices..."
                className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white" />
            </div>
            <select value={filterType} onChange={e => setFilterType(e.target.value)}
              className="px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white">
              <option value="all">All Types</option>
              <option value="sell">Sell</option>
              <option value="buy">Buy</option>
              <option value="exchange">Exchange</option>
              <option value="repair">Repair</option>
              <option value="rent">Rental</option>
            </select>
            <select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}
              className="px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white">
              <option value="all">All Status</option>
              <option value="pending">Pending Attention</option>
              <option value="created">Created</option>
              <option value="assigned">Assigned</option>
              <option value="inspection">Inspection</option>
              <option value="completed">Completed</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>

          {/* Orders Table */}
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-gray-50 border-b border-gray-100">
                    <th className="text-left px-5 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Order</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Customer</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Device</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Type</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Amount</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Status</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Fulfillment & Rider</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-50">
                  {filtered.map((order) => (
                    <tr
                      key={order.id}
                      onClick={() => setSelectedOrder(order)}
                      className="hover:bg-primary/5 transition-colors cursor-pointer group"
                    >
                      <td className="px-5 py-3.5">
                        <p className="font-bold text-gray-900 text-xs group-hover:text-primary transition-colors">{order.orderNumber}</p>
                        <p className="text-xs text-gray-400">{order.createdAt ? new Date(order.createdAt).toLocaleDateString('en-IN') : ''}</p>
                      </td>
                      <td className="px-4 py-3.5">
                        <p className="font-semibold text-gray-800 text-xs">{order.customerName}</p>
                        <p className="text-xs text-gray-400">{order.city} · {order.pinCode}</p>
                      </td>
                      <td className="px-4 py-3.5 max-w-[150px]">
                        <p className="text-xs text-gray-700 truncate font-medium">{order.deviceName}</p>
                        <p className="text-xs text-gray-400">{order.pickupDate}</p>
                      </td>
                      <td className="px-4 py-3.5">
                        <span className={`text-xs font-bold px-2 py-1 rounded-lg capitalize ${getTypeColor(order.type)}`}>{order.type}</span>
                      </td>
                      <td className="px-4 py-3.5">
                        <p className="font-bold text-gray-900 text-xs">₹{order.quotedPrice.toLocaleString('en-IN')}</p>
                        {order.finalPrice > 0 && order.finalPrice !== order.quotedPrice && (
                          <p className="text-xs text-green-600 font-semibold">Final: ₹{order.finalPrice.toLocaleString('en-IN')}</p>
                        )}
                      </td>
                      <td className="px-4 py-3.5" onClick={(e) => e.stopPropagation()}>
                        <div className="relative inline-block">
                          <select
                            value={order.status}
                            onChange={(e) => handleStatusChange(order.id, e.target.value as OrderStatus)}
                            className={`text-xs font-bold px-2.5 py-1 rounded-lg border border-transparent hover:border-gray-300 cursor-pointer appearance-none pr-6 transition-all ${getOrderStatusColor(order.status)}`}
                          >
                            {STATUS_OPTIONS.map(opt => (
                              <option key={opt.value} value={opt.value} className="bg-white text-gray-800 font-semibold">
                                {opt.label}
                              </option>
                            ))}
                          </select>
                          <ChevronDown size={11} className="absolute right-1.5 top-1/2 -translate-y-1/2 pointer-events-none opacity-60" />
                        </div>
                      </td>
                      <td className="px-4 py-3.5">
                        <div className="space-y-1">
                          {order.partnerName ? (
                            <p className="text-xs font-semibold text-gray-800 flex items-center gap-1">
                              <span className="w-1.5 h-1.5 rounded-full bg-purple-500" />
                              {order.partnerName}
                            </p>
                          ) : (
                            <span className="text-[10px] font-bold text-gray-400">Store: Unassigned</span>
                          )}

                          {order.deliveryAgentName ? (
                            <div className="flex items-center gap-1 text-[11px] font-bold text-blue-700 bg-blue-50 px-2 py-0.5 rounded-lg border border-blue-200/70 w-fit">
                              <Truck size={11} className="text-blue-600" />
                              <span>{order.deliveryAgentName}</span>
                            </div>
                          ) : (
                            <div className="flex items-center gap-1 text-[11px] font-semibold text-gray-400">
                              <Truck size={11} /> <span>No Rider</span>
                            </div>
                          )}

                          {order.deviceCollected && (
                            <div className="flex items-center gap-1 text-[10px] font-black text-emerald-800 bg-emerald-100 px-2 py-0.5 rounded-lg border border-emerald-300 w-fit">
                              <CheckCircle2 size={10} className="text-emerald-700" />
                              <span>Collected ({order.inspectionScore || 100}%)</span>
                            </div>
                          )}
                        </div>
                      </td>
                      <td className="px-4 py-3.5">
                        <div className="flex items-center gap-1.5" onClick={(e) => e.stopPropagation()}>
                          <button
                            type="button"
                            onClick={() => setSelectedOrder(order)}
                            className="p-1.5 rounded-lg bg-gray-100 hover:bg-primary hover:text-white transition-colors cursor-pointer"
                            title="View Details"
                          >
                            <Eye size={13} />
                          </button>
                          {!order.partnerId && (
                            <button
                              type="button"
                              onClick={() => setAssignModal(order)}
                              className="p-1.5 rounded-lg bg-green-100 text-green-700 hover:bg-green-500 hover:text-white transition-colors cursor-pointer"
                              title="Assign Partner"
                            >
                              <UserCheck size={13} />
                            </button>
                          )}
                          <button
                            type="button"
                            onClick={() => {
                              setAssignDeliveryModal(order);
                              setSelectedDeliveryAgentId(order.deliveryAgentId || '');
                              setScheduledPickupDate(order.pickupDate || '');
                              setScheduledPickupSlot(order.pickupSlot || '');
                            }}
                            className={`p-1.5 rounded-lg transition-colors cursor-pointer ${
                              order.deliveryAgentId
                                ? 'bg-blue-100 text-blue-700 hover:bg-blue-600 hover:text-white'
                                : 'bg-indigo-50 text-indigo-700 hover:bg-indigo-600 hover:text-white border border-indigo-200'
                            }`}
                            title={order.deliveryAgentId ? `Reassign Rider (${order.deliveryAgentName})` : 'Assign Delivery Agent for Pickup'}
                          >
                            <Truck size={13} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            {filtered.length === 0 && (
              <div className="text-center py-12 text-gray-400">
                <AlertCircle size={32} className="mx-auto mb-2 opacity-40" />
                <p className="text-sm">No orders found</p>
              </div>
            )}
          </div>
        </>
      )}

      {/* Order Detail Modal */}
      {selectedOrder && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setSelectedOrder(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-lg p-6 z-10 max-h-[90vh] overflow-y-auto border border-gray-100">
            <div className="flex items-center justify-between mb-5">
              <div>
                <span className="text-xs font-bold text-gray-400">Order Management</span>
                <h3 className="text-lg font-black text-gray-900">{selectedOrder.orderNumber}</h3>
              </div>
              <button onClick={() => setSelectedOrder(null)} className="p-2 rounded-xl hover:bg-gray-100 cursor-pointer"><X size={18} /></button>
            </div>
            <div className="space-y-4">
              <div className="flex gap-2">
                <span className={`text-xs font-bold px-2 py-1 rounded-lg capitalize ${getTypeColor(selectedOrder.type)}`}>{selectedOrder.type}</span>
                <span className={`text-xs font-semibold px-2 py-1 rounded-lg ${getOrderStatusColor(selectedOrder.status)}`}>{getOrderStatusLabel(selectedOrder.status)}</span>
                {selectedOrder.deviceCollected && (
                  <span className="text-xs font-black px-2 py-1 rounded-lg bg-emerald-100 text-emerald-800 flex items-center gap-1 border border-emerald-200">
                    <CheckCircle2 size={12} /> Doorstep Collected
                  </span>
                )}
              </div>

              {/* CHANGE ORDER STATUS SECTION IN ADMIN MODAL */}
              <div className="bg-gradient-to-br from-primary/5 via-white to-gray-50 border border-primary/20 rounded-2xl p-4 shadow-sm">
                <div className="flex items-center justify-between mb-2.5">
                  <p className="text-xs font-black text-gray-900 flex items-center gap-1.5">
                    <SlidersHorizontal size={14} className="text-primary" /> Change Order Status
                  </p>
                  <span className={`text-[11px] font-bold px-2.5 py-0.5 rounded-full ${getOrderStatusColor(selectedOrder.status)}`}>
                    {getOrderStatusLabel(selectedOrder.status)}
                  </span>
                </div>

                <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 mb-3">
                  <button
                    type="button"
                    onClick={() => handleStatusChange(selectedOrder.id, 'accepted')}
                    className={`py-1.5 px-2 rounded-xl text-xs font-bold border transition-all cursor-pointer ${
                      selectedOrder.status === 'accepted' ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-blue-700 border-blue-200 hover:bg-blue-50'
                    }`}
                  >
                    ✓ Accept
                  </button>
                  <button
                    type="button"
                    onClick={() => handleStatusChange(selectedOrder.id, 'picked_up')}
                    className={`py-1.5 px-2 rounded-xl text-xs font-bold border transition-all cursor-pointer ${
                      selectedOrder.status === 'picked_up' ? 'bg-purple-600 text-white border-purple-600' : 'bg-white text-purple-700 border-purple-200 hover:bg-purple-50'
                    }`}
                  >
                    🚚 Picked Up
                  </button>
                  <button
                    type="button"
                    onClick={() => handleStatusChange(selectedOrder.id, 'inspection')}
                    className={`py-1.5 px-2 rounded-xl text-xs font-bold border transition-all cursor-pointer ${
                      selectedOrder.status === 'inspection' ? 'bg-amber-600 text-white border-amber-600' : 'bg-white text-amber-700 border-amber-200 hover:bg-amber-50'
                    }`}
                  >
                    🔍 Inspection
                  </button>
                  <button
                    type="button"
                    onClick={() => handleStatusChange(selectedOrder.id, 'completed')}
                    className={`py-1.5 px-2 rounded-xl text-xs font-bold border transition-all cursor-pointer ${
                      selectedOrder.status === 'completed' ? 'bg-green-600 text-white border-green-600' : 'bg-white text-green-700 border-green-200 hover:bg-green-50'
                    }`}
                  >
                    🎉 Complete
                  </button>
                </div>

                <div className="flex items-center gap-2 pt-2 border-t border-gray-200/60">
                  <label htmlFor="admin-modal-status-select" className="text-xs font-semibold text-gray-700 whitespace-nowrap">
                    All Statuses:
                  </label>
                  <div className="relative flex-1">
                    <select
                      id="admin-modal-status-select"
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

              {/* DOORSTEP INSPECTION STATUS BANNER IF COLLECTED */}
              {selectedOrder.deviceCollected && (
                <div className="bg-gradient-to-r from-emerald-500 to-teal-600 text-white rounded-2xl p-4 shadow-md">
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <ShieldCheck size={20} className="text-emerald-100" />
                      <span className="text-xs font-black uppercase tracking-wider">Device Collected & Inspected</span>
                    </div>
                    <span className="text-xs font-black bg-white/20 px-2.5 py-0.5 rounded-full">
                      Score: {selectedOrder.inspectionScore || 100}%
                    </span>
                  </div>
                  <div className="grid grid-cols-2 gap-2 text-xs bg-black/10 rounded-xl p-2.5 mt-2">
                    <div>
                      <p className="text-emerald-100 text-[11px]">Final Doorstep Payout:</p>
                      <p className="text-base font-black text-white">₹{(selectedOrder.finalPrice || selectedOrder.quotedPrice).toLocaleString('en-IN')}</p>
                    </div>
                    <div>
                      <p className="text-emerald-100 text-[11px]">Handover Timestamp:</p>
                      <p className="font-semibold text-white truncate">
                        {selectedOrder.collectedAt ? new Date(selectedOrder.collectedAt).toLocaleDateString('en-IN', { hour: '2-digit', minute: '2-digit' }) : 'Verified at Doorstep'}
                      </p>
                    </div>
                    {selectedOrder.deviceImei && (
                      <div className="col-span-2 border-t border-white/10 pt-1.5 mt-1">
                        <p className="text-emerald-100 text-[11px]">Verified Device IMEI: <span className="font-mono font-bold text-white">{selectedOrder.deviceImei}</span></p>
                      </div>
                    )}
                  </div>
                </div>
              )}

              <div className="grid grid-cols-2 gap-4">
                <div className="bg-gray-50 rounded-xl p-3">
                  <p className="text-xs font-bold text-gray-500 mb-1">Customer</p>
                  <p className="text-sm font-bold text-gray-900">{selectedOrder.customerName}</p>
                  <p className="text-xs text-gray-500">{selectedOrder.customerPhone}</p>
                  <p className="text-xs text-gray-500">{selectedOrder.customerAddress}</p>
                  <p className="text-xs text-gray-500">PIN: {selectedOrder.pinCode}</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-3">
                  <p className="text-xs font-bold text-gray-500 mb-1">Device</p>
                  <p className="text-sm font-bold text-gray-900">{selectedOrder.deviceName}</p>
                  <p className="text-xs text-gray-500">{selectedOrder.deviceColor}</p>
                  <p className="text-xs text-gray-500">Pickup: {selectedOrder.pickupDate}</p>
                  <p className="text-xs text-gray-500">{selectedOrder.pickupSlot}</p>
                </div>
              </div>

              <div className="bg-green-50 rounded-xl p-3">
                <p className="text-xs font-bold text-gray-500 mb-2">Pricing</p>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-600">Quoted Price</span>
                  <span className="font-bold text-gray-900">₹{selectedOrder.quotedPrice.toLocaleString('en-IN')}</span>
                </div>
                {selectedOrder.finalPrice > 0 && (
                  <div className="flex justify-between text-sm mt-1">
                    <span className="text-gray-600">Final Inspected Price</span>
                    <span className="font-bold text-green-700">₹{selectedOrder.finalPrice.toLocaleString('en-IN')}</span>
                  </div>
                )}
              </div>

              {/* Delivery Agent Card in Details */}
              <div className="bg-blue-50 border border-blue-100 rounded-xl p-3">
                <div className="flex items-center justify-between mb-2">
                  <p className="text-xs font-bold text-blue-900 flex items-center gap-1.5">
                    <Truck size={14} className="text-blue-600" /> Delivery & Doorstep Executive
                  </p>
                  <button
                    onClick={() => {
                      setAssignDeliveryModal(selectedOrder);
                      setSelectedDeliveryAgentId(selectedOrder.deliveryAgentId || '');
                      setScheduledPickupDate(selectedOrder.pickupDate || '');
                      setScheduledPickupSlot(selectedOrder.pickupSlot || '');
                      setSelectedOrder(null);
                    }}
                    className="text-xs font-bold text-blue-700 hover:underline"
                  >
                    {selectedOrder.deliveryAgentId ? 'Reassign Rider →' : '+ Assign Rider'}
                  </button>
                </div>
                {selectedOrder.deliveryAgentName ? (
                  <div className="space-y-1 text-xs">
                    <p className="text-sm font-bold text-slate-900">{selectedOrder.deliveryAgentName}</p>
                    {selectedOrder.deliveryAgentPhone && (
                      <p className="text-slate-600 flex items-center gap-1">
                        <Phone size={11} className="text-blue-500" />
                        <a href={`tel:${selectedOrder.deliveryAgentPhone}`} className="hover:underline">{selectedOrder.deliveryAgentPhone}</a>
                      </p>
                    )}
                    <p className="text-slate-500">Status: <span className="font-semibold text-blue-700 capitalize">{selectedOrder.status.replace(/_/g, ' ')}</span></p>
                  </div>
                ) : (
                  <p className="text-xs text-slate-500">No delivery agent assigned yet. Click "+ Assign Rider" to dispatch executive for pickup.</p>
                )}
              </div>

              {selectedOrder.partnerName && (
                <div className="bg-purple-50 rounded-xl p-3">
                  <p className="text-xs font-bold text-gray-500 mb-1">Assigned Partner</p>
                  <p className="text-sm font-bold text-gray-900">{selectedOrder.partnerName}</p>
                </div>
              )}

              {selectedOrder.notes && (
                <div className="bg-gray-50 rounded-xl p-3">
                  <p className="text-xs font-bold text-gray-500 mb-1">Notes & Diagnostic Remarks</p>
                  <p className="text-xs text-gray-700">{selectedOrder.notes}</p>
                </div>
              )}
            </div>

            <div className="flex gap-2 mt-5">
              {!selectedOrder.partnerId && (
                <button
                  onClick={() => { setAssignModal(selectedOrder); setSelectedOrder(null); }}
                  className="flex-1 py-2.5 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary/90"
                >
                  Assign Partner
                </button>
              )}
              <button
                onClick={() => {
                  setAssignDeliveryModal(selectedOrder);
                  setSelectedDeliveryAgentId(selectedOrder.deliveryAgentId || '');
                  setScheduledPickupDate(selectedOrder.pickupDate || '');
                  setScheduledPickupSlot(selectedOrder.pickupSlot || '');
                  setSelectedOrder(null);
                }}
                className="flex-1 py-2.5 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 flex items-center justify-center gap-1.5"
              >
                <Truck size={14} /> {selectedOrder.deliveryAgentId ? 'Reassign Delivery Rider' : 'Assign Delivery Rider'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Assign Partner Modal */}
      {assignModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setAssignModal(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 z-10">
            <h3 className="text-lg font-black text-gray-900 mb-2">Assign Partner Store</h3>
            <p className="text-sm text-gray-500 mb-5">Order: {assignModal.orderNumber} · PIN: {assignModal.pinCode}</p>
            <div className="space-y-3 mb-5 max-h-60 overflow-y-auto">
              {partners.filter(p => p.status === 'active').map(partner => (
                <button key={partner.id} onClick={() => setSelectedPartner(partner.id)}
                  className={`w-full flex items-center gap-3 p-3 rounded-xl border-2 text-left transition-all ${selectedPartner === partner.id ? 'border-primary bg-primary/5' : 'border-gray-100 hover:border-gray-200'}`}>
                  <img src={partner.avatar} alt={partner.name} className="w-10 h-10 rounded-full object-cover" />
                  <div className="flex-1">
                    <p className="text-sm font-bold text-gray-900">{partner.storeName}</p>
                    <p className="text-xs text-gray-500">{partner.city} · ⭐ {partner.rating} · {partner.completedOrders} orders</p>
                    <p className="text-xs text-gray-400">PINs: {partner.pinCodes.slice(0, 3).join(', ')}</p>
                  </div>
                  {partner.pinCodes.includes(assignModal.pinCode) && (
                    <span className="text-xs font-bold text-green-600 bg-green-50 px-2 py-0.5 rounded-lg">PIN Match ✓</span>
                  )}
                </button>
              ))}
            </div>
            <div className="flex gap-3">
              <button onClick={() => setAssignModal(null)} className="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">Cancel</button>
              <button onClick={handleAssign} disabled={!selectedPartner} className="flex-1 py-2.5 rounded-xl bg-primary text-white text-sm font-semibold hover:bg-primary/90 disabled:opacity-50">
                Confirm Partner
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Assign Delivery Person Modal */}
      {assignDeliveryModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setAssignDeliveryModal(null)} />
          <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-lg p-6 sm:p-7 z-10 max-h-[92vh] overflow-y-auto border border-gray-100 animate-in fade-in zoom-in-95 duration-200">
            <div className="flex items-center justify-between pb-3 border-b border-gray-100 mb-4">
              <div>
                <span className="text-[11px] font-black text-blue-600 uppercase tracking-wider flex items-center gap-1">
                  <Truck size={13} /> Admin Dispatch Console
                </span>
                <h3 className="text-lg font-black text-gray-900">Assign Delivery Executive</h3>
              </div>
              <button onClick={() => setAssignDeliveryModal(null)} className="p-2 rounded-xl hover:bg-gray-100 cursor-pointer">
                <X size={18} className="text-gray-400" />
              </button>
            </div>

            {/* Target Order Summary */}
            <div className="bg-slate-50 rounded-2xl p-3.5 border border-slate-200/80 mb-4 space-y-1.5">
              <div className="flex items-center justify-between">
                <span className="font-mono text-xs font-black text-slate-700">{assignDeliveryModal.orderNumber}</span>
                <span className="text-xs font-bold text-emerald-700">₹{assignDeliveryModal.quotedPrice.toLocaleString('en-IN')}</span>
              </div>
              <p className="text-sm font-black text-slate-900">{assignDeliveryModal.deviceName}</p>
              <div className="flex items-center justify-between text-xs text-slate-500 pt-1">
                <span className="flex items-center gap-1"><MapPin size={11} className="text-primary" /> {assignDeliveryModal.city} (PIN: {assignDeliveryModal.pinCode})</span>
                <span>Customer: <strong>{assignDeliveryModal.customerName}</strong></span>
              </div>
            </div>

            {/* Schedule Slot Inputs */}
            <div className="grid grid-cols-2 gap-3 mb-4">
              <div>
                <label className="text-[11px] font-bold text-gray-600 mb-1 block">Scheduled Date</label>
                <input
                  type="date"
                  value={scheduledPickupDate}
                  onChange={e => setScheduledPickupDate(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-blue-500/20"
                />
              </div>
              <div>
                <label className="text-[11px] font-bold text-gray-600 mb-1 block">Pickup Window</label>
                <select
                  value={scheduledPickupSlot}
                  onChange={e => setScheduledPickupSlot(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-blue-500/20 bg-white"
                >
                  <option value="">Select Time Slot</option>
                  <option value="10:00 AM - 1:00 PM">10:00 AM - 1:00 PM</option>
                  <option value="1:00 PM - 4:00 PM">1:00 PM - 4:00 PM</option>
                  <option value="4:00 PM - 7:00 PM">4:00 PM - 7:00 PM</option>
                  <option value="7:00 PM - 9:00 PM">7:00 PM - 9:00 PM</option>
                </select>
              </div>
            </div>

            {/* List of Delivery Agents */}
            <div className="space-y-2.5 mb-5 max-h-64 overflow-y-auto pr-1">
              <label className="text-xs font-black text-gray-800 block">Select Active Executive:</label>
              {getAvailableDeliveryAgents().map(agent => {
                const isPinMatch = agent.pinCodes?.includes(assignDeliveryModal.pinCode);
                const isSelected = selectedDeliveryAgentId === agent.id;
                return (
                  <button
                    key={agent.id}
                    type="button"
                    onClick={() => setSelectedDeliveryAgentId(agent.id)}
                    className={`w-full flex items-center gap-3 p-3 rounded-2xl border-2 text-left transition-all cursor-pointer ${
                      isSelected
                        ? 'border-blue-600 bg-blue-50/70 shadow-sm'
                        : 'border-gray-100 hover:border-gray-200 bg-white'
                    }`}
                  >
                    <img src={agent.avatar} alt={agent.name} className="w-11 h-11 rounded-2xl object-cover border border-gray-200 flex-shrink-0" />
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <p className="text-xs font-black text-gray-900 truncate">{agent.name}</p>
                        <span className={`text-[10px] font-bold px-1.5 py-0.2 rounded-full ${
                          agent.status === 'online' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'
                        }`}>
                          {agent.status}
                        </span>
                        {isPinMatch && (
                          <span className="text-[10px] font-bold text-emerald-700 bg-emerald-100 px-2 py-0.2 rounded-full">
                            PIN Match ✓
                          </span>
                        )}
                      </div>
                      <p className="text-[11px] text-gray-500 mt-0.5 truncate">
                        {agent.vehicle} ({agent.vehicleNumber}) · 📞 {agent.phone}
                      </p>
                      <p className="text-[10px] text-gray-400">
                        {agent.city} · ⭐ {agent.rating} · {agent.todayPickups || 0} pickups today
                      </p>
                    </div>
                  </button>
                );
              })}
            </div>

            <div className="flex gap-3">
              <button
                type="button"
                onClick={() => setAssignDeliveryModal(null)}
                className="flex-1 py-3 rounded-2xl border border-gray-200 text-xs font-bold text-gray-600 hover:bg-gray-50 cursor-pointer"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleAssignDelivery}
                disabled={!selectedDeliveryAgentId}
                className="flex-1 py-3 rounded-2xl bg-blue-600 text-white text-xs font-black hover:bg-blue-700 disabled:opacity-50 transition-all shadow-md shadow-blue-600/20 cursor-pointer flex items-center justify-center gap-1.5"
              >
                <Truck size={14} /> Dispatch & Assign
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

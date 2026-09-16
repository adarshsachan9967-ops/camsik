'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { orders as defaultOrders, getOrderStatusColor, getOrderStatusLabel, getTypeColor } from '@/lib/casmikData';
import type { Order, OrderStatus } from '@/lib/casmikData';
import { Search, CheckCircle, XCircle, Eye, Phone, MapPin, X, Truck, Wifi, WifiOff } from 'lucide-react';
import LiveOrderTracker from '@/components/LiveOrderTracker';

const PARTNER_ID = 'partner-002';

const getStoredPartnerOrders = (): Order[] => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_orders_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) {
          return parsed.filter((o: Order) => o.partnerId === PARTNER_ID || !o.partnerId);
        }
      }
    } catch (e) {}
  }
  return defaultOrders.filter(o => o.partnerId === PARTNER_ID || !o.partnerId);
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

export default function PartnerOrders() {
  const [orderList, setOrderList] = useState<Order[]>(getStoredPartnerOrders);
  const [loading, setLoading] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [query, setQuery] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [activeTab, setActiveTab] = useState<'list' | 'live'>('list');
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

  const handleAccept = async (id: string) => {
    try {
      const { error } = await supabase.from('orders').update({ status: 'accepted' }).eq('id', id);
      if (error) console.log('Accept error:', error.message);
    } catch (err: any) { console.log(err.message); }
  };

  const handleReject = async (id: string) => {
    try {
      const { error } = await supabase.from('orders').update({ status: 'rejected' }).eq('id', id);
      if (error) console.log('Reject error:', error.message);
    } catch (err: any) { console.log(err.message); }
  };

  const handlePickup = async (id: string) => {
    try {
      const { error } = await supabase.from('orders').update({ status: 'picked_up' }).eq('id', id);
      if (error) console.log('Pickup error:', error.message);
    } catch (err: any) { console.log(err.message); }
  };

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
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="text-xl font-black text-gray-900 flex items-center gap-2">
            Order Management
            <span className={`inline-flex items-center gap-1 text-xs font-bold px-2 py-0.5 rounded-full ${
              isConnected ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'
            }`}>
              {isConnected ? <Wifi size={10} /> : <WifiOff size={10} />}
              {isConnected ? 'Live' : 'Connecting...'}
            </span>
          </h2>
          <p className="text-sm text-gray-500">Manage your assigned orders</p>
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
              <div key={order.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 hover:shadow-md transition-shadow">
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <span className="text-xs font-black text-gray-500">{order.orderNumber}</span>
                      <span className={`text-xs font-bold px-2 py-0.5 rounded-lg capitalize ${getTypeColor(order.type)}`}>{order.type}</span>
                      <span className={`text-xs font-semibold px-2 py-0.5 rounded-lg ${getOrderStatusColor(order.status)}`}>{getOrderStatusLabel(order.status)}</span>
                    </div>
                    <p className="text-sm font-bold text-gray-900">{order.deviceName}</p>
                  </div>
                  <p className="text-lg font-black text-gray-900">₹{order.quotedPrice.toLocaleString('en-IN')}</p>
                </div>

                <div className="grid grid-cols-2 gap-3 mb-3 text-xs">
                  <div className="flex items-center gap-1.5 text-gray-600">
                    <div className="w-6 h-6 rounded-full bg-gray-100 flex items-center justify-center text-gray-500 font-bold text-xs flex-shrink-0">
                      {order.customerName[0]}
                    </div>
                    <div>
                      <p className="font-semibold text-gray-800">{order.customerName}</p>
                      <p className="text-gray-400">{order.customerPhone}</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-1.5 text-gray-600">
                    <MapPin size={12} className="mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="font-semibold text-gray-800">{order.city}</p>
                      <p className="text-gray-400">PIN: {order.pinCode}</p>
                    </div>
                  </div>
                </div>

                <div className="flex items-center justify-between text-xs text-gray-500 mb-3">
                  <span>📅 Pickup: {order.pickupDate}</span>
                  <span>🕐 {order.pickupSlot}</span>
                </div>

                <div className="flex gap-2">
                  <button onClick={() => setSelectedOrder(order)} className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
                    <Eye size={12} /> Details
                  </button>
                  <button className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
                    <Phone size={12} /> Call
                  </button>
                  {order.status === 'assigned' && (
                    <>
                      <button onClick={() => handleAccept(order.id)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-green-500 text-white text-xs font-bold hover:bg-green-600">
                        <CheckCircle size={12} /> Accept
                      </button>
                      <button onClick={() => handleReject(order.id)} className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-red-50 text-red-600 text-xs font-semibold hover:bg-red-100">
                        <XCircle size={12} /> Reject
                      </button>
                    </>
                  )}
                  {order.status === 'accepted' && (
                    <button onClick={() => handlePickup(order.id)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary/90">
                      <Truck size={12} /> Start Pickup
                    </button>
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
              <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setSelectedOrder(null)} />
              <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 z-10 max-h-[90vh] overflow-y-auto">
                <div className="flex items-center justify-between mb-5">
                  <h3 className="text-lg font-black text-gray-900">{selectedOrder.orderNumber}</h3>
                  <button onClick={() => setSelectedOrder(null)} className="p-2 rounded-xl hover:bg-gray-100"><X size={18} /></button>
                </div>
                <div className="space-y-4">
                  <div className="bg-gray-50 rounded-xl p-4">
                    <p className="text-xs font-bold text-gray-500 mb-2">Device</p>
                    <p className="font-bold text-gray-900">{selectedOrder.deviceName}</p>
                    <p className="text-sm text-gray-500">{selectedOrder.deviceColor} · {selectedOrder.deviceStorage}</p>
                  </div>
                  <div className="bg-gray-50 rounded-xl p-4">
                    <p className="text-xs font-bold text-gray-500 mb-2">Customer</p>
                    <p className="font-bold text-gray-900">{selectedOrder.customerName}</p>
                    <p className="text-sm text-gray-500">{selectedOrder.customerPhone}</p>
                    <p className="text-sm text-gray-500">{selectedOrder.customerAddress}</p>
                  </div>
                  <div className="bg-green-50 rounded-xl p-4">
                    <p className="text-xs font-bold text-gray-500 mb-1">Quoted Price</p>
                    <p className="text-2xl font-black text-green-700">₹{selectedOrder.quotedPrice.toLocaleString('en-IN')}</p>
                  </div>
                  {selectedOrder.notes && (
                    <div className="bg-yellow-50 rounded-xl p-4">
                      <p className="text-xs font-bold text-gray-500 mb-1">Notes</p>
                      <p className="text-sm text-gray-700">{selectedOrder.notes}</p>
                    </div>
                  )}
                </div>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}

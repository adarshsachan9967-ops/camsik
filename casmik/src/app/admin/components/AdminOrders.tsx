'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { partners, getOrderStatusLabel, getOrderStatusColor, getTypeColor } from '@/lib/casmikData';
import type { Order, OrderStatus } from '@/lib/casmikData';
import { Search, Eye, UserCheck, X, AlertCircle, Wifi, WifiOff, RefreshCw } from 'lucide-react';
import LiveOrderTracker from '@/components/LiveOrderTracker';

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
    pickupDate: o.pickup_date || '',
    pickupSlot: o.pickup_slot || '',
    createdAt: o.created_at,
    updatedAt: o.updated_at,
    paymentStatus: o.payment_status as Order['paymentStatus'],
    inspectionScore: o.inspection_score,
    notes: o.notes || '',
  };
}

export default function AdminOrders() {
  const [orderList, setOrderList] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [isConnected, setIsConnected] = useState(false);
  const [query, setQuery] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [assignModal, setAssignModal] = useState<Order | null>(null);
  const [selectedPartner, setSelectedPartner] = useState('');
  const [activeTab, setActiveTab] = useState<'list' | 'live'>('list');
  const supabase = createClient();

  const fetchOrders = useCallback(async () => {
    try {
      const { data, error } = await supabase
        .from('orders')
        .select('*')
        .order('created_at', { ascending: false });
      if (error) {
        if (error.code?.startsWith('42')) throw error;
        console.log('Orders fetch error:', error.message);
        return;
      }
      setOrderList((data || []).map(dbToOrder));
    } catch (err: any) {
      console.log('Orders error:', err.message);
    } finally {
      setLoading(false);
    }
  }, []);

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
  }, [fetchOrders]);

  const filtered = orderList.filter(o =>
    (o.orderNumber.toLowerCase().includes(query.toLowerCase()) ||
     o.customerName.toLowerCase().includes(query.toLowerCase()) ||
     o.deviceName.toLowerCase().includes(query.toLowerCase())) &&
    (filterType === 'all' || o.type === filterType) &&
    (filterStatus === 'all' || o.status === filterStatus)
  );

  const handleAssign = async () => {
    if (!assignModal || !selectedPartner) return;
    const partner = partners.find(p => p.id === selectedPartner);
    try {
      const { error } = await supabase
        .from('orders')
        .update({ partner_id: selectedPartner, partner_name: partner?.storeName || '', status: 'assigned' })
        .eq('id', assignModal.id);
      if (error) console.log('Assign error:', error.message);
    } catch (err: any) {
      console.log('Assign error:', err.message);
    }
    setAssignModal(null);
    setSelectedPartner('');
  };

  const stats = {
    total: orderList.length,
    pending: orderList.filter(o => ['created', 'assigned'].includes(o.status)).length,
    active: orderList.filter(o => ['accepted', 'pickup_scheduled', 'picked_up', 'inspection'].includes(o.status)).length,
    completed: orderList.filter(o => o.status === 'completed').length,
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="flex flex-col items-center gap-3">
          <div className="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin" />
          <p className="text-sm text-gray-500">Loading orders...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <h2 className="text-xl font-black text-gray-900 flex items-center gap-2">
            Orders Management
            <span className={`inline-flex items-center gap-1 text-xs font-bold px-2 py-0.5 rounded-full ${
              isConnected ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'
            }`}>
              {isConnected ? <Wifi size={10} /> : <WifiOff size={10} />}
              {isConnected ? 'Live' : 'Connecting...'}
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
          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {[
              { label: 'Total Orders', value: stats.total, icon: '📦', color: 'bg-blue-50 text-blue-700' },
              { label: 'Pending', value: stats.pending, icon: '⏳', color: 'bg-yellow-50 text-yellow-700' },
              { label: 'Active', value: stats.active, icon: '🔄', color: 'bg-purple-50 text-purple-700' },
              { label: 'Completed', value: stats.completed, icon: '✅', color: 'bg-green-50 text-green-700' },
            ].map(s => (
              <div key={s.label} className="bg-white rounded-2xl p-4 border border-gray-100 shadow-sm">
                <div className="flex items-center gap-3">
                  <span className="text-2xl">{s.icon}</span>
                  <div>
                    <p className="text-2xl font-black text-gray-900">{s.value}</p>
                    <p className="text-xs text-gray-500">{s.label}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>

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
            </select>
            <select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}
              className="px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white">
              <option value="all">All Status</option>
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
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Partner</th>
                    <th className="text-left px-4 py-3.5 text-xs font-bold text-gray-500 uppercase tracking-wide">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-50">
                  {filtered.map((order) => (
                    <tr key={order.id} className="hover:bg-gray-50/50 transition-colors">
                      <td className="px-5 py-3.5">
                        <p className="font-bold text-gray-900 text-xs">{order.orderNumber}</p>
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
                      <td className="px-4 py-3.5">
                        <span className={`text-xs font-semibold px-2 py-1 rounded-lg ${getOrderStatusColor(order.status)}`}>
                          {getOrderStatusLabel(order.status)}
                        </span>
                      </td>
                      <td className="px-4 py-3.5">
                        {order.partnerName ? (
                          <p className="text-xs font-semibold text-gray-700">{order.partnerName}</p>
                        ) : (
                          <span className="text-xs font-bold text-red-500">Unassigned</span>
                        )}
                      </td>
                      <td className="px-4 py-3.5">
                        <div className="flex items-center gap-1.5">
                          <button onClick={() => setSelectedOrder(order)} className="p-1.5 rounded-lg bg-gray-100 hover:bg-primary hover:text-white transition-colors" title="View Details">
                            <Eye size={13} />
                          </button>
                          {!order.partnerId && (
                            <button onClick={() => setAssignModal(order)} className="p-1.5 rounded-lg bg-green-100 text-green-700 hover:bg-green-500 hover:text-white transition-colors" title="Assign Partner">
                              <UserCheck size={13} />
                            </button>
                          )}
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
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-lg p-6 z-10 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-lg font-black text-gray-900">{selectedOrder.orderNumber}</h3>
              <button onClick={() => setSelectedOrder(null)} className="p-2 rounded-xl hover:bg-gray-100"><X size={18} /></button>
            </div>
            <div className="space-y-4">
              <div className="flex gap-2">
                <span className={`text-xs font-bold px-2 py-1 rounded-lg capitalize ${getTypeColor(selectedOrder.type)}`}>{selectedOrder.type}</span>
                <span className={`text-xs font-semibold px-2 py-1 rounded-lg ${getOrderStatusColor(selectedOrder.status)}`}>{getOrderStatusLabel(selectedOrder.status)}</span>
              </div>
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
                    <span className="text-gray-600">Final Price</span>
                    <span className="font-bold text-green-700">₹{selectedOrder.finalPrice.toLocaleString('en-IN')}</span>
                  </div>
                )}
              </div>
              {selectedOrder.partnerName && (
                <div className="bg-purple-50 rounded-xl p-3">
                  <p className="text-xs font-bold text-gray-500 mb-1">Partner</p>
                  <p className="text-sm font-bold text-gray-900">{selectedOrder.partnerName}</p>
                  {selectedOrder.deliveryAgentName && <p className="text-xs text-gray-500">Delivery: {selectedOrder.deliveryAgentName}</p>}
                </div>
              )}
              {selectedOrder.inspectionScore && (
                <div className="bg-blue-50 rounded-xl p-3">
                  <p className="text-xs font-bold text-gray-500 mb-1">Inspection Score</p>
                  <p className="text-2xl font-black text-blue-700">{selectedOrder.inspectionScore}/100</p>
                </div>
              )}
              {selectedOrder.notes && (
                <div className="bg-gray-50 rounded-xl p-3">
                  <p className="text-xs font-bold text-gray-500 mb-1">Notes</p>
                  <p className="text-xs text-gray-700">{selectedOrder.notes}</p>
                </div>
              )}
            </div>
            {!selectedOrder.partnerId && (
              <button onClick={() => { setAssignModal(selectedOrder); setSelectedOrder(null); }}
                className="w-full mt-5 py-2.5 bg-primary text-white rounded-xl text-sm font-semibold hover:bg-primary/90">
                Assign Partner
              </button>
            )}
          </div>
        </div>
      )}

      {/* Assign Partner Modal */}
      {assignModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setAssignModal(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 z-10">
            <h3 className="text-lg font-black text-gray-900 mb-2">Assign Partner</h3>
            <p className="text-sm text-gray-500 mb-5">Order: {assignModal.orderNumber} · PIN: {assignModal.pinCode}</p>
            <div className="space-y-3 mb-5">
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
                Assign Partner
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

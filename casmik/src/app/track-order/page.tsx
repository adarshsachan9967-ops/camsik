'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { getOrderStatusLabel, getOrderStatusColor, getTypeColor } from '@/lib/casmikData';
import type { OrderStatus } from '@/lib/casmikData';
import { Package, CheckCircle, Clock, Truck, Search, Wrench, CreditCard, MapPin, Phone, X, Wifi, WifiOff } from 'lucide-react';
import Icon from '@/components/ui/AppIcon';


interface LiveOrder {
  id: string;
  order_number: string;
  order_type: string;
  status: string;
  customer_name: string;
  customer_phone: string;
  device_name: string;
  quoted_price: number;
  final_price: number;
  partner_name: string | null;
  delivery_agent_name: string | null;
  pickup_date: string | null;
  pickup_slot: string | null;
  city: string | null;
  pin_code: string | null;
  payment_status: string;
  inspection_score: number | null;
  notes: string | null;
  updated_at: string;
}

const STATUS_STEPS = [
  { key: 'created', label: 'Order Created', icon: Package, desc: 'Your order has been placed' },
  { key: 'assigned', label: 'Partner Assigned', icon: CheckCircle, desc: 'A partner has been assigned' },
  { key: 'accepted', label: 'Partner Accepted', icon: CheckCircle, desc: 'Partner confirmed your order' },
  { key: 'pickup_scheduled', label: 'Pickup Scheduled', icon: Clock, desc: 'Pickup agent is on the way' },
  { key: 'picked_up', label: 'Device Picked Up', icon: Truck, desc: 'Your device has been collected' },
  { key: 'inspection', label: 'Under Inspection', icon: Search, desc: 'Device is being inspected' },
  { key: 'inspection_completed', label: 'Inspection Done', icon: CheckCircle, desc: 'Inspection completed' },
  { key: 'payment_processing', label: 'Payment Processing', icon: CreditCard, desc: 'Payment is being processed' },
  { key: 'paid', label: 'Payment Done', icon: CheckCircle, desc: 'Payment sent to your account' },
  { key: 'completed', label: 'Completed', icon: CheckCircle, desc: 'Order successfully completed' },
];

const REPAIR_STEPS = [
  { key: 'created', label: 'Order Created', icon: Package, desc: 'Your repair order is placed' },
  { key: 'assigned', label: 'Partner Assigned', icon: CheckCircle, desc: 'Repair partner assigned' },
  { key: 'accepted', label: 'Accepted', icon: CheckCircle, desc: 'Partner confirmed your repair' },
  { key: 'pickup_scheduled', label: 'Pickup Scheduled', icon: Clock, desc: 'Pickup agent is on the way' },
  { key: 'picked_up', label: 'Device Picked Up', icon: Truck, desc: 'Device collected for repair' },
  { key: 'inspection', label: 'Under Repair', icon: Wrench, desc: 'Your device is being repaired' },
  { key: 'completed', label: 'Completed', icon: CheckCircle, desc: 'Repair done, device returned' },
];

export default function CustomerOrderTracker() {
  const [orders, setOrders] = useState<LiveOrder[]>([]);
  const [loading, setLoading] = useState(true);
  const [isConnected, setIsConnected] = useState(false);
  const [searchPhone, setSearchPhone] = useState('');
  const [searchInput, setSearchInput] = useState('');
  const [selectedOrder, setSelectedOrder] = useState<LiveOrder | null>(null);
  const [recentUpdate, setRecentUpdate] = useState<string | null>(null);
  const supabase = createClient();

  const fetchOrders = useCallback(async (phone: string) => {
    if (!phone) return;
    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('orders')
        .select('*')
        .eq('customer_phone', phone)
        .order('created_at', { ascending: false });
      if (error) {
        if (error.code?.startsWith('42')) throw error;
        console.log('Customer orders error:', error.message);
        return;
      }
      setOrders(data || []);
    } catch (err: any) {
      console.log('Customer orders error:', err.message);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!searchPhone) return;

    const channel = supabase
      .channel(`customer-orders-${searchPhone}`)
      .on('postgres_changes', {
        event: '*', schema: 'public', table: 'orders',
        filter: `customer_phone=eq.${searchPhone}`
      }, (payload) => {
        setRecentUpdate(payload.new && 'order_number' in payload.new ? (payload.new as any).order_number : null);
        setTimeout(() => setRecentUpdate(null), 4000);

        if (payload.eventType === 'UPDATE') {
          setOrders(prev => prev.map(o => o.id === (payload.new as LiveOrder).id ? payload.new as LiveOrder : o));
          setSelectedOrder(prev => prev?.id === (payload.new as LiveOrder).id ? payload.new as LiveOrder : prev);
        } else if (payload.eventType === 'INSERT') {
          setOrders(prev => [payload.new as LiveOrder, ...prev]);
        }
      })
      .subscribe(status => setIsConnected(status === 'SUBSCRIBED'));

    return () => { supabase.removeChannel(channel); };
  }, [searchPhone]);

  const handleSearch = () => {
    if (searchInput.trim().length >= 10) {
      setSearchPhone(searchInput.trim());
      fetchOrders(searchInput.trim());
    }
  };

  const getSteps = (orderType: string) => orderType === 'repair' ? REPAIR_STEPS : STATUS_STEPS;

  const getStepIndex = (steps: typeof STATUS_STEPS, status: string) =>
    steps.findIndex(s => s.key === status);

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50/30 py-8 px-4">
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mx-auto mb-4">
            <Package size={32} className="text-primary" />
          </div>
          <h1 className="text-2xl font-black text-gray-900 mb-2">Track Your Order</h1>
          <p className="text-gray-500 text-sm">Enter your phone number to see live order status</p>
        </div>

        {/* Search */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-6">
          <div className="flex gap-3">
            <div className="relative flex-1">
              <Phone size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                value={searchInput}
                onChange={e => setSearchInput(e.target.value)}
                onKeyDown={e => e.key === 'Enter' && handleSearch()}
                placeholder="Enter your mobile number (e.g. 9876543210)"
                className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
              />
            </div>
            <button onClick={handleSearch}
              className="px-5 py-3 bg-primary text-white rounded-xl text-sm font-bold hover:bg-primary/90 transition-colors">
              Track
            </button>
          </div>
          {searchPhone && (
            <div className="flex items-center gap-2 mt-3 text-xs">
              <span className={`inline-flex items-center gap-1 font-bold px-2 py-0.5 rounded-full ${
                isConnected ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'
              }`}>
                {isConnected ? <Wifi size={10} /> : <WifiOff size={10} />}
                {isConnected ? 'Live updates active' : 'Connecting...'}
              </span>
              <span className="text-gray-400">Tracking: {searchPhone}</span>
            </div>
          )}
        </div>

        {/* Recent Update Banner */}
        {recentUpdate && (
          <div className="bg-green-50 border border-green-200 rounded-xl p-3 mb-4 flex items-center gap-2 text-sm text-green-700 font-semibold animate-pulse">
            <div className="w-2 h-2 rounded-full bg-green-500" />
            Order {recentUpdate} status just updated!
          </div>
        )}

        {/* Orders */}
        {searchPhone && !loading && (
          <div className="space-y-4">
            {orders.length === 0 ? (
              <div className="bg-white rounded-2xl border border-gray-100 p-12 text-center">
                <p className="text-4xl mb-3">📭</p>
                <p className="font-bold text-gray-700 mb-1">No orders found</p>
                <p className="text-sm text-gray-400">No orders found for {searchPhone}</p>
              </div>
            ) : (
              orders.map(order => {
                const steps = getSteps(order.order_type);
                const currentIdx = getStepIndex(steps, order.status);
                const isTerminal = ['completed', 'cancelled', 'rejected'].includes(order.status);

                return (
                  <div key={order.id}
                    className={`bg-white rounded-2xl border shadow-sm overflow-hidden transition-all cursor-pointer hover:shadow-md ${
                      recentUpdate === order.order_number ? 'border-green-300 ring-2 ring-green-100' : 'border-gray-100'
                    }`}
                    onClick={() => setSelectedOrder(order)}>
                    <div className="p-5">
                      {/* Order Header */}
                      <div className="flex items-start justify-between mb-4">
                        <div>
                          <div className="flex items-center gap-2 mb-1">
                            <span className="text-xs font-black text-gray-500">{order.order_number}</span>
                            <span className={`text-xs font-bold px-2 py-0.5 rounded-lg capitalize ${getTypeColor(order.order_type as any)}`}>
                              {order.order_type}
                            </span>
                            {recentUpdate === order.order_number && (
                              <span className="text-xs font-bold text-green-600 bg-green-50 px-2 py-0.5 rounded-lg animate-pulse">● Updated</span>
                            )}
                          </div>
                          <p className="font-bold text-gray-900">{order.device_name}</p>
                          <p className="text-xs text-gray-500 mt-0.5">{order.city} · {order.pickup_date}</p>
                        </div>
                        <div className="text-right">
                          <p className="text-lg font-black text-gray-900">₹{(order.final_price || order.quoted_price || 0).toLocaleString('en-IN')}</p>
                          <span className={`text-xs font-semibold px-2 py-0.5 rounded-lg ${getOrderStatusColor(order.status as OrderStatus)}`}>
                            {getOrderStatusLabel(order.status as OrderStatus)}
                          </span>
                        </div>
                      </div>

                      {/* Progress Steps */}
                      <div className="space-y-2">
                        {steps.map((step, idx) => {
                          const Icon = step.icon;
                          const isDone = idx < currentIdx || (isTerminal && order.status === 'completed');
                          const isCurrent = idx === currentIdx;
                          return (
                            <div key={step.key} className={`flex items-center gap-3 py-1.5 px-3 rounded-xl transition-all ${
                              isCurrent ? 'bg-primary/5 border border-primary/20' : isDone ?'opacity-60' : 'opacity-30'
                            }`}>
                              <div className={`w-7 h-7 rounded-full flex items-center justify-center flex-shrink-0 ${
                                isDone ? 'bg-green-500 text-white' : isCurrent ?'bg-primary text-white ring-2 ring-primary/30': 'bg-gray-100 text-gray-400'
                              }`}>
                                <Icon size={13} />
                              </div>
                              <div className="flex-1 min-w-0">
                                <p className={`text-xs font-bold ${isCurrent ? 'text-primary' : isDone ? 'text-green-700' : 'text-gray-400'}`}>
                                  {step.label}
                                </p>
                                {isCurrent && <p className="text-xs text-gray-500">{step.desc}</p>}
                              </div>
                              {isCurrent && <div className="w-2 h-2 rounded-full bg-primary animate-pulse flex-shrink-0" />}
                            </div>
                          );
                        })}
                      </div>

                      {/* Partner/Agent Info */}
                      {(order.partner_name || order.delivery_agent_name) && (
                        <div className="mt-4 pt-4 border-t border-gray-100 flex items-center justify-between text-xs">
                          {order.partner_name && (
                            <div className="flex items-center gap-1.5 text-gray-600">
                              <MapPin size={12} className="text-primary" />
                              <span className="font-semibold">{order.partner_name}</span>
                            </div>
                          )}
                          {order.delivery_agent_name && (
                            <div className="flex items-center gap-1.5 text-gray-600">
                              <Truck size={12} className="text-blue-500" />
                              <span className="font-semibold">{order.delivery_agent_name}</span>
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                );
              })
            )}
          </div>
        )}

        {!searchPhone && (
          <div className="text-center py-12 text-gray-400">
            <p className="text-5xl mb-4">📦</p>
            <p className="font-semibold text-gray-500">Enter your phone number above to track your orders</p>
            <p className="text-sm mt-1">Real-time updates will appear automatically</p>
          </div>
        )}
      </div>

      {/* Order Detail Modal */}
      {selectedOrder && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setSelectedOrder(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 z-10 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-lg font-black text-gray-900">{selectedOrder.order_number}</h3>
              <button onClick={() => setSelectedOrder(null)} className="p-2 rounded-xl hover:bg-gray-100"><X size={18} /></button>
            </div>
            <div className="space-y-4">
              <div className="flex gap-2">
                <span className={`text-xs font-bold px-2 py-1 rounded-lg capitalize ${getTypeColor(selectedOrder.order_type as any)}`}>{selectedOrder.order_type}</span>
                <span className={`text-xs font-semibold px-2 py-1 rounded-lg ${getOrderStatusColor(selectedOrder.status as OrderStatus)}`}>{getOrderStatusLabel(selectedOrder.status as OrderStatus)}</span>
              </div>
              <div className="bg-gray-50 rounded-xl p-4">
                <p className="text-xs font-bold text-gray-500 mb-2">Device</p>
                <p className="font-bold text-gray-900">{selectedOrder.device_name}</p>
              </div>
              <div className="bg-green-50 rounded-xl p-4">
                <p className="text-xs font-bold text-gray-500 mb-2">Pricing</p>
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Quoted</span>
                  <span className="font-bold text-gray-900">₹{(selectedOrder.quoted_price || 0).toLocaleString('en-IN')}</span>
                </div>
                {selectedOrder.final_price > 0 && (
                  <div className="flex justify-between mt-1">
                    <span className="text-sm text-gray-600">Final</span>
                    <span className="font-bold text-green-700">₹{selectedOrder.final_price.toLocaleString('en-IN')}</span>
                  </div>
                )}
              </div>
              {selectedOrder.pickup_date && (
                <div className="bg-blue-50 rounded-xl p-4">
                  <p className="text-xs font-bold text-gray-500 mb-1">Pickup Details</p>
                  <p className="text-sm font-bold text-gray-900">📅 {selectedOrder.pickup_date}</p>
                  {selectedOrder.pickup_slot && <p className="text-xs text-gray-500">🕐 {selectedOrder.pickup_slot}</p>}
                </div>
              )}
              {selectedOrder.inspection_score && (
                <div className="bg-purple-50 rounded-xl p-4">
                  <p className="text-xs font-bold text-gray-500 mb-1">Inspection Score</p>
                  <p className="text-2xl font-black text-purple-700">{selectedOrder.inspection_score}/100</p>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

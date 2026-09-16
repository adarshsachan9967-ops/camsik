'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import type { Order, OrderStatus } from '@/lib/casmikData';
import { MapPin, Phone, CheckCircle, Camera, X, Navigation, Package, Truck, Wifi, WifiOff } from 'lucide-react';
import LiveOrderTracker from '@/components/LiveOrderTracker';

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
    id: o.id, orderNumber: o.order_number, type: o.order_type as Order['type'],
    status: o.status as OrderStatus, customerId: '', customerName: o.customer_name,
    customerPhone: o.customer_phone, customerEmail: '', customerAddress: o.customer_address || '',
    pinCode: o.pin_code || '', city: o.city || '', deviceName: o.device_name,
    deviceBrand: '', deviceModel: '', deviceStorage: '', deviceColor: '',
    quotedPrice: o.quoted_price || 0, finalPrice: 0,
    partnerId: null, partnerName: o.partner_name,
    deliveryAgentId: DELIVERY_AGENT_ID, deliveryAgentName: 'Ravi Kumar',
    pickupDate: o.pickup_date || '', pickupSlot: o.pickup_slot || '',
    createdAt: o.created_at, updatedAt: o.updated_at,
    paymentStatus: 'pending', inspectionScore: null, notes: '',
  };
}

import { orders } from '@/lib/casmikData';

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

export default function DeliveryTasks() {
  const [taskList, setTaskList] = useState<Order[]>(getStoredDeliveryTasks);
  const [loading, setLoading] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [activeTask, setActiveTask] = useState<Order | null>(null);
  const [otpInput, setOtpInput] = useState('');
  const [otpVerified, setOtpVerified] = useState(false);
  const [filterStatus, setFilterStatus] = useState('all');
  const [activeTab, setActiveTab] = useState<'list' | 'live'>('list');
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
        console.log('Tasks fetch error:', error.message);
        setTaskList(getStoredDeliveryTasks());
        return;
      }
      if (data && data.length > 0) {
        setTaskList(data.map(dbToOrder));
      } else {
        setTaskList(getStoredDeliveryTasks());
      }
    } catch (err: any) {
      console.log('Tasks error:', err.message);
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

  const handleStartPickup = async (id: string) => {
    try {
      const { error } = await supabase.from('orders').update({ status: 'pickup_scheduled' }).eq('id', id);
      if (error) console.log('Start pickup error:', error.message);
    } catch (err: any) { console.log(err.message); }
  };

  const handleVerifyOTP = async () => {
    if (otpInput === '1234' && activeTask) {
      setOtpVerified(true);
      try {
        const { error } = await supabase.from('orders').update({ status: 'picked_up' }).eq('id', activeTask.id);
        if (error) console.log('OTP verify error:', error.message);
      } catch (err: any) { console.log(err.message); }
    }
  };

  const handleComplete = async (id: string) => {
    try {
      const { error } = await supabase.from('orders').update({ status: 'completed' }).eq('id', id);
      if (error) console.log('Complete error:', error.message);
    } catch (err: any) { console.log(err.message); }
    setActiveTask(null);
  };

  const filtered = taskList.filter(t => filterStatus === 'all' || t.status === filterStatus);

  const tabs = [
    { id: 'all', label: 'All' },
    { id: 'assigned', label: 'Assigned' },
    { id: 'pickup_scheduled', label: 'En Route' },
    { id: 'picked_up', label: 'Picked Up' },
    { id: 'completed', label: 'Done' },
  ];

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="space-y-4 max-w-2xl mx-auto">
      <div className="flex items-center justify-between flex-wrap gap-2">
        <div>
          <h2 className="text-xl font-black text-gray-900 flex items-center gap-2">
            My Tasks
            <span className={`inline-flex items-center gap-1 text-xs font-bold px-2 py-0.5 rounded-full ${
              isConnected ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'
            }`}>
              {isConnected ? <Wifi size={10} /> : <WifiOff size={10} />}
              {isConnected ? 'Live' : 'Connecting...'}
            </span>
          </h2>
          <p className="text-sm text-gray-500">{taskList.length} assigned tasks</p>
        </div>
      </div>

      {/* View Tabs */}
      <div className="flex gap-2">
        {[{ id: 'list', label: '📋 My Tasks' }, { id: 'live', label: '🔴 Live Tracker' }].map(tab => (
          <button key={tab.id} onClick={() => setActiveTab(tab.id as any)}
            className={`px-4 py-2 rounded-xl text-sm font-bold transition-all ${
              activeTab === tab.id ? 'bg-primary text-white shadow-lg shadow-primary/20' : 'bg-white border border-gray-200 text-gray-600 hover:border-primary/40'
            }`}>
            {tab.label}
          </button>
        ))}
      </div>

      {activeTab === 'live' ? (
        <LiveOrderTracker panel="delivery" deliveryAgentId={DELIVERY_AGENT_ID} title="Delivery Live Tracker" />
      ) : (
        <>
          <div className="flex gap-2 overflow-x-auto scrollbar-hide pb-1">
            {tabs.map(tab => (
              <button key={tab.id} onClick={() => setFilterStatus(tab.id)}
                className={`flex-shrink-0 px-3 py-2 rounded-xl text-xs font-bold transition-all ${filterStatus === tab.id ? 'bg-primary text-white' : 'bg-white border border-gray-200 text-gray-600'}`}>
                {tab.label}
              </button>
            ))}
          </div>

          <div className="space-y-3">
            {filtered.map((task) => (
              <div key={task.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                <div className="p-4">
                  <div className="flex items-start justify-between mb-3">
                    <div>
                      <p className="text-xs font-black text-gray-400">{task.orderNumber}</p>
                      <p className="font-bold text-gray-900 text-sm mt-0.5">{task.deviceName.split(' ').slice(0, 4).join(' ')}</p>
                      <span className={`text-xs font-bold px-2 py-0.5 rounded-full mt-1 inline-block ${
                        task.type === 'sell' ? 'bg-green-100 text-green-700' :
                        task.type === 'buy' ? 'bg-blue-100 text-blue-700' :
                        task.type === 'repair' ? 'bg-orange-100 text-orange-700' : 'bg-purple-100 text-purple-700'
                      }`}>{task.type} · {task.status.replace(/_/g, ' ')}</span>
                    </div>
                    <p className="text-sm font-black text-gray-900">₹{task.quotedPrice.toLocaleString('en-IN')}</p>
                  </div>

                  <div className="bg-gray-50 rounded-xl p-3 mb-3">
                    <div className="flex items-start gap-2">
                      <MapPin size={14} className="text-primary mt-0.5 flex-shrink-0" />
                      <div>
                        <p className="text-xs font-bold text-gray-900">{task.customerName}</p>
                        <p className="text-xs text-gray-500">{task.customerAddress}</p>
                        <p className="text-xs text-gray-400">PIN: {task.pinCode} · {task.city}</p>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center justify-between text-xs text-gray-500 mb-3">
                    <span>📅 {task.pickupDate}</span>
                    <span>🕐 {task.pickupSlot}</span>
                  </div>

                  <div className="flex gap-2">
                    <button className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
                      <Phone size={12} /> Call
                    </button>
                    <button className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
                      <Navigation size={12} /> Navigate
                    </button>
                    {task.status === 'assigned' && (
                      <button onClick={() => handleStartPickup(task.id)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary/90">
                        <Truck size={12} /> Start Trip
                      </button>
                    )}
                    {task.status === 'pickup_scheduled' && (
                      <button onClick={() => setActiveTask(task)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-blue-500 text-white text-xs font-bold hover:bg-blue-600">
                        <Package size={12} /> Arrived — Verify OTP
                      </button>
                    )}
                    {task.status === 'picked_up' && (
                      <button onClick={() => handleComplete(task.id)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-green-500 text-white text-xs font-bold hover:bg-green-600">
                        <CheckCircle size={12} /> Mark Delivered
                      </button>
                    )}
                  </div>
                </div>
              </div>
            ))}
            {filtered.length === 0 && (
              <div className="text-center py-12 text-gray-400">
                <p className="text-4xl mb-2">📭</p>
                <p className="text-sm font-semibold">No tasks in this category</p>
              </div>
            )}
          </div>
        </>
      )}

      {/* OTP Verification Modal */}
      {activeTask && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setActiveTask(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6 z-10">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-lg font-black text-gray-900">Verify Pickup OTP</h3>
              <button onClick={() => setActiveTask(null)} className="p-2 rounded-xl hover:bg-gray-100"><X size={18} /></button>
            </div>

            {!otpVerified ? (
              <>
                <div className="bg-gray-50 rounded-xl p-3 mb-4">
                  <p className="text-xs font-bold text-gray-500">Device</p>
                  <p className="text-sm font-bold text-gray-900">{activeTask.deviceName}</p>
                  <p className="text-xs text-gray-500">{activeTask.customerName}</p>
                </div>
                <p className="text-sm text-gray-600 mb-3">Ask the customer for their OTP to confirm pickup.</p>
                <input value={otpInput} onChange={e => setOtpInput(e.target.value)} placeholder="Enter 4-digit OTP"
                  maxLength={4} className="w-full px-4 py-3 rounded-xl border-2 border-gray-200 text-center text-2xl font-black tracking-widest focus:outline-none focus:border-primary mb-4" />
                <p className="text-xs text-gray-400 text-center mb-4">Demo OTP: 1234</p>
                <button onClick={handleVerifyOTP} disabled={otpInput.length !== 4}
                  className="w-full py-3 bg-primary text-white rounded-xl font-bold hover:bg-primary/90 disabled:opacity-50">
                  Verify & Confirm Pickup
                </button>
              </>
            ) : (
              <div className="text-center py-4">
                <div className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-3">
                  <CheckCircle size={32} className="text-green-600" />
                </div>
                <p className="font-black text-gray-900 text-lg mb-1">OTP Verified!</p>
                <p className="text-sm text-gray-500 mb-4">Device picked up successfully.</p>
                <div className="space-y-2 mb-4">
                  <button className="w-full flex items-center justify-center gap-2 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">
                    <Camera size={16} /> Capture Device Photos
                  </button>
                </div>
                <button onClick={() => { setActiveTask(null); setOtpVerified(false); setOtpInput(''); }}
                  className="w-full py-3 bg-primary text-white rounded-xl font-bold hover:bg-primary/90">
                  Done
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

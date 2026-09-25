'use client';
import React, { useState, useEffect } from 'react';
import { deliveryAgents, orders as defaultOrders } from '@/lib/casmikData';
import type { Order, OrderStatus } from '@/lib/casmikData';
import { Search, MapPin, Phone, Star, Package, FileText, CheckCircle, XCircle, Shield, Clock, AlertTriangle, X, Truck, Check } from 'lucide-react';
import { triggerNotification } from '@/lib/notifications';

const agentDocs = {
  'delivery-001': { aadhar: true, pan: true, drivingLicense: true, vehicleRC: true, insurance: true },
  'delivery-002': { aadhar: true, pan: true, drivingLicense: true, vehicleRC: false, insurance: true },
  'delivery-003': { aadhar: true, pan: true, drivingLicense: true, vehicleRC: true, insurance: false },
  'delivery-004': { aadhar: true, pan: false, drivingLicense: false, vehicleRC: false, insurance: false },
  'delivery-005': { aadhar: true, pan: true, drivingLicense: true, vehicleRC: true, insurance: true },
};

const docLabels = [
  { key: 'aadhar', label: 'Aadhar Card', icon: '🪪' },
  { key: 'pan', label: 'PAN Card', icon: '📋' },
  { key: 'drivingLicense', label: 'Driving License', icon: '🚗' },
  { key: 'vehicleRC', label: 'Vehicle RC', icon: '📄' },
  { key: 'insurance', label: 'Vehicle Insurance', icon: '🛡️' },
];

// Extended agents with approval status
const extendedAgents = [
  ...deliveryAgents,
  { id: 'delivery-006', name: 'Priya Sharma', phone: '9876501234', email: 'priya.d@casmik.com', city: 'Delhi', pinCodes: ['110070', '110001'], status: 'offline' as const, rating: 0, todayPickups: 0, todayDeliveries: 0, totalDeliveries: 0, earnings: 0, vehicle: 'Bike', vehicleNumber: 'DL01AA0001', avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&q=80', joinedAt: '2024-12-20', approvalStatus: 'pending' },
];

const getInitialAgents = () => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_delivery_agents_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch {}
  }
  return extendedAgents.map(a => ({ ...a, approvalStatus: (a as any).approvalStatus || 'approved' }));
};

const getStoredOrders = (): Order[] => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_orders_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch {}
  }
  return defaultOrders;
};

export default function AdminDelivery() {
  const [agents, setAgents] = useState(getInitialAgents);
  const [ordersList, setOrdersList] = useState<Order[]>(getStoredOrders);
  const [query, setQuery] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [docModal, setDocModal] = useState<typeof agents[0] | null>(null);
  const [assignModal, setAssignModal] = useState<typeof agents[0] | null>(null);
  const [selectedOrderId, setSelectedOrderId] = useState('');
  const [scheduledSlot, setScheduledSlot] = useState('10:00 AM - 1:00 PM');
  const [scheduledDate, setScheduledDate] = useState('');
  const [callModal, setCallModal] = useState<typeof agents[0] | null>(null);
  const [activeTab, setActiveTab] = useState<'all' | 'pending'>('all');
  const [assignSuccess, setAssignSuccess] = useState<string | null>(null);

  useEffect(() => {
    const handleSync = () => {
      setOrdersList(getStoredOrders());
    };
    window.addEventListener('casmik_orders_updated', handleSync);
    window.addEventListener('storage', handleSync);
    return () => {
      window.removeEventListener('casmik_orders_updated', handleSync);
      window.removeEventListener('storage', handleSync);
    };
  }, []);

  const filtered = agents.filter(a =>
    (a?.name?.toLowerCase()?.includes(query?.toLowerCase()) || a?.city?.toLowerCase()?.includes(query?.toLowerCase())) &&
    (filterStatus === 'all' || a?.status === filterStatus) &&
    (activeTab === 'all' || (activeTab === 'pending' && a.approvalStatus === 'pending'))
  );

  const statusColors = { online: 'bg-green-100 text-green-700', offline: 'bg-gray-100 text-gray-600', on_trip: 'bg-blue-100 text-blue-700' };
  const statusDots = { online: 'bg-green-500', offline: 'bg-gray-400', on_trip: 'bg-blue-500' };

  const handleApprove = (id: string) => {
    setAgents(prev => {
      const updated = prev.map(a => a.id === id ? { ...a, approvalStatus: 'approved' } : a);
      if (typeof window !== 'undefined') localStorage.setItem('casmik_delivery_agents_v1', JSON.stringify(updated));
      return updated;
    });
  };

  const handleReject = (id: string) => {
    setAgents(prev => {
      const updated = prev.map(a => a.id === id ? { ...a, approvalStatus: 'rejected' } : a);
      if (typeof window !== 'undefined') localStorage.setItem('casmik_delivery_agents_v1', JSON.stringify(updated));
      return updated;
    });
  };

  const pendingCount = agents.filter(a => a.approvalStatus === 'pending').length;

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black text-gray-900">Delivery Agents</h2>
          <p className="text-sm text-gray-500">{agents?.length} agents · {agents?.filter(a => a?.status === 'online')?.length} online · {agents?.filter(a => a?.status === 'on_trip')?.length} on trip</p>
        </div>
        {pendingCount > 0 && (
          <div className="flex items-center gap-2 px-3 py-2 bg-yellow-50 border border-yellow-200 rounded-xl">
            <AlertTriangle size={15} className="text-yellow-600" />
            <span className="text-xs font-bold text-yellow-700">{pendingCount} pending approval</span>
          </div>
        )}
      </div>

      <div className="grid grid-cols-3 gap-4">
        {[
          { label: 'Online', value: agents?.filter(a => a?.status === 'online')?.length, color: 'text-green-600', bg: 'bg-green-50' },
          { label: 'On Trip', value: agents?.filter(a => a?.status === 'on_trip')?.length, color: 'text-blue-600', bg: 'bg-blue-50' },
          { label: 'Offline', value: agents?.filter(a => a?.status === 'offline')?.length, color: 'text-gray-600', bg: 'bg-gray-50' },
        ]?.map(s => (
          <div key={s?.label} className={`${s?.bg} rounded-2xl p-4`}>
            <p className={`text-2xl font-black ${s?.color}`}>{s?.value}</p>
            <p className="text-xs text-gray-600">{s?.label}</p>
          </div>
        ))}
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit">
        {[
          { key: 'all', label: 'All Agents' },
          { key: 'pending', label: `Pending Approval (${pendingCount})` },
        ].map(tab => (
          <button key={tab.key} onClick={() => setActiveTab(tab.key as typeof activeTab)}
            className={`px-4 py-2 rounded-lg text-xs font-bold transition-all ${activeTab === tab.key ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}>
            {tab.label}
          </button>
        ))}
      </div>

      <div className="flex gap-3">
        <div className="relative flex-1">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
          <input value={query} onChange={e => setQuery(e?.target?.value)} placeholder="Search agents..."
            className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white" />
        </div>
        <select value={filterStatus} onChange={e => setFilterStatus(e?.target?.value)}
          className="px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none bg-white">
          <option value="all">All Status</option>
          <option value="online">Online</option>
          <option value="on_trip">On Trip</option>
          <option value="offline">Offline</option>
        </select>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {filtered?.map((agent) => {
          const docs = agentDocs[agent?.id as keyof typeof agentDocs] || {};
          const docsSubmitted = Object.values(docs).filter(Boolean).length;
          return (
            <div key={agent?.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 hover:shadow-md transition-shadow">
              <div className="flex items-start gap-3 mb-3">
                <div className="relative">
                  <img src={agent?.avatar} alt={agent?.name} className="w-12 h-12 rounded-xl object-cover" />
                  <div className={`absolute -bottom-0.5 -right-0.5 w-3.5 h-3.5 rounded-full border-2 border-white ${statusDots?.[agent?.status as keyof typeof statusDots] || 'bg-gray-400'}`} />
                </div>
                <div className="flex-1">
                  <p className="font-bold text-gray-900 text-sm">{agent?.name}</p>
                  <p className="text-xs text-gray-500 flex items-center gap-1"><MapPin size={10} />{agent?.city}</p>
                  <p className="text-xs text-gray-400">{agent?.vehicle} · {agent?.vehicleNumber}</p>
                </div>
                <div className="flex flex-col items-end gap-1">
                  <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${statusColors?.[agent?.status as keyof typeof statusColors] || 'bg-gray-100 text-gray-700'}`}>
                    {agent?.status?.replace('_', ' ')}
                  </span>
                  {agent.approvalStatus === 'pending' && (
                    <span className="text-xs font-bold px-2 py-0.5 rounded-full bg-yellow-100 text-yellow-700">Pending</span>
                  )}
                </div>
              </div>

              {/* Doc status */}
              <div className="bg-gray-50 rounded-xl p-2 mb-3">
                <div className="flex items-center justify-between mb-1">
                  <span className="text-xs font-bold text-gray-600">Documents</span>
                  <span className={`text-xs font-bold ${docsSubmitted === docLabels.length ? 'text-green-600' : 'text-yellow-600'}`}>{docsSubmitted}/{docLabels.length}</span>
                </div>
                <div className="flex gap-1">
                  {docLabels.map(d => (
                    <div key={d.key} title={d.label}
                      className={`w-5 h-5 rounded text-xs flex items-center justify-center ${docs[d.key as keyof typeof docs] ? 'bg-green-100 text-green-700' : 'bg-red-50 text-red-400'}`}>
                      {docs[d.key as keyof typeof docs] ? '✓' : '✗'}
                    </div>
                  ))}
                </div>
              </div>

              <div className="grid grid-cols-4 gap-2 mb-3">
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-gray-900">{agent?.todayPickups}</p>
                  <p className="text-xs text-gray-500">Pickups</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-gray-900">{agent?.todayDeliveries}</p>
                  <p className="text-xs text-gray-500">Deliveries</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-gray-900">{agent?.totalDeliveries}</p>
                  <p className="text-xs text-gray-500">Total</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-yellow-600 flex items-center justify-center gap-0.5"><Star size={10} />{agent?.rating || 'N/A'}</p>
                  <p className="text-xs text-gray-500">Rating</p>
                </div>
              </div>

              <div className="flex items-center justify-between text-xs text-gray-500 mb-3">
                <span>Today: ₹{agent?.earnings?.toLocaleString('en-IN')}</span>
                <span>PINs: {agent?.pinCodes?.slice(0, 2)?.join(', ')}</span>
              </div>

              <div className="flex gap-2">
                <button onClick={() => setCallModal(agent)}
                  className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50 hover:border-green-300 hover:text-green-700 transition-colors">
                  <Phone size={12} /> Call
                </button>
                <button onClick={() => setDocModal(agent)}
                  className="flex items-center justify-center gap-1.5 py-2 px-3 rounded-xl border border-blue-200 bg-blue-50 text-xs font-semibold text-blue-700 hover:bg-blue-100">
                  <FileText size={12} />
                </button>
                {agent.approvalStatus === 'pending' ? (
                  <button onClick={() => handleApprove(agent.id)}
                    className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-green-500 text-white text-xs font-semibold hover:bg-green-600">
                    <Shield size={12} /> Approve
                  </button>
                ) : (
                  <button onClick={() => setAssignModal(agent)}
                    className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-primary/10 text-primary text-xs font-semibold hover:bg-primary/20">
                    <Package size={12} /> Assign Task
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {/* Call Modal */}
      {callModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setCallModal(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6 z-10 text-center">
            <div className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-4">
              <Phone size={28} className="text-green-600" />
            </div>
            <h3 className="text-lg font-black text-gray-900 mb-1">Call Agent</h3>
            <p className="text-gray-500 text-sm mb-4">{callModal.name}</p>
            <a href={`tel:${callModal.phone}`}
              className="block w-full py-3 bg-green-500 text-white rounded-xl font-bold text-lg hover:bg-green-600 mb-3">
              📞 {callModal.phone}
            </a>
            <button onClick={() => setCallModal(null)} className="w-full py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600">Cancel</button>
          </div>
        </div>
      )}

      {/* Toast Notification */}
      {assignSuccess && (
        <div className="fixed bottom-6 right-6 z-50 bg-gray-900 text-white px-4 py-3 rounded-2xl shadow-2xl flex items-center gap-3 text-xs font-bold border border-gray-700 animate-in fade-in">
          <CheckCircle size={16} className="text-green-400 flex-shrink-0" />
          <span>{assignSuccess}</span>
        </div>
      )}

      {/* Assign Task Modal */}
      {assignModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setAssignModal(null)} />
          <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-lg p-6 sm:p-7 z-10 border border-gray-100 animate-in fade-in zoom-in-95">
            <div className="flex items-center justify-between pb-3 border-b border-gray-100 mb-4">
              <div>
                <span className="text-[11px] font-black text-blue-600 uppercase tracking-wider flex items-center gap-1">
                  <Truck size={13} /> Dispatch Executive Task
                </span>
                <h3 className="text-lg font-black text-gray-900">Assign Order Pickup</h3>
              </div>
              <button onClick={() => setAssignModal(null)}><X size={18} className="text-gray-400 hover:text-gray-600" /></button>
            </div>

            <div className="flex items-center gap-3 p-3.5 bg-blue-50/70 border border-blue-100 rounded-2xl mb-4">
              <img src={assignModal.avatar} alt={assignModal.name} className="w-11 h-11 rounded-2xl object-cover border border-blue-200" />
              <div>
                <p className="font-bold text-gray-900 text-sm">{assignModal.name}</p>
                <p className="text-xs text-gray-600">{assignModal.city} · {assignModal.vehicle} ({assignModal.vehicleNumber}) · 📞 {assignModal.phone}</p>
              </div>
              <span className={`ml-auto text-xs font-bold px-2 py-0.5 rounded-full ${statusColors[assignModal.status as keyof typeof statusColors] || 'bg-gray-100 text-gray-700'}`}>{assignModal.status.replace('_', ' ')}</span>
            </div>

            <div className="space-y-3.5">
              <div>
                <label className="text-xs font-bold text-gray-700 mb-1.5 block">Select Live Order to Assign:</label>
                <select
                  value={selectedOrderId}
                  onChange={e => setSelectedOrderId(e.target.value)}
                  className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-xs font-bold focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white"
                >
                  <option value="">-- Choose an order from store ({ordersList.length} total) --</option>
                  {ordersList.map(o => (
                    <option key={o.id} value={o.id}>
                      {o.orderNumber} — {o.deviceName} ({o.customerName}, {o.city} · ₹{o.quotedPrice.toLocaleString('en-IN')}) [{o.status}]
                    </option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Scheduled Date</label>
                  <input
                    type="date"
                    value={scheduledDate}
                    onChange={e => setScheduledDate(e.target.value)}
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-primary/20"
                  />
                </div>
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Pickup Window</label>
                  <select
                    value={scheduledSlot}
                    onChange={e => setScheduledSlot(e.target.value)}
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white"
                  >
                    <option value="10:00 AM - 1:00 PM">10:00 AM - 1:00 PM</option>
                    <option value="1:00 PM - 4:00 PM">1:00 PM - 4:00 PM</option>
                    <option value="4:00 PM - 7:00 PM">4:00 PM - 7:00 PM</option>
                    <option value="7:00 PM - 9:00 PM">7:00 PM - 9:00 PM</option>
                  </select>
                </div>
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                type="button"
                onClick={() => setAssignModal(null)}
                className="flex-1 py-3 rounded-2xl border border-gray-200 text-xs font-bold text-gray-600 hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={async () => {
                  if (!selectedOrderId || !assignModal) return;
                  const targetOrder = ordersList.find(o => o.id === selectedOrderId || o.orderNumber === selectedOrderId);
                  if (!targetOrder) return;

                  const updatedOrder: Order = {
                    ...targetOrder,
                    deliveryAgentId: assignModal.id,
                    deliveryAgentName: assignModal.name,
                    deliveryAgentPhone: assignModal.phone,
                    status: 'pickup_scheduled',
                    pickupDate: scheduledDate || targetOrder.pickupDate || 'Today',
                    pickupSlot: scheduledSlot || targetOrder.pickupSlot || '10:00 AM - 1:00 PM',
                    updatedAt: new Date().toISOString(),
                  };

                  const updated = ordersList.map(o => o.id === targetOrder.id ? updatedOrder : o);
                  setOrdersList(updated);

                  if (typeof window !== 'undefined') {
                    localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
                    try {
                      const pOrders = localStorage.getItem('casmik_partner_orders_v1');
                      if (pOrders) {
                        const list = JSON.parse(pOrders);
                        if (Array.isArray(list)) {
                          const upP = list.map((o: Order) => o.id === targetOrder.id ? updatedOrder : o);
                          localStorage.setItem('casmik_partner_orders_v1', JSON.stringify(upP));
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
                        orderId: targetOrder.id,
                        deliveryAgentId: assignModal.id,
                        deliveryAgentName: assignModal.name,
                        deliveryAgentPhone: assignModal.phone,
                        status: 'pickup_scheduled',
                        pickupDate: updatedOrder.pickupDate,
                        pickupSlot: updatedOrder.pickupSlot,
                      }),
                    });
                  } catch {}

                  triggerNotification({
                    type: 'status_update',
                    targetRole: 'all',
                    title: `Order #${targetOrder.orderNumber} Assigned to ${assignModal.name}`,
                    shortDetails: `Admin assigned Order #${targetOrder.orderNumber} (${targetOrder.deviceName}) to delivery executive ${assignModal.name} (${assignModal.phone}).`,
                    orderNumber: targetOrder.orderNumber,
                    deviceName: targetOrder.deviceName,
                    customerName: targetOrder.customerName,
                    price: targetOrder.quotedPrice,
                    status: 'pickup_scheduled',
                  });

                  setAssignSuccess(`Order #${targetOrder.orderNumber} assigned to ${assignModal.name}!`);
                  setTimeout(() => setAssignSuccess(null), 4000);
                  setAssignModal(null);
                  setSelectedOrderId('');
                }}
                disabled={!selectedOrderId}
                className="flex-1 py-3 rounded-2xl bg-primary text-white text-xs font-black hover:bg-primary/90 disabled:opacity-50 transition-all shadow-md shadow-primary/20 flex items-center justify-center gap-1.5"
              >
                <Truck size={14} /> Assign Task
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Document Verification Modal */}
      {docModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setDocModal(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-lg p-6 z-10">
            <div className="flex items-center justify-between mb-5">
              <div>
                <h3 className="text-lg font-black text-gray-900">Document Verification</h3>
                <p className="text-sm text-gray-500">{docModal.name} · {docModal.city}</p>
              </div>
              <button onClick={() => setDocModal(null)} className="p-2 rounded-xl hover:bg-gray-100"><X size={18} /></button>
            </div>
            <div className="space-y-3 mb-5">
              {docLabels.map(doc => {
                const docs = agentDocs[docModal.id as keyof typeof agentDocs] || {};
                const submitted = docs[doc.key as keyof typeof docs];
                return (
                  <div key={doc.key} className={`flex items-center justify-between p-3 rounded-xl border ${submitted ? 'border-green-100 bg-green-50' : 'border-red-100 bg-red-50'}`}>
                    <div className="flex items-center gap-3">
                      <span className="text-xl">{doc.icon}</span>
                      <div>
                        <p className="text-sm font-bold text-gray-900">{doc.label}</p>
                        <p className="text-xs text-gray-500">{submitted ? 'Document submitted' : 'Not submitted yet'}</p>
                      </div>
                    </div>
                    {submitted ? (
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-bold text-green-700 bg-green-100 px-2 py-1 rounded-lg flex items-center gap-1"><CheckCircle size={11} /> Submitted</span>
                        <button className="text-xs text-blue-600 font-bold hover:underline">View</button>
                      </div>
                    ) : (
                      <span className="text-xs font-bold text-red-600 bg-red-100 px-2 py-1 rounded-lg flex items-center gap-1"><Clock size={11} /> Pending</span>
                    )}
                  </div>
                );
              })}
            </div>
            <div className="flex gap-3">
              {docModal.approvalStatus === 'pending' && (
                <>
                  <button onClick={() => { handleReject(docModal.id); setDocModal(null); }}
                    className="flex-1 py-2.5 rounded-xl bg-red-50 text-red-600 text-sm font-bold hover:bg-red-100 flex items-center justify-center gap-2">
                    <XCircle size={14} /> Reject
                  </button>
                  <button onClick={() => { handleApprove(docModal.id); setDocModal(null); }}
                    className="flex-1 py-2.5 rounded-xl bg-green-500 text-white text-sm font-bold hover:bg-green-600 flex items-center justify-center gap-2">
                    <Shield size={14} /> Verify & Approve
                  </button>
                </>
              )}
              {docModal.approvalStatus !== 'pending' && (
                <button onClick={() => setDocModal(null)} className="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600">Close</button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

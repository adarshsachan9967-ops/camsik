'use client';
import React, { useState } from 'react';
import { partners } from '@/lib/casmikData';
import { Search, Eye, CheckCircle, XCircle, Star, FileText, Shield, Clock, AlertTriangle } from 'lucide-react';

// Extended partner data with documents and approval status
const partnerDocs = {
  'partner-001': { aadhar: true, pan: true, gst: true, shopLicense: true, bankProof: true },
  'partner-002': { aadhar: true, pan: true, gst: true, shopLicense: false, bankProof: true },
  'partner-003': { aadhar: true, pan: true, gst: false, shopLicense: true, bankProof: true },
  'partner-004': { aadhar: true, pan: true, gst: true, shopLicense: true, bankProof: true },
  'partner-005': { aadhar: true, pan: false, gst: false, shopLicense: false, bankProof: false },
};

const docLabels = [
  { key: 'aadhar', label: 'Aadhar Card', icon: '🪪' },
  { key: 'pan', label: 'PAN Card', icon: '📋' },
  { key: 'gst', label: 'GST Certificate', icon: '📄' },
  { key: 'shopLicense', label: 'Shop License', icon: '🏪' },
  { key: 'bankProof', label: 'Bank Proof', icon: '🏦' },
];

const getInitialPartners = (): typeof partners => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_partners_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch {}
  }
  return partners;
};

export default function AdminPartners() {
  const [partnerList, setPartnerList] = useState(getInitialPartners);
  const [query, setQuery] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [selected, setSelected] = useState<typeof partners[0] | null>(null);
  const [docModal, setDocModal] = useState<typeof partners[0] | null>(null);
  const [activeTab, setActiveTab] = useState<'all' | 'pending' | 'unapproved'>('all');

  const filtered = partnerList.filter(p =>
    (p.storeName.toLowerCase().includes(query.toLowerCase()) || p.city.toLowerCase().includes(query.toLowerCase())) &&
    (filterStatus === 'all' || p.status === filterStatus) &&
    (activeTab === 'all' || (activeTab === 'pending' && p.status === 'pending') || (activeTab === 'unapproved' && (p.status === 'pending' || p.status === 'suspended')))
  );

  const handleApprove = (id: string) => {
    setPartnerList(prev => {
      const updated = prev.map(p => p.id === id ? { ...p, status: 'active' as const } : p);
      if (typeof window !== 'undefined') localStorage.setItem('casmik_partners_v1', JSON.stringify(updated));
      return updated;
    });
  };

  const handleSuspend = (id: string) => {
    setPartnerList(prev => {
      const updated = prev.map(p => p.id === id ? { ...p, status: 'suspended' as const } : p);
      if (typeof window !== 'undefined') localStorage.setItem('casmik_partners_v1', JSON.stringify(updated));
      return updated;
    });
  };

  const handleReject = (id: string) => {
    setPartnerList(prev => {
      const updated = prev.map(p => p.id === id ? { ...p, status: 'suspended' as const } : p);
      if (typeof window !== 'undefined') localStorage.setItem('casmik_partners_v1', JSON.stringify(updated));
      return updated;
    });
  };

  const pendingCount = partnerList.filter(p => p.status === 'pending').length;

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black text-gray-900">Partner Management</h2>
          <p className="text-sm text-gray-500">{partnerList.length} partners · {partnerList.filter(p => p.status === 'active').length} active</p>
        </div>
        {pendingCount > 0 && (
          <div className="flex items-center gap-2 px-3 py-2 bg-yellow-50 border border-yellow-200 rounded-xl">
            <AlertTriangle size={15} className="text-yellow-600" />
            <span className="text-xs font-bold text-yellow-700">{pendingCount} pending approval</span>
          </div>
        )}
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: 'Active Partners', value: partnerList.filter(p => p.status === 'active').length, color: 'text-green-600', bg: 'bg-green-50' },
          { label: 'Pending Approval', value: partnerList.filter(p => p.status === 'pending').length, color: 'text-yellow-600', bg: 'bg-yellow-50' },
          { label: 'Total Orders', value: partnerList.reduce((s, p) => s + p.totalOrders, 0), color: 'text-blue-600', bg: 'bg-blue-50' },
          { label: 'Total Payouts', value: `₹${(partnerList.reduce((s, p) => s + p.totalEarnings, 0) / 100000).toFixed(1)}L`, color: 'text-purple-600', bg: 'bg-purple-50' },
        ].map(s => (
          <div key={s.label} className={`${s.bg} rounded-2xl p-4 border border-white`}>
            <p className={`text-2xl font-black ${s.color}`}>{s.value}</p>
            <p className="text-xs text-gray-600 mt-0.5">{s.label}</p>
          </div>
        ))}
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit">
        {[
          { key: 'all', label: 'All Partners' },
          { key: 'pending', label: `Pending (${pendingCount})` },
          { key: 'unapproved', label: 'Unapproved' },
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
          <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Search partners..."
            className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white" />
        </div>
        <select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}
          className="px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none bg-white">
          <option value="all">All Status</option>
          <option value="active">Active</option>
          <option value="pending">Pending</option>
          <option value="suspended">Suspended</option>
        </select>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {filtered.map((partner) => {
          const docs = partnerDocs[partner.id as keyof typeof partnerDocs] || {};
          const docsSubmitted = Object.values(docs).filter(Boolean).length;
          const totalDocs = docLabels.length;
          return (
            <div key={partner.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 hover:shadow-md transition-shadow">
              <div className="flex items-start gap-3 mb-3">
                <img src={partner.avatar} alt={partner.name} className="w-12 h-12 rounded-xl object-cover flex-shrink-0" />
                <div className="flex-1 min-w-0">
                  <p className="font-bold text-gray-900 text-sm truncate">{partner.storeName}</p>
                  <p className="text-xs text-gray-500">{partner.name}</p>
                  <p className="text-xs text-gray-400">{partner.city}, {partner.state}</p>
                </div>
                <span className={`text-xs font-bold px-2 py-0.5 rounded-full flex-shrink-0 ${
                  partner.status === 'active' ? 'bg-green-100 text-green-700' :
                  partner.status === 'pending' ? 'bg-yellow-100 text-yellow-700' :
                  partner.status === 'suspended' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-600'
                }`}>{partner.status}</span>
              </div>

              {/* Document Status */}
              <div className="bg-gray-50 rounded-xl p-2.5 mb-3">
                <div className="flex items-center justify-between mb-1.5">
                  <span className="text-xs font-bold text-gray-600">Documents</span>
                  <span className={`text-xs font-bold ${docsSubmitted === totalDocs ? 'text-green-600' : 'text-yellow-600'}`}>{docsSubmitted}/{totalDocs}</span>
                </div>
                <div className="flex gap-1">
                  {docLabels.map(d => (
                    <div key={d.key} title={d.label}
                      className={`w-6 h-6 rounded-lg flex items-center justify-center text-xs ${docs[d.key as keyof typeof docs] ? 'bg-green-100 text-green-700' : 'bg-red-50 text-red-400'}`}>
                      {docs[d.key as keyof typeof docs] ? '✓' : '✗'}
                    </div>
                  ))}
                </div>
              </div>

              <div className="grid grid-cols-3 gap-2 mb-3">
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-gray-900">{partner.totalOrders}</p>
                  <p className="text-xs text-gray-500">Orders</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-green-700">₹{(partner.totalEarnings / 1000).toFixed(0)}K</p>
                  <p className="text-xs text-gray-500">Earnings</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-yellow-600 flex items-center justify-center gap-0.5"><Star size={11} />{partner.rating || 'N/A'}</p>
                  <p className="text-xs text-gray-500">Rating</p>
                </div>
              </div>

              <div className="flex gap-2">
                <button onClick={() => setSelected(partner)} className="flex items-center justify-center gap-1.5 py-2 px-3 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
                  <Eye size={12} /> View
                </button>
                <button onClick={() => setDocModal(partner)} className="flex items-center justify-center gap-1.5 py-2 px-3 rounded-xl border border-blue-200 bg-blue-50 text-xs font-semibold text-blue-700 hover:bg-blue-100">
                  <FileText size={12} /> Docs
                </button>
                {partner.status === 'pending' && (
                  <button onClick={() => handleApprove(partner.id)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-green-500 text-white text-xs font-semibold hover:bg-green-600">
                    <CheckCircle size={12} /> Approve
                  </button>
                )}
                {partner.status === 'active' && (
                  <button onClick={() => handleSuspend(partner.id)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-red-50 text-red-600 text-xs font-semibold hover:bg-red-100">
                    <XCircle size={12} /> Suspend
                  </button>
                )}
                {partner.status === 'suspended' && (
                  <button onClick={() => handleApprove(partner.id)} className="flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl bg-green-50 text-green-600 text-xs font-semibold hover:bg-green-100">
                    <CheckCircle size={12} /> Reactivate
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {/* Partner Detail Modal */}
      {selected && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setSelected(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 z-10 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center gap-4 mb-5">
              <img src={selected.avatar} alt={selected.name} className="w-16 h-16 rounded-2xl object-cover" />
              <div>
                <h3 className="text-lg font-black text-gray-900">{selected.storeName}</h3>
                <p className="text-sm text-gray-500">{selected.name} · {selected.phone}</p>
                <p className="text-xs text-gray-400">{selected.email}</p>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-3 mb-4">
              {[
                { label: 'Total Orders', value: selected.totalOrders },
                { label: 'Completed', value: selected.completedOrders },
                { label: 'Total Earnings', value: `₹${(selected.totalEarnings / 1000).toFixed(0)}K` },
                { label: 'Pending Payout', value: `₹${(selected.pendingPayout / 1000).toFixed(1)}K` },
                { label: 'Available Balance', value: `₹${(selected.availableBalance / 1000).toFixed(0)}K` },
                { label: 'Commission', value: `${selected.commission}%` },
              ].map(item => (
                <div key={item.label} className="bg-gray-50 rounded-xl p-3">
                  <p className="text-xs text-gray-500">{item.label}</p>
                  <p className="text-sm font-black text-gray-900">{item.value}</p>
                </div>
              ))}
            </div>
            <div className="bg-gray-50 rounded-xl p-3 mb-4">
              <p className="text-xs font-bold text-gray-500 mb-1">Service PIN Codes</p>
              <div className="flex flex-wrap gap-1.5">
                {selected.pinCodes.map(pin => (
                  <span key={pin} className="text-xs font-bold px-2 py-0.5 bg-primary/10 text-primary rounded-lg">{pin}</span>
                ))}
              </div>
            </div>
            <div className="flex gap-2 mt-4">
              {selected.status === 'pending' && (
                <button onClick={() => { handleApprove(selected.id); setSelected(null); }} className="flex-1 py-2.5 rounded-xl bg-green-500 text-white text-sm font-bold hover:bg-green-600 flex items-center justify-center gap-2">
                  <Shield size={14} /> Verify & Approve
                </button>
              )}
              <button onClick={() => setSelected(null)} className="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">Close</button>
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
                <p className="text-sm text-gray-500">{docModal.storeName} · {docModal.name}</p>
              </div>
              <button onClick={() => setDocModal(null)} className="p-2 rounded-xl hover:bg-gray-100">✕</button>
            </div>

            <div className="space-y-3 mb-5">
              {docLabels.map(doc => {
                const docs = partnerDocs[docModal.id as keyof typeof partnerDocs] || {};
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
                    <div className="flex items-center gap-2">
                      {submitted ? (
                        <>
                          <span className="text-xs font-bold text-green-700 bg-green-100 px-2 py-1 rounded-lg flex items-center gap-1"><CheckCircle size={11} /> Submitted</span>
                          <button className="text-xs text-blue-600 font-bold hover:underline">View</button>
                        </>
                      ) : (
                        <span className="text-xs font-bold text-red-600 bg-red-100 px-2 py-1 rounded-lg flex items-center gap-1"><Clock size={11} /> Pending</span>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>

            <div className="bg-yellow-50 rounded-xl p-3 mb-5 border border-yellow-100">
              <p className="text-xs font-bold text-yellow-800 mb-1">⚠️ Verification Note</p>
              <p className="text-xs text-yellow-700">Once you verify and approve this partner, they will be able to log in with their registered credentials and start accepting orders.</p>
            </div>

            <div className="flex gap-3">
              {docModal.status === 'pending' && (
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
              {docModal.status !== 'pending' && (
                <button onClick={() => setDocModal(null)} className="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600">Close</button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

'use client';
import React, { useState } from 'react';
import { partners, Partner } from '@/lib/casmikData';
import { Search, Eye, CheckCircle, XCircle, Star, FileText, Shield, Clock, AlertTriangle, Plus, Edit2, Key, Percent, DollarSign, Building, Phone, Mail, MapPin, Check, EyeOff } from 'lucide-react';

const docLabels = [
  { key: 'aadhar', label: 'Aadhaar Card', icon: '🪪' },
  { key: 'pan', label: 'PAN Card', icon: '📋' },
  { key: 'gst', label: 'GST Certificate', icon: '📄' },
  { key: 'shopLicense', label: 'Shop License', icon: '🏪' },
  { key: 'bankProof', label: 'Bank Proof', icon: '🏦' },
];

const getInitialPartners = (): Partner[] => {
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
  const [partnerList, setPartnerList] = useState<Partner[]>(getInitialPartners);
  const [query, setQuery] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [selected, setSelected] = useState<Partner | null>(null);
  const [docModal, setDocModal] = useState<Partner | null>(null);
  const [activeTab, setActiveTab] = useState<'all' | 'pending' | 'unapproved'>('all');

  // Add / Edit Modal state
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingPartner, setEditingPartner] = useState<Partner | null>(null);
  const [showPassword, setShowPassword] = useState(false);

  // Form Fields
  const [formStoreName, setFormStoreName] = useState('');
  const [formName, setFormName] = useState('');
  const [formPhone, setFormPhone] = useState('');
  const [formEmail, setFormEmail] = useState('');
  const [formPassword, setFormPassword] = useState('');
  const [formCity, setFormCity] = useState('');
  const [formState, setFormState] = useState('');
  const [formPinCodes, setFormPinCodes] = useState('');
  const [formCommission, setFormCommission] = useState('5.0');
  const [formCommissionType, setFormCommissionType] = useState<'percentage' | 'fixed'>('percentage');
  const [formStatus, setFormStatus] = useState<'active' | 'pending' | 'suspended'>('active');

  // Document Fields
  const [formAadhar, setFormAadhar] = useState(true);
  const [formAadharNo, setFormAadharNo] = useState('');
  const [formPan, setFormPan] = useState(true);
  const [formPanNo, setFormPanNo] = useState('');
  const [formGst, setFormGst] = useState(true);
  const [formGstNo, setFormGstNo] = useState('');
  const [formShopLicense, setFormShopLicense] = useState(true);
  const [formBankProof, setFormBankProof] = useState(true);
  const [formAccountNo, setFormAccountNo] = useState('');
  const [formIfsc, setFormIfsc] = useState('');

  const filtered = partnerList.filter(p =>
    (p.storeName.toLowerCase().includes(query.toLowerCase()) || p.city.toLowerCase().includes(query.toLowerCase()) || p.name.toLowerCase().includes(query.toLowerCase())) &&
    (filterStatus === 'all' || p.status === filterStatus) &&
    (activeTab === 'all' || (activeTab === 'pending' && p.status === 'pending') || (activeTab === 'unapproved' && (p.status === 'pending' || p.status === 'suspended')))
  );

  const savePartnersToStorage = (updated: Partner[]) => {
    setPartnerList(updated);
    if (typeof window !== 'undefined') {
      localStorage.setItem('casmik_partners_v1', JSON.stringify(updated));
      window.dispatchEvent(new Event('casmik_partners_updated'));
      window.dispatchEvent(new Event('storage'));
    }
  };

  const handleApprove = (id: string) => {
    const updated = partnerList.map(p => p.id === id ? { ...p, status: 'active' as const } : p);
    savePartnersToStorage(updated);
  };

  const handleSuspend = (id: string) => {
    const updated = partnerList.map(p => p.id === id ? { ...p, status: 'suspended' as const } : p);
    savePartnersToStorage(updated);
  };

  const handleReject = (id: string) => {
    const updated = partnerList.map(p => p.id === id ? { ...p, status: 'suspended' as const } : p);
    savePartnersToStorage(updated);
  };

  const openAddModal = () => {
    setEditingPartner(null);
    setFormStoreName('');
    setFormName('');
    setFormPhone('');
    setFormEmail('');
    setFormPassword(`Partner@${Math.floor(1000 + Math.random() * 9000)}`);
    setFormCity('Delhi NCR');
    setFormState('Delhi');
    setFormPinCodes('110001, 110016, 110070');
    setFormCommission('5.0');
    setFormCommissionType('percentage');
    setFormStatus('active');
    setFormAadhar(true);
    setFormAadharNo('XXXX-XXXX-4812');
    setFormPan(true);
    setFormPanNo('ABCDE1234F');
    setFormGst(true);
    setFormGstNo('07AAAAA0000A1Z5');
    setFormShopLicense(true);
    setFormBankProof(true);
    setFormAccountNo('987654321098');
    setFormIfsc('HDFC0001234');
    setShowPassword(false);
    setIsFormOpen(true);
  };

  const openEditModal = (partner: Partner) => {
    setEditingPartner(partner);
    setFormStoreName(partner.storeName);
    setFormName(partner.name);
    setFormPhone(partner.phone);
    setFormEmail(partner.email);
    setFormPassword(partner.password || 'Partner@2024');
    setFormCity(partner.city);
    setFormState(partner.state);
    setFormPinCodes(partner.pinCodes?.join(', ') || '');
    setFormCommission(partner.commission?.toString() || '5.0');
    setFormCommissionType(partner.commissionType || 'percentage');
    setFormStatus(partner.status as any);
    setFormAadhar(partner.documents?.aadhar ?? true);
    setFormAadharNo(partner.documents?.aadharNumber || '');
    setFormPan(partner.documents?.pan ?? true);
    setFormPanNo(partner.documents?.panNumber || '');
    setFormGst(partner.documents?.gst ?? true);
    setFormGstNo(partner.documents?.gstNumber || '');
    setFormShopLicense(partner.documents?.shopLicense ?? true);
    setFormBankProof(partner.documents?.bankProof ?? true);
    setFormAccountNo(partner.documents?.accountNumber || '');
    setFormIfsc(partner.documents?.ifscCode || '');
    setShowPassword(false);
    setIsFormOpen(true);
  };

  const handleSavePartner = (e: React.FormEvent) => {
    e.preventDefault();
    const pinArray = formPinCodes.split(',').map(s => s.trim()).filter(Boolean);
    const commVal = parseFloat(formCommission) || 5.0;

    const docPayload = {
      aadhar: formAadhar,
      aadharNumber: formAadharNo,
      pan: formPan,
      panNumber: formPanNo,
      gst: formGst,
      gstNumber: formGstNo,
      shopLicense: formShopLicense,
      bankProof: formBankProof,
      accountNumber: formAccountNo,
      ifscCode: formIfsc,
      verified: formAadhar && formPan && formGst,
    };

    if (editingPartner) {
      // Update existing
      const updated = partnerList.map(p => {
        if (p.id === editingPartner.id) {
          return {
            ...p,
            storeName: formStoreName,
            name: formName,
            phone: formPhone,
            email: formEmail,
            password: formPassword,
            city: formCity,
            state: formState,
            pinCodes: pinArray.length > 0 ? pinArray : p.pinCodes,
            commission: commVal,
            commissionType: formCommissionType,
            status: formStatus,
            documents: docPayload,
          };
        }
        return p;
      });
      savePartnersToStorage(updated);
    } else {
      // Create new partner
      const newPartner: Partner = {
        id: `partner-${Date.now()}`,
        name: formName,
        storeName: formStoreName,
        phone: formPhone,
        email: formEmail,
        password: formPassword,
        city: formCity,
        state: formState,
        pinCodes: pinArray.length > 0 ? pinArray : ['110001'],
        categories: ['cat-dslr', 'cat-lens', 'cat-mirrorless'],
        status: formStatus,
        rating: 5.0,
        totalOrders: 0,
        completedOrders: 0,
        totalEarnings: 0,
        pendingPayout: 0,
        availableBalance: 10000,
        joinedAt: new Date().toISOString().split('T')[0],
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
        commission: commVal,
        commissionType: formCommissionType,
        documents: docPayload,
      };
      savePartnersToStorage([newPartner, ...partnerList]);
    }

    setIsFormOpen(false);
  };

  const pendingCount = partnerList.filter(p => p.status === 'pending').length;

  return (
    <div className="space-y-5">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-black text-gray-900">Partner Management</h2>
          <p className="text-sm text-gray-500">{partnerList.length} partners · {partnerList.filter(p => p.status === 'active').length} active</p>
        </div>
        <div className="flex items-center gap-2">
          {pendingCount > 0 && (
            <div className="flex items-center gap-2 px-3 py-2 bg-yellow-50 border border-yellow-200 rounded-xl">
              <AlertTriangle size={15} className="text-yellow-600" />
              <span className="text-xs font-bold text-yellow-700">{pendingCount} pending</span>
            </div>
          )}
          <button
            onClick={openAddModal}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-primary text-white text-sm font-bold shadow-md hover:bg-primary/90 transition-all"
          >
            <Plus size={16} />
            <span>Add New Partner</span>
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: 'Active Partners', value: partnerList.filter(p => p.status === 'active').length, color: 'text-green-600', bg: 'bg-green-50' },
          { label: 'Pending Approval', value: partnerList.filter(p => p.status === 'pending').length, color: 'text-yellow-600', bg: 'bg-yellow-50' },
          { label: 'Total Orders', value: partnerList.reduce((s, p) => s + (p.totalOrders || 0), 0), color: 'text-blue-600', bg: 'bg-blue-50' },
          { label: 'Total Payouts', value: `₹${((partnerList.reduce((s, p) => s + (p.totalEarnings || 0), 0)) / 100000).toFixed(1)}L`, color: 'text-purple-600', bg: 'bg-purple-50' },
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
          <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Search partners by name, store, city..."
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

      {/* Partner Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {filtered.map((partner) => {
          const docs = partner.documents || { aadhar: true, pan: true, gst: true, shopLicense: true, bankProof: true };
          const docsSubmitted = [docs.aadhar, docs.pan, docs.gst, docs.shopLicense, docs.bankProof].filter(Boolean).length;
          const totalDocs = docLabels.length;
          const commissionLabel = partner.commissionType === 'fixed' ? `₹${partner.commission}/order` : `${partner.commission}%`;

          return (
            <div key={partner.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 hover:shadow-md transition-shadow relative">
              <div className="flex items-start gap-3 mb-3">
                <img src={partner.avatar || 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80'} alt={partner.name} className="w-12 h-12 rounded-xl object-cover flex-shrink-0" />
                <div className="flex-1 min-w-0">
                  <p className="font-bold text-gray-900 text-sm truncate">{partner.storeName}</p>
                  <p className="text-xs text-gray-500">{partner.name} · {partner.phone}</p>
                  <p className="text-xs text-gray-400">{partner.city}, {partner.state}</p>
                </div>
                <span className={`text-xs font-bold px-2 py-0.5 rounded-full flex-shrink-0 ${
                  partner.status === 'active' ? 'bg-green-100 text-green-700' :
                  partner.status === 'pending' ? 'bg-yellow-100 text-yellow-700' :
                  partner.status === 'suspended' ? 'bg-red-100 text-red-700' : 'bg-gray-100 text-gray-600'
                }`}>{partner.status}</span>
              </div>

              {/* Commission Badge & Login Info */}
              <div className="flex items-center justify-between bg-primary/5 border border-primary/15 rounded-xl px-3 py-2 mb-3">
                <div className="flex items-center gap-1.5">
                  <Percent size={13} className="text-primary" />
                  <span className="text-xs font-bold text-gray-700">Commission:</span>
                  <span className="text-xs font-extrabold text-primary">{commissionLabel}</span>
                </div>
                <div className="flex items-center gap-1 text-[11px] text-gray-500">
                  <Key size={11} className="text-gray-400" />
                  <span className="font-mono text-gray-600">{partner.password ? '••••••••' : 'Set'}</span>
                </div>
              </div>

              {/* Document Status */}
              <div className="bg-gray-50 rounded-xl p-2.5 mb-3">
                <div className="flex items-center justify-between mb-1.5">
                  <span className="text-xs font-bold text-gray-600">KYC Documents</span>
                  <span className={`text-xs font-bold ${docsSubmitted === totalDocs ? 'text-green-600' : 'text-yellow-600'}`}>{docsSubmitted}/{totalDocs}</span>
                </div>
                <div className="flex gap-1">
                  {docLabels.map(d => {
                    const isOk = docs[d.key as keyof typeof docs];
                    return (
                      <div key={d.key} title={d.label}
                        className={`w-6 h-6 rounded-lg flex items-center justify-center text-xs ${isOk ? 'bg-green-100 text-green-700' : 'bg-red-50 text-red-400'}`}>
                        {isOk ? '✓' : '✗'}
                      </div>
                    );
                  })}
                </div>
              </div>

              <div className="grid grid-cols-3 gap-2 mb-3">
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-gray-900">{partner.totalOrders || 0}</p>
                  <p className="text-xs text-gray-500">Orders</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-green-700">₹{((partner.totalEarnings || 0) / 1000).toFixed(0)}K</p>
                  <p className="text-xs text-gray-500">Earnings</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2 text-center">
                  <p className="text-sm font-black text-yellow-600 flex items-center justify-center gap-0.5"><Star size={11} />{partner.rating || 5.0}</p>
                  <p className="text-xs text-gray-500">Rating</p>
                </div>
              </div>

              <div className="flex flex-wrap gap-2">
                <button onClick={() => setSelected(partner)} className="flex items-center justify-center gap-1 py-2 px-2.5 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
                  <Eye size={12} /> View
                </button>
                <button onClick={() => openEditModal(partner)} className="flex-1 flex items-center justify-center gap-1 py-2 px-2.5 rounded-xl border border-primary/30 bg-primary/5 text-primary text-xs font-bold hover:bg-primary/10">
                  <Edit2 size={12} /> Edit & Commission
                </button>
                <button onClick={() => setDocModal(partner)} className="flex items-center justify-center gap-1 py-2 px-2.5 rounded-xl border border-blue-200 bg-blue-50 text-xs font-semibold text-blue-700 hover:bg-blue-100">
                  <FileText size={12} /> Docs
                </button>
                {partner.status === 'pending' && (
                  <button onClick={() => handleApprove(partner.id)} className="w-full flex items-center justify-center gap-1.5 py-2 rounded-xl bg-green-500 text-white text-xs font-semibold hover:bg-green-600 mt-1">
                    <CheckCircle size={12} /> Approve Partner
                  </button>
                )}
                {partner.status === 'active' && (
                  <button onClick={() => handleSuspend(partner.id)} className="flex items-center justify-center gap-1 py-2 px-2 rounded-xl bg-red-50 text-red-600 text-xs font-semibold hover:bg-red-100">
                    <XCircle size={12} />
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {/* Add / Edit Partner Modal */}
      {isFormOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={() => setIsFormOpen(false)} />
          <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-2xl p-6 z-10 max-h-[92vh] overflow-y-auto">
            <div className="flex items-center justify-between pb-4 border-b border-gray-100 mb-5">
              <div>
                <h3 className="text-lg font-black text-gray-900">
                  {editingPartner ? 'Edit Partner & Set Commission' : 'Add New Partner & Login Credentials'}
                </h3>
                <p className="text-xs text-gray-500">Configure partner store, commission split, login credentials, and documents</p>
              </div>
              <button onClick={() => setIsFormOpen(false)} className="p-2 rounded-xl hover:bg-gray-100 text-gray-400 hover:text-gray-700">✕</button>
            </div>

            <form onSubmit={handleSavePartner} className="space-y-4">
              {/* Basic Store & Contact Info */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-bold text-gray-700 mb-1">Store / Hub Name *</label>
                  <input
                    type="text"
                    required
                    value={formStoreName}
                    onChange={e => setFormStoreName(e.target.value)}
                    placeholder="e.g. Camsik Certified Hub Connaught Place"
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold text-gray-700 mb-1">Owner / Contact Name *</label>
                  <input
                    type="text"
                    required
                    value={formName}
                    onChange={e => setFormName(e.target.value)}
                    placeholder="e.g. Rajesh Kumar"
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
                  />
                </div>
              </div>

              {/* Contact Information */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-bold text-gray-700 mb-1">Phone Number *</label>
                  <input
                    type="tel"
                    required
                    value={formPhone}
                    onChange={e => setFormPhone(e.target.value)}
                    placeholder="98XXXXXXXX"
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold text-gray-700 mb-1">Email Address *</label>
                  <input
                    type="email"
                    required
                    value={formEmail}
                    onChange={e => setFormEmail(e.target.value)}
                    placeholder="partner@store.com"
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
                  />
                </div>
              </div>

              {/* Login Credentials & Security */}
              <div className="p-3.5 bg-slate-50 border border-slate-200/80 rounded-2xl space-y-2">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Key size={15} className="text-primary" />
                    <span className="text-xs font-bold text-gray-800">Partner Login Password</span>
                  </div>
                  <button
                    type="button"
                    onClick={() => setFormPassword(`Camsik@${Math.floor(1000 + Math.random() * 9000)}`)}
                    className="text-[11px] font-bold text-primary hover:underline"
                  >
                    Generate Random
                  </button>
                </div>
                <div className="relative">
                  <input
                    type={showPassword ? 'text' : 'password'}
                    required
                    value={formPassword}
                    onChange={e => setFormPassword(e.target.value)}
                    placeholder="Set partner portal password"
                    className="w-full pl-3 pr-10 py-2 rounded-xl border border-gray-300 text-sm bg-white font-mono focus:outline-none focus:ring-2 focus:ring-primary/30"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                  >
                    {showPassword ? <EyeOff size={15} /> : <Eye size={15} />}
                  </button>
                </div>
                <p className="text-[11px] text-gray-500">The partner can use their email and this password to sign in at <span className="font-semibold text-primary">/partner/login</span></p>
              </div>

              {/* Commission Setting */}
              <div className="p-3.5 bg-emerald-50/70 border border-emerald-200 rounded-2xl space-y-2.5">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Percent size={15} className="text-emerald-700" />
                    <span className="text-xs font-bold text-emerald-900">Set Admin Commission Split</span>
                  </div>
                  <span className="text-[11px] font-semibold text-emerald-700">Commission model</span>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block text-[11px] font-bold text-gray-700 mb-1">Commission Type</label>
                    <select
                      value={formCommissionType}
                      onChange={e => setFormCommissionType(e.target.value as any)}
                      className="w-full px-3 py-2 rounded-xl border border-emerald-300 text-sm bg-white font-semibold focus:outline-none"
                    >
                      <option value="percentage">Percentage (%) per Order</option>
                      <option value="fixed">Fixed Amount (₹) per Order</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-[11px] font-bold text-gray-700 mb-1">
                      {formCommissionType === 'percentage' ? 'Commission Rate (%)' : 'Commission Amount (₹)'}
                    </label>
                    <input
                      type="number"
                      step="0.1"
                      required
                      value={formCommission}
                      onChange={e => setFormCommission(e.target.value)}
                      placeholder={formCommissionType === 'percentage' ? '5.0' : '250'}
                      className="w-full px-3 py-2 rounded-xl border border-emerald-300 text-sm bg-white font-bold text-emerald-800 focus:outline-none focus:ring-2 focus:ring-emerald-400"
                    />
                  </div>
                </div>
                <p className="text-[11px] text-emerald-800">
                  {formCommissionType === 'percentage'
                    ? `Partner retains calculated order amount minus ${formCommission}% admin platform fee.`
                    : `Admin charges a flat ₹${formCommission} platform service fee per completed order.`}
                </p>
              </div>

              {/* Location & Service Areas */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block text-xs font-bold text-gray-700 mb-1">City</label>
                  <input
                    type="text"
                    value={formCity}
                    onChange={e => setFormCity(e.target.value)}
                    placeholder="Delhi NCR"
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold text-gray-700 mb-1">State</label>
                  <input
                    type="text"
                    value={formState}
                    onChange={e => setFormState(e.target.value)}
                    placeholder="Delhi"
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold text-gray-700 mb-1">Account Status</label>
                  <select
                    value={formStatus}
                    onChange={e => setFormStatus(e.target.value as any)}
                    className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none font-semibold"
                  >
                    <option value="active">Active (Verified)</option>
                    <option value="pending">Pending Approval</option>
                    <option value="suspended">Suspended</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-gray-700 mb-1">Service PIN Codes (Comma separated)</label>
                <input
                  type="text"
                  value={formPinCodes}
                  onChange={e => setFormPinCodes(e.target.value)}
                  placeholder="110001, 110016, 110020"
                  className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none"
                />
              </div>

              {/* KYC Documents Profile */}
              <div className="border border-gray-200 rounded-2xl p-3.5 space-y-3">
                <h4 className="text-xs font-extrabold text-gray-800 uppercase tracking-wider flex items-center gap-1.5">
                  <FileText size={14} className="text-primary" />
                  <span>Partner KYC Documents & Verification Profile</span>
                </h4>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                  <div className="p-2.5 rounded-xl border border-gray-100 bg-gray-50 flex flex-col gap-1.5">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-gray-800">🪪 Aadhaar Card</span>
                      <label className="flex items-center gap-1 text-[11px] font-semibold text-green-700 cursor-pointer">
                        <input type="checkbox" checked={formAadhar} onChange={e => setFormAadhar(e.target.checked)} /> Verified
                      </label>
                    </div>
                    <input
                      type="text"
                      value={formAadharNo}
                      onChange={e => setFormAadharNo(e.target.value)}
                      placeholder="12-digit Aadhaar No."
                      className="px-2 py-1 text-xs border border-gray-200 rounded-lg bg-white"
                    />
                  </div>

                  <div className="p-2.5 rounded-xl border border-gray-100 bg-gray-50 flex flex-col gap-1.5">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-gray-800">📋 PAN Card</span>
                      <label className="flex items-center gap-1 text-[11px] font-semibold text-green-700 cursor-pointer">
                        <input type="checkbox" checked={formPan} onChange={e => setFormPan(e.target.checked)} /> Verified
                      </label>
                    </div>
                    <input
                      type="text"
                      value={formPanNo}
                      onChange={e => setFormPanNo(e.target.value)}
                      placeholder="PAN Number"
                      className="px-2 py-1 text-xs border border-gray-200 rounded-lg bg-white uppercase"
                    />
                  </div>

                  <div className="p-2.5 rounded-xl border border-gray-100 bg-gray-50 flex flex-col gap-1.5">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-gray-800">📄 GST Certificate</span>
                      <label className="flex items-center gap-1 text-[11px] font-semibold text-green-700 cursor-pointer">
                        <input type="checkbox" checked={formGst} onChange={e => setFormGst(e.target.checked)} /> Verified
                      </label>
                    </div>
                    <input
                      type="text"
                      value={formGstNo}
                      onChange={e => setFormGstNo(e.target.value)}
                      placeholder="GSTIN Number"
                      className="px-2 py-1 text-xs border border-gray-200 rounded-lg bg-white uppercase"
                    />
                  </div>

                  <div className="p-2.5 rounded-xl border border-gray-100 bg-gray-50 flex flex-col gap-1.5">
                    <div className="flex items-center justify-between">
                      <span className="font-bold text-gray-800">🏪 Shop License / Reg</span>
                      <label className="flex items-center gap-1 text-[11px] font-semibold text-green-700 cursor-pointer">
                        <input type="checkbox" checked={formShopLicense} onChange={e => setFormShopLicense(e.target.checked)} /> Verified
                      </label>
                    </div>
                    <span className="text-[10px] text-gray-400">Trade License Verified</span>
                  </div>
                </div>

                {/* Bank Details */}
                <div className="pt-2 border-t border-gray-100 grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                  <div>
                    <label className="block text-[11px] font-semibold text-gray-600 mb-1">🏦 Bank Account No.</label>
                    <input
                      type="text"
                      value={formAccountNo}
                      onChange={e => setFormAccountNo(e.target.value)}
                      placeholder="e.g. 50100412345678"
                      className="w-full px-2.5 py-1.5 border border-gray-200 rounded-xl bg-white"
                    />
                  </div>
                  <div>
                    <label className="block text-[11px] font-semibold text-gray-600 mb-1">IFSC Code</label>
                    <input
                      type="text"
                      value={formIfsc}
                      onChange={e => setFormIfsc(e.target.value)}
                      placeholder="e.g. HDFC0001234"
                      className="w-full px-2.5 py-1.5 border border-gray-200 rounded-xl bg-white uppercase"
                    />
                  </div>
                </div>
              </div>

              {/* Submit Buttons */}
              <div className="flex gap-3 pt-3">
                <button
                  type="button"
                  onClick={() => setIsFormOpen(false)}
                  className="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2.5 rounded-xl bg-primary text-white text-sm font-bold shadow-md hover:bg-primary/90 transition-all flex items-center justify-center gap-2"
                >
                  <Check size={16} />
                  <span>{editingPartner ? 'Update Partner Profile' : 'Create Partner & Credentials'}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Partner Detail View Modal */}
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
                { label: 'Total Earnings', value: `₹${((selected.totalEarnings || 0) / 1000).toFixed(0)}K` },
                { label: 'Pending Payout', value: `₹${((selected.pendingPayout || 0) / 1000).toFixed(1)}K` },
                { label: 'Available Balance', value: `₹${((selected.availableBalance || 0) / 1000).toFixed(0)}K` },
                { label: 'Admin Commission', value: selected.commissionType === 'fixed' ? `₹${selected.commission}` : `${selected.commission}%` },
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
                {selected.pinCodes?.map(pin => (
                  <span key={pin} className="text-xs font-bold px-2 py-0.5 bg-primary/10 text-primary rounded-lg">{pin}</span>
                ))}
              </div>
            </div>
            <div className="flex gap-2 mt-4">
              <button
                onClick={() => {
                  openEditModal(selected);
                  setSelected(null);
                }}
                className="flex-1 py-2.5 rounded-xl bg-primary text-white text-sm font-bold hover:bg-primary/90 flex items-center justify-center gap-1.5"
              >
                <Edit2 size={14} /> Edit & Commission
              </button>
              <button onClick={() => setSelected(null)} className="py-2.5 px-4 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">Close</button>
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
                const docs = docModal.documents || { aadhar: true, pan: true, gst: true, shopLicense: true, bankProof: true };
                const submitted = docs[doc.key as keyof typeof docs];
                return (
                  <div key={doc.key} className={`flex items-center justify-between p-3 rounded-xl border ${submitted ? 'border-green-100 bg-green-50' : 'border-red-100 bg-red-50'}`}>
                    <div className="flex items-center gap-3">
                      <span className="text-xl">{doc.icon}</span>
                      <div>
                        <p className="text-sm font-bold text-gray-900">{doc.label}</p>
                        <p className="text-xs text-gray-500">{submitted ? 'Document verified & on file' : 'Not submitted yet'}</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      {submitted ? (
                        <span className="text-xs font-bold text-green-700 bg-green-100 px-2 py-1 rounded-lg flex items-center gap-1"><CheckCircle size={11} /> Verified</span>
                      ) : (
                        <span className="text-xs font-bold text-red-600 bg-red-100 px-2 py-1 rounded-lg flex items-center gap-1"><Clock size={11} /> Pending</span>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>

            <div className="bg-yellow-50 rounded-xl p-3 mb-5 border border-yellow-100">
              <p className="text-xs font-bold text-yellow-800 mb-1">⚠️ Verification & Commission Status</p>
              <p className="text-xs text-yellow-700">
                Partner commission is configured at <span className="font-bold text-gray-900">{docModal.commissionType === 'fixed' ? `₹${docModal.commission}` : `${docModal.commission}%`}</span>. Credentials can be managed in Edit.
              </p>
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

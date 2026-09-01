'use client';
import React, { useState, useRef } from 'react';
import { User, Phone, Mail, MapPin, Store, Star, Edit3, Camera, CheckCircle, Shield, FileText, LogOut, Upload, Eye, X, CheckCircle2, CreditCard, Building2 } from 'lucide-react';

interface DocFile {
  name: string;
  url: string;
}

interface DocState {
  status: 'verified' | 'pending' | 'uploaded';
  file?: DocFile;
}

export default function PartnerProfile() {
  const [editing, setEditing] = useState(false);
  const [name, setName] = useState('Rajesh Kumar');
  const [phone, setPhone] = useState('+91 98765 43210');
  const [email, setEmail] = useState('rajesh@mobilehub.in');
  const [address, setAddress] = useState('Shop 12, Sector 18, Noida, UP - 201301');
  const [storeName, setStoreName] = useState('MobileHub Store');
  const [gstNumber, setGstNumber] = useState('07AABCU9603R1ZX');
  const [previewDoc, setPreviewDoc] = useState<{ label: string; url: string } | null>(null);
  const [uploadSuccess, setUploadSuccess] = useState<string | null>(null);

  const [docs, setDocs] = useState<Record<string, DocState>>({
    'Aadhaar Card': { status: 'verified' },
    'PAN Card': { status: 'verified' },
    'GST Certificate': { status: 'pending' },
    'Shop License': { status: 'pending' },
    'Bank Proof': { status: 'uploaded' },
  });

  const fileInputRefs = useRef<Record<string, HTMLInputElement | null>>({});

  const handleFileChange = (label: string, e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const url = URL.createObjectURL(file);
    setDocs(prev => ({
      ...prev,
      [label]: { status: 'uploaded', file: { name: file.name, url } },
    }));
    setUploadSuccess(label);
    setTimeout(() => setUploadSuccess(null), 3000);
  };

  const docList = [
    { label: 'Aadhaar Card', icon: User },
    { label: 'PAN Card', icon: CreditCard },
    { label: 'GST Certificate', icon: FileText },
    { label: 'Shop License', icon: Store },
    { label: 'Bank Proof', icon: Building2 },
  ];

  return (
    <div className="space-y-5 max-w-xl mx-auto">
      {/* Profile Card */}
      <div className="bg-gradient-to-br from-primary to-green-600 rounded-2xl p-6 text-white relative overflow-hidden">
        <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-1/2 translate-x-1/2" />
        <div className="flex items-center gap-4 relative">
          <div className="relative">
            <div className="w-20 h-20 rounded-2xl bg-white/20 flex items-center justify-center border-2 border-white/30">
              <Store size={32} className="text-white" />
            </div>
            <button className="absolute -bottom-1 -right-1 w-7 h-7 bg-white rounded-full flex items-center justify-center shadow-lg">
              <Camera size={13} className="text-primary" />
            </button>
          </div>
          <div className="flex-1">
            <h2 className="text-xl font-black">{storeName}</h2>
            <p className="text-white/70 text-sm">{name} · Partner ID: CFN12345</p>
            <div className="flex items-center gap-3 mt-2">
              <div className="flex items-center gap-1">
                <Star size={13} className="fill-yellow-300 text-yellow-300" />
                <span className="text-sm font-bold">4.7</span>
              </div>
              <span className="text-white/40">·</span>
              <span className="text-sm text-white/80">128 orders completed</span>
            </div>
          </div>
          <button
            onClick={() => setEditing(e => !e)}
            className="w-9 h-9 bg-white/20 hover:bg-white/30 rounded-xl flex items-center justify-center transition-colors"
          >
            <Edit3 size={15} />
          </button>
        </div>
        <div className="grid grid-cols-3 gap-3 mt-5">
          <div className="bg-white/15 rounded-xl p-3 text-center">
            <p className="text-lg font-black">128</p>
            <p className="text-xs text-white/70">Total Orders</p>
          </div>
          <div className="bg-white/15 rounded-xl p-3 text-center">
            <p className="text-lg font-black">₹2.4L</p>
            <p className="text-xs text-white/70">Total Earnings</p>
          </div>
          <div className="bg-white/15 rounded-xl p-3 text-center">
            <p className="text-lg font-black">96%</p>
            <p className="text-xs text-white/70">Completion Rate</p>
          </div>
        </div>
      </div>

      {/* Verification Badge */}
      <div className="bg-green-50 border border-green-200 rounded-2xl p-4 flex items-center gap-3">
        <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center flex-shrink-0">
          <Shield size={18} className="text-green-600" />
        </div>
        <div className="flex-1">
          <p className="text-sm font-bold text-green-800">Verified Partner</p>
          <p className="text-xs text-green-600">KYC verified · Documents approved · Active since Mar 2023</p>
        </div>
        <CheckCircle size={20} className="text-green-500 flex-shrink-0" />
      </div>

      {/* Personal Info */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        <div className="px-4 py-3 border-b border-gray-50 flex items-center justify-between">
          <h3 className="font-bold text-gray-900">Business Information</h3>
          {!editing && (
            <button onClick={() => setEditing(true)} className="text-xs font-bold text-primary flex items-center gap-1">
              <Edit3 size={12} /> Edit
            </button>
          )}
        </div>
        <div className="p-4 space-y-4">
          {editing ? (
            <>
              <div>
                <label className="text-xs font-semibold text-gray-500 mb-1 block">Store Name</label>
                <input value={storeName} onChange={e => setStoreName(e.target.value)}
                  className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-primary" />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-500 mb-1 block">Owner Name</label>
                <input value={name} onChange={e => setName(e.target.value)}
                  className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-primary" />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-500 mb-1 block">Phone Number</label>
                <input value={phone} onChange={e => setPhone(e.target.value)}
                  className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-primary" />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-500 mb-1 block">Email Address</label>
                <input value={email} onChange={e => setEmail(e.target.value)}
                  className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-primary" />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-500 mb-1 block">Store Address</label>
                <textarea value={address} onChange={e => setAddress(e.target.value)} rows={2}
                  className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-primary resize-none" />
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-500 mb-1 block">GST Number</label>
                <input value={gstNumber} onChange={e => setGstNumber(e.target.value)}
                  className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-primary" />
              </div>
              <div className="flex gap-3">
                <button onClick={() => setEditing(false)}
                  className="flex-1 py-2.5 bg-primary text-white rounded-xl text-sm font-bold hover:bg-primary/90 transition-colors">
                  Save Changes
                </button>
                <button onClick={() => setEditing(false)}
                  className="flex-1 py-2.5 bg-gray-100 text-gray-700 rounded-xl text-sm font-bold hover:bg-gray-200 transition-colors">
                  Cancel
                </button>
              </div>
            </>
          ) : (
            <>
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Store size={16} className="text-gray-500" />
                </div>
                <div>
                  <p className="text-xs text-gray-400">Store Name</p>
                  <p className="text-sm font-semibold text-gray-900">{storeName}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <User size={16} className="text-gray-500" />
                </div>
                <div>
                  <p className="text-xs text-gray-400">Owner Name</p>
                  <p className="text-sm font-semibold text-gray-900">{name}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Phone size={16} className="text-gray-500" />
                </div>
                <div>
                  <p className="text-xs text-gray-400">Phone Number</p>
                  <p className="text-sm font-semibold text-gray-900">{phone}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Mail size={16} className="text-gray-500" />
                </div>
                <div>
                  <p className="text-xs text-gray-400">Email Address</p>
                  <p className="text-sm font-semibold text-gray-900">{email}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <MapPin size={16} className="text-gray-500" />
                </div>
                <div>
                  <p className="text-xs text-gray-400">Store Address</p>
                  <p className="text-sm font-semibold text-gray-900">{address}</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <FileText size={16} className="text-gray-500" />
                </div>
                <div>
                  <p className="text-xs text-gray-400">GST Number</p>
                  <p className="text-sm font-semibold text-gray-900">{gstNumber}</p>
                </div>
              </div>
            </>
          )}
        </div>
      </div>

      {/* Documents */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        <div className="px-4 py-3 border-b border-gray-50 flex items-center justify-between">
          <h3 className="font-bold text-gray-900">Documents</h3>
          <span className="text-xs text-gray-400">Upload PDF, JPG or PNG</span>
        </div>
        <div className="p-4 space-y-3">
          {/* Upload success toast */}
          {uploadSuccess && (
            <div className="flex items-center gap-2 bg-green-50 border border-green-200 rounded-xl px-3 py-2">
              <CheckCircle2 size={15} className="text-green-600 flex-shrink-0" />
              <p className="text-xs font-semibold text-green-700">{uploadSuccess} uploaded successfully! Pending admin review.</p>
            </div>
          )}

          {docList.map((doc) => {
            const state = docs[doc.label];
            const DocIcon = doc.icon;
            return (
              <div key={doc.label} className="border border-gray-100 rounded-xl p-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2 flex-1 min-w-0">
                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 ${
                      state.status === 'verified' ? 'bg-green-50' : state.status === 'uploaded' ? 'bg-blue-50' : 'bg-yellow-50'
                    }`}>
                      <DocIcon size={15} className={
                        state.status === 'verified' ? 'text-green-600' : state.status === 'uploaded' ? 'text-blue-600' : 'text-yellow-600'
                      } />
                    </div>
                    <div className="min-w-0">
                      <p className="text-sm font-semibold text-gray-800">{doc.label}</p>
                      {state.file && (
                        <p className="text-xs text-gray-400 truncate max-w-[140px]">{state.file.name}</p>
                      )}
                    </div>
                  </div>
                  <div className="flex items-center gap-2 flex-shrink-0">
                    <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${
                      state.status === 'verified' ? 'bg-green-100 text-green-700' :
                      state.status === 'uploaded'? 'bg-blue-100 text-blue-700' : 'bg-yellow-100 text-yellow-700'
                    }`}>
                      {state.status === 'verified' ? '✓ Verified' : state.status === 'uploaded' ? '⏫ Uploaded' : '⏳ Pending'}
                    </span>
                    {state.file && (
                      <button
                        onClick={() => setPreviewDoc({ label: doc.label, url: state.file!.url })}
                        className="w-7 h-7 bg-gray-100 hover:bg-gray-200 rounded-lg flex items-center justify-center transition-colors"
                        title="Preview"
                      >
                        <Eye size={13} className="text-gray-600" />
                      </button>
                    )}
                  </div>
                </div>
                {/* Upload button */}
                <div className="mt-2.5">
                  <input
                    type="file"
                    accept=".pdf,.jpg,.jpeg,.png"
                    className="hidden"
                    ref={el => { fileInputRefs.current[doc.label] = el; }}
                    onChange={e => handleFileChange(doc.label, e)}
                  />
                  <button
                    onClick={() => fileInputRefs.current[doc.label]?.click()}
                    className="w-full flex items-center justify-center gap-1.5 py-2 border border-dashed border-gray-300 hover:border-primary hover:bg-primary/5 rounded-lg text-xs font-semibold text-gray-500 hover:text-primary transition-all"
                  >
                    <Upload size={13} />
                    {state.status === 'verified' ? 'Re-upload Document' : 'Upload Document'}
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Sign Out */}
      <button className="w-full py-3.5 bg-red-50 border border-red-100 text-red-600 rounded-2xl text-sm font-bold flex items-center justify-center gap-2 hover:bg-red-100 transition-colors">
        <LogOut size={16} />
        Sign Out
      </button>

      {/* Document Preview Modal */}
      {previewDoc && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm overflow-hidden">
            <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100">
              <h4 className="font-bold text-gray-900 text-sm">{previewDoc.label}</h4>
              <button onClick={() => setPreviewDoc(null)} className="w-7 h-7 bg-gray-100 hover:bg-gray-200 rounded-lg flex items-center justify-center">
                <X size={14} className="text-gray-600" />
              </button>
            </div>
            <div className="p-4">
              <img src={previewDoc.url} alt={previewDoc.label} className="w-full rounded-xl object-contain max-h-64" />
            </div>
            <div className="px-4 pb-4">
              <button onClick={() => setPreviewDoc(null)} className="w-full py-2.5 bg-primary text-white rounded-xl text-sm font-bold hover:bg-primary/90">Close</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

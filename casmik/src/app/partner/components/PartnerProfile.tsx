'use client';
import React, { useState, useRef } from 'react';
import { 
  User, 
  Phone, 
  Mail, 
  MapPin, 
  Store, 
  Star, 
  Edit3, 
  Camera, 
  CheckCircle, 
  Shield, 
  FileText, 
  Upload, 
  Eye, 
  X, 
  CheckCircle2, 
  CreditCard, 
  Building2,
  Clock,
  Award,
  Download,
  AlertCircle,
  Save
} from 'lucide-react';
import { Partner } from '@/lib/casmikData';

interface DocFile {
  name: string;
  url: string;
}

interface DocState {
  status: 'verified' | 'pending' | 'uploaded';
  file?: DocFile;
}

interface PartnerProfileProps {
  partner?: Partner | null;
  onUpdateSession?: (p: Partner) => void;
}

export default function PartnerProfile({ partner, onUpdateSession }: PartnerProfileProps) {
  const [editing, setEditing] = useState(false);
  const [storeName, setStoreName] = useState(partner?.storeName || 'MobileHub Store');
  const [name, setName] = useState(partner?.name || 'Rajesh Kumar');
  const [phone, setPhone] = useState(partner?.phone || '+91 98765 43210');
  const [email, setEmail] = useState(partner?.email || 'rajesh@mobilehub.in');
  const [address, setAddress] = useState(partner?.address || 'Shop 12, Sector 18, Noida, UP - 201301');
  const [gstNumber, setGstNumber] = useState('07AABCU9603R1ZX');
  const [panNumber, setPanNumber] = useState('AABCU9603R');
  const [bankName, setBankName] = useState('HDFC Bank');
  const [accountNumber, setAccountNumber] = useState('50200034918273');
  const [ifscCode, setIfscCode] = useState('HDFC0000128');
  const [upiId, setUpiId] = useState('mobilehub@okhdfcbank');

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

  const handleSaveProfile = () => {
    if (onUpdateSession && partner) {
      const updated: Partner = {
        ...partner,
        storeName,
        name,
        phone,
        email,
        address,
      };
      onUpdateSession(updated);
      if (typeof window !== 'undefined') {
        localStorage.setItem('casmik_partner_session', JSON.stringify(updated));
      }
    }
    setEditing(false);
  };

  const docList = [
    { label: 'Aadhaar Card', icon: User, desc: 'Government Photo ID' },
    { label: 'PAN Card', icon: CreditCard, desc: 'Permanent Account Number' },
    { label: 'GST Certificate', icon: FileText, desc: 'Tax Registration' },
    { label: 'Shop License', icon: Store, desc: 'Municipal Trade Certificate' },
    { label: 'Bank Proof', icon: Building2, desc: 'Cancelled Cheque or Statement' },
  ];

  return (
    <div className="space-y-6 w-full max-w-7xl mx-auto font-sans">
      
      {/* 1. Full-Width Responsive Hero Card */}
      <div className="bg-gradient-to-r from-emerald-600 via-primary to-teal-700 rounded-3xl p-6 sm:p-8 text-white relative overflow-hidden shadow-xl">
        <div className="absolute top-0 right-0 w-96 h-96 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2 pointer-events-none" />
        <div className="absolute bottom-0 left-1/3 w-64 h-64 bg-black/10 rounded-full blur-2xl pointer-events-none" />

        <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative z-10">
          <div className="flex items-center gap-4 sm:gap-6">
            <div className="relative flex-shrink-0">
              <div className="w-20 h-20 sm:w-24 sm:h-24 rounded-2xl bg-white/20 backdrop-blur-md flex items-center justify-center border-2 border-white/40 shadow-inner">
                <Store size={38} className="text-white" />
              </div>
              <button
                className="absolute -bottom-1 -right-1 w-8 h-8 bg-white rounded-full flex items-center justify-center shadow-lg hover:scale-110 transition-transform"
                title="Change Store Avatar"
              >
                <Camera size={14} className="text-primary" />
              </button>
            </div>

            <div>
              <div className="flex flex-wrap items-center gap-2">
                <h1 className="text-2xl sm:text-3xl font-black tracking-tight">{storeName}</h1>
                <span className="px-2.5 py-0.5 rounded-full bg-white/20 text-white text-[11px] font-bold backdrop-blur-sm">
                  Tier 1 Certified Studio
                </span>
              </div>
              <p className="text-white/80 text-xs sm:text-sm mt-0.5 font-medium">
                {name} &bull; Partner ID: <strong className="text-white">{partner?.id || 'CFN12345'}</strong>
              </p>
              
              <div className="flex flex-wrap items-center gap-3 mt-2.5 text-xs">
                <div className="flex items-center gap-1 bg-black/20 px-2.5 py-1 rounded-lg">
                  <Star size={13} className="fill-yellow-300 text-yellow-300" />
                  <span className="font-bold text-white">4.8 / 5.0</span>
                </div>
                <span className="text-white/60">&bull;</span>
                <span className="text-white/90 font-medium">128 Orders Completed</span>
                <span className="text-white/60">&bull;</span>
                <span className="text-emerald-200 font-semibold flex items-center gap-1">
                  <CheckCircle2 size={13} /> Active &amp; Verified
                </span>
              </div>
            </div>
          </div>

          <div className="flex sm:self-center gap-3">
            <button
              onClick={() => setEditing((prev) => !prev)}
              className="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-white text-gray-900 font-bold text-xs hover:bg-white/90 shadow-md transition-all hover:scale-105"
            >
              <Edit3 size={14} className="text-primary" />
              <span>{editing ? 'Cancel Editing' : 'Edit Profile'}</span>
            </button>
          </div>
        </div>

        {/* Hero Performance Badges */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mt-6 pt-6 border-t border-white/20 relative z-10">
          <div className="bg-black/20 backdrop-blur-md rounded-2xl p-3.5 border border-white/10">
            <p className="text-[11px] text-white/70 font-semibold uppercase tracking-wider">Total Orders</p>
            <p className="text-xl sm:text-2xl font-black text-white mt-0.5">128</p>
          </div>
          <div className="bg-black/20 backdrop-blur-md rounded-2xl p-3.5 border border-white/10">
            <p className="text-[11px] text-white/70 font-semibold uppercase tracking-wider">Total Earnings</p>
            <p className="text-xl sm:text-2xl font-black text-white mt-0.5">₹2,44,350</p>
          </div>
          <div className="bg-black/20 backdrop-blur-md rounded-2xl p-3.5 border border-white/10">
            <p className="text-[11px] text-white/70 font-semibold uppercase tracking-wider">Order Completion</p>
            <p className="text-xl sm:text-2xl font-black text-emerald-300 mt-0.5">96.2%</p>
          </div>
          <div className="bg-black/20 backdrop-blur-md rounded-2xl p-3.5 border border-white/10">
            <p className="text-[11px] text-white/70 font-semibold uppercase tracking-wider">Daily Capacity</p>
            <p className="text-xl sm:text-2xl font-black text-white mt-0.5">15 Orders/Day</p>
          </div>
        </div>
      </div>

      {/* 2. Verification Alert Pill */}
      <div className="bg-emerald-50 border border-emerald-200/80 rounded-2xl p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3 shadow-sm">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-emerald-100 rounded-xl flex items-center justify-center flex-shrink-0 text-emerald-700">
            <Shield size={20} />
          </div>
          <div>
            <p className="text-sm font-bold text-emerald-900">Verified Camsik Partner Store</p>
            <p className="text-xs text-emerald-700 mt-0.5">
              KYC documents verified &bull; Inspection clearance level: Tier 1 Authorized Studio &bull; Active since March 2023
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-xs font-bold text-emerald-800 bg-emerald-200/60 px-3 py-1 rounded-lg">
            Authorized
          </span>
        </div>
      </div>

      {/* 3. Main Responsive Content Grid (Left 7 Cols, Right 5 Cols) */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        {/* Left Column (Business & Bank Info) */}
        <div className="lg:col-span-7 space-y-6">
          
          {/* Business Information Card */}
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
              <div>
                <h3 className="font-bold text-base text-gray-900">Store &amp; Business Details</h3>
                <p className="text-xs text-gray-500">Official legal information displayed on customer pickup slips</p>
              </div>
              {!editing && (
                <button
                  onClick={() => setEditing(true)}
                  className="text-xs font-bold text-primary hover:underline flex items-center gap-1"
                >
                  <Edit3 size={13} /> Edit Details
                </button>
              )}
            </div>

            <div className="p-6">
              {editing ? (
                <div className="space-y-4">
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="text-xs font-bold text-gray-700 mb-1 block">Store Trade Name</label>
                      <input
                        value={storeName}
                        onChange={(e) => setStoreName(e.target.value)}
                        className="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm font-medium focus:outline-none focus:border-primary"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-bold text-gray-700 mb-1 block">Store Owner / Manager Name</label>
                      <input
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        className="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm font-medium focus:outline-none focus:border-primary"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="text-xs font-bold text-gray-700 mb-1 block">Registered Contact Phone</label>
                      <input
                        value={phone}
                        onChange={(e) => setPhone(e.target.value)}
                        className="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm font-medium focus:outline-none focus:border-primary"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-bold text-gray-700 mb-1 block">Store Support Email</label>
                      <input
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        className="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm font-medium focus:outline-none focus:border-primary"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="text-xs font-bold text-gray-700 mb-1 block">Complete Physical Store Address</label>
                    <textarea
                      value={address}
                      onChange={(e) => setAddress(e.target.value)}
                      rows={2}
                      className="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm font-medium focus:outline-none focus:border-primary resize-none"
                    />
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="text-xs font-bold text-gray-700 mb-1 block">GSTIN Number</label>
                      <input
                        value={gstNumber}
                        onChange={(e) => setGstNumber(e.target.value)}
                        className="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm font-medium focus:outline-none focus:border-primary"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-bold text-gray-700 mb-1 block">Business PAN</label>
                      <input
                        value={panNumber}
                        onChange={(e) => setPanNumber(e.target.value)}
                        className="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm font-medium focus:outline-none focus:border-primary"
                      />
                    </div>
                  </div>

                  <div className="flex items-center gap-3 pt-3 border-t border-gray-100">
                    <button
                      onClick={handleSaveProfile}
                      className="flex-1 py-3 bg-primary text-white rounded-xl text-sm font-bold hover:bg-primary/90 transition-all flex items-center justify-center gap-2 shadow-md shadow-primary/20"
                    >
                      <Save size={15} /> Save Changes
                    </button>
                    <button
                      onClick={() => setEditing(false)}
                      className="px-6 py-3 bg-gray-100 text-gray-700 rounded-xl text-sm font-bold hover:bg-gray-200 transition-colors"
                    >
                      Cancel
                    </button>
                  </div>
                </div>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-y-5 gap-x-6">
                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0 text-gray-500 mt-0.5">
                      <Store size={16} />
                    </div>
                    <div>
                      <p className="text-xs text-gray-400 font-semibold">Store Trade Name</p>
                      <p className="text-sm font-bold text-gray-900 mt-0.5">{storeName}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0 text-gray-500 mt-0.5">
                      <User size={16} />
                    </div>
                    <div>
                      <p className="text-xs text-gray-400 font-semibold">Owner / Authorized Representative</p>
                      <p className="text-sm font-bold text-gray-900 mt-0.5">{name}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0 text-gray-500 mt-0.5">
                      <Phone size={16} />
                    </div>
                    <div>
                      <p className="text-xs text-gray-400 font-semibold">Phone Contact</p>
                      <p className="text-sm font-bold text-gray-900 mt-0.5">{phone}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0 text-gray-500 mt-0.5">
                      <Mail size={16} />
                    </div>
                    <div>
                      <p className="text-xs text-gray-400 font-semibold">Store Email</p>
                      <p className="text-sm font-bold text-gray-900 mt-0.5 truncate">{email}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3 sm:col-span-2">
                    <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0 text-gray-500 mt-0.5">
                      <MapPin size={16} />
                    </div>
                    <div>
                      <p className="text-xs text-gray-400 font-semibold">Registered Store Address</p>
                      <p className="text-sm font-bold text-gray-900 mt-0.5">{address}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0 text-gray-500 mt-0.5">
                      <FileText size={16} />
                    </div>
                    <div>
                      <p className="text-xs text-gray-400 font-semibold">GSTIN</p>
                      <p className="text-sm font-bold text-gray-900 mt-0.5">{gstNumber}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-3">
                    <div className="w-9 h-9 bg-gray-50 rounded-xl flex items-center justify-center flex-shrink-0 text-gray-500 mt-0.5">
                      <CreditCard size={16} />
                    </div>
                    <div>
                      <p className="text-xs text-gray-400 font-semibold">Business PAN</p>
                      <p className="text-sm font-bold text-gray-900 mt-0.5">{panNumber}</p>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Bank & Payout Settlement Information */}
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 space-y-4">
            <div className="flex items-center justify-between pb-3 border-b border-gray-100">
              <div>
                <h3 className="font-bold text-base text-gray-900 flex items-center gap-2">
                  <Building2 size={18} className="text-primary" />
                  Bank &amp; Settlement Account
                </h3>
                <p className="text-xs text-gray-500">Auto-settlement account for weekly commission &amp; customer payouts</p>
              </div>
              <span className="text-xs font-bold text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-lg border border-emerald-200">
                Verified IMPS Ready
              </span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
              <div className="p-3.5 rounded-xl bg-gray-50/80 border border-gray-100">
                <p className="text-xs text-gray-400 font-semibold">Bank Name</p>
                <p className="text-sm font-bold text-gray-900 mt-0.5">{bankName}</p>
              </div>

              <div className="p-3.5 rounded-xl bg-gray-50/80 border border-gray-100">
                <p className="text-xs text-gray-400 font-semibold">Account Number</p>
                <p className="text-sm font-bold text-gray-900 mt-0.5">•••• •••• {accountNumber.slice(-4)}</p>
              </div>

              <div className="p-3.5 rounded-xl bg-gray-50/80 border border-gray-100">
                <p className="text-xs text-gray-400 font-semibold">IFSC Code</p>
                <p className="text-sm font-bold text-gray-900 mt-0.5">{ifscCode}</p>
              </div>

              <div className="p-3.5 rounded-xl bg-gray-50/80 border border-gray-100">
                <p className="text-xs text-gray-400 font-semibold">Instant UPI VPA</p>
                <p className="text-sm font-bold text-gray-900 mt-0.5">{upiId}</p>
              </div>
            </div>
          </div>
        </div>

        {/* Right Column (KYC Documents, Operating Hours & Territory) */}
        <div className="lg:col-span-5 space-y-6">
          
          {/* KYC Documents */}
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
            <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
              <div>
                <h3 className="font-bold text-base text-gray-900">KYC &amp; Compliance Docs</h3>
                <p className="text-xs text-gray-500">Government documents for regulatory compliance</p>
              </div>
              <span className="text-xs font-bold text-gray-400">PDF, JPG, PNG</span>
            </div>

            <div className="p-6 space-y-3.5">
              {uploadSuccess && (
                <div className="flex items-center gap-2 bg-emerald-50 border border-emerald-200 rounded-xl p-3">
                  <CheckCircle2 size={16} className="text-emerald-600 flex-shrink-0" />
                  <p className="text-xs font-bold text-emerald-800">
                    {uploadSuccess} uploaded! Camsik Super Admin notified.
                  </p>
                </div>
              )}

              {docList.map((doc) => {
                const state = docs[doc.label];
                const DocIcon = doc.icon;
                return (
                  <div key={doc.label} className="p-3 rounded-xl border border-gray-100 hover:border-gray-200 transition-colors">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2.5 flex-1 min-w-0">
                        <div className={`w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 ${
                          state.status === 'verified' ? 'bg-emerald-50 text-emerald-600' :
                          state.status === 'uploaded' ? 'bg-blue-50 text-blue-600' : 'bg-amber-50 text-amber-600'
                        }`}>
                          <DocIcon size={16} />
                        </div>
                        <div className="min-w-0 flex-1">
                          <p className="text-xs font-bold text-gray-900 truncate">{doc.label}</p>
                          <p className="text-[11px] text-gray-400 truncate">{doc.desc}</p>
                        </div>
                      </div>

                      <div className="flex items-center gap-2">
                        <span className={`text-[10px] font-bold px-2 py-0.5 rounded-md capitalize ${
                          state.status === 'verified' ? 'bg-emerald-100 text-emerald-800' :
                          state.status === 'uploaded' ? 'bg-blue-100 text-blue-800' : 'bg-amber-100 text-amber-800'
                        }`}>
                          {state.status}
                        </span>

                        <input
                          type="file"
                          accept=".pdf,.jpg,.jpeg,.png"
                          className="hidden"
                          ref={el => { fileInputRefs.current[doc.label] = el; }}
                          onChange={(e) => handleFileChange(doc.label, e)}
                        />

                        <button
                          onClick={() => fileInputRefs.current[doc.label]?.click()}
                          className="p-1.5 rounded-lg text-gray-400 hover:text-primary hover:bg-primary/10 transition-colors"
                          title="Re-upload Document"
                        >
                          <Upload size={14} />
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Store Hours & Territory Coverage */}
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-6 space-y-4">
            <h3 className="font-bold text-base text-gray-900 flex items-center gap-2">
              <Clock size={18} className="text-primary" />
              Store Timings &amp; Coverage
            </h3>

            <div className="space-y-3 text-xs">
              <div className="flex justify-between items-center py-2 border-b border-gray-100">
                <span className="text-gray-500 font-medium">Operating Schedule</span>
                <span className="font-bold text-gray-900">Mon – Sat (10:00 AM – 8:30 PM)</span>
              </div>
              <div className="flex justify-between items-center py-2 border-b border-gray-100">
                <span className="text-gray-500 font-medium">Sunday Operations</span>
                <span className="font-bold text-amber-600">On-Call Pickups Only</span>
              </div>
              <div className="flex justify-between items-center py-2 border-b border-gray-100">
                <span className="text-gray-500 font-medium">Territory Pincodes</span>
                <span className="font-bold text-gray-900">201301, 201303, 110092, 110096</span>
              </div>
              <div className="flex justify-between items-center py-2">
                <span className="text-gray-500 font-medium">Partner Agreement</span>
                <span className="text-primary font-bold hover:underline cursor-pointer flex items-center gap-1">
                  <Download size={12} /> View Agreement PDF
                </span>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}

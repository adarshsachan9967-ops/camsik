'use client';
import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import {
  Search,
  Star,
  ShieldCheck,
  Truck,
  CheckCircle,
  Package,
  ArrowRight,
  ArrowLeft,
  Camera,
  Sparkles,
  CreditCard,
  ClipboardCheck,
  Check,
  BatteryCharging,
  Smartphone,
  Laptop,
  Tablet,
  Watch,
  X,
} from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import {
  RefurbishedProduct,
  ProductCategory,
  ProductCondition,
  getRefurbishedProducts,
} from '@/lib/refurbishedCatalog';

export default function BuyRefurbishedPage() {
  const [products, setProducts] = useState<RefurbishedProduct[]>([]);
  const [activeCategory, setActiveCategory] = useState<string>('all');
  const [activeCondition, setActiveCondition] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');

  // Navigation / views: 'list' | 'details' | 'checkout' | 'confirmed'
  const [currentView, setCurrentView] = useState<'list' | 'details' | 'checkout' | 'confirmed'>('list');
  const [selectedProduct, setSelectedProduct] = useState<RefurbishedProduct | null>(null);
  const [activeImageIndex, setActiveImageIndex] = useState(0);

  // Checkout form state
  const [address, setAddress] = useState('');
  const [pincode, setPincode] = useState('');
  const [phone, setPhone] = useState('');
  const [fullName, setFullName] = useState('');
  const [paymentMethod, setPaymentMethod] = useState<'UPI' | 'Card' | 'EMI'>('UPI');
  const [confirmedOrderId, setConfirmedOrderId] = useState('');

  // Load products & listen to admin updates
  useEffect(() => {
    setProducts(getRefurbishedProducts());

    const handleUpdate = (e: Event) => {
      const customEvent = e as CustomEvent<RefurbishedProduct[]>;
      if (customEvent.detail) {
        setProducts(customEvent.detail);
      } else {
        setProducts(getRefurbishedProducts());
      }
    };

    window.addEventListener('casmik_refurbished_updated', handleUpdate);
    return () => window.removeEventListener('casmik_refurbished_updated', handleUpdate);
  }, []);

  // Filter products
  const filteredProducts = products.filter((p) => {
    const matchCat = activeCategory === 'all' || p.category.toLowerCase() === activeCategory.toLowerCase();
    const matchCond = activeCondition === 'all' || p.condition.toLowerCase() === activeCondition.toLowerCase();
    const matchSearch =
      searchQuery.trim() === '' ||
      p.model.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.brand.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.specs.toLowerCase().includes(searchQuery.toLowerCase());
    return matchCat && matchCond && matchSearch;
  });

  const handleSelectProduct = (product: RefurbishedProduct) => {
    setSelectedProduct(product);
    setActiveImageIndex(0);
    setCurrentView('details');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleStartCheckout = () => {
    setCurrentView('checkout');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handlePlaceOrder = (e: React.FormEvent) => {
    e.preventDefault();
    const randomId = 'CAM-ORD-' + Math.floor(100000 + Math.random() * 900000);
    setConfirmedOrderId(randomId);
    setCurrentView('confirmed');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const conditionBadgeColor = (condition: ProductCondition) => {
    switch (condition) {
      case 'Superb':
        return 'bg-emerald-50 text-emerald-700 border-emerald-200';
      case 'Good':
        return 'bg-blue-50 text-blue-700 border-blue-200';
      case 'Fair':
        return 'bg-amber-50 text-amber-700 border-amber-200';
      default:
        return 'bg-slate-50 text-slate-700 border-slate-200';
    }
  };

  return (
    <main className="min-h-screen bg-slate-50/50 flex flex-col w-full max-w-full overflow-x-hidden">
      <CustomerHeader />

      {/* ─────────────────────────────────────────────────────────────
          VIEW 1: ORDER CONFIRMED CELEBRATION
      ────────────────────────────────────────────────────────────── */}
      {currentView === 'confirmed' && selectedProduct && (
        <div className="flex-1 max-w-2xl mx-auto px-4 py-12 sm:py-16 w-full">
          <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-10 shadow-xl text-center">
            <div className="w-20 h-20 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto mb-5 shadow-inner">
              <CheckCircle size={44} />
            </div>
            <span className="inline-block px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 text-xs font-bold mb-2">
              Order Placed Successfully
            </span>
            <h1 className="text-2xl sm:text-3xl font-black text-slate-900 mb-2">
              Congratulations! Order #{confirmedOrderId}
            </h1>
            <p className="text-sm text-slate-500 mb-6 max-w-md mx-auto">
              Your certified refurbished <span className="font-bold text-slate-800">{selectedProduct.model}</span> is confirmed and booked for insured delivery within {selectedProduct.deliveryDays} business days.
            </p>

            {/* Order Details Card */}
            <div className="rounded-2xl bg-slate-50 border border-slate-200 p-5 text-left text-xs space-y-2.5 mb-6">
              <div className="flex justify-between items-center pb-2.5 border-b border-slate-200">
                <span className="font-bold text-slate-500">Item</span>
                <span className="font-extrabold text-slate-900 text-right">{selectedProduct.model} ({selectedProduct.storage})</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-500">Condition Grade</span>
                <span className="font-bold text-emerald-600">{selectedProduct.condition} · {selectedProduct.conditionNote}</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-500">Warranty Coverage</span>
                <span className="font-bold text-slate-800">{selectedProduct.warranty} Official Certified Warranty</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-500">Payment Mode</span>
                <span className="font-bold text-slate-800">{paymentMethod}</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-slate-500">Deliver To</span>
                <span className="font-medium text-slate-800 text-right max-w-[200px] truncate">{address || 'Registered Customer Address'}</span>
              </div>
              <div className="flex justify-between items-center pt-2.5 border-t border-slate-200 text-sm font-black">
                <span className="text-slate-900">Total Paid</span>
                <span className="text-emerald-600">₹{selectedProduct.sellingPrice.toLocaleString('en-IN')}</span>
              </div>
            </div>

            <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
              <button
                type="button"
                onClick={() => {
                  setSelectedProduct(null);
                  setCurrentView('list');
                }}
                className="w-full sm:w-auto px-6 py-3 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-sm transition-all"
              >
                Browse More Refurbished Devices
              </button>
              <Link
                href="/track-order"
                className="w-full sm:w-auto px-6 py-3 rounded-xl bg-emerald-500 hover:bg-emerald-600 text-white font-bold text-sm transition-all text-center"
              >
                Track Your Order
              </Link>
            </div>
          </div>
        </div>
      )}

      {/* ─────────────────────────────────────────────────────────────
          VIEW 2: ORDER CHECKOUT (SCREENSHOT 4)
      ────────────────────────────────────────────────────────────── */}
      {currentView === 'checkout' && selectedProduct && (
        <div className="flex-1 max-w-4xl mx-auto px-4 py-8 sm:py-12 w-full">
          <button
            type="button"
            onClick={() => setCurrentView('details')}
            className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-600 hover:text-slate-900 mb-6 group"
          >
            <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
            <span>Back to Product Details</span>
          </button>

          <div className="bg-white rounded-3xl border border-slate-200 shadow-xl overflow-hidden p-6 sm:p-8">
            <h2 className="text-xl sm:text-2xl font-black text-slate-900 mb-6">
              Complete Your Order
            </h2>

            {/* Selected Device Summary Header (matches Screenshot 4) */}
            <div className="flex items-center gap-4 p-4 rounded-2xl bg-slate-50 border border-slate-200/80 mb-6">
              <div className="w-16 h-16 rounded-xl bg-white p-2 border border-slate-200 flex items-center justify-center shrink-0">
                <img
                  src={selectedProduct.image}
                  alt={selectedProduct.model}
                  className="max-w-full max-h-full object-contain"
                />
              </div>
              <div className="flex-1 min-w-0">
                <h3 className="text-sm sm:text-base font-extrabold text-slate-900 truncate">
                  {selectedProduct.brand} {selectedProduct.model}
                </h3>
                <p className="text-xs text-slate-500">
                  {selectedProduct.storage} · {selectedProduct.color}
                </p>
                <div className="flex items-center gap-2 mt-1">
                  <span className={`text-[10px] font-bold px-2 py-0.5 rounded-md border ${conditionBadgeColor(selectedProduct.condition)}`}>
                    {selectedProduct.condition}
                  </span>
                </div>
              </div>
              <div className="text-right">
                <p className="text-base sm:text-lg font-black text-slate-900">
                  ₹{selectedProduct.sellingPrice.toLocaleString('en-IN')}
                </p>
                <p className="text-xs text-slate-400 line-through">
                  ₹{selectedProduct.originalPrice.toLocaleString('en-IN')}
                </p>
              </div>
            </div>

            {/* Checkout Form */}
            <form onSubmit={handlePlaceOrder} className="space-y-6">
              {/* Delivery Address */}
              <div>
                <label className="block text-xs font-extrabold text-slate-700 uppercase tracking-wider mb-2">
                  Delivery Address
                </label>
                <textarea
                  required
                  rows={3}
                  value={address}
                  onChange={(e) => setAddress(e.target.value)}
                  placeholder="Enter your full delivery address (House/Flat, Street, Area, Landmark)..."
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 bg-white text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all"
                />
              </div>

              {/* PIN Code & Phone Number */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-extrabold text-slate-700 uppercase tracking-wider mb-2">
                    PIN Code
                  </label>
                  <input
                    required
                    type="text"
                    maxLength={6}
                    value={pincode}
                    onChange={(e) => setPincode(e.target.value)}
                    placeholder="6-digit PIN"
                    className="w-full px-4 py-3 rounded-xl border border-slate-200 bg-white text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all"
                  />
                </div>
                <div>
                  <label className="block text-xs font-extrabold text-slate-700 uppercase tracking-wider mb-2">
                    Phone Number
                  </label>
                  <input
                    required
                    type="tel"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    placeholder="+91 XXXXX XXXXX"
                    className="w-full px-4 py-3 rounded-xl border border-slate-200 bg-white text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all"
                  />
                </div>
              </div>

              {/* Full Name */}
              <div>
                <label className="block text-xs font-extrabold text-slate-700 uppercase tracking-wider mb-2">
                  Full Name
                </label>
                <input
                  required
                  type="text"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  placeholder="Receiver's full name"
                  className="w-full px-4 py-3 rounded-xl border border-slate-200 bg-white text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all"
                />
              </div>

              {/* Payment Method Selector (matches Screenshot 4) */}
              <div>
                <label className="block text-xs font-extrabold text-slate-700 uppercase tracking-wider mb-2">
                  Payment Method
                </label>
                <div className="grid grid-cols-3 gap-3">
                  {(['UPI', 'Card', 'EMI'] as const).map((method) => {
                    const isSelected = paymentMethod === method;
                    return (
                      <button
                        key={method}
                        type="button"
                        onClick={() => setPaymentMethod(method)}
                        className={`py-3 px-4 rounded-xl border font-bold text-sm transition-all text-center ${
                          isSelected
                            ? 'border-emerald-500 bg-emerald-50/50 text-emerald-700 shadow-sm ring-1 ring-emerald-500'
                            : 'border-slate-200 bg-white text-slate-600 hover:border-slate-300'
                        }`}
                      >
                        {method}
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Price Breakdown */}
              <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200/80 space-y-2 text-sm">
                <div className="flex justify-between text-slate-600">
                  <span>Device Price</span>
                  <span className="font-bold text-slate-900">₹{selectedProduct.sellingPrice.toLocaleString('en-IN')}</span>
                </div>
                <div className="flex justify-between text-slate-600">
                  <span>Delivery</span>
                  <span className="font-bold text-emerald-600">FREE</span>
                </div>
                <div className="flex justify-between pt-2 border-t border-slate-200 text-base font-black text-slate-900">
                  <span>Total</span>
                  <span className="text-emerald-600">₹{selectedProduct.sellingPrice.toLocaleString('en-IN')}</span>
                </div>
              </div>

              {/* Place Order CTA Button */}
              <button
                type="submit"
                className="w-full py-4 rounded-2xl bg-emerald-500 hover:bg-emerald-600 text-white font-extrabold text-base shadow-lg shadow-emerald-500/25 transition-all flex items-center justify-center gap-2"
              >
                <span>Place Order — ₹{selectedProduct.sellingPrice.toLocaleString('en-IN')}</span>
                <ArrowRight size={18} />
              </button>
            </form>
          </div>
        </div>
      )}

      {/* ─────────────────────────────────────────────────────────────
          VIEW 3: PRODUCT DETAILS (SCREENSHOT 3)
      ────────────────────────────────────────────────────────────── */}
      {currentView === 'details' && selectedProduct && (
        <div className="flex-1 max-w-6xl mx-auto px-4 sm:px-6 py-6 sm:py-10 w-full">
          {/* Back Button */}
          <button
            type="button"
            onClick={() => setCurrentView('list')}
            className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-600 hover:text-slate-900 mb-6 group"
          >
            <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
            <span>Back to All Devices</span>
          </button>

          <div className="bg-white rounded-3xl border border-slate-200 shadow-xl overflow-hidden p-6 sm:p-10">
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12">
              {/* Left Column: Image Gallery (matches Screenshot 3) */}
              <div className="lg:col-span-6 flex flex-col items-center">
                {/* Main Active Image Showcase */}
                <div className="relative w-full aspect-square max-w-[420px] rounded-2xl bg-slate-50 border border-slate-200/80 p-6 flex items-center justify-center mb-4">
                  <img
                    src={selectedProduct.gallery[activeImageIndex] || selectedProduct.image}
                    alt={selectedProduct.model}
                    className="max-w-full max-h-full object-contain filter drop-shadow-md transition-all duration-300"
                  />
                  <div className="absolute top-3 left-3">
                    <span className={`text-xs font-bold px-2.5 py-1 rounded-full border ${conditionBadgeColor(selectedProduct.condition)}`}>
                      {selectedProduct.condition}
                    </span>
                  </div>
                  <div className="absolute top-3 right-3">
                    <span className="text-xs font-extrabold px-2.5 py-1 rounded-full bg-emerald-500 text-white">
                      {selectedProduct.discount}% OFF
                    </span>
                  </div>
                </div>

                {/* 3 Clickable Thumbnails Underneath */}
                <div className="flex items-center gap-3 w-full max-w-[420px] justify-center">
                  {(selectedProduct.gallery.length > 0 ? selectedProduct.gallery : [selectedProduct.image]).map((img, idx) => {
                    const isSelected = activeImageIndex === idx;
                    return (
                      <button
                        key={idx}
                        type="button"
                        onClick={() => setActiveImageIndex(idx)}
                        className={`w-20 h-20 rounded-xl bg-slate-50 p-2 border transition-all flex items-center justify-center ${
                          isSelected
                            ? 'border-emerald-500 ring-2 ring-emerald-500/20 bg-white'
                            : 'border-slate-200 hover:border-slate-300'
                        }`}
                      >
                        <img src={img} alt={`Angle ${idx + 1}`} className="max-w-full max-h-full object-contain" />
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Right Column: Product Info & Metrics (matches Screenshot 3) */}
              <div className="lg:col-span-6 flex flex-col justify-between space-y-6">
                <div>
                  {/* Condition Pill & Note */}
                  <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 text-xs font-extrabold border border-emerald-200 mb-3">
                    <span className="w-2 h-2 rounded-full bg-emerald-500" />
                    <span>{selectedProduct.condition}</span>
                    <span className="text-emerald-600/70">·</span>
                    <span className="font-medium text-emerald-800">{selectedProduct.conditionNote}</span>
                  </div>

                  {/* Title & Storage/Color */}
                  <h1 className="text-2xl sm:text-3xl lg:text-4xl font-black text-slate-900 tracking-tight">
                    {selectedProduct.brand} {selectedProduct.model}
                  </h1>
                  <p className="text-sm font-semibold text-slate-500 mt-1">
                    {selectedProduct.storage} · {selectedProduct.color}
                  </p>

                  {/* Price Row */}
                  <div className="flex items-baseline gap-3 mt-4">
                    <span className="text-3xl sm:text-4xl font-black text-slate-900">
                      ₹{selectedProduct.sellingPrice.toLocaleString('en-IN')}
                    </span>
                    <span className="text-base text-slate-400 line-through">
                      ₹{selectedProduct.originalPrice.toLocaleString('en-IN')}
                    </span>
                    <span className="text-xs sm:text-sm font-extrabold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-lg border border-emerald-200">
                      {selectedProduct.discount}% OFF
                    </span>
                  </div>

                  {/* 4 Feature Metric Cards in 2x2 Grid (matches Screenshot 3) */}
                  <div className="grid grid-cols-2 gap-3 mt-6">
                    {/* Card 1: Battery Health or Shutter Count */}
                    <div className="p-3.5 rounded-2xl bg-slate-50/80 border border-slate-200/80 flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center shrink-0">
                        <BatteryCharging size={20} />
                      </div>
                      <div>
                        <p className="text-[11px] font-bold text-slate-500">
                          {typeof selectedProduct.batteryHealth === 'number' ? 'Battery Health' : 'Diagnostics'}
                        </p>
                        <p className="text-sm font-black text-slate-900">
                          {typeof selectedProduct.batteryHealth === 'number' ? `${selectedProduct.batteryHealth}%` : selectedProduct.batteryHealth}
                        </p>
                      </div>
                    </div>

                    {/* Card 2: Warranty */}
                    <div className="p-3.5 rounded-2xl bg-slate-50/80 border border-slate-200/80 flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-blue-100 text-blue-700 flex items-center justify-center shrink-0">
                        <ShieldCheck size={20} />
                      </div>
                      <div>
                        <p className="text-[11px] font-bold text-slate-500">Warranty</p>
                        <p className="text-sm font-black text-slate-900">{selectedProduct.warranty}</p>
                      </div>
                    </div>

                    {/* Card 3: Rating */}
                    <div className="p-3.5 rounded-2xl bg-slate-50/80 border border-slate-200/80 flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-amber-100 text-amber-600 flex items-center justify-center shrink-0">
                        <Star size={20} className="fill-amber-500 text-amber-500" />
                      </div>
                      <div>
                        <p className="text-[11px] font-bold text-slate-500">Rating</p>
                        <p className="text-sm font-black text-slate-900">
                          {selectedProduct.rating} / 5 <span className="text-xs font-normal text-slate-400">({selectedProduct.reviews})</span>
                        </p>
                      </div>
                    </div>

                    {/* Card 4: Delivery */}
                    <div className="p-3.5 rounded-2xl bg-slate-50/80 border border-slate-200/80 flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-purple-100 text-purple-700 flex items-center justify-center shrink-0">
                        <Truck size={20} />
                      </div>
                      <div>
                        <p className="text-[11px] font-bold text-slate-500">Delivery</p>
                        <p className="text-sm font-black text-slate-900">{selectedProduct.deliveryDays} business days</p>
                      </div>
                    </div>
                  </div>

                  {/* Certified Inspection Report Card (matches Screenshot 3) */}
                  <div className="mt-6 p-4 sm:p-5 rounded-2xl bg-slate-50 border border-slate-200/80">
                    <h3 className="text-xs font-extrabold text-slate-900 uppercase tracking-wider mb-3 flex items-center gap-1.5">
                      <ClipboardCheck size={16} className="text-emerald-600" />
                      <span>Certified 45-Point Inspection Report</span>
                    </h3>
                    <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-xs">
                      {[
                        { label: 'Display & Touch', status: selectedProduct.inspectionReport.display },
                        { label: 'Battery Capacity', status: selectedProduct.inspectionReport.battery },
                        { label: 'Camera & Optics', status: selectedProduct.inspectionReport.camera },
                        { label: 'Speakers & Mic', status: selectedProduct.inspectionReport.speakers },
                        { label: 'Charging & Ports', status: selectedProduct.inspectionReport.chargingPort },
                        { label: 'Sensors / Biometrics', status: selectedProduct.inspectionReport.sensor },
                      ].map((item) => (
                        <div key={item.label} className="flex items-center justify-between py-1 border-b border-slate-200/60">
                          <span className="text-slate-600">{item.label}</span>
                          <span className="inline-flex items-center gap-1 font-bold text-emerald-700">
                            <Check size={13} strokeWidth={3} className="text-emerald-600" />
                            {item.status}
                          </span>
                        </div>
                      ))}
                    </div>
                  </div>

                  {/* Technical Specs Brief */}
                  <p className="text-xs text-slate-500 mt-4 leading-relaxed">
                    <span className="font-bold text-slate-700">Key Specifications: </span>
                    {selectedProduct.specs}
                  </p>
                </div>

                {/* Primary Buy Now CTA Button (matches Screenshot 3) */}
                <div className="pt-4">
                  <button
                    type="button"
                    onClick={handleStartCheckout}
                    className="w-full py-4 rounded-2xl bg-emerald-500 hover:bg-emerald-600 text-white font-black text-base shadow-xl shadow-emerald-500/25 hover:shadow-emerald-500/40 transition-all flex items-center justify-center gap-2 btn-press"
                  >
                    <span>Buy Now — ₹{selectedProduct.sellingPrice.toLocaleString('en-IN')}</span>
                    <ArrowRight size={18} />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ─────────────────────────────────────────────────────────────
          VIEW 4: MAIN PRODUCTS LISTING PAGE (SCREENSHOTS 1 & 2)
      ────────────────────────────────────────────────────────────── */}
      {currentView === 'list' && (
        <>
          {/* Hero Section (matches Screenshot 1) */}
          <section className="bg-white border-b border-slate-200 py-8 sm:py-12">
            <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
              <div className="max-w-3xl mb-6">
                <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-blue-50 text-blue-700 text-xs font-extrabold uppercase tracking-wider mb-3 border border-blue-200/60">
                  <Sparkles size={13} className="text-blue-600" />
                  CERTIFIED REFURBISHED DEVICES
                </div>
                <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black text-slate-900 tracking-tight mb-2">
                  Buy Refurbished Devices
                </h1>
                <p className="text-sm sm:text-base text-slate-500 leading-relaxed">
                  Certified devices with warranty, inspection report and battery health guarantee. Save up to 60% vs new.
                </p>
              </div>

              {/* Global Search Bar (matches Screenshot 1) */}
              <div className="relative max-w-xl mb-8">
                <Search size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search iPhone, Samsung, MacBook, Sony A7..."
                  className="w-full pl-11 pr-4 py-3 bg-white border border-slate-200 rounded-2xl text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 shadow-sm transition-all"
                />
                {searchQuery && (
                  <button
                    type="button"
                    onClick={() => setSearchQuery('')}
                    className="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                  >
                    <X size={16} />
                  </button>
                )}
              </div>

              {/* 5-Step Process Bar (matches Screenshot 1) */}
              <div className="hidden lg:grid grid-cols-5 gap-3 pt-6 border-t border-slate-100">
                {[
                  {
                    step: '1',
                    icon: Search,
                    title: 'Choose Device',
                    desc: 'Browse certified refurbished devices by category, brand or model.',
                  },
                  {
                    step: '2',
                    icon: Star,
                    title: 'Select Condition',
                    desc: 'Pick Fair, Good or Superb condition based on your budget.',
                  },
                  {
                    step: '3',
                    icon: ClipboardCheck,
                    title: 'Check Details',
                    desc: 'Review inspection report, battery health, warranty and accessories.',
                  },
                  {
                    step: '4',
                    icon: CreditCard,
                    title: 'Place Order',
                    desc: 'Checkout securely via UPI, card or EMI with instant confirmation.',
                  },
                  {
                    step: '5',
                    icon: Package,
                    title: 'Get Delivery',
                    desc: 'Receive your device at home within 2-3 business days.',
                  },
                ].map((st, i) => {
                  const Icon = st.icon;
                  return (
                    <div key={st.step} className="flex items-start gap-3">
                      <div className="w-8 h-8 rounded-xl bg-slate-100 text-slate-700 flex items-center justify-center shrink-0 mt-0.5">
                        <Icon size={16} />
                      </div>
                      <div className="min-w-0 pr-2">
                        <p className="text-xs font-extrabold text-slate-900 truncate">{st.title}</p>
                        <p className="text-[11px] text-slate-500 leading-tight mt-0.5">{st.desc}</p>
                      </div>
                      {i < 4 && <span className="text-slate-300 font-bold self-center">›</span>}
                    </div>
                  );
                })}
              </div>
            </div>
          </section>

          {/* Filters & Grid Section */}
          <section className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 py-8 w-full">
            {/* Filter Bar (matches Screenshot 1) */}
            <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4 mb-6">
              {/* Category Pills */}
              <div className="flex items-center gap-1.5 overflow-x-auto pb-2 lg:pb-0 scrollbar-none">
                <span className="text-xs font-extrabold text-slate-400 mr-2 flex items-center gap-1 shrink-0">
                  Filter:
                </span>
                {[
                  { id: 'all', label: 'All Categories' },
                  { id: 'smartphones', label: 'Smartphones' },
                  { id: 'cameras', label: 'Cameras & Optics' },
                  { id: 'laptops', label: 'Laptops' },
                  { id: 'tablets', label: 'Tablets' },
                  { id: 'smartwatches', label: 'Smartwatches' },
                ].map((cat) => {
                  const isActive = activeCategory === cat.id;
                  return (
                    <button
                      key={cat.id}
                      type="button"
                      onClick={() => setActiveCategory(cat.id)}
                      className={`px-3.5 py-2 rounded-xl text-xs font-extrabold whitespace-nowrap transition-all ${
                        isActive
                          ? 'bg-emerald-500 text-white shadow-md shadow-emerald-500/20'
                          : 'bg-white border border-slate-200 text-slate-600 hover:border-slate-300 hover:text-slate-900'
                      }`}
                    >
                      {cat.label}
                    </button>
                  );
                })}
              </div>

              {/* Condition Pills */}
              <div className="flex items-center gap-1.5 self-start lg:self-center overflow-x-auto pb-2 lg:pb-0 scrollbar-none">
                {[
                  { id: 'all', label: 'All Conditions' },
                  { id: 'superb', label: 'Superb' },
                  { id: 'good', label: 'Good' },
                  { id: 'fair', label: 'Fair' },
                ].map((cond) => {
                  const isActive = activeCondition === cond.id;
                  return (
                    <button
                      key={cond.id}
                      type="button"
                      onClick={() => setActiveCondition(cond.id)}
                      className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap ${
                        isActive
                          ? 'bg-slate-900 text-white'
                          : 'bg-white border border-slate-200 text-slate-600 hover:text-slate-900'
                      }`}
                    >
                      {cond.label}
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Results Count */}
            <div className="mb-6">
              <p className="text-xs font-bold text-slate-500">
                {filteredProducts.length} devices found
              </p>
            </div>

            {/* Product Cards Grid (matches Screenshot 2) */}
            {filteredProducts.length === 0 ? (
              <div className="bg-white rounded-3xl border border-slate-200 p-12 text-center max-w-md mx-auto my-8">
                <Search size={36} className="mx-auto text-slate-300 mb-3" />
                <h3 className="text-base font-bold text-slate-900 mb-1">No matching devices found</h3>
                <p className="text-xs text-slate-500 mb-4">Try adjusting your category or condition filter, or clear your search term.</p>
                <button
                  type="button"
                  onClick={() => {
                    setActiveCategory('all');
                    setActiveCondition('all');
                    setSearchQuery('');
                  }}
                  className="px-4 py-2 rounded-xl bg-slate-900 text-white text-xs font-bold"
                >
                  Reset All Filters
                </button>
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {filteredProducts.map((product) => {
                  return (
                    <div
                      key={product.id}
                      className="bg-white rounded-3xl border border-slate-200/90 hover:border-emerald-500/50 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between overflow-hidden group"
                    >
                      <div className="p-5">
                        {/* Top Badges & Image Showcase (matches Screenshot 2) */}
                        <div className="relative aspect-[4/3] rounded-2xl bg-slate-50/70 border border-slate-100 p-4 mb-4 flex items-center justify-center overflow-hidden">
                          {/* Condition Badge on Top Left */}
                          <div className="absolute top-3 left-3 z-10">
                            <span className={`text-[10px] font-extrabold px-2.5 py-1 rounded-md border ${conditionBadgeColor(product.condition)}`}>
                              {product.condition}
                            </span>
                          </div>

                          {/* Discount on Top Right */}
                          <div className="absolute top-3 right-3 z-10">
                            <span className="text-[11px] font-black text-emerald-600 tracking-tight">
                              {product.discount}% OFF
                            </span>
                          </div>

                          {/* Clean Cutout Product Image */}
                          <img
                            src={product.image}
                            alt={product.model}
                            className="max-w-full max-h-full object-contain group-hover:scale-105 transition-transform duration-300"
                          />
                        </div>

                        {/* Brand Name */}
                        <p className="text-xs font-bold text-slate-400 mb-0.5">
                          {product.brand}
                        </p>

                        {/* Model Title */}
                        <h3 className="text-base font-extrabold text-slate-900 truncate group-hover:text-emerald-700 transition-colors">
                          {product.model}
                        </h3>

                        {/* Variant / Storage Specs */}
                        <p className="text-xs text-slate-500 mt-0.5 truncate">
                          {product.storage} · {product.color}
                        </p>

                        {/* Battery & Warranty Line (matches Screenshot 2) */}
                        <div className="flex items-center gap-3 mt-3 text-xs text-slate-600 font-medium">
                          <span className="inline-flex items-center gap-1">
                            <BatteryCharging size={13} className="text-emerald-600" />
                            <span>
                              {typeof product.batteryHealth === 'number'
                                ? `Battery: ${product.batteryHealth}%`
                                : product.batteryHealth}
                            </span>
                          </span>
                          <span className="text-slate-300">·</span>
                          <span className="inline-flex items-center gap-1">
                            <ShieldCheck size={13} className="text-blue-600" />
                            <span>{product.warranty}</span>
                          </span>
                        </div>

                        {/* Price Row */}
                        <div className="flex items-baseline gap-2 mt-4 pt-3 border-t border-slate-100">
                          <span className="text-xl font-black text-slate-900">
                            ₹{product.sellingPrice.toLocaleString('en-IN')}
                          </span>
                          <span className="text-xs text-slate-400 line-through">
                            ₹{product.originalPrice.toLocaleString('en-IN')}
                          </span>
                        </div>
                      </div>

                      {/* View Details CTA Button (matches Screenshot 2) */}
                      <div className="p-5 pt-0">
                        <button
                          type="button"
                          onClick={() => handleSelectProduct(product)}
                          className="w-full py-3 rounded-xl bg-emerald-500 hover:bg-emerald-600 text-white font-extrabold text-sm shadow-md shadow-emerald-500/20 hover:shadow-emerald-500/30 transition-all flex items-center justify-center gap-1.5"
                        >
                          View Details
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </section>
        </>
      )}

      <CustomerFooter />
    </main>
  );
}
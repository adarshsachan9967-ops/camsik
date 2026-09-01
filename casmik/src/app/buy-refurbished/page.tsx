'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { Search, Star, Shield, Truck, ChevronRight, SlidersHorizontal, CheckCircle, Battery, Package, ArrowRight } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import AppImage from '@/components/ui/AppImage';

type Condition = 'all' | 'superb' | 'good' | 'fair';
type Category = 'all' | 'smartphones' | 'laptops' | 'tablets' | 'smartwatches';

const refurbishedDevices = [
{ id: 'ref-001', brand: 'Apple', model: 'iPhone 15 Pro', storage: '128GB', color: 'Natural Titanium', condition: 'superb' as const, price: 58999, originalPrice: 134900, discount: 56, batteryHealth: 98, warranty: '12 months', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_17b82fb7a-1772960574407.png', alt: 'iPhone 15 Pro in natural titanium', rating: 4.8, reviews: 234, category: 'smartphones', inStock: true, deliveryDays: 2 },
{ id: 'ref-002', brand: 'Apple', model: 'iPhone 14 Pro Max', storage: '256GB', color: 'Deep Purple', condition: 'good' as const, price: 52999, originalPrice: 139900, discount: 62, batteryHealth: 92, warranty: '12 months', image: "https://images.unsplash.com/photo-1676353410356-867313a96ed4", alt: 'iPhone 14 Pro Max in deep purple', rating: 4.7, reviews: 189, category: 'smartphones', inStock: true, deliveryDays: 2 },
{ id: 'ref-003', brand: 'Samsung', model: 'Galaxy S24 Ultra', storage: '256GB', color: 'Titanium Black', condition: 'superb' as const, price: 62999, originalPrice: 129999, discount: 52, batteryHealth: 97, warranty: '12 months', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_1d40efa47-1773056836850.png', alt: 'Samsung Galaxy S24 Ultra in titanium black', rating: 4.9, reviews: 312, category: 'smartphones', inStock: true, deliveryDays: 2 },
{ id: 'ref-004', brand: 'Apple', model: 'MacBook Air M2', storage: '256GB SSD', color: 'Space Gray', condition: 'good' as const, price: 72999, originalPrice: 114900, discount: 36, batteryHealth: 94, warranty: '12 months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1a40d28b0-1772275866999.png", alt: 'MacBook Air M2 in space gray', rating: 4.8, reviews: 156, category: 'laptops', inStock: true, deliveryDays: 3 },
{ id: 'ref-005', brand: 'OnePlus', model: 'OnePlus 12', storage: '256GB', color: 'Silky Black', condition: 'superb' as const, price: 38999, originalPrice: 64999, discount: 40, batteryHealth: 99, warranty: '12 months', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_137629e57-1765615226355.png', alt: 'OnePlus 12 in silky black', rating: 4.7, reviews: 98, category: 'smartphones', inStock: true, deliveryDays: 2 },
{ id: 'ref-006', brand: 'Apple', model: 'iPad Pro 12.9"', storage: '256GB', color: 'Space Gray', condition: 'good' as const, price: 58999, originalPrice: 112900, discount: 48, batteryHealth: 93, warranty: '12 months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1f9863b31-1773175179242.png", alt: 'iPad Pro 12.9 inch in space gray', rating: 4.6, reviews: 87, category: 'tablets', inStock: true, deliveryDays: 2 },
{ id: 'ref-007', brand: 'Samsung', model: 'Galaxy S23', storage: '128GB', color: 'Phantom Black', condition: 'fair' as const, price: 28999, originalPrice: 74999, discount: 61, batteryHealth: 85, warranty: '6 months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_122e5667e-1772368533819.png", alt: 'Samsung Galaxy S23 in phantom black', rating: 4.4, reviews: 145, category: 'smartphones', inStock: true, deliveryDays: 2 },
{ id: 'ref-008', brand: 'Apple', model: 'Apple Watch Series 9', storage: '32GB', color: 'Midnight', condition: 'superb' as const, price: 18999, originalPrice: 41900, discount: 55, batteryHealth: 96, warranty: '6 months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_10e772778-1764671536455.png", alt: 'Apple Watch Series 9 in midnight', rating: 4.8, reviews: 203, category: 'smartwatches', inStock: true, deliveryDays: 2 },
{ id: 'ref-009', brand: 'Google', model: 'Pixel 8 Pro', storage: '256GB', color: 'Obsidian', condition: 'good' as const, price: 42999, originalPrice: 106999, discount: 60, batteryHealth: 91, warranty: '12 months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_182eccfbd-1765101833319.png", alt: 'Google Pixel 8 Pro in obsidian', rating: 4.6, reviews: 76, category: 'smartphones', inStock: true, deliveryDays: 2 },
{ id: 'ref-010', brand: 'Apple', model: 'iPhone 13', storage: '128GB', color: 'Midnight', condition: 'fair' as const, price: 32999, originalPrice: 79900, discount: 59, batteryHealth: 84, warranty: '6 months', image: "https://images.unsplash.com/photo-1702309087982-4bf4dc02f926", alt: 'iPhone 13 in midnight color', rating: 4.5, reviews: 421, category: 'smartphones', inStock: true, deliveryDays: 2 },
{ id: 'ref-011', brand: 'Dell', model: 'XPS 15', storage: '512GB SSD', color: 'Platinum Silver', condition: 'good' as const, price: 82999, originalPrice: 149990, discount: 45, batteryHealth: 90, warranty: '12 months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1fbe29315-1773056140933.png", alt: 'Dell XPS 15 laptop in platinum silver', rating: 4.7, reviews: 63, category: 'laptops', inStock: true, deliveryDays: 3 },
{ id: 'ref-012', brand: 'Samsung', model: 'Galaxy Tab S9', storage: '128GB', color: 'Graphite', condition: 'superb' as const, price: 44999, originalPrice: 87999, discount: 49, batteryHealth: 97, warranty: '12 months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_157363c6f-1764671536613.png", alt: 'Samsung Galaxy Tab S9 in graphite', rating: 4.7, reviews: 112, category: 'tablets', inStock: true, deliveryDays: 2 }];


const conditionConfig = {
  superb: { label: 'Superb', color: 'bg-emerald-100 text-emerald-700', desc: 'Like new, minimal marks' },
  good: { label: 'Good', color: 'bg-blue-100 text-blue-700', desc: 'Minor cosmetic marks' },
  fair: { label: 'Fair', color: 'bg-amber-100 text-amber-700', desc: 'Visible marks, fully functional' }
};

const howItWorks = [
{ step: 1, icon: '🔍', title: 'Choose Device', desc: 'Browse certified refurbished devices by category, brand or model.' },
{ step: 2, icon: '⭐', title: 'Select Condition', desc: 'Pick Fair, Good or Superb condition based on your budget.' },
{ step: 3, icon: '📋', title: 'Check Details', desc: 'Review inspection report, battery health, warranty and accessories.' },
{ step: 4, icon: '💳', title: 'Place Order', desc: 'Checkout securely via UPI, card or EMI with instant confirmation.' },
{ step: 5, icon: '📦', title: 'Get Delivery', desc: 'Receive your device at home within 2–3 business days.' }];


export default function BuyRefurbishedPage() {
  const [activeCategory, setActiveCategory] = useState<Category>('all');
  const [activeCondition, setActiveCondition] = useState<Condition>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedDevice, setSelectedDevice] = useState<typeof refurbishedDevices[0] | null>(null);
  const [checkoutStep, setCheckoutStep] = useState<'browse' | 'detail' | 'checkout' | 'confirmed'>('browse');

  const filtered = refurbishedDevices.filter((d) => {
    const matchCat = activeCategory === 'all' || d.category === activeCategory;
    const matchCond = activeCondition === 'all' || d.condition === activeCondition;
    const matchSearch = d.model.toLowerCase().includes(searchQuery.toLowerCase()) || d.brand.toLowerCase().includes(searchQuery.toLowerCase());
    return matchCat && matchCond && matchSearch;
  });

  if (checkoutStep === 'confirmed') {
    return (
      <main className="min-h-screen bg-background">
        <CustomerHeader />
        <div className="min-h-[calc(100vh-64px)] flex items-center justify-center py-12 px-4">
          <div className="text-center max-w-md">
            <div className="w-20 h-20 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-6">
              <CheckCircle size={40} className="text-primary" />
            </div>
            <h1 className="text-2xl font-extrabold text-foreground mb-2">Order Confirmed! 🎉</h1>
            <p className="text-muted-foreground mb-6">Your refurbished {selectedDevice?.brand} {selectedDevice?.model} is on its way. Expected delivery in {selectedDevice?.deliveryDays} business days.</p>
            <div className="bg-white rounded-2xl border border-border p-5 mb-6 text-left">
              <p className="text-sm font-semibold text-foreground mb-3">Order Summary</p>
              <div className="flex justify-between text-sm mb-2"><span className="text-muted-foreground">Device</span><span className="font-semibold">{selectedDevice?.brand} {selectedDevice?.model}</span></div>
              <div className="flex justify-between text-sm mb-2"><span className="text-muted-foreground">Condition</span><span className="font-semibold capitalize">{selectedDevice?.condition}</span></div>
              <div className="flex justify-between text-sm mb-2"><span className="text-muted-foreground">Amount Paid</span><span className="font-bold text-primary">₹{selectedDevice?.price.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Warranty</span><span className="font-semibold">{selectedDevice?.warranty}</span></div>
            </div>
            <Link href="/" className="inline-flex items-center gap-2 px-6 py-3 gradient-green text-white rounded-xl font-semibold shadow-green">
              Back to Home <ArrowRight size={16} />
            </Link>
          </div>
        </div>
        <CustomerFooter />
      </main>);

  }

  if (checkoutStep === 'checkout' && selectedDevice) {
    return (
      <main className="min-h-screen bg-background">
        <CustomerHeader />
        <div className="max-w-2xl mx-auto px-4 py-12">
          <button onClick={() => setCheckoutStep('detail')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors">
            ← Back to Device Details
          </button>
          <h1 className="text-2xl font-extrabold text-foreground mb-6">Complete Your Order</h1>
          <div className="bg-white rounded-2xl border border-border p-6 mb-6">
            <div className="flex items-center gap-4 mb-5 pb-5 border-b border-border">
              <img src={selectedDevice.image} alt={selectedDevice.alt} className="w-16 h-16 rounded-xl object-cover bg-muted" />
              <div>
                <p className="font-bold text-foreground">{selectedDevice.brand} {selectedDevice.model}</p>
                <p className="text-sm text-muted-foreground">{selectedDevice.storage} · {selectedDevice.color}</p>
                <span className={`text-xs px-2 py-0.5 rounded-full font-semibold ${conditionConfig[selectedDevice.condition].color}`}>{conditionConfig[selectedDevice.condition].label}</span>
              </div>
              <div className="ml-auto text-right">
                <p className="text-xl font-extrabold text-foreground">₹{selectedDevice.price.toLocaleString('en-IN')}</p>
                <p className="text-xs text-muted-foreground line-through">₹{selectedDevice.originalPrice.toLocaleString('en-IN')}</p>
              </div>
            </div>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-semibold text-foreground mb-1.5">Delivery Address</label>
                <textarea placeholder="Enter your full delivery address..." rows={3}
                className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 resize-none" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-semibold text-foreground mb-1.5">PIN Code</label>
                  <input type="text" placeholder="6-digit PIN" maxLength={6}
                  className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-foreground mb-1.5">Phone</label>
                  <input type="tel" placeholder="+91 XXXXX XXXXX"
                  className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                </div>
              </div>
              <div>
                <p className="text-sm font-semibold text-foreground mb-2">Payment Method</p>
                <div className="grid grid-cols-3 gap-2">
                  {['UPI', 'Card', 'EMI'].map((m) =>
                  <button key={m} className="py-2.5 rounded-xl border-2 border-border text-sm font-semibold hover:border-primary hover:bg-primary/5 transition-all first:border-primary first:bg-primary/5">
                      {m}
                    </button>
                  )}
                </div>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-2xl border border-border p-5 mb-5">
            <div className="flex justify-between text-sm mb-2"><span className="text-muted-foreground">Device Price</span><span>₹{selectedDevice.price.toLocaleString('en-IN')}</span></div>
            <div className="flex justify-between text-sm mb-2"><span className="text-muted-foreground">Delivery</span><span className="text-primary font-semibold">FREE</span></div>
            <div className="flex justify-between text-sm font-bold border-t border-border pt-2 mt-2"><span>Total</span><span className="text-primary">₹{selectedDevice.price.toLocaleString('en-IN')}</span></div>
          </div>
          <button onClick={() => setCheckoutStep('confirmed')}
          className="w-full py-4 gradient-green text-white rounded-xl font-bold text-base shadow-green btn-press flex items-center justify-center gap-2">
            <CheckCircle size={18} /> Place Order — ₹{selectedDevice.price.toLocaleString('en-IN')}
          </button>
        </div>
        <CustomerFooter />
      </main>);

  }

  if (checkoutStep === 'detail' && selectedDevice) {
    const cond = conditionConfig[selectedDevice.condition];
    return (
      <main className="min-h-screen bg-background">
        <CustomerHeader />
        <div className="max-w-screen-xl mx-auto px-4 py-8">
          <button onClick={() => setCheckoutStep('browse')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors">
            ← Back to Listings
          </button>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <div>
              <div className="bg-white rounded-2xl border border-border p-6 mb-4">
                <AppImage src={selectedDevice.image} alt={selectedDevice.alt} width={400} height={400} className="w-full h-72 object-contain" />
              </div>
              <div className="grid grid-cols-3 gap-3">
                {[selectedDevice.image, selectedDevice.image, selectedDevice.image].map((img, i) =>
                <div key={i} className="bg-white rounded-xl border border-border p-2 cursor-pointer hover:border-primary transition-colors">
                    <img src={img} alt={`View ${i + 1}`} className="w-full h-16 object-contain" />
                  </div>
                )}
              </div>
            </div>
            <div>
              <div className="flex items-center gap-2 mb-2">
                <span className={`text-xs px-2.5 py-1 rounded-full font-bold ${cond.color}`}>{cond.label}</span>
                <span className="text-xs text-muted-foreground">{cond.desc}</span>
              </div>
              <h1 className="text-2xl font-extrabold text-foreground mb-1">{selectedDevice.brand} {selectedDevice.model}</h1>
              <p className="text-sm text-muted-foreground mb-4">{selectedDevice.storage} · {selectedDevice.color}</p>
              <div className="flex items-baseline gap-3 mb-5">
                <span className="text-3xl font-extrabold text-foreground">₹{selectedDevice.price.toLocaleString('en-IN')}</span>
                <span className="text-lg text-muted-foreground line-through">₹{selectedDevice.originalPrice.toLocaleString('en-IN')}</span>
                <span className="text-sm font-bold text-primary bg-primary/10 px-2 py-0.5 rounded-lg">{selectedDevice.discount}% OFF</span>
              </div>
              <div className="grid grid-cols-2 gap-3 mb-5">
                {[
                { icon: Battery, label: 'Battery Health', value: `${selectedDevice.batteryHealth}%` },
                { icon: Shield, label: 'Warranty', value: selectedDevice.warranty },
                { icon: Star, label: 'Rating', value: `${selectedDevice.rating}/5 (${selectedDevice.reviews})` },
                { icon: Truck, label: 'Delivery', value: `${selectedDevice.deliveryDays} business days` }].
                map((item) =>
                <div key={item.label} className="bg-surface rounded-xl p-3 flex items-center gap-2.5">
                    <item.icon size={16} className="text-primary flex-shrink-0" />
                    <div>
                      <p className="text-xs text-muted-foreground">{item.label}</p>
                      <p className="text-sm font-bold text-foreground">{item.value}</p>
                    </div>
                  </div>
                )}
              </div>
              <div className="bg-surface rounded-xl p-4 mb-5">
                <p className="text-sm font-bold text-foreground mb-3">Inspection Report</p>
                {['Display', 'Battery', 'Camera', 'Speakers', 'Charging Port', 'Face ID / Fingerprint'].map((item) =>
                <div key={item} className="flex items-center justify-between py-1.5 border-b border-border last:border-0">
                    <span className="text-sm text-muted-foreground">{item}</span>
                    <span className="flex items-center gap-1 text-xs font-semibold text-primary"><CheckCircle size={12} /> Passed</span>
                  </div>
                )}
              </div>
              <button onClick={() => setCheckoutStep('checkout')}
              className="w-full py-4 gradient-green text-white rounded-xl font-bold text-base shadow-green btn-press mb-3">
                Buy Now — ₹{selectedDevice.price.toLocaleString('en-IN')}
              </button>
              <div className="flex items-center justify-center gap-4 text-xs text-muted-foreground">
                <span className="flex items-center gap-1"><Shield size={12} className="text-primary" /> Certified Refurbished</span>
                <span className="flex items-center gap-1"><Truck size={12} className="text-primary" /> Free Delivery</span>
                <span className="flex items-center gap-1"><Package size={12} className="text-primary" /> Easy Returns</span>
              </div>
            </div>
          </div>
        </div>
        <CustomerFooter />
      </main>);

  }

  return (
    <main className="min-h-screen bg-background">
      <CustomerHeader />
      {/* Hero */}
      <section className="bg-gradient-to-br from-blue-50 via-white to-white py-12 border-b border-border">
        <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-blue-100 text-blue-700 text-xs font-bold mb-4">
              <Shield size={12} /> CERTIFIED REFURBISHED DEVICES
            </div>
            <h1 className="text-4xl font-extrabold text-foreground mb-3">Buy Refurbished Devices</h1>
            <p className="text-lg text-muted-foreground mb-6">Certified devices with warranty, inspection report and battery health guarantee. Save up to 60% vs new.</p>
            <div className="relative max-w-lg">
              <Search size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground" />
              <input type="text" value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} placeholder="Search iPhone, Samsung, MacBook..."
              className="w-full pl-11 pr-4 py-3.5 rounded-2xl border-2 border-border bg-white shadow-sm text-sm focus:outline-none focus:border-primary transition-all" />
            </div>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-10 bg-white border-b border-border">
        <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
          <div className="flex items-center gap-4 overflow-x-auto scrollbar-hide">
            {howItWorks.map((step, i) =>
            <React.Fragment key={step.step}>
                <div className="flex items-center gap-3 flex-shrink-0">
                  <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center text-xl flex-shrink-0">{step.icon}</div>
                  <div>
                    <p className="text-xs font-bold text-foreground">{step.title}</p>
                    <p className="text-xs text-muted-foreground max-w-28 leading-tight">{step.desc}</p>
                  </div>
                </div>
                {i < howItWorks.length - 1 && <ChevronRight size={16} className="text-muted-foreground flex-shrink-0" />}
              </React.Fragment>
            )}
          </div>
        </div>
      </section>

      <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10 py-8">
        {/* Filters */}
        <div className="flex flex-wrap items-center gap-3 mb-6">
          <div className="flex items-center gap-1.5 text-sm font-semibold text-muted-foreground">
            <SlidersHorizontal size={14} /> Filter:
          </div>
          <div className="flex gap-2 flex-wrap">
            {(['all', 'smartphones', 'laptops', 'tablets', 'smartwatches'] as Category[]).map((cat) =>
            <button key={cat} onClick={() => setActiveCategory(cat)}
            className={`px-3.5 py-1.5 rounded-xl text-xs font-semibold capitalize transition-all ${activeCategory === cat ? 'bg-primary text-white' : 'bg-muted text-muted-foreground hover:text-foreground'}`}>
                {cat === 'all' ? 'All Categories' : cat}
              </button>
            )}
          </div>
          <div className="flex gap-2 ml-auto flex-wrap">
            {(['all', 'superb', 'good', 'fair'] as Condition[]).map((cond) =>
            <button key={cond} onClick={() => setActiveCondition(cond)}
            className={`px-3.5 py-1.5 rounded-xl text-xs font-semibold capitalize transition-all ${activeCondition === cond ? 'bg-secondary text-white' : 'bg-muted text-muted-foreground hover:text-foreground'}`}>
                {cond === 'all' ? 'All Conditions' : cond}
              </button>
            )}
          </div>
        </div>

        <p className="text-sm text-muted-foreground mb-5">{filtered.length} devices found</p>

        {/* Device grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {filtered.map((device) => {
            const cond = conditionConfig[device.condition];
            return (
              <div key={device.id} className="bg-white rounded-2xl border border-border hover:shadow-lg hover:-translate-y-0.5 transition-all duration-200 overflow-hidden group">
                <div className="relative p-4 bg-surface">
                  <span className={`absolute top-3 left-3 text-xs px-2 py-0.5 rounded-full font-bold ${cond.color}`}>{cond.label}</span>
                  <span className="absolute top-3 right-3 text-xs px-2 py-0.5 rounded-full font-bold bg-primary/10 text-primary">{device.discount}% OFF</span>
                  <AppImage src={device.image} alt={device.alt} width={200} height={160} className="w-full h-40 object-contain group-hover:scale-105 transition-transform duration-300" />
                </div>
                <div className="p-4">
                  <p className="text-xs text-muted-foreground font-medium mb-0.5">{device.brand}</p>
                  <p className="font-bold text-foreground mb-1">{device.model}</p>
                  <p className="text-xs text-muted-foreground mb-3">{device.storage} · {device.color}</p>
                  <div className="flex items-center gap-2 mb-3">
                    <Battery size={12} className="text-primary" />
                    <span className="text-xs text-muted-foreground">Battery: <strong className="text-foreground">{device.batteryHealth}%</strong></span>
                    <Shield size={12} className="text-primary ml-1" />
                    <span className="text-xs text-muted-foreground">{device.warranty}</span>
                  </div>
                  <div className="flex items-baseline gap-2 mb-4">
                    <span className="text-xl font-extrabold text-foreground">₹{device.price.toLocaleString('en-IN')}</span>
                    <span className="text-sm text-muted-foreground line-through">₹{device.originalPrice.toLocaleString('en-IN')}</span>
                  </div>
                  <button onClick={() => {setSelectedDevice(device);setCheckoutStep('detail');}}
                  className="w-full py-2.5 gradient-green text-white rounded-xl text-sm font-semibold shadow-green btn-press">
                    View Details
                  </button>
                </div>
              </div>);

          })}
        </div>
      </div>
      <CustomerFooter />
    </main>);

}
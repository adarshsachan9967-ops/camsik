'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { CheckCircle, Shield, Truck, Zap, Ban, TrendingUp, Clock, MapPin, Calendar, User, Phone } from 'lucide-react';
import type { SellState } from './SellDeviceWorkflow';

interface Props {
  sellState: SellState;
  onSchedulePickup: () => void;
  onBack: () => void;
}

const sellBenefits = [
  { id: 'benefit-price', icon: TrendingUp, title: 'Highest Prices', desc: 'Get up to 20% more than others', color: 'bg-primary/10 text-primary' },
  { id: 'benefit-payment', icon: Zap, title: 'Instant Payment', desc: 'Receive payment within 30 minutes', color: 'bg-warning/10 text-warning' },
  { id: 'benefit-pickup', icon: Truck, title: 'Free Pickup', desc: 'We pickup your device from your location', color: 'bg-info/10 text-info' },
  { id: 'benefit-secure', icon: Shield, title: '100% Safe & Secure', desc: 'Your data is secure with us', color: 'bg-purple-100 text-purple-600' },
  { id: 'benefit-hidden', icon: Ban, title: 'No Hidden Deductions', desc: 'Transparent pricing you can trust', color: 'bg-danger/10 text-danger' },
];

const timeSlots = ['9:00 AM - 11:00 AM', '11:00 AM - 1:00 PM', '1:00 PM - 3:00 PM', '3:00 PM - 5:00 PM', '5:00 PM - 7:00 PM'];

type QuoteView = 'quote' | 'schedule' | 'confirmed';

export default function StepQuoteResult({ sellState, onSchedulePickup, onBack }: Props) {
  const [view, setView] = useState<QuoteView>('quote');
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [address, setAddress] = useState('');
  const [pinCode, setPinCode] = useState('');
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedSlot, setSelectedSlot] = useState('');
  const [paymentMethod, setPaymentMethod] = useState('UPI');

  const price = sellState.currentPrice;

  if (view === 'confirmed') {
    return (
      <div className="space-y-5 fade-in">
        <div className="bg-white rounded-2xl border border-border shadow-sm overflow-hidden">
          <div className="gradient-green p-8 text-white text-center">
            <div className="text-5xl mb-3">🎉</div>
            <h2 className="text-2xl font-extrabold mb-2">Pickup Scheduled!</h2>
            <p className="text-white/80">Your order has been placed. Check My Orders to track your pickup.</p>
          </div>
          <div className="p-6 space-y-3">
            <div className="flex justify-between text-sm"><span className="text-muted-foreground">Device</span><span className="font-semibold">{sellState.brandName} {sellState.modelName}</span></div>
            <div className="flex justify-between text-sm"><span className="text-muted-foreground">Quoted Price</span><span className="font-bold text-primary">₹{price.toLocaleString('en-IN')}</span></div>
            <div className="flex justify-between text-sm"><span className="text-muted-foreground">Pickup Date</span><span className="font-semibold">{selectedDate}</span></div>
            <div className="flex justify-between text-sm"><span className="text-muted-foreground">Time Slot</span><span className="font-semibold">{selectedSlot}</span></div>
            <div className="flex justify-between text-sm"><span className="text-muted-foreground">Payment</span><span className="font-semibold">{paymentMethod}</span></div>
          </div>
        </div>
        <Link href="/" className="flex items-center justify-center gap-2 w-full py-3.5 gradient-green text-white rounded-xl font-semibold shadow-green btn-press">
          Back to Home
        </Link>
      </div>
    );
  }

  if (view === 'schedule') {
    return (
      <div className="space-y-5 fade-in">
        <div className="bg-white rounded-2xl border border-border shadow-sm p-6">
          <button onClick={() => setView('quote')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-5 transition-colors">
            ← Back to Quote
          </button>
          <h2 className="text-xl font-bold text-foreground mb-1">Schedule Free Pickup</h2>
          <p className="text-sm text-muted-foreground mb-5">Fill in your details to schedule a free pickup</p>

          <div className="space-y-4">
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="block text-sm font-semibold text-foreground mb-1.5">Your Name</label>
                <div className="relative">
                  <User size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                  <input type="text" value={name} onChange={e => setName(e.target.value)} placeholder="Full name"
                    className="w-full pl-9 pr-3 py-2.5 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                </div>
              </div>
              <div>
                <label className="block text-sm font-semibold text-foreground mb-1.5">Phone</label>
                <div className="relative">
                  <Phone size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                  <input type="tel" value={phone} onChange={e => setPhone(e.target.value)} placeholder="+91 XXXXX"
                    className="w-full pl-9 pr-3 py-2.5 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                </div>
              </div>
            </div>
            <div>
              <label className="block text-sm font-semibold text-foreground mb-1.5">Pickup Address</label>
              <div className="relative">
                <MapPin size={14} className="absolute left-3 top-3 text-muted-foreground" />
                <textarea value={address} onChange={e => setAddress(e.target.value)} placeholder="Full address with landmark..." rows={2}
                  className="w-full pl-9 pr-3 py-2.5 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 resize-none" />
              </div>
            </div>
            <div>
              <label className="block text-sm font-semibold text-foreground mb-1.5">PIN Code</label>
              <input type="text" value={pinCode} onChange={e => setPinCode(e.target.value.replace(/\D/g, '').slice(0, 6))} placeholder="6-digit PIN code" maxLength={6}
                className="w-full px-4 py-2.5 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
            </div>
            <div>
              <label className="block text-sm font-semibold text-foreground mb-1.5">Pickup Date</label>
              <div className="relative">
                <Calendar size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                <input type="date" value={selectedDate} onChange={e => setSelectedDate(e.target.value)} min={new Date().toISOString().split('T')[0]}
                  className="w-full pl-9 pr-3 py-2.5 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
              </div>
            </div>
            <div>
              <label className="block text-sm font-semibold text-foreground mb-2">Time Slot</label>
              <div className="grid grid-cols-2 gap-2">
                {timeSlots.map(slot => (
                  <button key={slot} onClick={() => setSelectedSlot(slot)}
                    className={`py-2 px-3 rounded-xl border-2 text-xs font-semibold transition-all ${selectedSlot === slot ? 'border-primary bg-primary/5 text-primary' : 'border-border hover:border-primary/40'}`}>
                    {slot}
                  </button>
                ))}
              </div>
            </div>
            <div>
              <label className="block text-sm font-semibold text-foreground mb-2">Payment Method</label>
              <div className="grid grid-cols-3 gap-2">
                {['UPI', 'Bank Transfer', 'Cash'].map(m => (
                  <button key={m} onClick={() => setPaymentMethod(m)}
                    className={`py-2.5 rounded-xl border-2 text-xs font-semibold transition-all ${paymentMethod === m ? 'border-primary bg-primary/5 text-primary' : 'border-border hover:border-primary/40'}`}>
                    {m}
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-2xl border border-border p-4">
          <div className="flex justify-between text-sm mb-1"><span className="text-muted-foreground">Device</span><span className="font-semibold">{sellState.brandName} {sellState.modelName}</span></div>
          <div className="flex justify-between text-sm font-bold"><span>Quoted Price</span><span className="text-primary">₹{price.toLocaleString('en-IN')}</span></div>
        </div>

        <button
          onClick={() => { if (name && phone && address && pinCode && selectedDate && selectedSlot) setView('confirmed'); }}
          disabled={!name || !phone || !address || !pinCode || !selectedDate || !selectedSlot}
          className="w-full py-4 gradient-green text-white rounded-xl font-bold shadow-green btn-press disabled:opacity-50 flex items-center justify-center gap-2">
          <CheckCircle size={18} /> Confirm Pickup Booking
        </button>
      </div>
    );
  }

  return (
    <div className="space-y-5 fade-in">
      {/* Quote hero card */}
      <div className="bg-white rounded-2xl border border-border shadow-sm overflow-hidden">
        <div className="gradient-green p-6 text-white">
          <div className="text-3xl mb-2">🎉</div>
          <h2 className="text-2xl font-extrabold mb-1">Amazing! Here&apos;s your best price</h2>
          <p className="text-white/80 text-sm">We&apos;ve evaluated your device and here&apos;s what you can get.</p>
        </div>
        <div className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <p className="text-sm font-semibold text-muted-foreground mb-2">Your Best Price</p>
              <div className="text-5xl font-extrabold text-foreground font-tabular mb-3">
                ₹{price.toLocaleString('en-IN')}
              </div>
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <Clock size={14} className="text-warning" />
                <span>Price locked for next <strong className="text-foreground">24 hours</strong></span>
              </div>
            </div>
            <div className="bg-surface rounded-xl p-4">
              <div className="flex items-start gap-4">
                <div className="w-16 h-16 rounded-xl bg-muted overflow-hidden flex-shrink-0">
                  <img src="https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=64&h=64&fit=crop" alt={`${sellState.modelName} device photo`} className="w-full h-full object-cover" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="font-bold text-foreground text-sm">{sellState.brandName} {sellState.modelName}</p>
                  {sellState.storage && <span className="inline-block mt-1 px-2 py-0.5 rounded-lg bg-primary/10 text-primary text-xs font-semibold">{sellState.storage}</span>}
                  {sellState.color && <p className="text-xs text-muted-foreground mt-1">🎨 {sellState.color}</p>}
                  <div className="flex items-center gap-1.5 mt-2 text-xs text-primary font-semibold">
                    <CheckCircle size={12} /> 100% Original Device
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Why sell to Casmik */}
      <div className="bg-white rounded-2xl border border-border shadow-sm p-6">
        <h3 className="font-bold text-foreground mb-4">Why sell to Casmik?</h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-3">
          {sellBenefits.map(b => (
            <div key={b.id} className="flex flex-col items-center text-center p-3 rounded-xl bg-surface">
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center mb-2 ${b.color}`}>
                <b.icon size={18} />
              </div>
              <p className="text-xs font-bold text-foreground leading-tight">{b.title}</p>
              <p className="text-xs text-muted-foreground mt-1 leading-tight">{b.desc}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Action cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <button onClick={() => setView('schedule')}
          className="gradient-green text-white rounded-2xl p-5 flex items-center gap-4 hover:opacity-95 btn-press shadow-green text-left">
          <div className="w-12 h-12 rounded-xl bg-white/20 flex items-center justify-center flex-shrink-0">
            <Truck size={22} className="text-white" />
          </div>
          <div>
            <p className="font-bold text-base">Schedule Free Pickup</p>
            <p className="text-white/80 text-sm mt-0.5">We&apos;ll pickup your device from your location</p>
          </div>
        </button>
        <div className="bg-white border border-border rounded-2xl p-5 flex items-start gap-3">
          <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center flex-shrink-0">
            <Shield size={18} className="text-primary" />
          </div>
          <div>
            <p className="font-bold text-sm text-foreground mb-1">Your data is always safe with us</p>
            <p className="text-xs text-muted-foreground leading-relaxed">We follow industry standard data erasure process before reselling any device.</p>
          </div>
        </div>
      </div>

      <div className="flex items-center justify-center gap-2 text-sm text-muted-foreground bg-white rounded-xl border border-border p-3">
        <Shield size={14} className="text-primary flex-shrink-0" />
        This quote is valid for <strong className="text-foreground">24 hours from now.</strong>
      </div>
    </div>
  );
}
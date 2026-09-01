'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowRight, ChevronRight, CheckCircle, Wrench, Shield, Truck } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import { brands as allBrands, deviceModels } from '@/lib/casmikData';


type RepairStep = 'select-device' | 'select-problem' | 'book-service' | 'schedule' | 'confirmed';

const repairIssues = [
  { id: 'screen', icon: '📱', title: 'Screen Replacement', desc: 'Cracked, broken or unresponsive screen', price: { min: 2500, max: 15000 }, time: '2-4 hours', warranty: '3 months' },
  { id: 'battery', icon: '🔋', title: 'Battery Replacement', desc: 'Battery draining fast or not charging', price: { min: 1500, max: 5000 }, time: '1-2 hours', warranty: '6 months' },
  { id: 'camera', icon: '📷', title: 'Camera Repair', desc: 'Blurry, black screen or camera not working', price: { min: 2000, max: 8000 }, time: '2-3 hours', warranty: '3 months' },
  { id: 'charging', icon: '🔌', title: 'Charging Port', desc: 'Device not charging or loose port', price: { min: 800, max: 3000 }, time: '1-2 hours', warranty: '3 months' },
  { id: 'speaker', icon: '🔊', title: 'Speaker / Mic', desc: 'No sound, distorted audio or mic issues', price: { min: 1000, max: 4000 }, time: '1-2 hours', warranty: '3 months' },
  { id: 'software', icon: '💻', title: 'Software Issues', desc: 'Stuck, slow, virus or OS problems', price: { min: 500, max: 2000 }, time: '1-3 hours', warranty: '1 month' },
  { id: 'water', icon: '💧', title: 'Water Damage', desc: 'Device exposed to water or moisture', price: { min: 3000, max: 12000 }, time: '4-8 hours', warranty: '1 month' },
  { id: 'back-glass', icon: '🪟', title: 'Back Glass', desc: 'Cracked or shattered back panel', price: { min: 1500, max: 6000 }, time: '2-3 hours', warranty: '3 months' },
  { id: 'face-id', icon: '🔐', title: 'Face ID / Touch ID', desc: 'Biometric not working or not recognized', price: { min: 2000, max: 8000 }, time: '2-4 hours', warranty: '3 months' },
  { id: 'wifi', icon: '📶', title: 'WiFi / Bluetooth', desc: 'Connectivity issues or not connecting', price: { min: 1500, max: 5000 }, time: '2-3 hours', warranty: '3 months' },
  { id: 'buttons', icon: '🔘', title: 'Buttons Repair', desc: 'Power, volume or home button not working', price: { min: 800, max: 3000 }, time: '1-2 hours', warranty: '3 months' },
  { id: 'motherboard', icon: '🔧', title: 'Motherboard Issue', desc: 'Device not turning on or major hardware fault', price: { min: 5000, max: 20000 }, time: '1-3 days', warranty: '1 month' },
  { id: 'network', icon: '📡', title: 'Network / SIM', desc: 'No signal, SIM not detected or call issues', price: { min: 1000, max: 4000 }, time: '1-2 hours', warranty: '3 months' },
  { id: 'earpiece', icon: '👂', title: 'Earpiece', desc: 'Cannot hear during calls', price: { min: 800, max: 2500 }, time: '1-2 hours', warranty: '3 months' },
  { id: 'vibration', icon: '📳', title: 'Vibration Motor', desc: 'No vibration or abnormal vibration', price: { min: 600, max: 2000 }, time: '1-2 hours', warranty: '3 months' },
  { id: 'fingerprint', icon: '👆', title: 'Fingerprint Sensor', desc: 'In-display or physical fingerprint not working', price: { min: 1500, max: 5000 }, time: '2-3 hours', warranty: '3 months' },
  { id: 'display-color', icon: '🎨', title: 'Display Color Issue', desc: 'Yellow tint, dead pixels or discoloration', price: { min: 2000, max: 10000 }, time: '2-4 hours', warranty: '3 months' },
  { id: 'overheating', icon: '🌡️', title: 'Overheating', desc: 'Device gets too hot during use', price: { min: 1000, max: 4000 }, time: '2-3 hours', warranty: '1 month' },
  { id: 'data-recovery', icon: '💾', title: 'Data Recovery', desc: 'Recover lost or deleted data', price: { min: 2000, max: 8000 }, time: '2-6 hours', warranty: 'N/A' },
  { id: 'other', icon: '🔩', title: 'Other Issue', desc: 'Any other hardware or software problem', price: { min: 500, max: 15000 }, time: 'Varies', warranty: 'Varies' },
];

const timeSlots = ['9:00 AM - 11:00 AM', '11:00 AM - 1:00 PM', '1:00 PM - 3:00 PM', '3:00 PM - 5:00 PM', '5:00 PM - 7:00 PM'];

const howItWorks = [
  { step: 1, icon: '📱', title: 'Select Device', desc: 'Choose your device category, brand and model.' },
  { step: 2, icon: '🔧', title: 'Select Problem', desc: 'Pick the issue — screen, battery, camera, charging, software or other.' },
  { step: 3, icon: '📋', title: 'Book Service', desc: 'See estimated price, service time and warranty before confirming.' },
  { step: 4, icon: '🚚', title: 'Device Pickup', desc: 'Free pickup from your location or drop at nearest service center.' },
  { step: 5, icon: '✅', title: 'Repair Completed', desc: 'Device repaired with genuine parts and returned with warranty.' },
];

const brands = allBrands;

export default function RepairDevicePage() {
  const [step, setStep] = useState<RepairStep>('select-device');
  const [selectedModel, setSelectedModel] = useState<typeof deviceModels[0] | null>(null);
  const [selectedIssue, setSelectedIssue] = useState<typeof repairIssues[0] | null>(null);
  const [serviceType, setServiceType] = useState<'pickup' | 'drop'>('pickup');
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedSlot, setSelectedSlot] = useState('');
  const [address, setAddress] = useState('');

  const smartphoneModels = deviceModels.filter(m => m.categoryId === 'cat-smartphone').slice(0, 8);

  if (step === 'confirmed') {
    return (
      <main className="min-h-screen bg-background">
        <CustomerHeader />
        <div className="min-h-[calc(100vh-64px)] flex items-center justify-center py-12 px-4">
          <div className="text-center max-w-md">
            <div className="w-20 h-20 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-6">
              <CheckCircle size={40} className="text-primary" />
            </div>
            <h1 className="text-2xl font-extrabold text-foreground mb-2">Repair Booked! 🎉</h1>
            <p className="text-muted-foreground mb-6">Your repair request is confirmed. Our technician will {serviceType === 'pickup' ? 'pick up your device' : 'be ready at the service center'} on the scheduled date.</p>
            <div className="bg-white rounded-2xl border border-border p-5 mb-6 text-left space-y-2">
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Device</span><span className="font-semibold">{selectedModel?.name}</span></div>
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Issue</span><span className="font-semibold">{selectedIssue?.title}</span></div>
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Estimated Cost</span><span className="font-bold text-primary">₹{selectedIssue?.price.min.toLocaleString('en-IN')} - ₹{selectedIssue?.price.max.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Service Type</span><span className="font-semibold capitalize">{serviceType}</span></div>
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Warranty</span><span className="font-semibold">{selectedIssue?.warranty}</span></div>
            </div>
            <Link href="/" className="inline-flex items-center gap-2 px-6 py-3 gradient-green text-white rounded-xl font-semibold shadow-green">
              Back to Home <ArrowRight size={16} />
            </Link>
          </div>
        </div>
        <CustomerFooter />
      </main>
    );
  }

  return (
    <main className="min-h-screen bg-background">
      <CustomerHeader />
      {/* Hero */}
      <section className="bg-gradient-to-br from-orange-50 via-white to-white py-12 border-b border-border">
        <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-orange-100 text-orange-700 text-xs font-bold mb-4">
              <Wrench size={12} /> PROFESSIONAL DEVICE REPAIR
            </div>
            <h1 className="text-4xl font-extrabold text-foreground mb-3">Repair Your Device</h1>
            <p className="text-lg text-muted-foreground">Professional repair with genuine parts, warranty and free pickup. 20+ repair services available.</p>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-8 bg-white border-b border-border">
        <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
          <div className="flex items-center gap-4 overflow-x-auto scrollbar-hide">
            {howItWorks.map((s, i) => (
              <React.Fragment key={s.step}>
                <div className="flex items-center gap-3 flex-shrink-0">
                  <div className="w-10 h-10 rounded-xl bg-orange-100 flex items-center justify-center text-xl flex-shrink-0">{s.icon}</div>
                  <div>
                    <p className="text-xs font-bold text-foreground">{s.title}</p>
                    <p className="text-xs text-muted-foreground max-w-28 leading-tight">{s.desc}</p>
                  </div>
                </div>
                {i < howItWorks.length - 1 && <ChevronRight size={16} className="text-muted-foreground flex-shrink-0" />}
              </React.Fragment>
            ))}
          </div>
        </div>
      </section>

      <div className="max-w-screen-xl mx-auto px-4 lg:px-8 py-8">
        {/* Step indicator */}
        <div className="flex items-center gap-2 mb-8 overflow-x-auto scrollbar-hide">
          {(['select-device', 'select-problem', 'book-service', 'schedule'] as RepairStep[]).map((s, i) => {
            const labels = ['Select Device', 'Select Problem', 'Book Service', 'Schedule'];
            const stepIndex = ['select-device', 'select-problem', 'book-service', 'schedule'].indexOf(step);
            const done = i < stepIndex;
            const active = s === step;
            return (
              <React.Fragment key={s}>
                <div className={`flex items-center gap-2 flex-shrink-0 px-3 py-2 rounded-xl ${active ? 'bg-orange-50' : ''}`}>
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${done ? 'bg-orange-500 text-white' : active ? 'bg-orange-500 text-white' : 'bg-muted text-muted-foreground'}`}>
                    {done ? '✓' : i + 1}
                  </div>
                  <span className={`text-xs font-semibold whitespace-nowrap ${active ? 'text-orange-600' : 'text-muted-foreground'}`}>{labels[i]}</span>
                </div>
                {i < 3 && <div className={`h-0.5 w-6 flex-shrink-0 ${done ? 'bg-orange-500' : 'bg-border'}`} />}
              </React.Fragment>
            );
          })}
        </div>

        {/* Step 1: Select Device */}
        {step === 'select-device' && (
          <div className="bg-white rounded-2xl border border-border p-6 fade-in">
            <h2 className="text-xl font-bold text-foreground mb-1">Select Your Device</h2>
            <p className="text-sm text-muted-foreground mb-5">Choose the device that needs repair</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
              {smartphoneModels.map(model => (
                <button key={model.id} onClick={() => { setSelectedModel(model); setStep('select-problem'); }}
                  className={`flex items-center gap-3 p-3 rounded-xl border-2 text-left transition-all btn-press ${selectedModel?.id === model.id ? 'border-orange-500 bg-orange-50' : 'border-border hover:border-orange-300'}`}>
                  <img src={model.image} alt={model.alt} className="w-12 h-12 rounded-lg object-cover bg-muted flex-shrink-0" />
                  <div>
                    <p className="text-sm font-semibold text-foreground">{model.name}</p>
                    <p className="text-xs text-muted-foreground">{brands.find(b => b.id === model.brandId)?.name}</p>
                  </div>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Step 2: Select Problem */}
        {step === 'select-problem' && (
          <div className="bg-white rounded-2xl border border-border p-6 fade-in">
            <button onClick={() => setStep('select-device')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors">← Back</button>
            <h2 className="text-xl font-bold text-foreground mb-1">What&apos;s the Problem?</h2>
            <p className="text-sm text-muted-foreground mb-5">Select the issue with your <strong>{selectedModel?.name}</strong></p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
              {repairIssues.map(issue => (
                <button key={issue.id} onClick={() => { setSelectedIssue(issue); setStep('book-service'); }}
                  className={`flex flex-col items-start gap-2 p-4 rounded-2xl border-2 text-left transition-all btn-press ${selectedIssue?.id === issue.id ? 'border-orange-500 bg-orange-50' : 'border-border hover:border-orange-300 hover:bg-orange-50/30'}`}>
                  <span className="text-2xl">{issue.icon}</span>
                  <div>
                    <p className="text-sm font-bold text-foreground">{issue.title}</p>
                    <p className="text-xs text-muted-foreground leading-tight mt-0.5">{issue.desc}</p>
                  </div>
                  <p className="text-xs font-semibold text-orange-600">₹{issue.price.min.toLocaleString('en-IN')} - ₹{issue.price.max.toLocaleString('en-IN')}</p>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Step 3: Book Service */}
        {step === 'book-service' && selectedIssue && (
          <div className="max-w-2xl fade-in">
            <button onClick={() => setStep('select-problem')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors">← Back</button>
            <h2 className="text-xl font-bold text-foreground mb-5">Service Details</h2>
            <div className="bg-white rounded-2xl border border-border p-6 mb-5">
              <div className="flex items-start gap-4 pb-5 border-b border-border mb-5">
                <span className="text-4xl">{selectedIssue.icon}</span>
                <div className="flex-1">
                  <h3 className="font-bold text-foreground text-lg">{selectedIssue.title}</h3>
                  <p className="text-sm text-muted-foreground">{selectedIssue.desc}</p>
                </div>
              </div>
              <div className="grid grid-cols-3 gap-4">
                <div className="text-center p-3 bg-surface rounded-xl">
                  <p className="text-xs text-muted-foreground mb-1">Estimated Cost</p>
                  <p className="font-bold text-foreground text-sm">₹{selectedIssue.price.min.toLocaleString('en-IN')} - ₹{selectedIssue.price.max.toLocaleString('en-IN')}</p>
                </div>
                <div className="text-center p-3 bg-surface rounded-xl">
                  <p className="text-xs text-muted-foreground mb-1">Service Time</p>
                  <p className="font-bold text-foreground text-sm">{selectedIssue.time}</p>
                </div>
                <div className="text-center p-3 bg-surface rounded-xl">
                  <p className="text-xs text-muted-foreground mb-1">Warranty</p>
                  <p className="font-bold text-foreground text-sm">{selectedIssue.warranty}</p>
                </div>
              </div>
            </div>
            <div className="bg-white rounded-2xl border border-border p-6 mb-5">
              <p className="font-bold text-foreground mb-3">Service Type</p>
              <div className="grid grid-cols-2 gap-3">
                <button onClick={() => setServiceType('pickup')}
                  className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${serviceType === 'pickup' ? 'border-orange-500 bg-orange-50' : 'border-border hover:border-orange-300'}`}>
                  <Truck size={20} className="text-orange-500" />
                  <p className="font-semibold text-sm text-foreground">Free Pickup</p>
                  <p className="text-xs text-muted-foreground text-center">We pick up from your location</p>
                </button>
                <button onClick={() => setServiceType('drop')}
                  className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${serviceType === 'drop' ? 'border-orange-500 bg-orange-50' : 'border-border hover:border-orange-300'}`}>
                  <Wrench size={20} className="text-orange-500" />
                  <p className="font-semibold text-sm text-foreground">Drop at Center</p>
                  <p className="text-xs text-muted-foreground text-center">Drop at nearest service center</p>
                </button>
              </div>
            </div>
            <div className="flex items-center gap-3 bg-orange-50 rounded-xl p-4 mb-5">
              <Shield size={16} className="text-orange-500 flex-shrink-0" />
              <p className="text-sm text-foreground">All repairs use genuine parts and come with a warranty. Final price confirmed after diagnosis.</p>
            </div>
            <button onClick={() => setStep('schedule')}
              className="w-full py-4 bg-orange-500 hover:bg-orange-600 text-white rounded-xl font-bold text-base btn-press flex items-center justify-center gap-2 transition-colors">
              Book This Repair <ArrowRight size={16} />
            </button>
          </div>
        )}

        {/* Step 4: Schedule */}
        {step === 'schedule' && (
          <div className="max-w-lg fade-in">
            <button onClick={() => setStep('book-service')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors">← Back</button>
            <h2 className="text-xl font-bold text-foreground mb-5">Schedule {serviceType === 'pickup' ? 'Pickup' : 'Drop-off'}</h2>
            <div className="bg-white rounded-2xl border border-border p-6 space-y-5">
              {serviceType === 'pickup' && (
                <div>
                  <label className="block text-sm font-semibold text-foreground mb-1.5">Pickup Address</label>
                  <textarea value={address} onChange={e => setAddress(e.target.value)} placeholder="Enter your full address..." rows={3}
                    className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-orange-300 resize-none" />
                </div>
              )}
              <div>
                <label className="block text-sm font-semibold text-foreground mb-1.5">Select Date</label>
                <input type="date" value={selectedDate} onChange={e => setSelectedDate(e.target.value)} min={new Date().toISOString().split('T')[0]}
                  className="w-full px-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-orange-300" />
              </div>
              <div>
                <label className="block text-sm font-semibold text-foreground mb-2">Select Time Slot</label>
                <div className="grid grid-cols-2 gap-2">
                  {timeSlots.map(slot => (
                    <button key={slot} onClick={() => setSelectedSlot(slot)}
                      className={`py-2.5 px-3 rounded-xl border-2 text-xs font-semibold transition-all ${selectedSlot === slot ? 'border-orange-500 bg-orange-50 text-orange-600' : 'border-border hover:border-orange-300'}`}>
                      {slot}
                    </button>
                  ))}
                </div>
              </div>
            </div>
            {selectedDate && selectedSlot && (serviceType === 'drop' || address) && (
              <button onClick={() => setStep('confirmed')}
                className="w-full mt-5 py-4 bg-orange-500 hover:bg-orange-600 text-white rounded-xl font-bold text-base btn-press flex items-center justify-center gap-2 transition-colors fade-in">
                <CheckCircle size={18} /> Confirm Repair Booking
              </button>
            )}
          </div>
        )}
      </div>
      <CustomerFooter />
    </main>
  );
}

'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowRight, ChevronRight, CheckCircle, RefreshCw, Zap, TrendingDown, Camera, ShieldCheck } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import { deviceModels } from '@/lib/casmikData';
import AppImage from '@/components/ui/AppImage';

type ExchangeStep = 'select-old' | 'condition' | 'select-new' | 'summary' | 'confirmed';

const conditionQuestions = [
  { 
    id: 'sensor', 
    question: 'Sensor & Optics Condition?', 
    options: [
      { label: 'Spotless & Clean', adj: 0 }, 
      { label: 'Minor Dust (Normal)', adj: -1500 }, 
      { label: 'Sensor Scratches', adj: -8000 }, 
      { label: 'Fungus on Sensor Glass', adj: -12000 }
    ] 
  },
  { 
    id: 'shutter', 
    question: 'Shutter Count Actuations?', 
    options: [
      { label: 'Low (< 10,000)', adj: 3000 }, 
      { label: 'Moderate (10,000 - 50,000)', adj: 0 }, 
      { label: 'High (50,000 - 100,000)', adj: -4000 }, 
      { label: 'Very High (> 100,000)', adj: -8000 }
    ] 
  },
  { 
    id: 'body', 
    question: 'Body & Rubber Grip Condition?', 
    options: [
      { label: 'Mint / Like New', adj: 2000 }, 
      { label: 'Good (Minor Scuffs)', adj: 0 }, 
      { label: 'Peeling Rubber / Dent', adj: -3000 }, 
      { label: 'Heavy Wear / Missing Port Covers', adj: -5000 }
    ] 
  },
  { 
    id: 'functional', 
    question: 'Autofocus & Electronic Functions?', 
    options: [
      { label: '100% Fully Functional', adj: 0 }, 
      { label: 'Minor Dial / Button Sticky', adj: -2500 }, 
      { label: 'Autofocus Hunt / Error', adj: -7000 }
    ] 
  },
];

const newUpgradeCameras = [
  { 
    id: 'new-001', 
    brand: 'Sony', 
    model: 'Sony Alpha 7 IV (ILCE-7M4)', 
    category: 'Full-Frame Mirrorless', 
    price: 185000, 
    image: 'https://camsik.com/img/purchaseProducts/ilce_7m4_1_png.png', 
    alt: 'Sony Alpha 7 IV' 
  },
  { 
    id: 'new-002', 
    brand: 'Canon', 
    model: 'Canon EOS R6 Mark II', 
    category: 'Full-Frame Mirrorless', 
    price: 198000, 
    image: 'https://camsik.com/img/purchaseProducts/eos_r6_mark_ii_body_1_png.png', 
    alt: 'Canon EOS R6 Mark II' 
  },
  { 
    id: 'new-003', 
    brand: 'Nikon', 
    model: 'Nikon Z8 Flagship Body', 
    category: 'Full-Frame Mirrorless', 
    price: 295000, 
    image: 'https://camsik.com/img/purchaseProducts/nikon_z8_1_png.png', 
    alt: 'Nikon Z8' 
  },
  { 
    id: 'new-004', 
    brand: 'Fujifilm', 
    model: 'Fujifilm X-T5 Mirrorless', 
    category: 'APS-C Mirrorless', 
    price: 145000, 
    image: 'https://camsik.com/img/purchaseProducts/fujifilm_xt5_1_png.png', 
    alt: 'Fujifilm X-T5' 
  },
  { 
    id: 'new-005', 
    brand: 'Sony', 
    model: 'Sony FE 24-70mm f/2.8 GM II', 
    category: 'G Master Zoom Lens', 
    price: 175000, 
    image: 'https://camsik.com/img/purchaseProducts/sony_fe_24_70mm_gm2_1_png.png', 
    alt: 'Sony 24-70 GM II' 
  },
  { 
    id: 'new-006', 
    brand: 'DJI', 
    model: 'DJI RS 3 Pro Combo Gimbal', 
    category: '3-Axis Gimbal Stabilizer', 
    price: 64900, 
    image: 'https://camsik.com/img/purchaseProducts/dji_rs3_pro_1_png.png', 
    alt: 'DJI RS 3 Pro' 
  },
];

const howItWorks = [
  { step: 1, icon: '📷', title: 'Select Old Camera', desc: 'Choose the camera body, lens or gimbal you want to trade in.' },
  { step: 2, icon: '💰', title: 'Get Instant Trade-In Value', desc: 'Receive instant valuation calibrated with shutter count diagnostics.' },
  { step: 3, icon: '🔄', title: 'Choose Upgrade Gear', desc: 'Select your flagship mirrorless camera or GM lens.' },
  { step: 4, icon: '💳', title: 'Pay Difference', desc: 'Pay only the difference with guaranteed ₹3,000 extra exchange bonus.' },
  { step: 5, icon: '🚚', title: 'Doorstep Handover', desc: 'Simultaneous pickup of old camera and delivery of upgrade.' },
];

export default function ExchangeDevicePage() {
  const [step, setStep] = useState<ExchangeStep>('select-old');
  const [selectedOldModel, setSelectedOldModel] = useState<typeof deviceModels[0] | null>(null);
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [selectedNewDevice, setSelectedNewDevice] = useState<typeof newUpgradeCameras[0] | null>(null);
  const [exchangeBonus] = useState(3000);

  const oldDeviceValue = selectedOldModel
    ? Math.max(selectedOldModel.basePrice + Object.values(answers).reduce((a, b) => a + b, 0), 10000)
    : 0;

  const payable = selectedNewDevice
    ? Math.max(selectedNewDevice.price - oldDeviceValue - exchangeBonus, 0)
    : 0;

  const cameraModels = deviceModels.slice(0, 12);

  if (step === 'confirmed') {
    return (
      <main className="min-h-screen bg-background">
        <CustomerHeader />
        <div className="min-h-[calc(100vh-64px)] flex items-center justify-center py-12 px-4">
          <div className="text-center max-w-md">
            <div className="w-20 h-20 rounded-full bg-emerald-500/10 flex items-center justify-center mx-auto mb-6 text-emerald-600">
              <CheckCircle size={40} />
            </div>
            <h1 className="text-2xl font-black text-foreground mb-2">Camera Exchange Booked! 🎉</h1>
            <p className="text-muted-foreground mb-6">
              Our camera technician will visit your doorstep with the {selectedNewDevice?.model} and perform digital verification of your {selectedOldModel?.name}.
            </p>
            <div className="bg-white rounded-2xl border border-border p-5 mb-6 text-left space-y-2 text-sm shadow-sm">
              <div className="flex justify-between"><span className="text-muted-foreground">Your Gear</span><span className="font-semibold">{selectedOldModel?.name}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Upgrade Gear</span><span className="font-semibold">{selectedNewDevice?.model}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Trade-In Value</span><span className="font-bold text-emerald-600">₹{oldDeviceValue.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Camsik Exchange Bonus</span><span className="font-bold text-primary">+₹{exchangeBonus.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between pt-2 border-t border-border"><span className="font-bold text-foreground">Final Balance Payable</span><span className="font-black text-lg text-primary">₹{payable.toLocaleString('en-IN')}</span></div>
            </div>
            <Link href="/" className="inline-flex items-center gap-2 px-6 py-3 gradient-green text-white rounded-xl font-bold shadow-green">
              Back to Camsik Home <ArrowRight size={16} />
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
      <section className="bg-gradient-to-br from-primary-50 via-white to-surface py-12 border-b border-border">
        <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
          <div className="max-w-3xl">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold mb-4">
              <RefreshCw size={12} className="animate-spin-slow" />
              UPGRADE &amp; TRADE-IN PROGRAM
            </div>
            <h1 className="text-3xl sm:text-4xl font-black text-foreground mb-3">
              Exchange Your Camera for a Newer Model
            </h1>
            <p className="text-sm sm:text-base text-muted-foreground">
              Get an extra ₹3,000 guaranteed exchange bonus on top of market valuation. Seamless doorstep handover with zero downtime for your photography projects.
            </p>
          </div>
        </div>
      </section>

      {/* How it Works Bar */}
      <section className="py-6 bg-white border-b border-border overflow-x-auto scrollbar-none">
        <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
          <div className="flex items-center gap-6 min-w-[700px]">
            {howItWorks.map((s, i) => (
              <React.Fragment key={s.step}>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center text-xl shrink-0">
                    {s.icon}
                  </div>
                  <div>
                    <p className="text-xs font-bold text-foreground">{s.title}</p>
                    <p className="text-[11px] text-muted-foreground leading-tight max-w-[140px]">{s.desc}</p>
                  </div>
                </div>
                {i < howItWorks.length - 1 && <ChevronRight size={16} className="text-muted-foreground shrink-0" />}
              </React.Fragment>
            ))}
          </div>
        </div>
      </section>

      {/* Exchange Wizard Steps */}
      <div className="max-w-screen-xl mx-auto px-4 lg:px-8 py-10">
        {/* Step 1: Select Old Device */}
        {step === 'select-old' && (
          <div className="bg-white rounded-3xl border border-border p-6 sm:p-8 shadow-sm">
            <h2 className="text-2xl font-black text-foreground mb-1">Select Your Existing Camera Gear</h2>
            <p className="text-sm text-muted-foreground mb-6">Choose the camera body, lens or gimbal you want to trade in</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
              {cameraModels.map((model) => (
                <button
                  key={model.id}
                  onClick={() => {
                    setSelectedOldModel(model);
                    setStep('condition');
                  }}
                  className={`flex items-center gap-3.5 p-4 rounded-2xl border text-left transition-all hover:border-primary hover:shadow-md ${
                    selectedOldModel?.id === model.id ? 'border-primary bg-primary/5 ring-2 ring-primary/20' : 'border-border bg-white'
                  }`}
                >
                  <div className="w-14 h-14 relative rounded-xl bg-slate-50 overflow-hidden shrink-0 border border-border">
                    <AppImage src={model.image} alt={model.alt} fill className="object-contain p-1" />
                  </div>
                  <div>
                    <p className="text-xs font-bold text-primary uppercase">{model.brand}</p>
                    <p className="text-sm font-extrabold text-foreground line-clamp-1">{model.name}</p>
                    <p className="text-xs font-bold text-emerald-600 mt-0.5">Up to ₹{model.basePrice.toLocaleString('en-IN')}</p>
                  </div>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Step 2: Answer Condition Questions */}
        {step === 'condition' && selectedOldModel && (
          <div className="bg-white rounded-3xl border border-border p-6 sm:p-8 shadow-sm max-w-3xl mx-auto">
            <button
              onClick={() => setStep('select-old')}
              className="text-xs font-bold text-muted-foreground hover:text-foreground mb-4 inline-block"
            >
              &larr; Back to Gear Selection
            </button>
            <h2 className="text-2xl font-black text-foreground mb-1">
              Verify Condition of {selectedOldModel.name}
            </h2>
            <p className="text-sm text-muted-foreground mb-6">
              Answer 4 quick questions for guaranteed trade-in value calculation
            </p>

            <div className="space-y-6">
              {conditionQuestions.map((q) => (
                <div key={q.id} className="p-4 rounded-2xl bg-surface border border-border/80">
                  <p className="text-sm font-bold text-foreground mb-3">{q.question}</p>
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                    {q.options.map((opt) => {
                      const isSelected = answers[q.id] === opt.adj;
                      return (
                        <button
                          key={opt.label}
                          onClick={() => setAnswers((prev) => ({ ...prev, [q.id]: opt.adj }))}
                          className={`p-3 rounded-xl border text-xs font-bold text-center transition-all ${
                            isSelected
                              ? 'border-primary bg-primary text-white shadow-sm'
                              : 'border-border bg-white text-muted-foreground hover:text-foreground hover:border-primary/40'
                          }`}
                        >
                          {opt.label}
                        </button>
                      );
                    })}
                  </div>
                </div>
              ))}
            </div>

            <div className="mt-8 flex justify-between items-center pt-6 border-t border-border">
              <div>
                <p className="text-xs text-muted-foreground">Estimated Trade-In Credit</p>
                <p className="text-2xl font-black text-emerald-600">₹{oldDeviceValue.toLocaleString('en-IN')}</p>
              </div>
              <button
                onClick={() => setStep('select-new')}
                className="px-8 py-3.5 rounded-xl gradient-green text-white font-extrabold text-sm shadow-green hover:shadow-lg transition-all"
              >
                Choose Upgrade Camera &rarr;
              </button>
            </div>
          </div>
        )}

        {/* Step 3: Select New Upgrade Camera */}
        {step === 'select-new' && (
          <div className="bg-white rounded-3xl border border-border p-6 sm:p-8 shadow-sm">
            <button
              onClick={() => setStep('condition')}
              className="text-xs font-bold text-muted-foreground hover:text-foreground mb-4 inline-block"
            >
              &larr; Back to Condition
            </button>
            <h2 className="text-2xl font-black text-foreground mb-1">
              Select Your Target Camera or Lens
            </h2>
            <p className="text-sm text-muted-foreground mb-6">
              Pick the gear you want delivered to your doorstep
            </p>

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
              {newUpgradeCameras.map((cam) => {
                const effectivePrice = Math.max(cam.price - oldDeviceValue - exchangeBonus, 0);
                return (
                  <div
                    key={cam.id}
                    className="p-5 rounded-3xl border border-border/80 bg-white hover:border-primary/50 hover:shadow-lg transition-all flex flex-col justify-between"
                  >
                    <div>
                      <div className="relative aspect-video rounded-2xl bg-slate-50 overflow-hidden mb-4 border border-border/60">
                        <AppImage src={cam.image} alt={cam.alt} fill className="object-contain p-2" />
                      </div>
                      <span className="text-[11px] font-bold text-primary bg-primary/10 px-2.5 py-0.5 rounded-full">
                        {cam.category}
                      </span>
                      <h3 className="font-black text-foreground text-base mt-2">{cam.model}</h3>
                      <p className="text-xs text-muted-foreground mt-1">MRP: ₹{cam.price.toLocaleString('en-IN')}</p>
                    </div>

                    <div className="mt-6 pt-4 border-t border-border/60">
                      <div className="flex justify-between items-end mb-3">
                        <div>
                          <p className="text-[11px] text-muted-foreground">You Pay Only</p>
                          <p className="text-xl font-black text-primary">₹{effectivePrice.toLocaleString('en-IN')}</p>
                        </div>
                        <span className="text-[11px] font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full">
                          Save ₹{(oldDeviceValue + exchangeBonus).toLocaleString('en-IN')}
                        </span>
                      </div>

                      <button
                        onClick={() => {
                          setSelectedNewDevice(cam);
                          setStep('summary');
                        }}
                        className="w-full py-3 rounded-xl gradient-green text-white font-bold text-xs uppercase tracking-wider shadow-green hover:shadow-lg transition-all"
                      >
                        Select This Upgrade
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Step 4: Summary & Confirm */}
        {step === 'summary' && selectedOldModel && selectedNewDevice && (
          <div className="bg-white rounded-3xl border border-border p-6 sm:p-8 shadow-sm max-w-xl mx-auto">
            <button
              onClick={() => setStep('select-new')}
              className="text-xs font-bold text-muted-foreground hover:text-foreground mb-4 inline-block"
            >
              &larr; Back to Upgrade Selection
            </button>
            <h2 className="text-2xl font-black text-foreground mb-1">Exchange Order Summary</h2>
            <p className="text-sm text-muted-foreground mb-6">Review your trade-in breakdown before booking</p>

            <div className="space-y-3 p-4 rounded-2xl bg-surface border border-border/80 mb-6 text-sm">
              <div className="flex justify-between"><span className="text-muted-foreground">Upgrading To</span><span className="font-bold text-foreground">{selectedNewDevice.model}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Upgrade Camera Price</span><span className="font-semibold text-foreground">₹{selectedNewDevice.price.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Your Gear Valuation ({selectedOldModel.name})</span><span className="font-semibold text-emerald-600">- ₹{oldDeviceValue.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Special Camsik Exchange Bonus</span><span className="font-bold text-emerald-600">- ₹{exchangeBonus.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between pt-3 border-t border-border font-black text-base">
                <span>Net Amount to Pay on Delivery</span>
                <span className="text-primary text-xl">₹{payable.toLocaleString('en-IN')}</span>
              </div>
            </div>

            <button
              onClick={() => setStep('confirmed')}
              className="w-full py-4 rounded-xl gradient-green text-white font-black text-sm uppercase tracking-wider shadow-green hover:shadow-lg transition-all"
            >
              Confirm Doorstep Exchange &rarr;
            </button>
          </div>
        )}
      </div>

      <CustomerFooter />
    </main>
  );
}
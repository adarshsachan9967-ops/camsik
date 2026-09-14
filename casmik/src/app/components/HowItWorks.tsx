'use client';
import React, { useState } from 'react';
import { Camera, ClipboardCheck, Banknote, Calendar, ShieldCheck, Sparkles, CheckCircle2, ArrowRight } from 'lucide-react';
import Link from 'next/link';

const tabs = [
  { id: 'tab-sell', label: 'Sell Camera Gear' },
  { id: 'tab-buy', label: 'Buy Refurbished Cameras' },
  { id: 'tab-exchange', label: 'Exchange & Upgrade' },
];

const flows: Record<string, { icon: React.ElementType; stepNumber: string; title: string; desc: string; highlight: string }[]> = {
  'tab-sell': [
    {
      icon: Camera,
      stepNumber: '01',
      title: 'Select Camera & Lens',
      desc: 'Pick your DSLR, Mirrorless, Cinema Camera, Lens, or Gimbal model and tell us about its physical and optical condition.',
      highlight: 'Instant AI Quote in 60s',
    },
    {
      icon: Calendar,
      stepNumber: '02',
      title: 'Schedule Free Doorstep Pickup',
      desc: 'Choose your preferred date and time slot. Our camera evaluation specialist arrives at your home or studio.',
      highlight: 'Available in 200+ Cities',
    },
    {
      icon: Banknote,
      stepNumber: '03',
      title: 'Get Instant Bank Payment',
      desc: 'Quick 15-minute sensor, shutter count, and autofocus test. Payment is transferred directly to your bank account or UPI on the spot.',
      highlight: 'Zero Commission Fees',
    },
  ],
  'tab-buy': [
    {
      icon: Camera,
      stepNumber: '01',
      title: 'Browse Certified Gear',
      desc: 'Explore pre-owned DSLRs, Mirrorless bodies, and lenses tested through our rigorous 45-point optical and mechanical inspection.',
      highlight: 'Genuine Shutter Count Stated',
    },
    {
      icon: ShieldCheck,
      stepNumber: '02',
      title: 'Select Condition Grade',
      desc: 'Choose between Like New, Superb, and Good grades with crystal clear condition reports, actual photos, and battery health.',
      highlight: '6-Month Warranty Included',
    },
    {
      icon: Banknote,
      stepNumber: '03',
      title: 'Fast Delivery & Payout Protection',
      desc: 'Secure checkout with zero-cost EMI options. Receive insured doorstep delivery with a 7-day hassle-free return guarantee.',
      highlight: '100% Transit Insured',
    },
  ],
  'tab-exchange': [
    {
      icon: Camera,
      stepNumber: '01',
      title: 'Evaluate Existing Camera',
      desc: 'Provide details of your old camera or lens to calculate guaranteed trade-in credit toward your next upgrade.',
      highlight: 'Extra ₹3,000 Exchange Bonus',
    },
    {
      icon: ClipboardCheck,
      stepNumber: '02',
      title: 'Pick Upgrade Body or Lens',
      desc: 'Browse our flagship mirrorless camera lineup or premium fast primes and zooms to replace your aging gear.',
      highlight: 'Wide Selection in Stock',
    },
    {
      icon: Banknote,
      stepNumber: '03',
      title: 'Handover & Swap at Doorstep',
      desc: 'Our technician brings your upgraded camera, tests your old gear at your doorstep, and you pay only the difference amount.',
      highlight: 'Same-Day Swap Experience',
    },
  ],
};

export default function HowItWorks() {
  const [activeTab, setActiveTab] = useState('tab-sell');
  const steps = flows[activeTab] || flows['tab-sell'];

  return (
    <section id="how-it-works" className="py-16 lg:py-24 bg-gradient-to-b from-white via-surface to-white relative">
      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
        <div className="text-center max-w-3xl mx-auto mb-12">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-3">
            <Sparkles size={13} />
            Hassle-Free Camera Liquidation
          </div>
          <h2 className="text-3xl sm:text-4xl font-black text-foreground tracking-tight">
            How Selling on <span className="text-primary">Camsik</span> Works
          </h2>
          <p className="text-muted-foreground mt-3 text-sm sm:text-base">
            Turn your unused camera gear into instant liquid cash in 3 effortless steps.
          </p>
        </div>

        {/* Tab Buttons (Sell / Buy / Exchange - No Repair!) */}
        <div className="flex items-center justify-center gap-2.5 mb-14 flex-wrap">
          {tabs.map((tab) => {
            const isActive = activeTab === tab.id;
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`px-6 py-3 rounded-2xl text-sm font-bold transition-all duration-200 btn-press ${
                  isActive
                    ? 'gradient-green text-white shadow-green ring-2 ring-primary/30'
                    : 'bg-white border border-border text-muted-foreground hover:text-foreground hover:border-primary/40 shadow-sm'
                }`}
              >
                {tab.label}
              </button>
            );
          })}
        </div>

        {/* 3 Step Cards with Connectors */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 relative">
          {steps.map((step, i) => {
            const Icon = step.icon;
            return (
              <div
                key={`${activeTab}-${step.stepNumber}`}
                className="bg-white rounded-3xl p-8 border border-border/80 shadow-md hover:shadow-xl transition-all duration-300 relative flex flex-col justify-between group hover:border-primary/40 hover:-translate-y-1"
              >
                {/* Step indicator watermark */}
                <div className="absolute top-6 right-6 text-4xl font-black text-slate-100 group-hover:text-primary/10 transition-colors pointer-events-none select-none">
                  {step.stepNumber}
                </div>

                <div>
                  {/* Icon Circle */}
                  <div className="w-16 h-16 rounded-2xl gradient-green flex items-center justify-center mb-6 shadow-green text-white group-hover:scale-110 transition-transform duration-300">
                    <Icon size={28} />
                  </div>

                  <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-600 bg-emerald-50 px-2.5 py-0.5 rounded-full mb-3">
                    <CheckCircle2 size={12} />
                    {step.highlight}
                  </span>

                  <h3 className="font-black text-xl text-foreground mb-3 group-hover:text-primary transition-colors">
                    {step.title}
                  </h3>

                  <p className="text-sm text-muted-foreground leading-relaxed">
                    {step.desc}
                  </p>
                </div>

                <div className="mt-8 pt-4 border-t border-border/60 flex items-center justify-between text-xs font-bold text-primary">
                  <span>Step {step.stepNumber} of 03</span>
                  <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
                </div>
              </div>
            );
          })}
        </div>

        {/* Action Button */}
        <div className="mt-12 text-center">
          <Link
            href="/sell-device-get-quote"
            className="inline-flex items-center gap-2 px-8 py-4 rounded-2xl gradient-green text-white font-extrabold text-base shadow-green hover:shadow-xl hover:scale-105 transition-all duration-200 btn-press"
          >
            <Camera size={20} />
            Check Your Camera&apos;s Resale Value Now
          </Link>
        </div>
      </div>
    </section>
  );
}
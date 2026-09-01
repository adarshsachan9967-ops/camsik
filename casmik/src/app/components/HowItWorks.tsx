'use client';
import React, { useState } from 'react';
import { Smartphone, MessageSquare, Tag, Calendar, CreditCard } from 'lucide-react';

const tabs = [
  { id: 'tab-sell', label: 'Sell Device' },
  { id: 'tab-buy', label: 'Buy Refurbished' },
  { id: 'tab-exchange', label: 'Exchange' },
  { id: 'tab-repair', label: 'Repair' },
];

const flows: Record<string, { icon: React.ElementType; title: string; desc: string }[]> = {
  'tab-sell': [
    { icon: Smartphone, title: 'Select Device', desc: 'Choose your device category, brand, model and storage variant.' },
    { icon: MessageSquare, title: 'Answer Questions', desc: 'Tell us about your device condition — display, body, battery, accessories.' },
    { icon: Tag, title: 'Get Instant Quote', desc: 'Receive a transparent price quote with full breakdown in seconds.' },
    { icon: Calendar, title: 'Schedule Pickup', desc: 'Book a free doorstep pickup at your preferred date and time slot.' },
    { icon: CreditCard, title: 'Get Paid', desc: 'Receive instant payment via UPI or bank transfer after inspection.' },
  ],
  'tab-buy': [
    { icon: Smartphone, title: 'Choose Device', desc: 'Browse certified refurbished devices by category, brand or model.' },
    { icon: Tag, title: 'Select Condition', desc: 'Pick Fair, Good or Superb condition based on your budget and preference.' },
    { icon: MessageSquare, title: 'Check Details', desc: 'Review inspection report, battery health, warranty and accessories.' },
    { icon: CreditCard, title: 'Place Order', desc: 'Checkout securely via UPI, card or EMI with instant confirmation.' },
    { icon: Calendar, title: 'Get Delivery', desc: 'Receive your device at home within 2–3 business days.' },
  ],
  'tab-exchange': [
    { icon: Smartphone, title: 'Select Old Device', desc: 'Tell us about the device you want to exchange.' },
    { icon: Tag, title: 'Get Exchange Value', desc: 'Receive instant valuation for your old device.' },
    { icon: MessageSquare, title: 'Choose New Device', desc: 'Browse and select your new refurbished or upgraded device.' },
    { icon: CreditCard, title: 'Pay Difference', desc: 'Pay only the difference between new device price and exchange value.' },
    { icon: Calendar, title: 'Get New Device', desc: 'Simultaneous pickup of old and delivery of new device.' },
  ],
  'tab-repair': [
    { icon: Smartphone, title: 'Select Device', desc: 'Choose your device category, brand and model.' },
    { icon: MessageSquare, title: 'Select Problem', desc: 'Pick the issue — screen, battery, camera, charging, software or other.' },
    { icon: Tag, title: 'Book Service', desc: 'See estimated price, service time and warranty before confirming.' },
    { icon: Calendar, title: 'Device Pickup', desc: 'Free pickup from your location or drop at nearest service center.' },
    { icon: CreditCard, title: 'Repair Completed', desc: 'Device repaired with genuine parts and returned with warranty.' },
  ],
};

export default function HowItWorks() {
  const [activeTab, setActiveTab] = useState('tab-sell');
  const steps = flows[activeTab];

  return (
    <section id="how-it-works" className="py-14 lg:py-20 bg-surface">
      <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
        <div className="text-center mb-10">
          <h2 className="text-3xl font-bold text-foreground mb-3">How Casmik Works</h2>
          <p className="text-muted-foreground">Simple, transparent and fast — just 5 steps to get started</p>
        </div>

        {/* Tabs */}
        <div className="flex items-center justify-center gap-2 mb-10 flex-wrap">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`px-5 py-2.5 rounded-xl text-sm font-semibold transition-all duration-150 btn-press ${
                activeTab === tab.id
                  ? 'gradient-green text-white shadow-green'
                  : 'bg-white border border-border text-muted-foreground hover:text-foreground hover:border-primary/30'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* Steps */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4 fade-in" key={activeTab}>
          {steps.map((step, i) => (
            <div key={`step-${activeTab}-${i}`} className="relative flex flex-col items-center text-center">
              {/* Connector line */}
              {i < steps.length - 1 && (
                <div className="hidden lg:block absolute top-6 left-1/2 w-full h-0.5 bg-border z-0" />
              )}
              <div className="relative z-10 w-12 h-12 rounded-full gradient-green flex items-center justify-center mb-4 shadow-green">
                <step.icon size={20} className="text-white" />
                <span className="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-white border-2 border-primary text-xs font-bold text-primary flex items-center justify-center">
                  {i + 1}
                </span>
              </div>
              <h4 className="font-bold text-sm text-foreground mb-1.5">{step.title}</h4>
              <p className="text-xs text-muted-foreground leading-relaxed">{step.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
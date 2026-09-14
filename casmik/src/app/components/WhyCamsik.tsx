'use client';
import React from 'react';
import { 
  TrendingUp, 
  Zap, 
  Truck, 
  ShieldCheck, 
  FileCheck2, 
  EyeOff, 
  Camera, 
  Sparkles, 
  Scale, 
  Clock 
} from 'lucide-react';

const reasons = [
  {
    id: 'why-price',
    icon: TrendingUp,
    title: 'Objective AI Valuation',
    desc: 'Our dynamic pricing engine factors in current sensor condition, shutter count, and market liquidity to give you up to 25% higher value than offline shops.',
    badge: 'Best Price',
    color: 'bg-emerald-50 text-emerald-600 border-emerald-200',
  },
  {
    id: 'why-payment',
    icon: Zap,
    title: 'Instant Bank Payout',
    desc: 'Receive funds directly into your bank account or UPI within 2 minutes of doorstep inspection — before handing over your camera gear.',
    badge: 'Instant UPI/IMPS',
    color: 'bg-amber-50 text-amber-600 border-amber-200',
  },
  {
    id: 'why-pickup',
    icon: Truck,
    title: 'Free Doorstep Evaluation',
    desc: 'Trained camera technicians visit your home, studio, or office across 200+ cities in India. Zero pickup or travel charges.',
    badge: '200+ Cities',
    color: 'bg-blue-50 text-blue-600 border-blue-200',
  },
  {
    id: 'why-inspection',
    icon: Camera,
    title: 'Digital Shutter & Sensor Check',
    desc: 'We perform transparent, digital shutter counter readings and laser sensor inspections right in front of you. No hidden deductions.',
    badge: 'Transparent QA',
    color: 'bg-indigo-50 text-indigo-600 border-indigo-200',
  },
  {
    id: 'why-data',
    icon: EyeOff,
    title: 'Factory Memory Wipe',
    desc: 'Certified complete deletion of memory buffers and metadata on cameras to ensure 100% privacy protection of your past photos and EXIF data.',
    badge: '100% Secure',
    color: 'bg-purple-50 text-purple-600 border-purple-200',
  },
  {
    id: 'why-invoice',
    icon: FileCheck2,
    title: 'Legal Bill of Sale & Release',
    desc: 'Receive a legally binding purchase invoice and indemnity certificate relieving you of all future liability once the device is handed over.',
    badge: 'Full Legal Indemnity',
    color: 'bg-teal-50 text-teal-600 border-teal-200',
  },
  {
    id: 'why-convenience',
    icon: Clock,
    title: 'Zero Listing & Haggling Hassle',
    desc: 'Skip weeks of fielding spam calls, negotiating lowball offers, or meeting strangers from online classifieds.',
    badge: 'Zero Haggling',
    color: 'bg-rose-50 text-rose-600 border-rose-200',
  },
  {
    id: 'why-transparent',
    icon: Scale,
    title: 'Guaranteed Price Lock',
    desc: 'Lock in your camera valuation online for up to 7 days while you finalize your schedule or new gear upgrade.',
    badge: '7-Day Price Lock',
    color: 'bg-sky-50 text-sky-600 border-sky-200',
  },
  {
    id: 'why-gear-wide',
    icon: ShieldCheck,
    title: 'All Camera Brands & Accessories',
    desc: 'We purchase DSLRs, Mirrorless bodies, prime & zoom lenses, cine cameras, action cameras, and professional 3-axis gimbals.',
    badge: 'Comprehensive Range',
    color: 'bg-cyan-50 text-cyan-600 border-cyan-200',
  },
];

export default function WhyCamsik() {
  return (
    <section id="why-us" className="py-16 lg:py-24 bg-white relative overflow-hidden">
      {/* Subtle background decoration */}
      <div className="absolute top-0 right-1/4 w-96 h-96 bg-primary/5 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-0 left-10 w-96 h-96 bg-emerald-500/5 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 relative">
        <div className="text-center max-w-3xl mx-auto mb-14">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-3">
            <Sparkles size={13} />
            The Camsik Advantage
          </div>
          <h2 className="text-3xl sm:text-4xl font-black text-foreground tracking-tight">
            Why Over 1.85 Lakh Photographers Trust <span className="text-primary">Camsik</span>
          </h2>
          <p className="text-muted-foreground mt-3 text-sm sm:text-base leading-relaxed">
            Experience the safest, fastest, and most transparent platform to sell your old cameras, cinema rigs, and optics with zero hassle.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {reasons.map((reason) => {
            const Icon = reason.icon;
            return (
              <div
                key={reason.id}
                className="flex flex-col justify-between p-6 rounded-3xl border border-border/80 bg-white hover:border-primary/40 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group"
              >
                <div>
                  <div className="flex items-center justify-between mb-4">
                    <div className={`w-13 h-13 p-3 rounded-2xl border flex items-center justify-center ${reason.color} group-hover:scale-110 transition-transform duration-300`}>
                      <Icon size={24} />
                    </div>
                    <span className="text-[11px] font-bold px-2.5 py-1 rounded-full bg-surface border border-border text-muted-foreground">
                      {reason.badge}
                    </span>
                  </div>

                  <h3 className="font-extrabold text-foreground text-lg mb-2 group-hover:text-primary transition-colors">
                    {reason.title}
                  </h3>
                  <p className="text-sm text-muted-foreground leading-relaxed">
                    {reason.desc}
                  </p>
                </div>

                <div className="mt-6 pt-4 border-t border-border/50 flex items-center text-xs font-bold text-primary opacity-0 group-hover:opacity-100 transition-opacity">
                  Learn more about our process &rarr;
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

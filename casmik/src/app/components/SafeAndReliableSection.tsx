'use client';
import React from 'react';
import { ShieldCheck, Lock, FileCheck2, Cpu, CheckCircle2, Award, Zap } from 'lucide-react';
import Link from 'next/link';

const safetyPillars = [
  {
    icon: Cpu,
    title: 'Automated Digital Diagnostics',
    description: 'We connect your camera to our proprietary diagnostic software to read the exact mechanical shutter count and sensor health without subjective human bias.',
  },
  {
    icon: Zap,
    title: 'Payment Handover Guarantee',
    description: 'The technician initiates an instant IMPS or UPI transfer directly to your chosen bank account and waits for your confirmation SMS before taking the equipment.',
  },
  {
    icon: Lock,
    title: 'Certified Buffer & Storage Wipe',
    description: 'Camera internal storage, cache buffers, and WiFi/Bluetooth connection profiles are completely purged to military-grade standards before gear moves forward.',
  },
  {
    icon: FileCheck2,
    title: 'Legal Bill of Sale with Full Indemnity',
    description: 'You receive an instant digitally signed bill of sale and liability waiver confirming the legal transfer of serial numbers to Camsik India.',
  },
];

export default function SafeAndReliableSection() {
  return (
    <section className="py-8 lg:py-12 bg-surface border-y border-border/70 relative overflow-hidden">
      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-10 items-center">
          {/* Left Column: 3D-styled Shield Card & Visual Guarantee */}
          <div className="lg:col-span-5">
            <div className="relative rounded-3xl p-8 sm:p-10 bg-gradient-to-br from-slate-900 via-slate-800 to-slate-950 text-white shadow-2xl overflow-hidden border border-slate-700/60">
              {/* Decorative radial gradients */}
              <div className="absolute top-0 right-0 w-64 h-64 bg-primary/20 rounded-full blur-3xl pointer-events-none" />
              <div className="absolute bottom-0 left-0 w-64 h-64 bg-emerald-500/10 rounded-full blur-3xl pointer-events-none" />

              <div className="relative z-10">
                <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary to-emerald-500 flex items-center justify-center text-white shadow-lg mb-6">
                  <ShieldCheck size={36} />
                </div>

                <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-slate-800 text-emerald-400 text-xs font-bold uppercase tracking-wider mb-3 border border-slate-700">
                  <Award size={13} />
                  Safe & Reliable Guarantee
                </div>

                <h3 className="text-2xl sm:text-3xl font-black tracking-tight text-white mb-4 leading-snug">
                  Selling Cameras Shouldn&apos;t Be Risky or Stressful
                </h3>

                <p className="text-sm text-slate-300 leading-relaxed mb-6">
                  Unlike unregulated open marketplaces where meeting unknown buyers carries fraud or safety risks, Camsik offers an enterprise-grade, insured, and verified trade-in process.
                </p>

                <div className="space-y-3 pt-4 border-t border-slate-700/80">
                  <div className="flex items-center gap-2.5 text-xs sm:text-sm font-semibold text-slate-200">
                    <CheckCircle2 size={16} className="text-emerald-400 shrink-0" />
                    <span>Zero physical store visits required</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-xs sm:text-sm font-semibold text-slate-200">
                    <CheckCircle2 size={16} className="text-emerald-400 shrink-0" />
                    <span>Verified background-checked technicians</span>
                  </div>
                  <div className="flex items-center gap-2.5 text-xs sm:text-sm font-semibold text-slate-200">
                    <CheckCircle2 size={16} className="text-emerald-400 shrink-0" />
                    <span>Full transit insurance covered by Camsik</span>
                  </div>
                </div>

                <div className="mt-8">
                  <Link
                    href="/sell-device-get-quote"
                    className="inline-flex items-center justify-center w-full py-3.5 px-6 rounded-xl gradient-green text-white font-extrabold text-sm shadow-green hover:shadow-lg transition-all"
                  >
                    Sell Your Camera with Full Protection &rarr;
                  </Link>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column: 4 Security & Reliability Pillars */}
          <div className="lg:col-span-7">
            <div className="mb-8">
              <span className="text-xs font-black uppercase tracking-widest text-primary">
                Uncompromising Trust
              </span>
              <h2 className="text-3xl sm:text-4xl font-black text-foreground tracking-tight mt-1">
                The 4 Pillars of Camsik Protection
              </h2>
              <p className="text-muted-foreground mt-2 text-sm sm:text-base">
                How we protect your money, your privacy, and your time at every step of the transaction.
              </p>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
              {safetyPillars.map((pillar, idx) => {
                const Icon = pillar.icon;
                return (
                  <div
                    key={idx}
                    className="p-6 rounded-2xl bg-white border border-border/80 shadow-sm hover:shadow-md hover:border-primary/40 transition-all duration-200 flex flex-col justify-between group"
                  >
                    <div>
                      <div className="w-12 h-12 rounded-xl bg-primary/10 text-primary flex items-center justify-center mb-4 group-hover:scale-110 group-hover:bg-primary group-hover:text-white transition-all duration-200">
                        <Icon size={22} />
                      </div>
                      <h4 className="font-bold text-foreground text-base mb-2 group-hover:text-primary transition-colors">
                        {pillar.title}
                      </h4>
                      <p className="text-xs sm:text-sm text-muted-foreground leading-relaxed">
                        {pillar.description}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

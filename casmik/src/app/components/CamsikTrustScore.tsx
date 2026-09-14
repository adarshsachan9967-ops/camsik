'use client';
import React from 'react';
import { IndianRupee, Camera, MapPin, Star, ShieldCheck, Award } from 'lucide-react';

const stats = [
  {
    id: 'stat-cash',
    icon: IndianRupee,
    value: '₹13,898+ Cr',
    label: 'Total Cash Disbursed',
    subtext: 'Direct instant bank payouts to photographers',
    color: 'text-emerald-600 bg-emerald-50 border-emerald-200',
  },
  {
    id: 'stat-devices',
    icon: Camera,
    value: '1,85,000+',
    label: 'Cameras & Lenses Acquired',
    subtext: 'DSLRs, mirrorless, cinema & cine gear',
    color: 'text-primary bg-primary/10 border-primary/20',
  },
  {
    id: 'stat-cities',
    icon: MapPin,
    value: '200+',
    label: 'Cities Across India',
    subtext: 'Doorstep pickup from Indiranagar to Bandra',
    color: 'text-blue-600 bg-blue-50 border-blue-200',
  },
  {
    id: 'stat-rating',
    icon: Star,
    value: '4.9 / 5.0',
    label: 'Photographer Satisfaction',
    subtext: 'Based on 52,000+ Google & Trustpilot ratings',
    color: 'text-amber-600 bg-amber-50 border-amber-200',
  },
];

export default function CamsikTrustScore() {
  return (
    <section className="py-14 bg-slate-900 text-white relative overflow-hidden">
      {/* Glow effects */}
      <div className="absolute -top-24 -left-24 w-96 h-96 bg-primary/20 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute -bottom-24 -right-24 w-96 h-96 bg-emerald-500/20 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 relative">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-10 pb-8 border-b border-slate-800">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-800 text-emerald-400 text-xs font-bold uppercase tracking-wider mb-2 border border-slate-700">
              <ShieldCheck size={14} />
              India&apos;s Most Trusted Camera ReCommerce Platform
            </div>
            <h2 className="text-2xl sm:text-3xl font-black tracking-tight text-white">
              Trusted by Amateurs, Studios & National Creators
            </h2>
          </div>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-slate-800 flex items-center justify-center text-amber-400">
              <Award size={22} />
            </div>
            <div>
              <p className="text-xs text-slate-400">Official ISO 9001:2015 Certified</p>
              <p className="text-sm font-bold text-white">Electronic Valuation Process</p>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {stats.map((item) => {
            const Icon = item.icon;
            return (
              <div
                key={item.id}
                className="bg-slate-800/80 backdrop-blur-sm border border-slate-700/80 rounded-2xl p-6 hover:border-primary/60 transition-all duration-300 group"
              >
                <div className={`w-12 h-12 rounded-xl border flex items-center justify-center mb-4 ${item.color} group-hover:scale-110 transition-transform duration-200`}>
                  <Icon size={22} />
                </div>
                <p className="text-3xl sm:text-4xl font-black tracking-tight text-white mb-1">
                  {item.value}
                </p>
                <p className="text-sm font-bold text-slate-200 mb-1">
                  {item.label}
                </p>
                <p className="text-xs text-slate-400 leading-relaxed">
                  {item.subtext}
                </p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

'use client';
import React from 'react';
import { Check, X, Sparkles, Shield, Camera } from 'lucide-react';
import Link from 'next/link';

interface FeatureComparison {
  feature: string;
  camsik: string;
  camsikPositive: boolean;
  localShops: string;
  localPositive: boolean;
  classifieds: string;
  classifiedsPositive: boolean;
}

const comparisonData: FeatureComparison[] = [
  {
    feature: 'Valuation Method',
    camsik: 'Objective AI algorithm based on live market pricing & shutter health',
    camsikPositive: true,
    localShops: 'Arbitrary verbal quote, heavy dealer profit margin deducted',
    localPositive: false,
    classifieds: 'Random buyer lowballing and tire-kickers',
    classifiedsPositive: false,
  },
  {
    feature: 'Payment Speed & Mode',
    camsik: 'Instant UPI/IMPS directly to bank within 2 mins before handover',
    camsikPositive: true,
    localShops: 'Cheque or deferred payment after selling to their customer',
    localPositive: false,
    classifieds: 'High risk of fake payment screenshots or counterfeit cash',
    classifiedsPositive: false,
  },
  {
    feature: 'Doorstep Convenience',
    camsik: 'Free doorstep inspection & pickup across 200+ Indian cities',
    camsikPositive: true,
    localShops: 'You must travel with bulky, expensive camera bodies & lenses',
    localPositive: false,
    classifieds: 'Meet strangers in parking lots or invite unknown people home',
    classifiedsPositive: false,
  },
  {
    feature: 'Sensor & Shutter Count Check',
    camsik: 'Digital automated diagnostics right in front of your eyes',
    camsikPositive: true,
    localShops: 'Subjective visual guessing to artificially decrease quote',
    localPositive: false,
    classifieds: 'Buyers demanding free testing periods without deposit',
    classifiedsPositive: false,
  },
  {
    feature: 'Data Privacy & Buffer Wipe',
    camsik: 'Certified factory wipe of internal buffer, memory & EXIF profiles',
    camsikPositive: true,
    localShops: 'Rarely done, risk of sensitive photos or client data lingering',
    localPositive: false,
    classifieds: 'Completely on seller, no technical assistance',
    classifiedsPositive: false,
  },
  {
    feature: 'Legal Indemnity & Bill of Sale',
    camsik: 'Official digital GST invoice & liability waiver certificate provided',
    camsikPositive: true,
    localShops: 'Kachha receipt or no formal transfer paperwork',
    localPositive: false,
    classifieds: 'Zero documentation, leaves you liable if gear is misused',
    classifiedsPositive: false,
  },
];

export default function CompetitiveComparisonTable() {
  return (
    <section className="py-8 lg:py-12 bg-white relative overflow-hidden">
      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
        <div className="text-center max-w-3xl mx-auto mb-6">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-2">
            <Sparkles size={13} />
            Honest Comparison
          </div>
          <h2 className="text-3xl sm:text-4xl font-black text-foreground tracking-tight">
            Why Photographers Choose <span className="text-primary">Camsik</span>
          </h2>
          <p className="text-muted-foreground mt-2 text-sm sm:text-base">
            See how selling on Camsik compares against traditional offline camera markets and peer-to-peer classified websites.
          </p>
        </div>

        {/* Comparison Table */}
        <div className="overflow-x-auto rounded-3xl border border-border/80 shadow-lg bg-white">
          <table className="w-full text-left border-collapse min-w-[700px]">
            <thead>
              <tr className="border-b border-border bg-slate-50/70">
                <th className="py-5 px-6 font-extrabold text-sm text-foreground w-1/4">
                  Feature / Capability
                </th>
                <th className="py-5 px-6 font-black text-sm text-primary bg-primary/5 w-1/3 border-x border-primary/20">
                  <div className="flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-primary animate-pulse" />
                    Camsik (Recommended)
                  </div>
                </th>
                <th className="py-5 px-6 font-bold text-sm text-muted-foreground w-1/4">
                  Offline Camera Shops
                </th>
                <th className="py-5 px-6 font-bold text-sm text-muted-foreground w-1/4">
                  Online Classifieds (OLX/Etc.)
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border/60">
              {comparisonData.map((row, idx) => (
                <tr key={idx} className="hover:bg-slate-50/40 transition-colors">
                  <td className="py-5 px-6 font-bold text-sm text-foreground align-top">
                    {row.feature}
                  </td>

                  {/* Camsik Column */}
                  <td className="py-5 px-6 bg-primary/[0.02] border-x border-primary/20 align-top">
                    <div className="flex items-start gap-2.5">
                      <div className="w-5 h-5 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center shrink-0 mt-0.5">
                        <Check size={13} strokeWidth={3} />
                      </div>
                      <span className="text-xs sm:text-sm font-semibold text-foreground leading-snug">
                        {row.camsik}
                      </span>
                    </div>
                  </td>

                  {/* Offline Shops Column */}
                  <td className="py-5 px-6 align-top text-muted-foreground">
                    <div className="flex items-start gap-2.5">
                      <div className="w-5 h-5 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center shrink-0 mt-0.5">
                        <X size={13} strokeWidth={3} />
                      </div>
                      <span className="text-xs sm:text-sm text-muted-foreground leading-snug">
                        {row.localShops}
                      </span>
                    </div>
                  </td>

                  {/* Classifieds Column */}
                  <td className="py-5 px-6 align-top text-muted-foreground">
                    <div className="flex items-start gap-2.5">
                      <div className="w-5 h-5 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center shrink-0 mt-0.5">
                        <X size={13} strokeWidth={3} />
                      </div>
                      <span className="text-xs sm:text-sm text-muted-foreground leading-snug">
                        {row.classifieds}
                      </span>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Bottom CTA Banner */}
        <div className="mt-10 p-6 rounded-3xl bg-gradient-to-r from-primary-900 to-slate-900 text-white flex flex-col sm:flex-row items-center justify-between gap-6 shadow-xl">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-2xl bg-white/10 flex items-center justify-center text-primary-300 shrink-0">
              <Camera size={26} />
            </div>
            <div>
              <h4 className="text-lg font-black text-white">
                Ready to experience the smarter way to sell cameras?
              </h4>
              <p className="text-xs sm:text-sm text-slate-300">
                It takes only 60 seconds to see your exact guaranteed payout.
              </p>
            </div>
          </div>
          <Link
            href="/sell-device-get-quote"
            className="shrink-0 px-6 py-3 rounded-xl gradient-green text-white font-black text-sm shadow-green hover:shadow-lg transition-all"
          >
            Calculate Exact Price Now &rarr;
          </Link>
        </div>
      </div>
    </section>
  );
}

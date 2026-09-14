'use client';
import React from 'react';
import { Camera, Star, QrCode, ShieldCheck, Download } from 'lucide-react';
import AppImage from '@/components/ui/AppImage';

export default function AppDownloadCTA() {
  return (
    <section className="py-16 lg:py-24 bg-slate-950 overflow-hidden relative border-t border-slate-800">
      {/* Background gradients */}
      <div className="absolute top-0 right-1/3 w-96 h-96 bg-primary/15 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-0 right-10 w-80 h-80 bg-emerald-500/10 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center">
          <div className="lg:col-span-7">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/20 text-xs font-bold text-primary mb-4 border border-primary/30">
              <Camera size={13} />
              OFFICIAL CAMSIK MOBILE APP
            </div>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-white mb-4 leading-tight">
              Sell Cameras Smarter with the{' '}
              <span className="text-primary">Camsik App</span>
            </h2>
            <p className="text-slate-300 text-sm sm:text-base mb-6 leading-relaxed max-w-xl">
              Scan your camera serial number, run automated sensor diagnostics, check live shutter count, and track your doorstep technician in real time.
            </p>

            <div className="flex items-center gap-3 mb-8">
              <div className="flex items-center gap-1">
                {[1, 2, 3, 4, 5].map((s) => (
                  <Star key={`app-star-${s}`} size={16} className="text-amber-400 fill-amber-400" />
                ))}
              </div>
              <span className="text-sm font-semibold text-slate-300">
                4.9/5 Rating &bull; 85,000+ Photographers Trust Us
              </span>
            </div>

            {/* App Store Buttons and QR Code */}
            <div className="flex flex-wrap items-center gap-4">
              <a
                href="https://play.google.com"
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-3 px-5 py-3 bg-slate-900 border border-slate-700 rounded-2xl hover:border-primary transition-all hover:scale-105 btn-press"
              >
                <div className="text-left">
                  <p className="text-[10px] uppercase tracking-wider text-slate-400">Get it on</p>
                  <p className="text-sm font-bold text-white">Google Play</p>
                </div>
              </a>

              <a
                href="https://apple.com/app-store"
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-3 px-5 py-3 bg-slate-900 border border-slate-700 rounded-2xl hover:border-primary transition-all hover:scale-105 btn-press"
              >
                <div className="text-left">
                  <p className="text-[10px] uppercase tracking-wider text-slate-400">Download on</p>
                  <p className="text-sm font-bold text-white">Apple App Store</p>
                </div>
              </a>

              <div className="hidden sm:flex items-center gap-3 pl-4 border-l border-slate-800">
                <div className="w-12 h-12 bg-white rounded-xl p-1.5 flex items-center justify-center shadow-md">
                  <QrCode size={36} className="text-slate-950" />
                </div>
                <div className="text-xs text-slate-400">
                  <p className="font-bold text-white">Scan to install</p>
                  <p>Instant camera quote</p>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column: Visual Mockup */}
          <div className="lg:col-span-5 flex justify-center">
            <div className="relative w-72 h-80 sm:w-88 sm:h-96">
              <div className="absolute inset-0 rounded-full bg-primary/20 blur-3xl animate-pulse" />
              <div className="relative z-10 w-full h-full rounded-3xl border-2 border-slate-800 bg-slate-900/90 p-6 flex flex-col justify-between shadow-2xl backdrop-blur-sm">
                <div className="flex items-center justify-between pb-4 border-b border-slate-800">
                  <div className="flex items-center gap-2">
                    <span className="w-3 h-3 rounded-full bg-primary" />
                    <span className="text-xs font-bold text-white">Camsik Shutter Diagnostic</span>
                  </div>
                  <span className="text-[10px] px-2 py-0.5 rounded-full bg-emerald-500/20 text-emerald-400 font-bold">
                    Connected
                  </span>
                </div>

                <div className="space-y-3 my-auto">
                  <div className="p-3 rounded-xl bg-slate-800/80 border border-slate-700">
                    <p className="text-[11px] text-slate-400">Detected Camera</p>
                    <p className="text-sm font-black text-white">Sony Alpha 7 IV (ILCE-7M4)</p>
                  </div>
                  <div className="p-3 rounded-xl bg-slate-800/80 border border-slate-700 flex justify-between items-center">
                    <div>
                      <p className="text-[11px] text-slate-400">Shutter Count</p>
                      <p className="text-base font-black text-emerald-400">12,410 / 200,000</p>
                    </div>
                    <span className="text-xs font-bold text-slate-300">Grade A (94%)</span>
                  </div>
                  <div className="p-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 flex justify-between items-center">
                    <div>
                      <p className="text-[10px] text-emerald-400 uppercase font-bold">Instant Payout Valuation</p>
                      <p className="text-xl font-black text-white">₹1,48,500</p>
                    </div>
                    <span className="text-xs font-black bg-primary px-2.5 py-1 rounded-lg text-white">
                      Locked
                    </span>
                  </div>
                </div>

                <div className="pt-3 border-t border-slate-800 text-center">
                  <p className="text-[11px] text-slate-400">
                    Pickup scheduled for Today at 4:30 PM &bull; Indiranagar
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
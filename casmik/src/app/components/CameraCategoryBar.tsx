'use client';
import React from 'react';
import Link from 'next/link';
import { ArrowRight, Camera, Sparkles } from 'lucide-react';
import { categories } from '@/lib/casmikData';

export default function CameraCategoryBar() {
  return (
    <section className="py-6 sm:py-8 bg-white border-b border-slate-100">
      <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
        {/* Section Header */}
        <div className="flex flex-col sm:flex-row items-start sm:items-end justify-between mb-5 gap-4">
          <div>
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-purple-50 border border-purple-200/60 text-xs font-bold text-purple-700 mb-2">
              <Sparkles size={12} className="text-purple-600" />
              <span>OFFICIAL DEVICE & CAMERA CATEGORIES</span>
            </div>
            <h2 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
              Sell Your <span className="bg-gradient-to-r from-purple-600 to-indigo-600 bg-clip-text text-transparent">Electronics & Cameras</span>
            </h2>
            <p className="text-xs sm:text-sm text-slate-500 mt-1">
              Select your device or gear type to get an instant AI-calculated resale valuation
            </p>
          </div>

          <Link
            href="/sell-device-get-quote"
            className="inline-flex items-center gap-1 text-xs sm:text-sm font-bold text-purple-700 hover:text-purple-900 transition-colors group"
          >
            <span>View all device models</span>
            <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>

        {/* 8 Category Cards Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-4 xl:grid-cols-8 gap-3">
          {categories.filter(c => c.active).map((cat) => (
            <Link
              key={cat.id}
              href={`/sell-device-get-quote?cat=${cat.id}`}
              className="group relative flex flex-col items-center p-4 rounded-2xl bg-slate-50/70 hover:bg-white border border-slate-200/70 hover:border-purple-300 shadow-sm hover:shadow-xl hover:shadow-purple-500/10 hover:-translate-y-1.5 transition-all duration-300 text-center"
            >
              {/* Image with subtle spotlight glow */}
              <div className="relative w-20 h-20 mb-3 flex items-center justify-center">
                <div className="absolute inset-2 rounded-full bg-purple-100/60 group-hover:bg-purple-200/60 blur-md transition-colors" />
                <img
                  src={cat.image}
                  alt={cat.alt}
                  className="relative z-10 max-w-full max-h-full object-contain group-hover:scale-110 transition-transform duration-300 filter drop-shadow-sm"
                />
              </div>

              {/* Title & Stats */}
              <h3 className="font-extrabold text-xs sm:text-sm text-slate-900 group-hover:text-purple-700 transition-colors mb-0.5 line-clamp-1">
                {cat.name}
              </h3>
              <p className="text-[10px] text-slate-500 line-clamp-1 mb-3">
                {cat.brandCount} Brands · {cat.modelCount}+ Models
              </p>

              {/* Circular Action Arrow */}
              <div className="mt-auto w-7 h-7 rounded-full bg-white group-hover:bg-purple-600 border border-slate-200 group-hover:border-purple-600 text-slate-400 group-hover:text-white flex items-center justify-center transition-all duration-200 shadow-sm group-hover:shadow-md">
                <ArrowRight size={12} className="group-hover:translate-x-0.5 transition-transform" />
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

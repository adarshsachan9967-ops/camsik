'use client';

import React from 'react';
import Link from 'next/link';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import HeroBannerCarousel from '@/app/components/HeroBannerCarousel';
import QuickActionHub from '@/app/components/QuickActionHub';
import CameraCategoryBar from '@/app/components/CameraCategoryBar';
import TopDealsShowcase from '@/app/components/TopDealsShowcase';
import DeviceEcosystemShowcase from '@/app/components/DeviceEcosystemShowcase';
import CamsikTrustScore from '@/app/components/CamsikTrustScore';
import WhyCamsik from '@/app/components/WhyCamsik';
import HowItWorks from '@/app/components/HowItWorks';
import CustomerVideoReviewsCarousel from '@/app/components/CustomerVideoReviewsCarousel';
import SafeAndReliableSection from '@/app/components/SafeAndReliableSection';
import CameraBrandsCarousel from '@/app/components/CameraBrandsCarousel';
import CompetitiveComparisonTable from '@/app/components/CompetitiveComparisonTable';
import CamsikFaqSection from '@/app/components/CamsikFaqSection';
import AppDownloadCTA from '@/app/components/AppDownloadCTA';
import { ArrowRight, ShieldCheck, Zap, RefreshCw, ShoppingBag, Truck, Building, Headphones } from 'lucide-react';

export default function UserWebHomePage() {
  return (
    <main className="min-h-screen bg-background flex flex-col overflow-x-hidden w-full max-w-full">
      {/* Top Multi-Panel Navigation Banner */}
      <div className="bg-slate-950 text-white text-xs py-2 px-4 border-b border-slate-800">
        <div className="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <span className="inline-block w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            <span className="font-semibold text-emerald-300">CASMIK RECOMMERCE ECOSYSTEM</span>
            <span className="hidden sm:inline text-slate-500">|</span>
            <span className="hidden sm:inline text-slate-400">User Web Portal</span>
          </div>
          <div className="flex items-center gap-3 font-medium text-slate-400">
            <span>Switch Portal:</span>
            <Link href="/partner" className="text-blue-400 hover:text-blue-300 hover:underline flex items-center gap-1">
              <Building size={12} /> Partner
            </Link>
            <Link href="/delivery" className="text-amber-400 hover:text-amber-300 hover:underline flex items-center gap-1">
              <Truck size={12} /> Delivery
            </Link>
            <Link href="/admin" className="text-purple-400 hover:text-purple-300 hover:underline flex items-center gap-1">
              <ShieldCheck size={12} /> Admin
            </Link>
          </div>
        </div>
      </div>

      {/* Main Customer Header */}
      <CustomerHeader />

      {/* Quick Jump Bar to User Web Pages */}
      <nav className="bg-slate-900 text-slate-300 text-xs py-2 px-4 border-b border-slate-800 hidden md:block">
        <div className="max-w-7xl mx-auto flex items-center justify-center gap-6 font-medium overflow-x-auto">
          <Link href="/user/sell-device" className="hover:text-emerald-400 flex items-center gap-1 transition-colors">
            <Zap size={13} className="text-emerald-400" /> Sell Device (Instant Quote)
          </Link>
          <Link href="/user/buy-refurbished" className="hover:text-blue-400 flex items-center gap-1 transition-colors">
            <ShoppingBag size={13} className="text-blue-400" /> Buy Refurbished Tech
          </Link>
          <Link href="/user/exchange" className="hover:text-amber-400 flex items-center gap-1 transition-colors">
            <RefreshCw size={13} className="text-amber-400" /> Doorstep Exchange
          </Link>
          <Link href="/user/my-orders" className="hover:text-purple-400 flex items-center gap-1 transition-colors">
            <Truck size={13} className="text-purple-400" /> Track Orders
          </Link>
          <Link href="/user/how-it-works" className="hover:text-white transition-colors">
            How It Works
          </Link>
          <Link href="/user/about-us" className="hover:text-white transition-colors">
            Why Casmik
          </Link>
          <Link href="/user/faq" className="hover:text-white transition-colors">
            FAQs
          </Link>
          <Link href="/user/contact-us" className="hover:text-white flex items-center gap-1 transition-colors">
            <Headphones size={13} /> Support
          </Link>
        </div>
      </nav>

      {/* 1. Hero Banner Promo Carousel with search & live navigation */}
      <HeroBannerCarousel />

      {/* 2. Three Action Hub: Sell, Buy, Exchange */}
      <QuickActionHub />

      {/* 3. Explore All Device Categories Bar */}
      <CameraCategoryBar />

      {/* 4. Top Deals Showcase: Top Selling, Top Buying & Top Exchange */}
      <TopDealsShowcase />

      {/* 5. Complete Device Ecosystem */}
      <DeviceEcosystemShowcase />

      {/* 6. Live Trust & ReCommerce Stats */}
      <CamsikTrustScore />

      {/* 7. 3-Step Process for Selling, Buying Refurbished & Doorstep Exchange */}
      <HowItWorks />

      {/* 8. Why Camsik: 9 Value Propositions */}
      <WhyCamsik />

      {/* 9. Customer Video Reviews & Stories */}
      <CustomerVideoReviewsCarousel />

      {/* 10. Safe & Reliable Section: 4 Pillars of Protection */}
      <SafeAndReliableSection />

      {/* 11. Top Tech Brands Carousel */}
      <CameraBrandsCarousel />

      {/* 12. Market Comparison Table */}
      <CompetitiveComparisonTable />

      {/* 13. Comprehensive FAQs */}
      <CamsikFaqSection />

      {/* 14. Official Casmik App CTA */}
      <AppDownloadCTA />

      {/* Footer */}
      <CustomerFooter />
    </main>
  );
}

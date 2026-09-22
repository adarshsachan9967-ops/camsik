import React from 'react';
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

import Link from 'next/link';
import { ShieldCheck, Building, Truck, User } from 'lucide-react';

export default function CustomerHomePage() {
  return (
    <main className="min-h-screen bg-background flex flex-col overflow-x-hidden w-full max-w-full">
      {/* Top Multi-Panel Navigation Banner */}
      <div className="bg-slate-950 text-white text-xs py-2 px-4 border-b border-slate-800">
        <div className="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <span className="inline-block w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            <span className="font-semibold text-emerald-300">CASMIK RECOMMERCE ECOSYSTEM</span>
            <span className="hidden sm:inline text-slate-500">|</span>
            <span className="hidden sm:inline text-slate-400">4 Web Panels Available</span>
          </div>
          <div className="flex items-center gap-3 font-medium text-slate-400">
            <span>Explore Panels:</span>
            <Link href="/user" className="text-emerald-400 hover:text-emerald-300 hover:underline flex items-center gap-1">
              <User size={12} /> User Web
            </Link>
            <Link href="/partner" className="text-blue-400 hover:text-blue-300 hover:underline flex items-center gap-1">
              <Building size={12} /> Partner Web
            </Link>
            <Link href="/delivery" className="text-amber-400 hover:text-amber-300 hover:underline flex items-center gap-1">
              <Truck size={12} /> Delivery Web
            </Link>
            <Link href="/admin" className="text-purple-400 hover:text-purple-300 hover:underline flex items-center gap-1">
              <ShieldCheck size={12} /> Super Admin
            </Link>
          </div>
        </div>
      </div>

      <CustomerHeader />
      
      {/* 1. Hero Banner Promo Carousel with search & live navigation */}
      <HeroBannerCarousel />

      {/* 2. Three Action Hub: Sell, Buy, Exchange (Prominent world-class boxes below banners) */}
      <QuickActionHub />

      {/* 3. Explore All 8 Device Categories Bar (Phones, Laptops, Tablets, Cameras, etc.) */}
      <CameraCategoryBar />

      {/* 4. Top Deals Showcase: Top Selling, Top Buying (Refurbished) & Top Exchange with Category Filters */}
      <TopDealsShowcase />

      {/* 5. Complete Device Ecosystem (Smartphones, MacBooks, DSLRs, iPads with Sell/Buy/Exchange tags) */}
      <DeviceEcosystemShowcase />

      {/* 6. Live Trust & ReCommerce Stats (₹18,400+ Cr disbursed, 3.4L+ devices handled) */}
      <CamsikTrustScore />

      {/* 7. 3-Step Process for Selling, Buying Refurbished & 1-Step Doorstep Exchange */}
      <HowItWorks />

      {/* 8. Why Camsik: 9 Value Propositions covering all tech (DoD data wipe, 45-pt QA, instant payout) */}
      <WhyCamsik />

      {/* 9. Customer Video Reviews & Stories (iPhones, MacBooks, DSLRs, Tablets & Exchange) */}
      <CustomerVideoReviewsCarousel />

      {/* 10. Safe & Reliable Section: 4 Pillars of Protection (Diagnostics, DoD wipe, Indemnity, Payout) */}
      <SafeAndReliableSection />

      {/* 11. Top Tech & Camera Brands Carousel (Apple, Samsung, Dell, HP, Sony, Canon, DJI) */}
      <CameraBrandsCarousel />

      {/* 12. Market Comparison Table: Camsik vs Offline Shops vs Classifieds */}
      <CompetitiveComparisonTable />

      {/* 13. Comprehensive FAQs on Selling, Refurbished Warranties & Exchange */}
      <CamsikFaqSection />

      {/* 14. Official Camsik App Download Banner */}
      <AppDownloadCTA />

      <CustomerFooter />
    </main>
  );
}
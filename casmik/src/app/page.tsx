import React from 'react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import HeroBannerCarousel from '@/app/components/HeroBannerCarousel';
import CameraCategoryBar from '@/app/components/CameraCategoryBar';
import TopCamerasCarousel from '@/app/components/TopCamerasCarousel';
import CamsikTrustScore from '@/app/components/CamsikTrustScore';
import WhyCamsik from '@/app/components/WhyCamsik';
import HowItWorks from '@/app/components/HowItWorks';
import CustomerVideoReviewsCarousel from '@/app/components/CustomerVideoReviewsCarousel';
import SafeAndReliableSection from '@/app/components/SafeAndReliableSection';
import CameraBrandsCarousel from '@/app/components/CameraBrandsCarousel';
import CompetitiveComparisonTable from '@/app/components/CompetitiveComparisonTable';
import CamsikFaqSection from '@/app/components/CamsikFaqSection';
import AppDownloadCTA from '@/app/components/AppDownloadCTA';

export default function CustomerHomePage() {
  return (
    <main className="min-h-screen bg-background flex flex-col overflow-x-hidden w-full max-w-full">
      <CustomerHeader />
      
      {/* Carousel 1: Hero Banner Promo Carousel with search & live navigation */}
      <HeroBannerCarousel />

      {/* Camera-Exclusive Quick Category Bar */}
      <CameraCategoryBar />

      {/* Carousel 2: Top Selling Camera Gear Carousel with Category Filters & Instant Sell */}
      <TopCamerasCarousel />

      {/* Live Trust & Verification Stats (camsik.com parity) */}
      <CamsikTrustScore />

      {/* 3-Step Camera Liquidation Process (No Repair!) */}
      <HowItWorks />

      {/* Why Camsik: 9 Value Propositions & Objective AI Valuation */}
      <WhyCamsik />

      {/* Carousel 3: Customer Video Reviews & Stories with Verified Payout Badges */}
      <CustomerVideoReviewsCarousel />

      {/* Safe & Reliable Section: 3D Shield & Diagnostic Guarantees */}
      <SafeAndReliableSection />

      {/* Carousel 4: Top Camera & Optics Brands Carousel */}
      <CameraBrandsCarousel />

      {/* Market Comparison Table: Camsik vs Offline Shops vs Classifieds */}
      <CompetitiveComparisonTable />

      {/* Camera Resale & Inspection FAQs */}
      <CamsikFaqSection />

      {/* Official Camsik App Download Banner */}
      <AppDownloadCTA />

      <CustomerFooter />
    </main>
  );
}
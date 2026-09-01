import React from 'react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import HeroSection from '@/app/components/HeroSection';
import ServiceCards from '@/app/components/ServiceCards';
import TrustStats from '@/app/components/TrustStats';
import TopValueDevices from '@/app/components/TopValueDevices';
import WhyCasmik from '@/app/components/WhyCasmik';
import HowItWorks from '@/app/components/HowItWorks';
import TestimonialsSection from '@/app/components/TestimonialsSection';
import PopularBrands from '@/app/components/PopularBrands';
import AppDownloadCTA from '@/app/components/AppDownloadCTA';

export default function CustomerHomePage() {
  return (
    <main className="min-h-screen bg-background">
      <CustomerHeader />
      <HeroSection />
      <ServiceCards />
      <TrustStats />
      <TopValueDevices />
      <WhyCasmik />
      <HowItWorks />
      <TestimonialsSection />
      <PopularBrands />
      <AppDownloadCTA />
      <CustomerFooter />
    </main>
  );
}
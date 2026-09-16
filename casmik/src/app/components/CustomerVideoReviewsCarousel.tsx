'use client';
import React, { useState, useEffect, useRef } from 'react';
import { Star, ChevronLeft, ChevronRight, Play, CheckCircle2, ShieldCheck, Camera, Sparkles, MapPin, X } from 'lucide-react';
import AppImage from '@/components/ui/AppImage';

interface VideoReview {
  id: string;
  name: string;
  role: string;
  city: string;
  cameraSold: string;
  amountReceived: string;
  rating: number;
  duration: string;
  thumbnail: string;
  avatar: string;
  quote: string;
  highlight: string;
  verifiedBadge: string;
}

const reviews: VideoReview[] = [
  {
    id: 'rev-1',
    name: 'Prateek Sharma',
    role: 'Commercial Photographer',
    city: 'Bengaluru (Indiranagar)',
    cameraSold: 'Sony Alpha 7 IV (Body)',
    amountReceived: '₹1,48,500',
    rating: 5,
    duration: '1:12',
    thumbnail: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=800&auto=format&fit=crop',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    quote: 'Sold my Sony A7 IV in just 2 hours! The technician tested the shutter count digitally at my doorstep in Indiranagar and transferred ₹1,48,500 right before leaving.',
    highlight: 'Instant IMPS Payment in 2 Mins',
    verifiedBadge: 'Verified Sony Seller',
  },
  {
    id: 'rev-2',
    name: 'Megha Singhal',
    role: 'Travel Filmmaker',
    city: 'Mumbai (Bandra West)',
    cameraSold: 'Canon EOS R6 Mark II + 24-105mm',
    amountReceived: '₹1,94,000',
    rating: 5,
    duration: '0:58',
    thumbnail: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?q=80&w=800&auto=format&fit=crop',
    avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=200&auto=format&fit=crop',
    quote: 'Local shops in Fort offered ₹30k less citing subjective depreciation. Camsik gave an algorithm-backed transparent quote with zero haggling!',
    highlight: '₹30,000 Higher Than Local Market',
    verifiedBadge: 'Verified Canon Seller',
  },
  {
    id: 'rev-3',
    name: 'Rajesh Kannan',
    role: 'Wedding Cinematographer',
    city: 'Chennai (T. Nagar)',
    cameraSold: 'Nikon Z6 II + Nikkor 24-70mm f/2.8',
    amountReceived: '₹1,82,000',
    rating: 5,
    duration: '1:34',
    thumbnail: 'https://images.unsplash.com/photo-1512790182412-b19e6d62bc39?q=80&w=800&auto=format&fit=crop',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
    quote: 'Sold my wedding backup kit — camera body and premium 2.8 zoom. Seamless pickup, professional sensor check, and direct bank transfer without stress.',
    highlight: 'Same Day Multi-gear Valuation',
    verifiedBadge: 'Verified Nikon Pro Seller',
  },
  {
    id: 'rev-4',
    name: 'Ananya Roy',
    role: 'Documentary Photographer',
    city: 'Delhi NCR (Gurugram)',
    cameraSold: 'Fujifilm X-T5 (Silver Edition)',
    amountReceived: '₹1,18,000',
    rating: 5,
    duration: '1:05',
    thumbnail: 'https://images.unsplash.com/photo-1495745966610-2a67f2297e5e?q=80&w=800&auto=format&fit=crop',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200&auto=format&fit=crop',
    quote: 'I upgraded to medium format and needed quick liquidity. Camsik picked up my Fuji X-T5 from Cyber City, verified optics and shutter, and paid ₹1,18,000 on the spot.',
    highlight: 'Doorstep Pickup in 90 Mins',
    verifiedBadge: 'Verified Fuji Seller',
  },
  {
    id: 'rev-5',
    name: 'Vikramaditya Joshi',
    role: 'Automotive Content Creator',
    city: 'Pune (Kothrud)',
    cameraSold: 'DJI RS 3 Pro + GoPro Hero 12',
    amountReceived: '₹68,500',
    rating: 5,
    duration: '1:20',
    thumbnail: 'https://images.unsplash.com/photo-1516724562728-afc824a36e84?q=80&w=800&auto=format&fit=crop',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
    quote: 'Sold my gimbal and action camera creator bundle. The executive checked motors, calibration, and stabilization. Paid via UPI in 3 minutes flat!',
    highlight: 'Zero Commission or Listing Fees',
    verifiedBadge: 'Verified Gear Seller',
  },
];

export default function CustomerVideoReviewsCarousel() {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isPlayingModal, setIsPlayingModal] = useState<VideoReview | null>(null);
  const [isAutoPlaying, setIsAutoPlaying] = useState(true);
  const touchStartX = useRef<number>(0);
  const touchEndX = useRef<number>(0);

  // Auto slide every 5 seconds if not hovered or playing
  useEffect(() => {
    if (!isAutoPlaying || isPlayingModal) return;
    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % reviews.length);
    }, 5000);
    return () => clearInterval(interval);
  }, [isAutoPlaying, isPlayingModal]);

  const handlePrev = () => {
    setCurrentIndex((prev) => (prev === 0 ? reviews.length - 1 : prev - 1));
  };

  const handleNext = () => {
    setCurrentIndex((prev) => (prev + 1) % reviews.length);
  };

  const handleTouchStart = (e: React.TouchEvent) => {
    touchStartX.current = e.touches[0].clientX;
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    touchEndX.current = e.touches[0].clientX;
  };

  const handleTouchEnd = () => {
    if (touchStartX.current - touchEndX.current > 50) {
      handleNext();
    } else if (touchEndX.current - touchStartX.current > 50) {
      handlePrev();
    }
  };

  return (
    <section 
      className="py-8 lg:py-12 bg-gradient-to-b from-surface via-white to-surface overflow-hidden relative"
      onMouseEnter={() => setIsAutoPlaying(false)}
      onMouseLeave={() => setIsAutoPlaying(true)}
    >
      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
        {/* Header with Badges */}
        <div className="flex flex-col md:flex-row md:items-end justify-between mb-6 gap-6">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-3">
              <Sparkles size={13} />
              Real Stories from Verified Photographers
            </div>
            <h2 className="text-3xl sm:text-4xl font-black text-foreground tracking-tight">
              Customer Video Reviews & Stories
            </h2>
            <p className="text-muted-foreground mt-2 text-sm sm:text-base max-w-2xl">
              Hear directly from photographers, filmmakers, and studio creators who sold their DSLR, Mirrorless, and cinema gear on Camsik with instant bank payout.
            </p>
          </div>

          {/* Navigation Controls & Counter */}
          <div className="flex items-center gap-3 self-start md:self-auto">
            <span className="text-sm font-semibold text-muted-foreground mr-2">
              <strong className="text-foreground">{currentIndex + 1}</strong> / {reviews.length}
            </span>
            <button
              onClick={handlePrev}
              className="w-11 h-11 rounded-full border border-border bg-white text-foreground hover:bg-primary hover:text-white hover:border-primary flex items-center justify-center transition-all duration-200 shadow-sm btn-press"
              aria-label="Previous review"
            >
              <ChevronLeft size={20} />
            </button>
            <button
              onClick={handleNext}
              className="w-11 h-11 rounded-full border border-border bg-white text-foreground hover:bg-primary hover:text-white hover:border-primary flex items-center justify-center transition-all duration-200 shadow-sm btn-press"
              aria-label="Next review"
            >
              <ChevronRight size={20} />
            </button>
          </div>
        </div>

        {/* Carousel Slider */}
        <div 
          className="relative"
          onTouchStart={handleTouchStart}
          onTouchMove={handleTouchMove}
          onTouchEnd={handleTouchEnd}
        >
          {/* Active Card Showcase (Split 2-column on desktop) */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center bg-white rounded-3xl border border-border/80 shadow-xl overflow-hidden p-4 sm:p-6 lg:p-8 transition-all duration-500">
            {/* Left: Video Preview Card with Play Trigger */}
            <div className="lg:col-span-5 relative group">
              <div className="relative aspect-[4/3] sm:aspect-video lg:aspect-[4/3] rounded-2xl overflow-hidden shadow-inner bg-slate-900">
                <AppImage
                  src={reviews[currentIndex].thumbnail}
                  alt={`${reviews[currentIndex].name} selling ${reviews[currentIndex].cameraSold}`}
                  fill
                  className="object-cover transition-transform duration-700 group-hover:scale-105"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-black/20" />

                {/* Duration Badge */}
                <div className="absolute top-4 left-4 px-2.5 py-1 rounded-md bg-black/60 backdrop-blur-md text-white text-xs font-medium tracking-wide">
                  ▶ {reviews[currentIndex].duration}
                </div>

                {/* Verified Camera Seller Tag */}
                <div className="absolute top-4 right-4 flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/90 text-white text-xs font-bold backdrop-blur-sm shadow-md">
                  <ShieldCheck size={14} />
                  {reviews[currentIndex].verifiedBadge}
                </div>

                {/* Play Button Overlay */}
                <button
                  onClick={() => setIsPlayingModal(reviews[currentIndex])}
                  className="absolute inset-0 m-auto w-16 h-16 sm:w-20 sm:h-20 rounded-full bg-white/95 text-primary shadow-2xl flex items-center justify-center hover:scale-110 hover:bg-primary hover:text-white transition-all duration-300 group-hover:ring-8 group-hover:ring-primary/20"
                  aria-label="Play video review"
                >
                  <Play size={28} className="ml-1 fill-current" />
                </button>

                {/* Bottom Overlay Info on Video */}
                <div className="absolute bottom-4 left-4 right-4 text-white">
                  <p className="text-xs uppercase tracking-wider text-primary-300 font-semibold mb-1">
                    Gear Sold
                  </p>
                  <div className="flex items-center justify-between">
                    <p className="font-bold text-sm sm:text-base truncate mr-2">
                      {reviews[currentIndex].cameraSold}
                    </p>
                    <span className="text-xs sm:text-sm font-extrabold bg-emerald-500/90 px-2.5 py-0.5 rounded-full text-white shrink-0">
                      {reviews[currentIndex].amountReceived}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Right: Review Details & Quote */}
            <div className="lg:col-span-7 flex flex-col justify-between py-2 lg:px-4">
              <div>
                {/* Rating & Highlight Pill */}
                <div className="flex flex-wrap items-center gap-3 mb-4">
                  <div className="flex items-center gap-1">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Star
                        key={i}
                        size={18}
                        className={i < reviews[currentIndex].rating ? 'text-amber-400 fill-amber-400' : 'text-slate-300 fill-slate-300'}
                      />
                    ))}
                  </div>
                  <span className="text-xs font-bold px-3 py-1 rounded-full bg-amber-50 text-amber-700 border border-amber-200">
                    ★ 5.0 Verified Experience
                  </span>
                  <span className="text-xs font-bold px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200 flex items-center gap-1">
                    <CheckCircle2 size={13} />
                    {reviews[currentIndex].highlight}
                  </span>
                </div>

                {/* Quote */}
                <blockquote className="text-lg sm:text-xl md:text-2xl font-bold text-foreground leading-relaxed mb-6">
                  &ldquo;{reviews[currentIndex].quote}&rdquo;
                </blockquote>
              </div>

              {/* Author Info and City */}
              <div className="pt-6 border-t border-border/80 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div className="flex items-center gap-3">
                  <div className="relative w-12 h-12 rounded-full overflow-hidden border-2 border-primary ring-2 ring-primary/20 shrink-0">
                    <AppImage
                      src={reviews[currentIndex].avatar}
                      alt={reviews[currentIndex].name}
                      fill
                      className="object-cover"
                    />
                  </div>
                  <div>
                    <h4 className="font-bold text-foreground text-base leading-tight">
                      {reviews[currentIndex].name}
                    </h4>
                    <p className="text-xs text-muted-foreground">
                      {reviews[currentIndex].role}
                    </p>
                    <div className="flex items-center gap-1 text-xs text-primary font-medium mt-0.5">
                      <MapPin size={12} />
                      {reviews[currentIndex].city}
                    </div>
                  </div>
                </div>

                {/* Sell Similar Gear CTA */}
                <a
                  href="/sell-device-get-quote"
                  className="inline-flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl gradient-green text-white font-bold text-sm shadow-green hover:shadow-lg transition-all duration-200 btn-press"
                >
                  <Camera size={16} />
                  Sell Your Camera Now
                </a>
              </div>
            </div>
          </div>

          {/* Thumbnail Strip for Direct Selection */}
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-3 sm:gap-4 mt-6">
            {reviews.map((rev, index) => {
              const isActive = index === currentIndex;
              return (
                <button
                  key={rev.id}
                  onClick={() => setCurrentIndex(index)}
                  className={`relative text-left p-3 rounded-2xl border transition-all duration-300 flex flex-col gap-2 ${
                    isActive
                      ? 'bg-primary/5 border-primary shadow-md ring-2 ring-primary/20 scale-[1.02]'
                      : 'bg-white border-border hover:border-primary/40 hover:bg-slate-50/80 opacity-70 hover:opacity-100'
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <div className="relative w-8 h-8 rounded-full overflow-hidden shrink-0 border border-border">
                      <AppImage src={rev.avatar} alt={rev.name} fill className="object-cover" />
                    </div>
                    <div className="min-w-0">
                      <p className="text-xs font-bold text-foreground truncate">{rev.name}</p>
                      <p className="text-[10px] text-muted-foreground truncate">{rev.city.split(' ')[0]}</p>
                    </div>
                  </div>
                  <p className="text-[11px] font-medium text-foreground line-clamp-1">
                    {rev.cameraSold}
                  </p>
                  <span className="text-[11px] font-black text-emerald-600">
                    {rev.amountReceived}
                  </span>
                </button>
              );
            })}
          </div>
        </div>
      </div>

      {/* Video Modal Simulation */}
      {isPlayingModal && (
        <div 
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in"
          onClick={() => setIsPlayingModal(null)}
        >
          <div 
            className="bg-slate-900 border border-slate-700 text-white rounded-3xl overflow-hidden max-w-2xl w-full shadow-2xl relative"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Header */}
            <div className="flex items-center justify-between p-4 border-b border-slate-800 bg-slate-950/80">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center text-primary">
                  <Camera size={16} />
                </div>
                <div>
                  <h3 className="font-bold text-sm text-white">{isPlayingModal.name} &bull; {isPlayingModal.cameraSold}</h3>
                  <p className="text-xs text-slate-400">{isPlayingModal.city} &bull; Paid {isPlayingModal.amountReceived}</p>
                </div>
              </div>
              <button
                onClick={() => setIsPlayingModal(null)}
                className="w-8 h-8 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-300 hover:text-white flex items-center justify-center transition-colors"
                aria-label="Close modal"
              >
                <X size={18} />
              </button>
            </div>

            {/* Video Player Box with Simulation Controls */}
            <div className="relative aspect-video bg-black flex items-center justify-center overflow-hidden">
              <AppImage
                src={isPlayingModal.thumbnail}
                alt={isPlayingModal.name}
                fill
                className="object-cover opacity-60"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-black/40" />

              {/* Verified Seller Story Callout in Video */}
              <div className="absolute p-6 text-center max-w-lg">
                <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 text-xs font-bold mb-3">
                  <CheckCircle2 size={14} />
                  Doorstep Camera Handover Verified
                </div>
                <h4 className="text-lg sm:text-xl font-black text-white mb-2">
                  &ldquo;{isPlayingModal.quote}&rdquo;
                </h4>
                <p className="text-xs text-slate-300">
                  Instant bank payout confirmed on {isPlayingModal.cameraSold} &bull; Valuation: {isPlayingModal.amountReceived}
                </p>
              </div>

              {/* Progress bar simulation */}
              <div className="absolute bottom-0 left-0 right-0 h-1.5 bg-slate-800">
                <div className="h-full bg-primary animate-pulse w-3/4 rounded-r" />
              </div>
            </div>

            {/* Modal Footer CTA */}
            <div className="p-4 bg-slate-950 flex flex-col sm:flex-row items-center justify-between gap-3">
              <div className="text-center sm:text-left">
                <p className="text-xs text-slate-400">Want to sell your {isPlayingModal.cameraSold.split(' ')[0]} camera?</p>
                <p className="text-sm font-bold text-white">Get accurate instant valuation in 60 seconds</p>
              </div>
              <a
                href="/sell-device-get-quote"
                className="w-full sm:w-auto px-6 py-2.5 rounded-xl gradient-green text-white text-xs font-black uppercase tracking-wider text-center shadow-green hover:shadow-lg transition-all"
              >
                Get Exact Price Now
              </a>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}

'use client';
import React, { useRef } from 'react';
import Link from 'next/link';
import { Camera, ChevronLeft, ChevronRight, Sparkles, ArrowUpRight } from 'lucide-react';
import AppImage from '@/components/ui/AppImage';

interface CameraBrand {
  id: string;
  name: string;
  logo: string;
  tagline: string;
  specialty: string;
  popularModels: string;
  category: string;
}

const cameraBrands: CameraBrand[] = [
  {
    id: 'canon',
    name: 'Canon',
    logo: 'https://camsik.com/img/brand/canon.png',
    tagline: 'EOS R & DSLR Series',
    specialty: 'EOS R5, R6 II, 5D IV, 90D',
    popularModels: '120+ Models Supported',
    category: 'cat-dslr',
  },
  {
    id: 'sony',
    name: 'Sony',
    logo: 'https://camsik.com/img/brand/sony.png',
    tagline: 'Alpha Full-Frame & Cinema',
    specialty: 'A7 IV, A7R V, FX3, FX30, ZV-E10',
    popularModels: '95+ Models Supported',
    category: 'cat-dslr',
  },
  {
    id: 'nikon',
    name: 'Nikon',
    logo: 'https://camsik.com/img/brand/nikon.png',
    tagline: 'Z-Mount & D-Series',
    specialty: 'Z8, Z6 II, Z50, D850, D750',
    popularModels: '80+ Models Supported',
    category: 'cat-dslr',
  },
  {
    id: 'fujifilm',
    name: 'Fujifilm',
    logo: 'https://camsik.com/img/brand/fujifilm.png',
    tagline: 'X-Series & GFX Medium Format',
    specialty: 'X-T5, X-H2S, X100V, GFX 100S',
    popularModels: '45+ Models Supported',
    category: 'cat-dslr',
  },
  {
    id: 'lumix',
    name: 'Panasonic LUMIX',
    logo: 'https://camsik.com/img/brand/panasonic.png',
    tagline: 'S & GH Hybrid Series',
    specialty: 'S5 IIX, GH6, GH5 II, G9 II',
    popularModels: '35+ Models Supported',
    category: 'cat-dslr',
  },
  {
    id: 'sigma',
    name: 'Sigma',
    logo: 'https://camsik.com/img/brand/sigma.png',
    tagline: 'Art, Contemporary & Sport Lenses',
    specialty: '24-70mm Art, 85mm f/1.4, 18-50mm',
    popularModels: '70+ Lenses Supported',
    category: 'cat-lens',
  },
  {
    id: 'tamron',
    name: 'Tamron',
    logo: 'https://camsik.com/img/brand/tamron.png',
    tagline: 'Fast Di III Zooms & Primes',
    specialty: '28-75mm G2, 70-180mm, 35-150mm',
    popularModels: '50+ Lenses Supported',
    category: 'cat-lens',
  },
  {
    id: 'gopro',
    name: 'GoPro',
    logo: 'https://camsik.com/img/brand/gopro.png',
    tagline: 'Hero & Max Action Cameras',
    specialty: 'Hero 13 Black, Hero 12, Hero 11, Max',
    popularModels: '25+ Action Models',
    category: 'cat-action-camera',
  },
  {
    id: 'dji',
    name: 'DJI',
    logo: 'https://camsik.com/img/brand/dji.png',
    tagline: 'Ronin Gimbals & Osmo Action',
    specialty: 'RS 3 Pro, RS 4, Osmo Pocket 3, Action 4',
    popularModels: '30+ Gimbals & Cameras',
    category: 'cat-gimbal',
  },
  {
    id: 'insta360',
    name: 'Insta360',
    logo: 'https://camsik.com/img/brand/insta360.png',
    tagline: '360° & AI Action Cameras',
    specialty: 'X4 8K 360, Ace Pro, GO 3S, ONE RS',
    popularModels: '20+ Models Supported',
    category: 'cat-action-camera',
  },
  {
    id: 'zhiyun',
    name: 'Zhiyun Tech',
    logo: 'https://camsik.com/img/brand/zhiyun.png',
    tagline: 'Crane & Weebill Pro Gimbals',
    specialty: 'Crane 4, Weebill 3S, Smooth 5S',
    popularModels: '18+ Stabilizers',
    category: 'cat-gimbal',
  },
];

export default function CameraBrandsCarousel() {
  const scrollContainerRef = useRef<HTMLDivElement>(null);

  const scroll = (direction: 'left' | 'right') => {
    if (scrollContainerRef.current) {
      const scrollAmount = 340;
      scrollContainerRef.current.scrollBy({
        left: direction === 'left' ? -scrollAmount : scrollAmount,
        behavior: 'smooth',
      });
    }
  };

  return (
    <section className="py-14 lg:py-20 bg-white border-y border-border/60 overflow-hidden">
      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
        {/* Header with Badges */}
        <div className="flex flex-col sm:flex-row sm:items-end justify-between mb-8 gap-4">
          <div>
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-2.5">
              <Sparkles size={12} />
              Supported Manufacturers
            </div>
            <h2 className="text-2xl sm:text-3xl font-black text-foreground tracking-tight">
              Sell Cameras & Optics by Top Brands
            </h2>
            <p className="text-muted-foreground text-xs sm:text-sm mt-1">
              Select your gear brand to get a direct valuation model calibrated for market demand.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => scroll('left')}
              className="w-10 h-10 rounded-full border border-border bg-white text-foreground hover:bg-primary hover:text-white hover:border-primary flex items-center justify-center transition-all duration-200 shadow-sm btn-press"
              aria-label="Scroll left"
            >
              <ChevronLeft size={18} />
            </button>
            <button
              onClick={() => scroll('right')}
              className="w-10 h-10 rounded-full border border-border bg-white text-foreground hover:bg-primary hover:text-white hover:border-primary flex items-center justify-center transition-all duration-200 shadow-sm btn-press"
              aria-label="Scroll right"
            >
              <ChevronRight size={18} />
            </button>
          </div>
        </div>

        {/* Brand Cards Carousel */}
        <div
          ref={scrollContainerRef}
          className="flex gap-4 sm:gap-5 overflow-x-auto pb-4 scrollbar-none snap-x snap-mandatory"
          style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
        >
          {cameraBrands.map((brand) => (
            <Link
              key={brand.id}
              href={`/sell-device-get-quote?category=${brand.category}&brand=${brand.id}`}
              className="group snap-start flex-shrink-0 w-64 sm:w-72 bg-gradient-to-b from-surface/50 to-surface rounded-2xl p-5 border border-border/80 hover:border-primary/50 hover:shadow-lg transition-all duration-300 flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between mb-4">
                  <div className="h-10 w-24 relative flex items-center">
                    <AppImage
                      src={brand.logo}
                      alt={`${brand.name} logo`}
                      fill
                      className="object-contain object-left group-hover:scale-105 transition-transform duration-300"
                    />
                  </div>
                  <div className="w-8 h-8 rounded-full bg-white border border-border flex items-center justify-center text-muted-foreground group-hover:bg-primary group-hover:text-white group-hover:border-primary transition-all duration-200">
                    <ArrowUpRight size={15} />
                  </div>
                </div>

                <h3 className="font-extrabold text-foreground text-base group-hover:text-primary transition-colors">
                  {brand.name}
                </h3>
                <p className="text-xs font-semibold text-primary/90 mt-0.5">
                  {brand.tagline}
                </p>
                <p className="text-xs text-muted-foreground mt-2 line-clamp-2 leading-relaxed">
                  Popular: {brand.specialty}
                </p>
              </div>

              <div className="mt-5 pt-3 border-t border-border/60 flex items-center justify-between text-[11px] font-bold text-muted-foreground group-hover:text-foreground">
                <span className="inline-flex items-center gap-1">
                  <Camera size={12} className="text-primary" />
                  {brand.popularModels}
                </span>
                <span className="text-primary font-bold">Check Quote &rarr;</span>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

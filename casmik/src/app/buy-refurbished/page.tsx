'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { Search, Star, Shield, Truck, ChevronRight, CheckCircle, Package, ArrowRight, Camera, Sparkles } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import AppImage from '@/components/ui/AppImage';

type Condition = 'all' | 'superb' | 'good' | 'fair';
type CameraCategory =
  | 'all'
  | 'cat-smartphone'
  | 'cat-laptop'
  | 'cat-tablet'
  | 'cat-dslr'
  | 'cat-lens'
  | 'cat-video-camera'
  | 'cat-action-camera'
  | 'cat-gimbal';

interface RefurbishedCamera {
  id: string;
  brand: string;
  model: string;
  category: CameraCategory;
  categoryLabel: string;
  condition: 'superb' | 'good' | 'fair';
  price: number;
  originalPrice: number;
  discount: number;
  shutterCount: string;
  warranty: string;
  image: string;
  alt: string;
  rating: number;
  reviews: number;
  inStock: boolean;
  deliveryDays: number;
  specs: string;
}

const refurbishedCameras: RefurbishedCamera[] = [
  // ── Smartphones ──
  {
    id: 'ref-phone-001',
    brand: 'Apple',
    model: 'Apple iPhone 15 Pro Max (256GB)',
    category: 'cat-smartphone',
    categoryLabel: 'Flagship Smartphone',
    condition: 'superb',
    price: 74000,
    originalPrice: 159900,
    discount: 54,
    shutterCount: 'Battery Health: 96%, Zero scratches',
    warranty: '12 Months Warranty',
    image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=600&q=80',
    alt: 'Refurbished Apple iPhone 15 Pro Max',
    rating: 4.9,
    reviews: 184,
    inStock: true,
    deliveryDays: 2,
    specs: '6.7" Super Retina XDR OLED 120Hz, A17 Pro Chip, 48MP Triple Camera, Natural Titanium',
  },
  {
    id: 'ref-phone-002',
    brand: 'Samsung',
    model: 'Samsung Galaxy S24 Ultra 5G (256GB)',
    category: 'cat-smartphone',
    categoryLabel: 'AI Flagship Smartphone',
    condition: 'superb',
    price: 68000,
    originalPrice: 129999,
    discount: 48,
    shutterCount: 'Battery Health: 95%, S-Pen included',
    warranty: '12 Months Warranty',
    image: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=600&q=80',
    alt: 'Refurbished Samsung Galaxy S24 Ultra',
    rating: 4.9,
    reviews: 142,
    inStock: true,
    deliveryDays: 2,
    specs: '6.8" Dynamic AMOLED 2X QHD+, Snapdragon 8 Gen 3, 200MP Quad Camera, Titanium Gray',
  },
  {
    id: 'ref-phone-003',
    brand: 'OnePlus',
    model: 'OnePlus 12 5G (256GB)',
    category: 'cat-smartphone',
    categoryLabel: 'Performance Smartphone',
    condition: 'good',
    price: 38000,
    originalPrice: 64999,
    discount: 42,
    shutterCount: 'Battery Health: 93%, Mint condition',
    warranty: '6 Months Warranty',
    image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&q=80',
    alt: 'Refurbished OnePlus 12 5G',
    rating: 4.7,
    reviews: 96,
    inStock: true,
    deliveryDays: 2,
    specs: '6.82" 2K 120Hz ProXDR, Snapdragon 8 Gen 3, Hasselblad Camera, 100W Charging',
  },

  // ── Laptops ──
  {
    id: 'ref-laptop-001',
    brand: 'Apple',
    model: 'Apple MacBook Pro 14" M3 Pro',
    category: 'cat-laptop',
    categoryLabel: 'Pro Laptop',
    condition: 'superb',
    price: 118000,
    originalPrice: 199900,
    discount: 41,
    shutterCount: 'Battery Cycle: 32 cycles (99% capacity)',
    warranty: '12 Months Warranty',
    image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80',
    alt: 'Refurbished Apple MacBook Pro 14 M3 Pro',
    rating: 5.0,
    reviews: 88,
    inStock: true,
    deliveryDays: 2,
    specs: 'Apple M3 Pro 11-core CPU / 14-core GPU, 18GB Unified RAM, 512GB SSD, Space Black',
  },
  {
    id: 'ref-laptop-002',
    brand: 'Dell',
    model: 'Dell XPS 15 9530 (i7-13700H / RTX 4060)',
    category: 'cat-laptop',
    categoryLabel: 'Premium Laptop',
    condition: 'good',
    price: 82000,
    originalPrice: 149999,
    discount: 45,
    shutterCount: 'Battery Health: 89%, Clean keyboard & screen',
    warranty: '6 Months Warranty',
    image: 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=600&q=80',
    alt: 'Refurbished Dell XPS 15',
    rating: 4.8,
    reviews: 64,
    inStock: true,
    deliveryDays: 2,
    specs: '15.6" 3.5K OLED Touch, Intel i7-13700H, 16GB RAM, 512GB SSD, RTX 4060 8GB',
  },
  {
    id: 'ref-laptop-003',
    brand: 'Lenovo',
    model: 'Lenovo ThinkPad X1 Carbon Gen 11',
    category: 'cat-laptop',
    categoryLabel: 'Business Ultrabook',
    condition: 'superb',
    price: 69000,
    originalPrice: 135000,
    discount: 49,
    shutterCount: 'Battery Health: 94%, Pristine chassis',
    warranty: '6 Months Warranty',
    image: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=600&q=80',
    alt: 'Refurbished Lenovo ThinkPad X1 Carbon',
    rating: 4.9,
    reviews: 52,
    inStock: true,
    deliveryDays: 2,
    specs: '14" 2.8K OLED, Intel Core i7-1355U, 16GB LPDDR5, 512GB SSD, Ultralight 1.12kg',
  },

  // ── Tablets ──
  {
    id: 'ref-tablet-001',
    brand: 'Apple',
    model: 'Apple iPad Pro 12.9" M2 (128GB Wi-Fi)',
    category: 'cat-tablet',
    categoryLabel: 'Flagship iPad',
    condition: 'superb',
    price: 58000,
    originalPrice: 112900,
    discount: 49,
    shutterCount: 'Battery Health: 95%, Screen protector applied',
    warranty: '12 Months Warranty',
    image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=600&q=80',
    alt: 'Refurbished Apple iPad Pro 12.9 M2',
    rating: 4.9,
    reviews: 110,
    inStock: true,
    deliveryDays: 2,
    specs: '12.9" Liquid Retina XDR Mini-LED 120Hz, Apple M2 Chip, Face ID, Space Gray',
  },
  {
    id: 'ref-tablet-002',
    brand: 'Samsung',
    model: 'Samsung Galaxy Tab S9 Ultra (256GB Wi-Fi)',
    category: 'cat-tablet',
    categoryLabel: 'AMOLED Tablet',
    condition: 'good',
    price: 52000,
    originalPrice: 108999,
    discount: 52,
    shutterCount: 'Battery Health: 93%, S-Pen in box',
    warranty: '6 Months Warranty',
    image: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=600&q=80',
    alt: 'Refurbished Samsung Galaxy Tab S9 Ultra',
    rating: 4.8,
    reviews: 73,
    inStock: true,
    deliveryDays: 2,
    specs: '14.6" Dynamic AMOLED 2X 120Hz, Snapdragon 8 Gen 2, Quad AKG Speakers, IP68',
  },
  {
    id: 'ref-tablet-003',
    brand: 'Apple',
    model: 'Apple iPad Air 5th Gen M1 (64GB Wi-Fi)',
    category: 'cat-tablet',
    categoryLabel: 'Lightweight Tablet',
    condition: 'superb',
    price: 36000,
    originalPrice: 59900,
    discount: 40,
    shutterCount: 'Battery Health: 97%, Flawless body',
    warranty: '6 Months Warranty',
    image: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=600&q=80',
    alt: 'Refurbished Apple iPad Air 5th Gen M1',
    rating: 4.8,
    reviews: 95,
    inStock: true,
    deliveryDays: 2,
    specs: '10.9" Liquid Retina, Apple M1 Chip, Touch ID in top button, Blue finish',
  },

  // ── DSLR & Mirrorless Cameras ──
  {
    id: 'ref-cam-001',
    brand: 'Sony',
    model: 'Sony Alpha 7 IV (ILCE-7M4)',
    category: 'cat-dslr',
    categoryLabel: 'Full-Frame Mirrorless',
    condition: 'superb',
    price: 148000,
    originalPrice: 242490,
    discount: 39,
    shutterCount: '4,210 actuations (98% life)',
    warranty: '12 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/ilce_7m4_1_png.png',
    alt: 'Sony Alpha 7 IV',
    rating: 4.9,
    reviews: 142,
    inStock: true,
    deliveryDays: 2,
    specs: '33MP BSI Sensor, 4K60p 10-bit 4:2:2, Dual BIONZ XR',
  },
  {
    id: 'ref-cam-002',
    brand: 'Canon',
    model: 'Canon EOS R6 Mark II',
    category: 'cat-dslr',
    categoryLabel: 'Full-Frame Mirrorless',
    condition: 'superb',
    price: 154000,
    originalPrice: 243995,
    discount: 37,
    shutterCount: '2,800 actuations (99% life)',
    warranty: '12 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/eos_r6_mark_ii_body_1_png.png',
    alt: 'Canon EOS R6 Mark II',
    rating: 4.8,
    reviews: 98,
    inStock: true,
    deliveryDays: 2,
    specs: '24.2MP CMOS, 40 fps electronic shutter, 6K RAW',
  },
  {
    id: 'ref-cam-003',
    brand: 'Nikon',
    model: 'Nikon Z8 Flagship Body',
    category: 'cat-dslr',
    categoryLabel: 'Flagship Mirrorless',
    condition: 'superb',
    price: 248000,
    originalPrice: 343995,
    discount: 28,
    shutterCount: '6,150 actuations (97% life)',
    warranty: '12 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/nikon_z8_1_png.png',
    alt: 'Nikon Z8',
    rating: 5.0,
    reviews: 64,
    inStock: true,
    deliveryDays: 2,
    specs: '45.7MP Stacked CMOS, 8.3K60p N-RAW, No shutter lag',
  },
  {
    id: 'ref-cam-004',
    brand: 'Fujifilm',
    model: 'Fujifilm X-T5 Mirrorless Body',
    category: 'cat-dslr',
    categoryLabel: 'APS-C Mirrorless',
    condition: 'good',
    price: 108000,
    originalPrice: 169999,
    discount: 36,
    shutterCount: '12,400 actuations (94% life)',
    warranty: '6 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/fujifilm_xt5_1_png.png',
    alt: 'Fujifilm X-T5',
    rating: 4.7,
    reviews: 87,
    inStock: true,
    deliveryDays: 2,
    specs: '40.2MP X-Trans CMOS 5 HR, Film Simulations, IBIS',
  },
  {
    id: 'ref-cam-005',
    brand: 'Sony',
    model: 'Sony FE 24-70mm f/2.8 GM II',
    category: 'cat-lens',
    categoryLabel: 'G Master Zoom Lens',
    condition: 'superb',
    price: 142000,
    originalPrice: 199990,
    discount: 29,
    shutterCount: 'Clean optics, zero fungus',
    warranty: '12 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/sony_fe_24_70mm_gm2_1_png.png',
    alt: 'Sony FE 24-70mm f/2.8 GM II',
    rating: 4.9,
    reviews: 110,
    inStock: true,
    deliveryDays: 2,
    specs: 'XD Linear Motors, Nano AR Coating II, Aperture ring click switch',
  },
  {
    id: 'ref-cam-006',
    brand: 'Canon',
    model: 'Canon RF 70-200mm f/2.8L IS USM',
    category: 'cat-lens',
    categoryLabel: 'L-Series Telephoto',
    condition: 'good',
    price: 172000,
    originalPrice: 249995,
    discount: 31,
    shutterCount: 'Pristine glass, minor barrel rub',
    warranty: '12 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/canon_rf_70_200mm_f28_1_png.png',
    alt: 'Canon RF 70-200mm f/2.8L IS USM',
    rating: 4.9,
    reviews: 53,
    inStock: true,
    deliveryDays: 2,
    specs: 'Dual Nano USM, 5-stop Image Stabilization, Compact retracting body',
  },
  {
    id: 'ref-cam-007',
    brand: 'DJI',
    model: 'DJI RS 3 Pro Combo Gimbal',
    category: 'cat-gimbal',
    categoryLabel: 'Professional Gimbal',
    condition: 'superb',
    price: 49500,
    originalPrice: 79900,
    discount: 38,
    shutterCount: '4.5kg payload, calibrated motors',
    warranty: '6 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/dji_rs3_pro_1_png.png',
    alt: 'DJI RS 3 Pro Gimbal',
    rating: 4.8,
    reviews: 79,
    inStock: true,
    deliveryDays: 2,
    specs: 'Carbon fiber arms, LiDAR autofocus compatible, automated axis locks',
  },
  {
    id: 'ref-cam-008',
    brand: 'GoPro',
    model: 'GoPro HERO 12 Black Creator Edition',
    category: 'cat-action-camera',
    categoryLabel: 'Action Camera',
    condition: 'superb',
    price: 32500,
    originalPrice: 48990,
    discount: 34,
    shutterCount: 'Includes Volta, Media Mod & Light Mod',
    warranty: '6 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/gopro_hero12_1_png.png',
    alt: 'GoPro HERO 12 Black',
    rating: 4.7,
    reviews: 165,
    inStock: true,
    deliveryDays: 2,
    specs: '5.3K60 HDR, HyperSmooth 6.0, GP-Log encoding, Bluetooth audio',
  },
  {
    id: 'ref-cam-009',
    brand: 'Insta360',
    model: 'Insta360 X4 8K 360 Action Camera',
    category: 'cat-action-camera',
    categoryLabel: '360° Action Camera',
    condition: 'superb',
    price: 38900,
    originalPrice: 54990,
    discount: 29,
    shutterCount: 'Scratchless dual lenses with guards',
    warranty: '6 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/insta360_x4_1_png.png',
    alt: 'Insta360 X4 8K',
    rating: 4.9,
    reviews: 84,
    inStock: true,
    deliveryDays: 2,
    specs: '8K 30fps 360 video, Invisible Selfie Stick effect, AI Gesture Control',
  },
  {
    id: 'ref-cam-010',
    brand: 'Sony',
    model: 'Sony Cinema Line FX3 (ILME-FX3)',
    category: 'cat-video-camera',
    categoryLabel: 'Cinema Camera',
    condition: 'good',
    price: 265000,
    originalPrice: 399990,
    discount: 34,
    shutterCount: '180 operating hours, pristine sensor',
    warranty: '12 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/sony_fx3_1_png.png',
    alt: 'Sony Cinema Line FX3',
    rating: 5.0,
    reviews: 42,
    inStock: true,
    deliveryDays: 2,
    specs: '10.2MP Full-Frame Back-Illuminated sensor, Active cooling fan, S-Cinetone',
  },
  {
    id: 'ref-cam-011',
    brand: 'Sigma',
    model: 'Sigma 24-70mm f/2.8 DG DN Art (Sony E)',
    category: 'cat-lens',
    categoryLabel: 'Art Series Zoom',
    condition: 'good',
    price: 68000,
    originalPrice: 104990,
    discount: 35,
    shutterCount: 'Optically flawless, minor hood wear',
    warranty: '6 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/sigma_24_70_art_1_png.png',
    alt: 'Sigma 24-70mm Art',
    rating: 4.8,
    reviews: 132,
    inStock: true,
    deliveryDays: 2,
    specs: 'Dust and splash-proof mount, 11-blade rounded diaphragm, stepping AF motor',
  },
  {
    id: 'ref-cam-012',
    brand: 'Canon',
    model: 'Canon EOS 90D DSLR Body',
    category: 'cat-dslr',
    categoryLabel: 'DSLR Camera',
    condition: 'fair',
    price: 54000,
    originalPrice: 97495,
    discount: 45,
    shutterCount: '34,200 actuations (65% life)',
    warranty: '6 Months Warranty',
    image: 'https://camsik.com/img/purchaseProducts/canon_eos_90d_1_png.png',
    alt: 'Canon EOS 90D',
    rating: 4.6,
    reviews: 210,
    inStock: true,
    deliveryDays: 2,
    specs: '32.5MP APS-C sensor, 45-point all cross-type AF, uncropped 4K video',
  },
];

const conditionConfig = {
  superb: { label: 'Superb', color: 'bg-emerald-100 text-emerald-800 border-emerald-200', desc: 'Like new, < 10k shutter, zero marks' },
  good: { label: 'Good', color: 'bg-blue-100 text-blue-800 border-blue-200', desc: 'Clean optics, minor scuffs on body' },
  fair: { label: 'Fair', color: 'bg-amber-100 text-amber-800 border-amber-200', desc: 'Fully functional, cosmetic wear or high shutter' },
};

const categoryTabs = [
  { id: 'all', label: 'All Devices' },
  { id: 'cat-smartphone', label: 'Smartphones' },
  { id: 'cat-laptop', label: 'Laptops' },
  { id: 'cat-tablet', label: 'Tablets & iPads' },
  { id: 'cat-dslr', label: 'DSLR & Mirrorless' },
  { id: 'cat-lens', label: 'Lenses & Optics' },
  { id: 'cat-video-camera', label: 'Cinema Cameras' },
  { id: 'cat-action-camera', label: 'Action & 360' },
  { id: 'cat-gimbal', label: 'Gimbals & Stabilizers' },
];

export default function BuyRefurbishedPage() {
  const [activeCategory, setActiveCategory] = useState<CameraCategory>('all');
  const [activeCondition, setActiveCondition] = useState<Condition>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedDevice, setSelectedDevice] = useState<RefurbishedCamera | null>(null);
  const [checkoutStep, setCheckoutStep] = useState<'browse' | 'confirmed'>('browse');

  const filtered = refurbishedCameras.filter((d) => {
    const matchCat = activeCategory === 'all' || d.category === activeCategory;
    const matchCond = activeCondition === 'all' || d.condition === activeCondition;
    const matchSearch =
      d.model.toLowerCase().includes(searchQuery.toLowerCase()) ||
      d.brand.toLowerCase().includes(searchQuery.toLowerCase()) ||
      d.categoryLabel.toLowerCase().includes(searchQuery.toLowerCase());
    return matchCat && matchCond && matchSearch;
  });

  if (checkoutStep === 'confirmed' && selectedDevice) {
    return (
      <main className="min-h-screen bg-background">
        <CustomerHeader />
        <div className="min-h-[calc(100vh-64px)] flex items-center justify-center py-12 px-4">
          <div className="text-center max-w-md bg-white rounded-3xl border border-border p-8 shadow-xl">
            <div className="w-20 h-20 rounded-full bg-emerald-500/10 flex items-center justify-center mx-auto mb-6 text-emerald-600">
              <CheckCircle size={40} />
            </div>
            <h1 className="text-2xl font-black text-foreground mb-2">Order Reserved! 🎉</h1>
            <p className="text-sm text-muted-foreground mb-6">
              Your certified pre-owned {selectedDevice.model} has been reserved. Our camera team will call you to schedule insured doorstep delivery with 7-day inspection return privilege.
            </p>
            <div className="p-4 rounded-2xl bg-surface border border-border/80 text-left text-xs space-y-2 mb-6">
              <div className="flex justify-between"><span className="text-muted-foreground">Camera</span><span className="font-bold">{selectedDevice.model}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Condition</span><span className="font-bold capitalize">{selectedDevice.condition}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Price</span><span className="font-black text-primary text-sm">₹{selectedDevice.price.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between"><span className="text-muted-foreground">Warranty</span><span className="font-bold text-emerald-600">{selectedDevice.warranty}</span></div>
            </div>
            <Link href="/" className="inline-flex items-center gap-2 px-6 py-3 gradient-green text-white rounded-xl font-bold shadow-green">
              Back to Camsik Home <ArrowRight size={16} />
            </Link>
          </div>
        </div>
        <CustomerFooter />
      </main>
    );
  }

  return (
    <main className="min-h-screen bg-background">
      <CustomerHeader />

      {/* Hero */}
      <section className="bg-gradient-to-b from-slate-900 to-slate-950 text-white py-14 border-b border-slate-800 relative overflow-hidden">
        <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 relative z-10">
          <div className="max-w-3xl">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/20 text-primary text-xs font-bold mb-4 border border-primary/30">
              <Sparkles size={13} />
              45-POINT CERTIFIED PRE-OWNED GEAR
            </div>
            <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-white mb-4">
              Buy Certified Refurbished Devices &amp; Cameras
            </h1>
            <p className="text-sm sm:text-base text-slate-300 leading-relaxed max-w-2xl">
              Save up to 60% on flagship iPhones, Samsung Galaxy, Apple MacBooks, iPads, mirrorless camera bodies, and premium lenses. Every unit is rigorously tested with comprehensive inspection and up to 12 months warranty.
            </p>
          </div>
        </div>
      </section>

      {/* Filters & Content Area */}
      <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 py-10">
        {/* Search & Category Filter Tabs */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
          {/* Category Tabs */}
          <div className="flex items-center gap-2 overflow-x-auto pb-2 md:pb-0 scrollbar-none">
            {categoryTabs.map((tab) => {
              const isActive = activeCategory === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveCategory(tab.id as CameraCategory)}
                  className={`px-4 py-2.5 rounded-xl text-xs font-bold whitespace-nowrap transition-all ${
                    isActive
                      ? 'bg-primary text-white shadow-md'
                      : 'bg-white border border-border text-muted-foreground hover:text-foreground hover:border-primary/40'
                  }`}
                >
                  {tab.label}
                </button>
              );
            })}
          </div>

          {/* Search Box */}
          <div className="relative w-full md:w-72">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <input
              type="text"
              placeholder="Search Sony, Canon, 24-70mm..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2.5 bg-white border border-border rounded-xl text-xs font-medium focus:outline-none focus:ring-2 focus:ring-primary/20"
            />
          </div>
        </div>

        {/* Condition Filter Badges */}
        <div className="flex items-center gap-2 mb-8">
          <span className="text-xs font-bold text-muted-foreground mr-1">Condition Grade:</span>
          {(['all', 'superb', 'good', 'fair'] as Condition[]).map((cond) => (
            <button
              key={cond}
              onClick={() => setActiveCondition(cond)}
              className={`px-3 py-1 rounded-lg text-xs font-bold capitalize transition-all ${
                activeCondition === cond
                  ? 'bg-slate-900 text-white'
                  : 'bg-slate-100 text-muted-foreground hover:text-foreground'
              }`}
            >
              {cond}
            </button>
          ))}
        </div>

        {/* Camera Products Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {filtered.map((cam) => {
            const cond = conditionConfig[cam.condition];
            return (
              <div
                key={cam.id}
                className="bg-white rounded-3xl border border-border/80 overflow-hidden hover:border-primary/50 hover:shadow-xl transition-all duration-300 flex flex-col justify-between group"
              >
                <div className="p-5">
                  {/* Image with Badges */}
                  <div className="relative aspect-[4/3] rounded-2xl bg-slate-50 overflow-hidden mb-4 border border-border/50">
                    <AppImage
                      src={cam.image}
                      alt={cam.alt}
                      fill
                      className="object-contain p-3 group-hover:scale-105 transition-transform duration-300"
                    />
                    <div className="absolute top-3 left-3">
                      <span className={`text-[10px] font-black px-2.5 py-1 rounded-full border ${cond.color}`}>
                        Grade: {cond.label}
                      </span>
                    </div>
                    <div className="absolute top-3 right-3">
                      <span className="text-[10px] font-black px-2.5 py-1 rounded-full bg-emerald-500 text-white shadow-sm">
                        {cam.discount}% OFF
                      </span>
                    </div>
                  </div>

                  {/* Brand & Category */}
                  <div className="flex items-center justify-between text-xs font-bold text-muted-foreground mb-1">
                    <span className="text-primary uppercase tracking-wider">{cam.brand}</span>
                    <span className="text-[11px] bg-surface px-2 py-0.5 rounded-md border border-border">
                      {cam.categoryLabel}
                    </span>
                  </div>

                  <h3 className="font-black text-foreground text-base line-clamp-1 group-hover:text-primary transition-colors">
                    {cam.model}
                  </h3>

                  <p className="text-xs text-muted-foreground mt-1 line-clamp-1">
                    {cam.specs}
                  </p>

                  <div className="mt-3 p-2.5 rounded-xl bg-slate-50 border border-slate-100 space-y-1 text-[11px]">
                    <div className="flex justify-between text-muted-foreground">
                      <span>Diagnostics</span>
                      <span className="font-bold text-slate-700 truncate max-w-[150px]">{cam.shutterCount}</span>
                    </div>
                    <div className="flex justify-between text-muted-foreground">
                      <span>Warranty</span>
                      <span className="font-bold text-emerald-600">{cam.warranty}</span>
                    </div>
                  </div>
                </div>

                <div className="p-5 pt-0">
                  <div className="flex items-baseline justify-between pt-3 border-t border-border/60 mb-4">
                    <div>
                      <p className="text-lg font-black text-primary">
                        ₹{cam.price.toLocaleString('en-IN')}
                      </p>
                      <p className="text-[11px] text-muted-foreground line-through">
                        MRP: ₹{cam.originalPrice.toLocaleString('en-IN')}
                      </p>
                    </div>
                    <div className="flex items-center gap-1 text-xs font-bold text-amber-500">
                      <Star size={13} className="fill-amber-400 text-amber-400" />
                      <span>{cam.rating}</span>
                      <span className="text-muted-foreground">({cam.reviews})</span>
                    </div>
                  </div>

                  <button
                    onClick={() => {
                      setSelectedDevice(cam);
                      setCheckoutStep('confirmed');
                    }}
                    className="w-full py-3 rounded-xl gradient-green text-white font-extrabold text-xs uppercase tracking-wider shadow-green hover:shadow-lg transition-all flex items-center justify-center gap-2 btn-press"
                  >
                    <Camera size={14} />
                    Reserve This Gear Now
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      <CustomerFooter />
    </main>
  );
}
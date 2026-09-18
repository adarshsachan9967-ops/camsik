'use client';
import React, { useState, useEffect, useMemo } from 'react';
import Link from 'next/link';
import {
  ArrowRight,
  ArrowLeft,
  ChevronRight,
  CheckCircle,
  RefreshCw,
  Zap,
  TrendingDown,
  Camera,
  ShieldCheck,
  Search,
  Check,
  Smartphone,
  Laptop,
  Sparkles,
  Tag,
  Clock,
  MapPin,
  Calendar,
  User,
  Phone,
  AlertCircle,
  X,
  CreditCard,
  Truck,
  BatteryCharging,
  Layers,
  Award,
} from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import {
  RefurbishedProduct,
  ProductCondition,
  getRefurbishedProducts,
  getModelKey,
  getConditionsForModel,
  getVariantsByModel,
} from '@/lib/refurbishedCatalog';
import {
  getCurrentUser,
  setCurrentUser,
  saveCustomerOrder,
  CustomerUser,
  CustomerOrderRecord,
} from '@/lib/auth';

// ── Types ──
type ExchangeWizardStep =
  | 'select-old'
  | 'condition'
  | 'select-new'
  | 'product-detail'
  | 'checkout'
  | 'confirmed';

interface OldDeviceItem {
  id: string;
  category: 'Cameras' | 'Lenses' | 'Smartphones' | 'Laptops';
  brand: string;
  name: string;
  image: string;
  basePrice: number;
  specs: string;
}

// ── Catalog of Old Devices for Trade-in ──
const oldTradeInDevices: OldDeviceItem[] = [
  // Cameras
  {
    id: 'old-cam-sony-a7',
    category: 'Cameras',
    brand: 'Sony',
    name: 'Sony Alpha A7 (Body Only)',
    image: '/assets/images/refurbished/sony-a7.jpg',
    basePrice: 38000,
    specs: '24.3 MP Full-Frame, E-mount, BIONZ X',
  },
  {
    id: 'old-cam-sony-a7ii',
    category: 'Cameras',
    brand: 'Sony',
    name: 'Sony Alpha A7 II Body',
    image: '/assets/images/refurbished/sony-a7.jpg',
    basePrice: 52000,
    specs: '24.3 MP Full-Frame, 5-axis IBIS, Fast Hybrid AF',
  },
  {
    id: 'old-cam-sony-a7iii',
    category: 'Cameras',
    brand: 'Sony',
    name: 'Sony Alpha A7 III Body',
    image: '/assets/images/refurbished/sony-a7.jpg',
    basePrice: 85000,
    specs: '24.2 MP BSI Sensor, 4K HDR, 693 AF Points, Dual Slots',
  },
  {
    id: 'old-cam-canon-rp',
    category: 'Cameras',
    brand: 'Canon',
    name: 'Canon EOS RP Full Frame',
    image: '/assets/images/refurbished/canon-eos-rp.jpg',
    basePrice: 58000,
    specs: '26.2 MP Full-Frame, Dual Pixel CMOS AF, 4K UHD',
  },
  {
    id: 'old-cam-canon-r',
    category: 'Cameras',
    brand: 'Canon',
    name: 'Canon EOS R Mirrorless Body',
    image: '/assets/images/refurbished/canon-eos-r.webp',
    basePrice: 78000,
    specs: '30.3 MP Full-Frame, DIGIC 8, 4K Canon Log',
  },
  {
    id: 'old-cam-nikon-z50',
    category: 'Cameras',
    brand: 'Nikon',
    name: 'Nikon Z50 Mirrorless Body',
    image: '/assets/images/refurbished/nikon-z50ii.png',
    basePrice: 48000,
    specs: '20.9 MP DX CMOS, Eye-Detection AF, 4K UHD 30p',
  },
  {
    id: 'old-cam-nikon-z50ii',
    category: 'Cameras',
    brand: 'Nikon',
    name: 'Nikon Z50 II Mirrorless',
    image: '/assets/images/refurbished/nikon-z50ii.png',
    basePrice: 62000,
    specs: '20.9 MP DX Sensor, EXPEED 7 Engine, AI Subject Detection',
  },
  {
    id: 'old-cam-nikon-z30',
    category: 'Cameras',
    brand: 'Nikon',
    name: 'Nikon Z30 Creator Body',
    image: '/assets/images/refurbished/nikon-z50ii.png',
    basePrice: 42000,
    specs: '20.9 MP DX Sensor, Vari-angle Screen, Uncropped 4K',
  },
  {
    id: 'old-cam-fuji-xt4',
    category: 'Cameras',
    brand: 'Fujifilm',
    name: 'Fujifilm X-T4 Mirrorless',
    image: '/assets/images/refurbished/fujifilm-xt5.jpg',
    basePrice: 79000,
    specs: '26.1 MP X-Trans CMOS 4, 6.5-stop IBIS, 4K 60p 10-bit',
  },
  {
    id: 'old-cam-fuji-xt5',
    category: 'Cameras',
    brand: 'Fujifilm',
    name: 'Fujifilm X-T5 Mirrorless Body',
    image: '/assets/images/refurbished/fujifilm-xt5.jpg',
    basePrice: 110000,
    specs: '40.2 MP X-Trans CMOS 5 HR, Deep Learning AI AF, 6.2K 30p',
  },

  // Lenses
  {
    id: 'old-lens-sony-1635gm',
    category: 'Lenses',
    brand: 'Sony',
    name: 'Sony FE 16-35mm f/2.8 GM Lens',
    image: '/assets/images/refurbished/sony-1635gm.jpg',
    basePrice: 75000,
    specs: 'G Master Wide Zoom, Constant f/2.8, Direct Drive SSM',
  },
  {
    id: 'old-lens-sony-2470gm',
    category: 'Lenses',
    brand: 'Sony',
    name: 'Sony FE 24-70mm f/2.8 GM I',
    image: '/assets/images/refurbished/sony-1635gm.jpg',
    basePrice: 72000,
    specs: 'G Master Standard Zoom, Constant f/2.8, Direct Drive SSM',
  },

  // Smartphones
  {
    id: 'old-phone-ip14pm',
    category: 'Smartphones',
    brand: 'Apple',
    name: 'Apple iPhone 14 Pro Max',
    image: '/assets/images/refurbished/iphone-14-pro-max.png',
    basePrice: 52000,
    specs: '6.7" Super Retina XDR OLED, A16 Bionic, 48MP Pro Camera',
  },
  {
    id: 'old-phone-ip14p',
    category: 'Smartphones',
    brand: 'Apple',
    name: 'Apple iPhone 14 Pro',
    image: '/assets/images/refurbished/iphone-14-pro-gold.jpg',
    basePrice: 47000,
    specs: '6.1" Super Retina XDR OLED, Dynamic Island, A16 Bionic',
  },
  {
    id: 'old-phone-ip13pm',
    category: 'Smartphones',
    brand: 'Apple',
    name: 'Apple iPhone 13 Pro Max',
    image: '/assets/images/refurbished/iphone-13-pro-max.png',
    basePrice: 38000,
    specs: '6.7" ProMotion 120Hz, A15 Bionic, Triple Camera',
  },
  {
    id: 'old-phone-s23u',
    category: 'Smartphones',
    brand: 'Samsung',
    name: 'Samsung Galaxy S23 Ultra',
    image: '/assets/images/refurbished/galaxy-s24-ultra.png',
    basePrice: 46000,
    specs: '6.8" Dynamic AMOLED 2X, Snapdragon 8 Gen 2, 200MP Quad Camera',
  },
  {
    id: 'old-phone-pix8p',
    category: 'Smartphones',
    brand: 'Google',
    name: 'Google Pixel 8 Pro',
    image: '/assets/images/refurbished/pixel-8-pro.png',
    basePrice: 42000,
    specs: '6.7" Super Actua OLED, Google Tensor G3, Pro Camera System',
  },
  {
    id: 'old-phone-op12',
    category: 'Smartphones',
    brand: 'OnePlus',
    name: 'OnePlus 12 5G',
    image: '/assets/images/refurbished/oneplus-12.png',
    basePrice: 38000,
    specs: '6.82" 2K 120Hz ProXDR, Snapdragon 8 Gen 3, Hasselblad',
  },

  // Laptops & Tablets
  {
    id: 'old-lap-macbook-air',
    category: 'Laptops',
    brand: 'Apple',
    name: 'Apple MacBook Air M1',
    image: '/assets/images/refurbished/macbook-air-m2.png',
    basePrice: 42000,
    specs: '13.3" Retina Display, Apple M1 Chip 8-Core, 8GB Unified RAM',
  },
  {
    id: 'old-lap-macbook-pro',
    category: 'Laptops',
    brand: 'Apple',
    name: 'Apple MacBook Pro 14" M1 Pro',
    image: '/assets/images/refurbished/macbook-pro-14.png',
    basePrice: 78000,
    specs: '14.2" Liquid Retina XDR 120Hz, M1 Pro 8-Core, 16GB RAM',
  },
  {
    id: 'old-tab-ipad-pro',
    category: 'Laptops',
    brand: 'Apple',
    name: 'Apple iPad Pro 12.9" M1',
    image: '/assets/images/refurbished/ipad-pro-m2.jpg',
    basePrice: 46000,
    specs: '12.9" Liquid Retina XDR Mini-LED, Apple M1 Chip, Face ID',
  },
  {
    id: 'old-lap-dell-xps',
    category: 'Laptops',
    brand: 'Dell',
    name: 'Dell XPS 13 9310',
    image: '/assets/images/refurbished/dell-xps-15.png',
    basePrice: 45000,
    specs: '13.4" FHD+ InfinityEdge, Intel Core i7 11th Gen, 16GB RAM',
  },
];

// ── Diagnostic Questions for Each Category ──
interface DiagnosticOption {
  label: string;
  sublabel: string;
  adj: number;
}

interface DiagnosticQuestion {
  id: string;
  question: string;
  options: DiagnosticOption[];
}

const cameraQuestions: DiagnosticQuestion[] = [
  {
    id: 'sensor',
    question: 'Sensor & Optics Condition?',
    options: [
      { label: 'Spotless & Pristine', sublabel: 'Zero scratches or dust', adj: 0 },
      { label: 'Minor Normal Dust', sublabel: 'Cleanable with blower', adj: -1500 },
      { label: 'Visible Scratches', sublabel: 'Marks on sensor filter', adj: -6000 },
      { label: 'Fungus on Sensor Glass', sublabel: 'Needs deep service', adj: -10000 },
    ],
  },
  {
    id: 'shutter',
    question: 'Estimated Shutter Actuations?',
    options: [
      { label: 'Low (< 10,000)', sublabel: 'Barely used / Like new', adj: 3000 },
      { label: 'Moderate (10k - 50k)', sublabel: 'Normal hobbyist use', adj: 0 },
      { label: 'High (50k - 100k)', sublabel: 'Active photography use', adj: -3500 },
      { label: 'Heavy (> 100,000)', sublabel: 'Commercial usage', adj: -7000 },
    ],
  },
  {
    id: 'body',
    question: 'Chassis Body & Rubber Grip?',
    options: [
      { label: 'Mint / Zero Marks', sublabel: 'Flawless aesthetic', adj: 2000 },
      { label: 'Good (Minor Scuffs)', sublabel: 'Subtle signs of normal use', adj: 0 },
      { label: 'Peeling Rubber / Dent', sublabel: 'Rubber loose or corner dent', adj: -3000 },
      { label: 'Heavy Wear / Missing Parts', sublabel: 'Missing port doors/caps', adj: -5000 },
    ],
  },
  {
    id: 'functional',
    question: 'Autofocus & Electronic Functions?',
    options: [
      { label: '100% Fully Functional', sublabel: 'All dials, AF, EVF tested', adj: 0 },
      { label: 'Minor Sticky Button', sublabel: 'Slight stiffness in dials', adj: -2000 },
      { label: 'Autofocus Hunt / Error', sublabel: 'Erratic AF or sensor error', adj: -6000 },
    ],
  },
  {
    id: 'accessories',
    question: 'Original Accessories Included?',
    options: [
      { label: 'Battery + Charger + Box', sublabel: 'Complete packaging', adj: 2000 },
      { label: 'Battery + Charger Only', sublabel: 'No original retail box', adj: 0 },
      { label: 'Device Only / No Charger', sublabel: 'Missing charging unit', adj: -2000 },
    ],
  },
];

const smartphoneQuestions: DiagnosticQuestion[] = [
  {
    id: 'screen',
    question: 'Display Glass & Touch Screen?',
    options: [
      { label: 'Flawless & Pristine', sublabel: 'Zero scratches or marks', adj: 0 },
      { label: 'Minor Micro-scratches', sublabel: 'Invisible when screen is on', adj: -1500 },
      { label: 'Deep Scratches', sublabel: 'Felt with fingernail', adj: -4000 },
      { label: 'Cracked Glass / Lines', sublabel: 'Broken glass or display lines', adj: -8000 },
    ],
  },
  {
    id: 'body',
    question: 'Chassis Frame & Back Glass?',
    options: [
      { label: 'Pristine / No Marks', sublabel: 'Chassis looks brand new', adj: 1500 },
      { label: 'Normal Pocket Wear', sublabel: 'Light scuffs along bezel', adj: 0 },
      { label: 'Dents or Frame Chips', sublabel: 'Corner dents from drops', adj: -3000 },
      { label: 'Heavy Frame Scratches', sublabel: 'Noticeable cosmetic wear', adj: -5000 },
    ],
  },
  {
    id: 'battery',
    question: 'Battery Health Percentage?',
    options: [
      { label: '90%+ Battery Health', sublabel: 'Exceptional battery endurance', adj: 1500 },
      { label: '80% - 89% Health', sublabel: 'Normal day-to-day life', adj: 0 },
      { label: 'Below 80% / Service', sublabel: 'Shows service notice', adj: -3000 },
    ],
  },
  {
    id: 'functional',
    question: 'Face ID, Cameras & Speakers?',
    options: [
      { label: '100% Fully Functional', sublabel: 'Cameras, Face ID, mics tested', adj: 0 },
      { label: 'Camera Blur / Lens Scratch', sublabel: 'Minor optic imperfection', adj: -3500 },
      { label: 'Face ID / Touch Defect', sublabel: 'Biometrics unavailable', adj: -5000 },
    ],
  },
  {
    id: 'accessories',
    question: 'Box & Original Cable?',
    options: [
      { label: 'Original Box + Cable', sublabel: 'Matching IMEI box', adj: 1000 },
      { label: 'Device Only', sublabel: 'Without retail accessories', adj: 0 },
    ],
  },
];

const laptopQuestions: DiagnosticQuestion[] = [
  {
    id: 'display',
    question: 'Display Panel & Screen Glass?',
    options: [
      { label: 'Flawless Retina / OLED', sublabel: 'Zero dead pixels or marks', adj: 0 },
      { label: 'Minor Keyboard Imprint', sublabel: 'Faint coating mark', adj: -3000 },
      { label: 'Dead Pixels / Scratch', sublabel: 'Visible screen flaw', adj: -7000 },
    ],
  },
  {
    id: 'keyboard',
    question: 'Keyboard & Trackpad Condition?',
    options: [
      { label: 'All Keys & Touchpad Perfect', sublabel: 'Smooth typing & gestures', adj: 0 },
      { label: 'Sticky / Stiff Keys', sublabel: 'Minor key resistance', adj: -2500 },
      { label: 'Trackpad Click Defect', sublabel: 'Click or haptic unresponsive', adj: -4000 },
    ],
  },
  {
    id: 'battery',
    question: 'Battery Health & Charger?',
    options: [
      { label: 'Original Charger + High Health', sublabel: 'Holds charge 6+ hours', adj: 2000 },
      { label: 'Normal Battery Health', sublabel: 'Holds charge 3-5 hours', adj: 0 },
      { label: 'Service Battery Warning', sublabel: 'Requires replacement', adj: -4000 },
    ],
  },
  {
    id: 'body',
    question: 'Aluminum Body & Hinges?',
    options: [
      { label: 'Mint / Solid Hinges', sublabel: 'Smooth opening & closing', adj: 1500 },
      { label: 'Minor Edge Scuffs', sublabel: 'Cosmetic edge rub', adj: 0 },
      { label: 'Heavy Dent / Loose Hinge', sublabel: 'Chassis deformity', adj: -4500 },
    ],
  },
];

// Available Promo Coupon Codes
interface CouponOption {
  code: string;
  title: string;
  discount: number;
  description: string;
  minAmount: number;
}

const availableCoupons: CouponOption[] = [
  {
    code: 'CAMSIK500',
    title: 'Flat ₹500 Instant Discount',
    discount: 500,
    description: 'Instant welcome credit on any exchange upgrade',
    minAmount: 10000,
  },
  {
    code: 'UPGRADE1000',
    title: 'Flagship Upgrade Bonus: ₹1,000 OFF',
    discount: 1000,
    description: 'Applicable on pro cameras & flagship smartphone upgrades',
    minAmount: 25000,
  },
  {
    code: 'FESTIVE1500',
    title: 'Festive Mega Exchange: ₹1,500 OFF',
    discount: 1500,
    description: 'Special seasonal booster for certified refurbished purchases',
    minAmount: 40000,
  },
];

export default function ExchangeDevicePage() {
  const [step, setStep] = useState<ExchangeWizardStep>('select-old');

  // Step 1: Old Device Selection
  const [oldCategoryFilter, setOldCategoryFilter] = useState<string>('all');
  const [oldSearchQuery, setOldSearchQuery] = useState('');
  const [selectedOldDevice, setSelectedOldDevice] = useState<OldDeviceItem | null>(null);

  // Step 2: Diagnostics & Answers
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const exchangeBonus = 3000; // Guaranteed Camsik bonus

  // Step 3 & 4: Upgrade Products Catalog & Selection
  const [refurbishedCatalog, setRefurbishedCatalog] = useState<RefurbishedProduct[]>([]);
  const [newCategoryFilter, setNewCategoryFilter] = useState<string>('all');
  const [newSearchQuery, setNewSearchQuery] = useState('');
  const [selectedUpgradeProduct, setSelectedUpgradeProduct] = useState<RefurbishedProduct | null>(null);
  const [activeDetailCondition, setActiveDetailCondition] = useState<ProductCondition>('Superb');
  const [activeImageIndex, setActiveImageIndex] = useState(0);

  // Step 5: Checkout, Coupons, Slot Booking
  const [appliedCoupon, setAppliedCoupon] = useState<CouponOption | null>(null);
  const [customCouponInput, setCustomCouponInput] = useState('');
  const [couponError, setCouponError] = useState('');

  // Handover Slot & Address
  const [pickupDate, setPickupDate] = useState('');
  const [pickupSlot, setPickupSlot] = useState('10:00 AM - 1:00 PM');
  const [customerName, setCustomerName] = useState('');
  const [customerPhone, setCustomerPhone] = useState('');
  const [customerAddress, setCustomerAddress] = useState('');
  const [customerCity, setCustomerCity] = useState('');
  const [customerPincode, setCustomerPincode] = useState('');
  const [paymentPreference, setPaymentPreference] = useState<'delivery' | 'online' | 'emi'>('delivery');

  // Auth Gate
  const [currentUserState, setCurrentUserState] = useState<CustomerUser | null>(null);
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [authPhone, setAuthPhone] = useState('');
  const [authName, setAuthName] = useState('');
  const [authOtp, setAuthOtp] = useState('');
  const [authOtpSent, setAuthOtpSent] = useState(false);

  // Confirmed Order
  const [confirmedOrder, setConfirmedOrder] = useState<CustomerOrderRecord | null>(null);

  // ── Load Catalog & Auth on Mount ──
  useEffect(() => {
    const products = getRefurbishedProducts();
    setRefurbishedCatalog(products);

    const user = getCurrentUser();
    setCurrentUserState(user);
    if (user) {
      setCustomerName(user.name);
      setCustomerPhone(user.phone);
    }

    // Default pickup date to tomorrow
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    setPickupDate(tomorrow.toISOString().split('T')[0]);

    // Load city if stored in localStorage
    try {
      const savedCity = localStorage.getItem('camsik_city');
      if (savedCity) {
        const parsed = JSON.parse(savedCity);
        if (parsed?.name && parsed.name !== 'All Cities') {
          setCustomerCity(parsed.name);
        }
      }
    } catch {}
  }, []);

  // ── Diagnostics questions resolver based on chosen old device ──
  const activeQuestions = useMemo(() => {
    if (!selectedOldDevice) return cameraQuestions;
    if (selectedOldDevice.category === 'Smartphones') return smartphoneQuestions;
    if (selectedOldDevice.category === 'Laptops') return laptopQuestions;
    return cameraQuestions;
  }, [selectedOldDevice]);

  // ── Valuation Calculation ──
  const diagnosticAdjustmentsTotal = useMemo(() => {
    return Object.values(answers).reduce((acc, curr) => acc + curr, 0);
  }, [answers]);

  const oldDeviceNetValuation = useMemo(() => {
    if (!selectedOldDevice) return 0;
    const calculated = selectedOldDevice.basePrice + diagnosticAdjustmentsTotal;
    return Math.max(calculated, 8000);
  }, [selectedOldDevice, diagnosticAdjustmentsTotal]);

  const totalTradeInCredit = useMemo(() => {
    return oldDeviceNetValuation + exchangeBonus;
  }, [oldDeviceNetValuation, exchangeBonus]);

  // ── Filtered Old Devices ──
  const filteredOldDevices = useMemo(() => {
    return oldTradeInDevices.filter((d) => {
      const matchCat =
        oldCategoryFilter === 'all' ||
        d.category.toLowerCase() === oldCategoryFilter.toLowerCase();
      const matchSearch =
        oldSearchQuery.trim() === '' ||
        d.name.toLowerCase().includes(oldSearchQuery.toLowerCase()) ||
        d.brand.toLowerCase().includes(oldSearchQuery.toLowerCase()) ||
        d.specs.toLowerCase().includes(oldSearchQuery.toLowerCase());
      return matchCat && matchSearch;
    });
  }, [oldCategoryFilter, oldSearchQuery]);

  // ── Filtered Upgrade Products ──
  const filteredUpgradeProducts = useMemo(() => {
    return refurbishedCatalog.filter((p) => {
      const matchCat =
        newCategoryFilter === 'all' ||
        p.category.toLowerCase() === newCategoryFilter.toLowerCase();
      const matchSearch =
        newSearchQuery.trim() === '' ||
        p.model.toLowerCase().includes(newSearchQuery.toLowerCase()) ||
        p.brand.toLowerCase().includes(newSearchQuery.toLowerCase()) ||
        p.specs.toLowerCase().includes(newSearchQuery.toLowerCase());
      return matchCat && matchSearch;
    });
  }, [refurbishedCatalog, newCategoryFilter, newSearchQuery]);

  // ── Model Variants for Product Detail View (Step 4) ──
  const currentModelKey = selectedUpgradeProduct
    ? getModelKey(selectedUpgradeProduct)
    : '';

  const siblingVariants = useMemo(() => {
    if (!selectedUpgradeProduct) return [];
    return getVariantsByModel(refurbishedCatalog, currentModelKey);
  }, [refurbishedCatalog, selectedUpgradeProduct, currentModelKey]);

  const conditionGroups = useMemo(() => {
    if (!selectedUpgradeProduct) {
      return { Superb: [], Good: [], Fair: [] };
    }
    return getConditionsForModel(refurbishedCatalog, currentModelKey);
  }, [refurbishedCatalog, selectedUpgradeProduct, currentModelKey]);

  // ── Financial Breakdown for Checkout (Step 5) ──
  const upgradeDevicePrice = selectedUpgradeProduct?.sellingPrice || 0;
  const couponDiscountAmount = appliedCoupon ? appliedCoupon.discount : 0;
  const netPayableAmount = Math.max(
    upgradeDevicePrice - totalTradeInCredit - couponDiscountAmount,
    0
  );

  // ── Navigation Handlers ──
  const handleSelectOldDevice = (item: OldDeviceItem) => {
    setSelectedOldDevice(item);
    // Initialize default answers (option index 0 for each question)
    const defaults: Record<string, number> = {};
    const questions =
      item.category === 'Smartphones'
        ? smartphoneQuestions
        : item.category === 'Laptops'
        ? laptopQuestions
        : cameraQuestions;
    questions.forEach((q) => {
      defaults[q.id] = q.options[0].adj;
    });
    setAnswers(defaults);
    setStep('condition');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleSelectUpgradeModel = (prod: RefurbishedProduct) => {
    setSelectedUpgradeProduct(prod);
    setActiveDetailCondition(prod.condition);
    setActiveImageIndex(0);
    setStep('product-detail');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleSwitchUnit = (unit: RefurbishedProduct) => {
    setSelectedUpgradeProduct(unit);
    setActiveDetailCondition(unit.condition);
    setActiveImageIndex(0);
  };

  const handleSelectConditionGrade = (cond: ProductCondition) => {
    setActiveDetailCondition(cond);
    if (!selectedUpgradeProduct) return;
    const unitsInCond = conditionGroups[cond];
    if (unitsInCond && unitsInCond.length > 0) {
      setSelectedUpgradeProduct(unitsInCond[0]);
      setActiveImageIndex(0);
    }
  };

  const handleApplyCoupon = (coupon: CouponOption) => {
    if (upgradeDevicePrice < coupon.minAmount) {
      setCouponError(`Requires minimum upgrade value of ₹${coupon.minAmount.toLocaleString('en-IN')}`);
      return;
    }
    setAppliedCoupon(coupon);
    setCouponError('');
  };

  const handleApplyCustomCoupon = (e: React.FormEvent) => {
    e.preventDefault();
    const query = customCouponInput.trim().toUpperCase();
    const match = availableCoupons.find((c) => c.code === query);
    if (match) {
      handleApplyCoupon(match);
      setCustomCouponInput('');
    } else {
      setCouponError('Invalid coupon code. Try CAMSIK500 or UPGRADE1000');
    }
  };

  // ── Auth Handling ──
  const handleTriggerAuth = () => {
    setShowAuthModal(true);
  };

  const handleQuickLoginSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!authOtpSent) {
      if (authPhone.replace(/\D/g, '').length < 10) return;
      setAuthOtpSent(true);
    } else {
      // Complete login
      const newUser: CustomerUser = {
        id: 'user-' + Date.now(),
        name: authName.trim() || `Customer ${authPhone.slice(-4)}`,
        phone: authPhone.trim(),
        createdAt: new Date().toISOString(),
      };
      setCurrentUser(newUser);
      setCurrentUserState(newUser);
      setCustomerName(newUser.name);
      setCustomerPhone(newUser.phone);
      setShowAuthModal(false);
    }
  };

  // ── Confirm Exchange Order ──
  const handleConfirmOrder = () => {
    if (!currentUserState) {
      setShowAuthModal(true);
      return;
    }

    if (!customerName || !customerPhone || !customerAddress || !customerPincode) {
      alert('Please fill in your complete delivery address and phone number.');
      return;
    }

    const orderId = 'CAM-EXCH-' + Math.floor(100000 + Math.random() * 900000);
    const orderRecord: CustomerOrderRecord = {
      id: orderId,
      orderNumber: orderId,
      type: 'exchange',
      status: 'handover_scheduled',
      createdAt: new Date().toISOString(),
      customerName,
      customerPhone,
      customerAddress,
      city: customerCity || 'Delhi NCR',
      pincode: customerPincode,
      pickupDate,
      pickupSlot,
      paymentMethod: paymentPreference === 'delivery' ? 'Pay on Handover (Cash/UPI)' : paymentPreference === 'online' ? 'Prepaid Online' : 'No-Cost EMI',
      paymentStatus: paymentPreference === 'online' ? 'paid' : 'pay_on_delivery',
      oldDevice: selectedOldDevice
        ? {
            brand: selectedOldDevice.brand,
            model: selectedOldDevice.name,
            image: selectedOldDevice.image,
            category: selectedOldDevice.category,
            conditionSummary: 'Verified 5-Point Trade-In Diagnostics',
            valuation: oldDeviceNetValuation,
            exchangeBonus,
          }
        : undefined,
      newDevice: selectedUpgradeProduct
        ? {
            id: selectedUpgradeProduct.id,
            brand: selectedUpgradeProduct.brand,
            model: selectedUpgradeProduct.model,
            storage: selectedUpgradeProduct.storage,
            color: selectedUpgradeProduct.color,
            condition: selectedUpgradeProduct.condition,
            price: selectedUpgradeProduct.sellingPrice,
            originalPrice: selectedUpgradeProduct.originalPrice,
            warranty: selectedUpgradeProduct.warranty,
            batteryHealth: selectedUpgradeProduct.batteryHealth,
            image:
              selectedUpgradeProduct.gallery && selectedUpgradeProduct.gallery[0]
                ? selectedUpgradeProduct.gallery[0]
                : selectedUpgradeProduct.image,
          }
        : undefined,
      upgradePrice: upgradeDevicePrice,
      tradeInCredit: oldDeviceNetValuation,
      exchangeBonus,
      couponCode: appliedCoupon?.code,
      couponDiscount: couponDiscountAmount,
      netPayable: netPayableAmount,
    };

    saveCustomerOrder(orderRecord);
    setConfirmedOrder(orderRecord);
    setStep('confirmed');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <main className="min-h-screen bg-slate-50 flex flex-col justify-between">
      <div>
        <CustomerHeader />

        {/* ─────────────────────────────────────────────────────────────
            HEADER HERO & WORKFLOW STEPPER BAR (MATCHING SCREENSHOT 1)
        ────────────────────────────────────────────────────────────── */}
        <section className="bg-white border-b border-slate-200/80 pt-6 pb-4 sm:pt-8 sm:pb-6">
          <div className="max-w-6xl mx-auto px-4 sm:px-6">
            <div className="max-w-3xl">
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 text-xs font-black mb-3 border border-emerald-200">
                <RefreshCw size={13} className="animate-spin-slow text-emerald-600" />
                <span>UPGRADE &amp; TRADE-IN PROGRAM</span>
              </div>
              <h1 className="text-2xl sm:text-4xl font-black text-slate-900 tracking-tight">
                Exchange Your Old Device for a Newer Model
              </h1>
              <p className="text-xs sm:text-sm text-slate-500 mt-1">
                Get guaranteed ₹3,000 extra exchange bonus on top of market valuation. Simultaneous doorstep handover with zero downtime for your work.
              </p>
            </div>

            {/* Stepper Progress Bar */}
            <div className="mt-6 pt-5 border-t border-slate-100 overflow-x-auto scrollbar-none">
              <div className="flex items-center justify-between min-w-[650px] text-xs">
                {[
                  { key: 'select-old', num: '1', title: 'Select Old Device', desc: 'Choose trade-in gear' },
                  { key: 'condition', num: '2', title: 'Condition Check', desc: 'Get instant valuation' },
                  { key: 'select-new', num: '3', title: 'Choose Upgrade', desc: 'Select target device' },
                  { key: 'product-detail', num: '4', title: 'Unit & Grade', desc: 'Photos & specs' },
                  { key: 'checkout', num: '5', title: 'Pay Difference', desc: 'Coupons & slot' },
                ].map((s, idx, arr) => {
                  const isCurrent = step === s.key;
                  const isPast =
                    (s.key === 'select-old' && step !== 'select-old') ||
                    (s.key === 'condition' && ['select-new', 'product-detail', 'checkout', 'confirmed'].includes(step)) ||
                    (s.key === 'select-new' && ['product-detail', 'checkout', 'confirmed'].includes(step)) ||
                    (s.key === 'product-detail' && ['checkout', 'confirmed'].includes(step));

                  return (
                    <React.Fragment key={s.key}>
                      <div className="flex items-center gap-2.5">
                        <div
                          className={`w-7 h-7 rounded-full flex items-center justify-center font-black text-xs transition-all ${
                            isCurrent
                              ? 'bg-emerald-600 text-white ring-4 ring-emerald-100 shadow-xs'
                              : isPast
                              ? 'bg-slate-900 text-white'
                              : 'bg-slate-100 text-slate-400'
                          }`}
                        >
                          {isPast ? <Check size={14} strokeWidth={3} /> : s.num}
                        </div>
                        <div>
                          <p className={`font-bold leading-none ${isCurrent ? 'text-slate-900 font-black' : isPast ? 'text-slate-700' : 'text-slate-400'}`}>
                            {s.title}
                          </p>
                          <p className="text-[10px] text-slate-400 mt-0.5">{s.desc}</p>
                        </div>
                      </div>
                      {idx < arr.length - 1 && <ChevronRight size={14} className="text-slate-300 mx-2 shrink-0" />}
                    </React.Fragment>
                  );
                })}
              </div>
            </div>
          </div>
        </section>

        {/* ─────────────────────────────────────────────────────────────
            STEP 1: SELECT OLD DEVICE (SCREENSHOT 1)
        ────────────────────────────────────────────────────────────── */}
        {step === 'select-old' && (
          <section className="max-w-6xl mx-auto px-4 sm:px-6 py-8">
            <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                <div>
                  <h2 className="text-xl sm:text-2xl font-black text-slate-900">
                    Select Your Existing Device
                  </h2>
                  <p className="text-xs sm:text-sm text-slate-500 mt-0.5">
                    Choose the camera body, lens, smartphone or laptop you want to trade in
                  </p>
                </div>

                {/* Real-time search */}
                <div className="relative w-full sm:w-72">
                  <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                  <input
                    type="text"
                    placeholder="Search your old device..."
                    value={oldSearchQuery}
                    onChange={(e) => setOldSearchQuery(e.target.value)}
                    className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 bg-slate-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-500/30 transition-all"
                  />
                  {oldSearchQuery && (
                    <button
                      type="button"
                      onClick={() => setOldSearchQuery('')}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                    >
                      <X size={14} />
                    </button>
                  )}
                </div>
              </div>

              {/* Category Filter Pills */}
              <div className="flex items-center gap-2 overflow-x-auto pb-3 mb-6 scrollbar-none">
                {[
                  { key: 'all', label: 'All Equipment' },
                  { key: 'cameras', label: '📷 DSLR & Mirrorless' },
                  { key: 'lenses', label: '🔍 Camera Lenses' },
                  { key: 'smartphones', label: '📱 Smartphones' },
                  { key: 'laptops', label: '💻 Laptops & Tablets' },
                ].map((tab) => (
                  <button
                    key={tab.key}
                    type="button"
                    onClick={() => setOldCategoryFilter(tab.key)}
                    className={`px-4 py-2 rounded-xl text-xs font-bold transition-all whitespace-nowrap cursor-pointer ${
                      oldCategoryFilter === tab.key
                        ? 'bg-slate-900 text-white shadow-sm'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200/80'
                    }`}
                  >
                    {tab.label}
                  </button>
                ))}
              </div>

              {/* Grid of Devices (Matches Screenshot 1) */}
              {filteredOldDevices.length > 0 ? (
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
                  {filteredOldDevices.map((item) => (
                    <button
                      key={item.id}
                      type="button"
                      onClick={() => handleSelectOldDevice(item)}
                      className="p-4 rounded-2xl border border-slate-200/90 bg-white hover:border-emerald-500 hover:shadow-md transition-all text-left flex items-center gap-3.5 group cursor-pointer"
                    >
                      <div className="w-16 h-16 rounded-xl bg-slate-50 p-1 flex items-center justify-center shrink-0 border border-slate-100 group-hover:scale-105 transition-transform">
                        <img src={item.image} alt={item.name} className="max-w-full max-h-full object-contain" />
                      </div>
                      <div className="min-w-0 flex-1">
                        <span className="text-[10px] font-black uppercase text-emerald-700 tracking-wider">
                          {item.brand}
                        </span>
                        <p className="text-sm font-black text-slate-900 truncate leading-snug">
                          {item.name}
                        </p>
                        <p className="text-xs font-extrabold text-emerald-600 mt-1">
                          Up to ₹{item.basePrice.toLocaleString('en-IN')}
                        </p>
                      </div>
                    </button>
                  ))}
                </div>
              ) : (
                <div className="text-center py-12">
                  <p className="text-sm font-semibold text-slate-500">
                    No devices found matching &ldquo;{oldSearchQuery}&rdquo;.
                  </p>
                  <button
                    type="button"
                    onClick={() => {
                      setOldSearchQuery('');
                      setOldCategoryFilter('all');
                    }}
                    className="mt-3 text-xs font-bold text-emerald-600 hover:underline"
                  >
                    Clear search filter
                  </button>
                </div>
              )}
            </div>
          </section>
        )}

        {/* ─────────────────────────────────────────────────────────────
            STEP 2: ANSWER DIAGNOSTIC QUESTIONS
        ────────────────────────────────────────────────────────────── */}
        {step === 'condition' && selectedOldDevice && (
          <section className="max-w-4xl mx-auto px-4 sm:px-6 py-8">
            <button
              type="button"
              onClick={() => setStep('select-old')}
              className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-600 hover:text-slate-900 mb-6 group"
            >
              <ArrowLeft size={15} className="group-hover:-translate-x-1 transition-transform" />
              <span>Back to Gear Selection</span>
            </button>

            <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm">
              {/* Selected Old Device Banner */}
              <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200/80 flex items-center justify-between gap-4 mb-6">
                <div className="flex items-center gap-3.5">
                  <div className="w-14 h-14 rounded-xl bg-white p-1 border border-slate-200 flex items-center justify-center shrink-0">
                    <img src={selectedOldDevice.image} alt={selectedOldDevice.name} className="max-w-full max-h-full object-contain" />
                  </div>
                  <div>
                    <span className="text-[10px] font-black uppercase text-slate-500">{selectedOldDevice.brand} · {selectedOldDevice.category}</span>
                    <h3 className="text-base font-black text-slate-900 leading-tight">{selectedOldDevice.name}</h3>
                    <p className="text-xs text-slate-500 mt-0.5">{selectedOldDevice.specs}</p>
                  </div>
                </div>

                <div className="text-right hidden sm:block">
                  <span className="text-[11px] text-slate-400 font-medium">Base Market Value</span>
                  <p className="text-base font-black text-slate-800">₹{selectedOldDevice.basePrice.toLocaleString('en-IN')}</p>
                </div>
              </div>

              <div className="mb-6">
                <h2 className="text-xl sm:text-2xl font-black text-slate-900">
                  Verify Device Condition &amp; Shutter
                </h2>
                <p className="text-xs sm:text-sm text-slate-500 mt-0.5">
                  Select accurate options below for certified doorstep trade-in valuation
                </p>
              </div>

              {/* Diagnostic Questions */}
              <div className="space-y-6">
                {activeQuestions.map((q) => (
                  <div key={q.id} className="p-4 sm:p-5 rounded-2xl bg-slate-50/70 border border-slate-200/80">
                    <p className="text-sm font-black text-slate-900 mb-3">{q.question}</p>
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-2.5">
                      {q.options.map((opt) => {
                        const isSelected = answers[q.id] === opt.adj;
                        return (
                          <button
                            key={opt.label}
                            type="button"
                            onClick={() => setAnswers((prev) => ({ ...prev, [q.id]: opt.adj }))}
                            className={`p-3 rounded-xl border text-left transition-all cursor-pointer flex flex-col justify-between ${
                              isSelected
                                ? 'border-emerald-500 bg-white ring-2 ring-emerald-500/20 shadow-xs'
                                : 'border-slate-200 bg-white hover:border-slate-300'
                            }`}
                          >
                            <div>
                              <div className="flex items-center justify-between mb-1">
                                <span className={`text-xs font-black ${isSelected ? 'text-slate-900' : 'text-slate-800'}`}>
                                  {opt.label}
                                </span>
                                {isSelected && <Check size={13} className="text-emerald-600" />}
                              </div>
                              <p className="text-[11px] text-slate-500 font-medium leading-tight">
                                {opt.sublabel}
                              </p>
                            </div>
                            <span className="text-[10px] font-bold text-slate-400 mt-2">
                              {opt.adj > 0 ? `+₹${opt.adj}` : opt.adj < 0 ? `-₹${Math.abs(opt.adj)}` : 'Included'}
                            </span>
                          </button>
                        );
                      })}
                    </div>
                  </div>
                ))}
              </div>

              {/* Live Trade-in Value Breakdown Footer */}
              <div className="mt-8 p-5 sm:p-6 rounded-2xl bg-gradient-to-r from-emerald-500/10 via-emerald-500/5 to-teal-500/10 border border-emerald-200 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-xs font-bold text-slate-600">Calculated Trade-In Credit:</span>
                    <span className="text-xs font-black text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-full">
                      +₹{exchangeBonus.toLocaleString('en-IN')} Guaranteed Bonus Included
                    </span>
                  </div>
                  <div className="flex items-baseline gap-2 mt-1">
                    <span className="text-2xl sm:text-3xl font-black text-emerald-700">
                      ₹{totalTradeInCredit.toLocaleString('en-IN')}
                    </span>
                    <span className="text-xs text-slate-500">
                      (Base: ₹{oldDeviceNetValuation.toLocaleString('en-IN')} + Bonus: ₹{exchangeBonus})
                    </span>
                  </div>
                </div>

                <button
                  type="button"
                  onClick={() => {
                    setStep('select-new');
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                  }}
                  className="px-6 py-3.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-black text-xs uppercase tracking-wider shadow-sm shadow-emerald-600/30 transition-all cursor-pointer flex items-center justify-center gap-2"
                >
                  <span>Choose Upgrade Gear</span>
                  <ArrowRight size={15} />
                </button>
              </div>
            </div>
          </section>
        )}

        {/* ─────────────────────────────────────────────────────────────
            STEP 3: SELECT TARGET UPGRADE PRODUCT
        ────────────────────────────────────────────────────────────── */}
        {step === 'select-new' && (
          <section className="max-w-6xl mx-auto px-4 sm:px-6 py-8">
            {/* Top Trade-in Credit Reminder Bar */}
            <div className="p-4 rounded-2xl bg-emerald-600 text-white flex flex-wrap items-center justify-between gap-3 mb-6 shadow-sm">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-xl bg-white/20 flex items-center justify-center text-white shrink-0">
                  <RefreshCw size={17} />
                </div>
                <div>
                  <p className="text-xs font-extrabold uppercase text-emerald-100">Trade-In Gear Active</p>
                  <p className="text-sm font-black">{selectedOldDevice?.name} · Value: ₹{totalTradeInCredit.toLocaleString('en-IN')}</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setStep('condition')}
                className="text-xs font-bold text-white underline hover:text-emerald-100"
              >
                Change Valuation &larr;
              </button>
            </div>

            <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-8 shadow-sm">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                <div>
                  <h2 className="text-xl sm:text-2xl font-black text-slate-900">
                    Select Your Target Upgrade Device
                  </h2>
                  <p className="text-xs sm:text-sm text-slate-500 mt-0.5">
                    Choose any certified refurbished camera, smartphone, or laptop to upgrade to
                  </p>
                </div>

                <div className="relative w-full sm:w-72">
                  <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                  <input
                    type="text"
                    placeholder="Search upgrade model..."
                    value={newSearchQuery}
                    onChange={(e) => setNewSearchQuery(e.target.value)}
                    className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 bg-slate-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-500/30 transition-all"
                  />
                  {newSearchQuery && (
                    <button
                      type="button"
                      onClick={() => setNewSearchQuery('')}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                    >
                      <X size={14} />
                    </button>
                  )}
                </div>
              </div>

              {/* Category Pills */}
              <div className="flex items-center gap-2 overflow-x-auto pb-3 mb-6 scrollbar-none">
                {[
                  { key: 'all', label: 'All Upgrades' },
                  { key: 'smartphones', label: '📱 Smartphones' },
                  { key: 'cameras', label: '📷 Cameras & Optics' },
                  { key: 'laptops', label: '💻 Laptops' },
                  { key: 'tablets', label: '📟 Tablets' },
                  { key: 'smartwatches', label: '⌚ Smartwatches' },
                ].map((tab) => (
                  <button
                    key={tab.key}
                    type="button"
                    onClick={() => setNewCategoryFilter(tab.key)}
                    className={`px-4 py-2 rounded-xl text-xs font-bold transition-all whitespace-nowrap cursor-pointer ${
                      newCategoryFilter === tab.key
                        ? 'bg-slate-900 text-white shadow-sm'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200/80'
                    }`}
                  >
                    {tab.label}
                  </button>
                ))}
              </div>

              {/* Upgrade Products Grid */}
              {filteredUpgradeProducts.length > 0 ? (
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                  {filteredUpgradeProducts.map((prod) => {
                    const effectivePayable = Math.max(prod.sellingPrice - totalTradeInCredit, 0);
                    return (
                      <div
                        key={prod.id}
                        className="p-5 rounded-3xl border border-slate-200 bg-white hover:border-emerald-500 hover:shadow-lg transition-all flex flex-col justify-between group"
                      >
                        <div>
                          <div className="relative aspect-square rounded-2xl bg-slate-50 border border-slate-100 overflow-hidden p-4 mb-4 flex items-center justify-center">
                            <img
                              src={prod.image}
                              alt={prod.model}
                              className="max-w-full max-h-full object-contain group-hover:scale-105 transition-transform duration-300"
                            />
                            <div className="absolute top-2.5 left-2.5">
                              <span className="text-[10px] font-black uppercase px-2 py-0.5 rounded-full bg-slate-900 text-white">
                                {prod.category}
                              </span>
                            </div>
                            <div className="absolute top-2.5 right-2.5">
                              <span className="text-[10px] font-black px-2 py-0.5 rounded-full bg-emerald-500 text-white">
                                {prod.discount}% OFF
                              </span>
                            </div>
                          </div>

                          <p className="text-[11px] font-bold text-slate-500 uppercase tracking-wider">
                            {prod.brand}
                          </p>
                          <h3 className="text-base font-black text-slate-900 mt-0.5 line-clamp-1">
                            {prod.model}
                          </h3>
                          <p className="text-xs text-slate-500 mt-1 line-clamp-1">
                            {prod.specs}
                          </p>
                        </div>

                        {/* Price & Difference */}
                        <div className="mt-5 pt-4 border-t border-slate-100">
                          <div className="flex items-baseline justify-between mb-2">
                            <div>
                              <p className="text-[10px] text-slate-400">Certified Price</p>
                              <p className="text-xs font-semibold text-slate-600 line-through">
                                ₹{prod.originalPrice.toLocaleString('en-IN')}
                              </p>
                            </div>
                            <div className="text-right">
                              <p className="text-[10px] font-bold text-emerald-700">You Pay Difference</p>
                              <p className="text-lg font-black text-slate-900">
                                ₹{effectivePayable.toLocaleString('en-IN')}
                              </p>
                            </div>
                          </div>

                          <div className="p-2 rounded-xl bg-emerald-50 text-emerald-800 text-[11px] font-bold flex items-center justify-between mb-3 border border-emerald-200/60">
                            <span>Trade-In Credit Applied:</span>
                            <span>- ₹{totalTradeInCredit.toLocaleString('en-IN')}</span>
                          </div>

                          <button
                            type="button"
                            onClick={() => handleSelectUpgradeModel(prod)}
                            className="w-full py-3 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-black text-xs uppercase tracking-wider transition-all cursor-pointer flex items-center justify-center gap-1.5 shadow-xs"
                          >
                            <span>View Units &amp; Select</span>
                            <ArrowRight size={13} />
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <div className="text-center py-12">
                  <p className="text-sm font-semibold text-slate-500">
                    No products found matching &ldquo;{newSearchQuery}&rdquo;.
                  </p>
                </div>
              )}
            </div>
          </section>
        )}

        {/* ─────────────────────────────────────────────────────────────
            STEP 4: DETAILED PRODUCT VIEW (MATCHING /buy-refurbished)
        ────────────────────────────────────────────────────────────── */}
        {step === 'product-detail' && selectedUpgradeProduct && (
          <section className="max-w-6xl mx-auto px-4 sm:px-6 py-8">
            <button
              type="button"
              onClick={() => setStep('select-new')}
              className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-600 hover:text-slate-900 mb-6 group"
            >
              <ArrowLeft size={15} className="group-hover:-translate-x-1 transition-transform" />
              <span>Back to All Upgrades</span>
            </button>

            {/* Trade-In Active Highlight Banner */}
            <div className="p-4 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-900 flex flex-wrap items-center justify-between gap-3 mb-6">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-emerald-600 text-white flex items-center justify-center font-black text-xs shadow-xs">
                  ✓
                </div>
                <div>
                  <p className="text-xs font-black">Trade-In Gear: {selectedOldDevice?.name}</p>
                  <p className="text-[11px] text-emerald-700">
                    Total Credit: ₹{totalTradeInCredit.toLocaleString('en-IN')} (Includes ₹3,000 Extra Exchange Bonus)
                  </p>
                </div>
              </div>
              <div className="text-right">
                <span className="text-[11px] text-slate-500">Net Upgrade Price:</span>
                <span className="text-base font-black text-slate-900 ml-2">
                  ₹{Math.max(selectedUpgradeProduct.sellingPrice - totalTradeInCredit, 0).toLocaleString('en-IN')}
                </span>
              </div>
            </div>

            <div className="bg-white rounded-3xl border border-slate-200 shadow-xl overflow-hidden p-6 sm:p-10">
              <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12">
                {/* Left Column: Image Showcase & Dedicated Multi-Angle Thumbnails */}
                <div className="lg:col-span-6 flex flex-col items-center">
                  <div className="relative w-full aspect-square max-w-[420px] rounded-2xl bg-slate-50 border border-slate-200/80 p-6 flex items-center justify-center mb-4 overflow-hidden">
                    <img
                      key={`${selectedUpgradeProduct.id}-${activeImageIndex}`}
                      src={
                        selectedUpgradeProduct.gallery && selectedUpgradeProduct.gallery[activeImageIndex]
                          ? selectedUpgradeProduct.gallery[activeImageIndex]
                          : selectedUpgradeProduct.image
                      }
                      alt={`${selectedUpgradeProduct.brand} ${selectedUpgradeProduct.model} - ${selectedUpgradeProduct.color}`}
                      className="max-w-full max-h-full object-contain filter drop-shadow-md transition-all duration-300"
                    />
                    <div className="absolute top-3 left-3">
                      <span className="text-xs font-bold px-2.5 py-1 rounded-full border bg-emerald-50 text-emerald-700 border-emerald-200">
                        {selectedUpgradeProduct.condition}
                      </span>
                    </div>
                    <div className="absolute top-3 right-3">
                      <span className="text-xs font-extrabold px-2.5 py-1 rounded-full bg-emerald-500 text-white">
                        {selectedUpgradeProduct.discount}% OFF
                      </span>
                    </div>
                    {/* Selected Color & Storage Badge on Image */}
                    <div className="absolute bottom-3 left-1/2 -translate-x-1/2 px-3 py-1 rounded-full bg-white/95 backdrop-blur-xs border border-slate-200/80 text-[11px] font-bold text-slate-700 shadow-xs flex items-center gap-1.5 whitespace-nowrap">
                      <span className="w-2 h-2 rounded-full bg-emerald-500" />
                      <span>{selectedUpgradeProduct.color} · {selectedUpgradeProduct.storage}</span>
                    </div>
                  </div>

                  {/* Clickable Multi-Angle Thumbnails */}
                  <div className="flex items-center gap-3 w-full max-w-[420px] justify-center overflow-x-auto py-1">
                    {(selectedUpgradeProduct.gallery && selectedUpgradeProduct.gallery.length > 0
                      ? selectedUpgradeProduct.gallery
                      : [selectedUpgradeProduct.image]
                    ).map((img, idx) => {
                      const isSelected = activeImageIndex === idx;
                      return (
                        <button
                          key={`${selectedUpgradeProduct.id}-thumb-${idx}`}
                          type="button"
                          onClick={() => setActiveImageIndex(idx)}
                          className={`w-20 h-20 rounded-xl bg-slate-50 p-2 border transition-all flex items-center justify-center cursor-pointer shrink-0 ${
                            isSelected
                              ? 'border-emerald-500 ring-2 ring-emerald-500/20 bg-white shadow-sm'
                              : 'border-slate-200 hover:border-slate-300 bg-white/50'
                          }`}
                        >
                          <img src={img} alt={`Angle ${idx + 1}`} className="max-w-full max-h-full object-contain" />
                        </button>
                      );
                    })}
                  </div>
                </div>

                {/* Right Column: Condition Grade & Units Switcher */}
                <div className="lg:col-span-6 flex flex-col justify-between space-y-6">
                  <div>
                    {/* Condition Pill & Note */}
                    <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 text-xs font-extrabold border border-emerald-200 mb-3">
                      <span className="w-2 h-2 rounded-full bg-emerald-500" />
                      <span>{selectedUpgradeProduct.condition}</span>
                      <span className="text-emerald-600/70">·</span>
                      <span className="font-medium text-emerald-800">{selectedUpgradeProduct.conditionNote}</span>
                    </div>

                    {/* Title & Storage/Color */}
                    <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
                      {selectedUpgradeProduct.brand} {selectedUpgradeProduct.model}
                    </h1>
                    <p className="text-sm font-semibold text-slate-500 mt-1">
                      {selectedUpgradeProduct.storage} · {selectedUpgradeProduct.color}
                    </p>

                    {/* Price Row */}
                    <div className="flex items-baseline gap-3 mt-4">
                      <span className="text-3xl sm:text-4xl font-black text-slate-900">
                        ₹{selectedUpgradeProduct.sellingPrice.toLocaleString('en-IN')}
                      </span>
                      <span className="text-base text-slate-400 line-through">
                        ₹{selectedUpgradeProduct.originalPrice.toLocaleString('en-IN')}
                      </span>
                      <span className="text-xs sm:text-sm font-extrabold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-lg border border-emerald-200">
                        {selectedUpgradeProduct.discount}% OFF
                      </span>
                    </div>

                    {/* ─────────────────────────────────────────────────────────────
                        STEP 1: SELECT CONDITION GRADE (Superb / Good / Fair)
                    ────────────────────────────────────────────────────────────── */}
                    <div className="mt-6 p-4 sm:p-5 rounded-2xl bg-slate-50/90 border border-slate-200/90 shadow-xs">
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-2">
                          <span className="w-5 h-5 rounded-full bg-emerald-500 text-white text-xs font-black flex items-center justify-center shadow-xs">
                            1
                          </span>
                          <h3 className="text-xs font-extrabold text-slate-900 uppercase tracking-wider">
                            Select Condition Grade
                          </h3>
                        </div>
                        <span className="text-[11px] font-bold text-slate-500 bg-white px-2 py-0.5 rounded-md border border-slate-200/60">
                          {siblingVariants.length} certified {siblingVariants.length === 1 ? 'unit' : 'units'} listed
                        </span>
                      </div>

                      {/* 3 Condition Option Cards */}
                      <div className="grid grid-cols-1 sm:grid-cols-3 gap-2.5">
                        {(['Superb', 'Good', 'Fair'] as ProductCondition[]).map((cond) => {
                          const isSelected = activeDetailCondition === cond;
                          const count = conditionGroups[cond].length;
                          const prices = conditionGroups[cond].map((p) => p.sellingPrice);
                          const minPrice = prices.length > 0 ? Math.min(...prices) : null;

                          return (
                            <button
                              key={cond}
                              type="button"
                              onClick={() => handleSelectConditionGrade(cond)}
                              className={`relative p-3 rounded-2xl border text-left transition-all duration-200 cursor-pointer flex flex-col justify-between group ${
                                isSelected
                                  ? 'bg-white border-emerald-500 ring-2 ring-emerald-500/20 shadow-sm'
                                  : 'bg-white border-slate-200 hover:border-slate-300 hover:bg-slate-50/50'
                              }`}
                            >
                              {isSelected && (
                                <span className="absolute -top-2 -right-1 bg-slate-900 text-white text-[10px] font-black px-2 py-0.5 rounded-full shadow-xs flex items-center gap-1">
                                  <Check size={11} strokeWidth={3} /> Selected
                                </span>
                              )}

                              <div>
                                <div className="flex items-center justify-between gap-1 mb-1">
                                  <span className={`text-sm font-black ${isSelected ? 'text-slate-900' : 'text-slate-800'}`}>
                                    {cond}
                                  </span>
                                  <span
                                    className={`text-[10px] font-extrabold px-1.5 py-0.5 rounded-md ${
                                      count > 0 ? 'bg-emerald-50 text-emerald-700' : 'bg-slate-100 text-slate-400'
                                    }`}
                                  >
                                    {count > 0 ? `${count} available` : 'Out of stock'}
                                  </span>
                                </div>
                                <p className="text-[11px] font-medium text-slate-500 leading-tight">
                                  {cond === 'Superb' ? 'Like New · Minimal marks' : cond === 'Good' ? 'Lightly Used · Best Value' : 'Budget Deal · Fully Tested'}
                                </p>
                              </div>

                              <div className="mt-2 pt-2 border-t border-slate-100 flex items-center justify-between text-[11px]">
                                <span className="text-slate-400">Starting</span>
                                <span className="font-bold text-slate-900">
                                  {minPrice ? `₹${minPrice.toLocaleString('en-IN')}` : '—'}
                                </span>
                              </div>
                            </button>
                          );
                        })}
                      </div>

                      {/* ─────────────────────────────────────────────────────────────
                          STEP 2: AVAILABLE UNITS IN CHOSEN CONDITION
                      ────────────────────────────────────────────────────────────── */}
                      <div className="mt-5 pt-4 border-t border-slate-200/80">
                        <div className="flex items-center justify-between mb-3">
                          <div className="flex items-center gap-2">
                            <span className="w-5 h-5 rounded-full bg-slate-900 text-white text-xs font-black flex items-center justify-center shadow-xs">
                              2
                            </span>
                            <h4 className="text-xs font-extrabold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
                              <span>Available Units in</span>
                              <span className="text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md border border-emerald-200 text-[11px]">
                                {activeDetailCondition} Condition
                              </span>
                            </h4>
                          </div>
                          <span className="text-[11px] font-semibold text-slate-500 hidden sm:inline">
                            Tap any unit to switch details &amp; photos
                          </span>
                        </div>

                        {/* Units List */}
                        {conditionGroups[activeDetailCondition].length > 0 ? (
                          <div className="space-y-2 max-h-[260px] overflow-y-auto pr-1">
                            {conditionGroups[activeDetailCondition].map((unit) => {
                              const isCurrentUnit = selectedUpgradeProduct.id === unit.id;
                              return (
                                <button
                                  key={unit.id}
                                  type="button"
                                  onClick={() => handleSwitchUnit(unit)}
                                  className={`w-full p-3 rounded-2xl border text-left transition-all duration-200 flex items-center justify-between gap-3 group cursor-pointer ${
                                    isCurrentUnit
                                      ? 'border-emerald-500 bg-white ring-2 ring-emerald-500/20 shadow-md'
                                      : 'bg-white border-slate-200 hover:border-slate-300 hover:bg-slate-50/80 shadow-xs'
                                  }`}
                                >
                                  <div className="flex items-center gap-3 min-w-0">
                                    <div className="w-12 h-12 rounded-xl bg-slate-50 border border-slate-200/80 p-1 flex items-center justify-center shrink-0">
                                      <img
                                        src={unit.gallery && unit.gallery[0] ? unit.gallery[0] : unit.image}
                                        alt={unit.model}
                                        className="max-w-full max-h-full object-contain"
                                      />
                                    </div>
                                    <div className="min-w-0">
                                      <div className="flex items-center gap-2 flex-wrap">
                                        <span className="text-xs font-black text-slate-900">{unit.storage}</span>
                                        <span className="text-slate-300">·</span>
                                        <span className="text-xs font-semibold text-slate-600 truncate">{unit.color}</span>
                                        {isCurrentUnit && (
                                          <span className="text-[10px] font-extrabold px-2 py-0.5 rounded-full bg-emerald-500 text-white">
                                            Currently Selected
                                          </span>
                                        )}
                                      </div>
                                      <div className="flex items-center gap-2 mt-1 text-[11px] font-medium text-slate-500 flex-wrap">
                                        <span className="inline-flex items-center gap-1 font-bold text-emerald-700">
                                          <BatteryCharging size={12} className="text-emerald-600" />
                                          {typeof unit.batteryHealth === 'number' ? `${unit.batteryHealth}% Battery` : unit.batteryHealth}
                                        </span>
                                        <span className="text-slate-300">·</span>
                                        <span>{unit.warranty} Warranty</span>
                                      </div>
                                    </div>
                                  </div>

                                  <div className="text-right shrink-0">
                                    <p className="text-sm font-black text-slate-900">
                                      ₹{unit.sellingPrice.toLocaleString('en-IN')}
                                    </p>
                                    <p className="text-[10px] text-emerald-600 font-extrabold">
                                      {unit.discount}% OFF
                                    </p>
                                  </div>
                                </button>
                              );
                            })}
                          </div>
                        ) : (
                          <div className="p-4 rounded-xl bg-slate-100 text-center text-xs text-slate-500">
                            No certified units currently available in {activeDetailCondition} condition.
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Proceed CTA */}
                  <div className="pt-4 border-t border-slate-100 flex items-center justify-between gap-4">
                    <div>
                      <p className="text-xs text-slate-400">Net Payable After Trade-In:</p>
                      <p className="text-2xl font-black text-emerald-700">
                        ₹{Math.max(selectedUpgradeProduct.sellingPrice - totalTradeInCredit, 0).toLocaleString('en-IN')}
                      </p>
                    </div>

                    <button
                      type="button"
                      onClick={() => {
                        setStep('checkout');
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                      }}
                      className="px-8 py-4 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-black text-sm shadow-lg shadow-emerald-600/30 transition-all cursor-pointer flex items-center gap-2"
                    >
                      <span>Proceed to Exchange Checkout</span>
                      <ArrowRight size={16} />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </section>
        )}

        {/* ─────────────────────────────────────────────────────────────
            STEP 5: CHECKOUT, COUPONS & DETAILED SUMMARY (SCREENSHOT 2)
        ────────────────────────────────────────────────────────────── */}
        {step === 'checkout' && selectedOldDevice && selectedUpgradeProduct && (
          <section className="max-w-6xl mx-auto px-4 sm:px-6 py-8">
            <button
              type="button"
              onClick={() => setStep('product-detail')}
              className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-600 hover:text-slate-900 mb-6 group"
            >
              <ArrowLeft size={15} className="group-hover:-translate-x-1 transition-transform" />
              <span>Back to Unit Selection</span>
            </button>

            <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
              {/* Left Column: Side-by-Side Comparative Cards + Doorstep Schedule & Address */}
              <div className="lg:col-span-7 space-y-6">
                {/* 1. Comparative Trade-In Visual Card */}
                <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                  <h3 className="text-base font-black text-slate-900 mb-4 flex items-center gap-2">
                    <RefreshCw size={17} className="text-emerald-600" />
                    <span>Doorstep Exchange Overview</span>
                  </h3>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {/* Old Gear */}
                    <div className="p-4 rounded-2xl bg-amber-50/50 border border-amber-200/70 flex flex-col justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-14 h-14 rounded-xl bg-white p-1 border border-amber-200/80 flex items-center justify-center shrink-0">
                          <img src={selectedOldDevice.image} alt={selectedOldDevice.name} className="max-w-full max-h-full object-contain" />
                        </div>
                        <div className="min-w-0">
                          <span className="text-[10px] font-extrabold uppercase px-2 py-0.5 rounded bg-amber-100 text-amber-800">
                            Old Device Handover
                          </span>
                          <p className="text-xs font-black text-slate-900 truncate mt-1">
                            {selectedOldDevice.name}
                          </p>
                          <p className="text-[11px] text-slate-500 font-semibold">
                            Trade-In Value: ₹{oldDeviceNetValuation.toLocaleString('en-IN')}
                          </p>
                        </div>
                      </div>
                      <div className="mt-3 pt-2.5 border-t border-amber-200/60 text-[11px] font-bold text-emerald-700 flex items-center justify-between">
                        <span>Guaranteed Bonus:</span>
                        <span>+ ₹{exchangeBonus.toLocaleString('en-IN')}</span>
                      </div>
                    </div>

                    {/* New Upgrade */}
                    <div className="p-4 rounded-2xl bg-emerald-50/50 border border-emerald-200/70 flex flex-col justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-14 h-14 rounded-xl bg-white p-1 border border-emerald-200/80 flex items-center justify-center shrink-0">
                          <img
                            src={
                              selectedUpgradeProduct.gallery && selectedUpgradeProduct.gallery[0]
                                ? selectedUpgradeProduct.gallery[0]
                                : selectedUpgradeProduct.image
                            }
                            alt={selectedUpgradeProduct.model}
                            className="max-w-full max-h-full object-contain"
                          />
                        </div>
                        <div className="min-w-0">
                          <span className="text-[10px] font-extrabold uppercase px-2 py-0.5 rounded bg-emerald-100 text-emerald-800">
                            Upgrade Delivered
                          </span>
                          <p className="text-xs font-black text-slate-900 truncate mt-1">
                            {selectedUpgradeProduct.brand} {selectedUpgradeProduct.model}
                          </p>
                          <p className="text-[11px] text-slate-600 font-semibold">
                            {selectedUpgradeProduct.storage} · {selectedUpgradeProduct.color}
                          </p>
                        </div>
                      </div>
                      <div className="mt-3 pt-2.5 border-t border-emerald-200/60 text-[11px] font-bold text-slate-700 flex items-center justify-between">
                        <span>Certified Condition:</span>
                        <span className="text-emerald-700 font-black">{selectedUpgradeProduct.condition} ({selectedUpgradeProduct.warranty})</span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* 2. Schedule Doorstep Handover Slot */}
                <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                  <h3 className="text-base font-black text-slate-900 mb-4 flex items-center gap-2">
                    <Calendar size={17} className="text-emerald-600" />
                    <span>Schedule Simultaneous Doorstep Handover</span>
                  </h3>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1.5">
                        Preferred Handover Date
                      </label>
                      <input
                        type="date"
                        value={pickupDate}
                        onChange={(e) => setPickupDate(e.target.value)}
                        min={new Date().toISOString().split('T')[0]}
                        className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1.5">
                        Preferred Time Window
                      </label>
                      <select
                        value={pickupSlot}
                        onChange={(e) => setPickupSlot(e.target.value)}
                        className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                      >
                        <option value="10:00 AM - 1:00 PM">10:00 AM - 1:00 PM (Morning)</option>
                        <option value="1:00 PM - 4:00 PM">1:00 PM - 4:00 PM (Afternoon)</option>
                        <option value="4:00 PM - 7:00 PM">4:00 PM - 7:00 PM (Evening)</option>
                      </select>
                    </div>
                  </div>
                </div>

                {/* 3. Doorstep Delivery & Pickup Address */}
                <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                  <h3 className="text-base font-black text-slate-900 mb-4 flex items-center gap-2">
                    <MapPin size={17} className="text-emerald-600" />
                    <span>Doorstep Address &amp; Contact Details</span>
                  </h3>

                  <div className="space-y-4">
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1.5">Full Name</label>
                        <input
                          type="text"
                          placeholder="e.g. Adarsh Sachan"
                          value={customerName}
                          onChange={(e) => setCustomerName(e.target.value)}
                          className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1.5">Mobile Number (for OTP &amp; Technician Call)</label>
                        <input
                          type="tel"
                          placeholder="10-digit mobile number"
                          value={customerPhone}
                          onChange={(e) => setCustomerPhone(e.target.value.replace(/\D/g, '').slice(0, 10))}
                          className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                        />
                      </div>
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1.5">Full Street Address &amp; Landmark</label>
                      <textarea
                        rows={2}
                        placeholder="House/Flat No., Building Name, Street, Landmark..."
                        value={customerAddress}
                        onChange={(e) => setCustomerAddress(e.target.value)}
                        className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30 resize-none"
                      />
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1.5">City</label>
                        <input
                          type="text"
                          placeholder="e.g. Delhi NCR, Mumbai..."
                          value={customerCity}
                          onChange={(e) => setCustomerCity(e.target.value)}
                          className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                        />
                      </div>
                      <div>
                        <label className="block text-xs font-bold text-slate-700 mb-1.5">PIN Code</label>
                        <input
                          type="text"
                          placeholder="6-digit PIN code"
                          value={customerPincode}
                          onChange={(e) => setCustomerPincode(e.target.value.replace(/\D/g, '').slice(0, 6))}
                          className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                        />
                      </div>
                    </div>
                  </div>
                </div>

                {/* 4. Payment Preference */}
                <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                  <h3 className="text-base font-black text-slate-900 mb-3 flex items-center gap-2">
                    <CreditCard size={17} className="text-emerald-600" />
                    <span>How would you like to pay the difference?</span>
                  </h3>

                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                    {[
                      { key: 'delivery', title: 'Pay on Handover', desc: 'UPI / Cash to technician' },
                      { key: 'online', title: 'Pay Online Now', desc: 'Credit / Debit / UPI' },
                      { key: 'emi', title: 'No-Cost EMI', desc: 'Starting ₹1,850/mo' },
                    ].map((p) => (
                      <button
                        key={p.key}
                        type="button"
                        onClick={() => setPaymentPreference(p.key as any)}
                        className={`p-3 rounded-2xl border text-left transition-all cursor-pointer ${
                          paymentPreference === p.key
                            ? 'border-emerald-500 bg-emerald-50/50 ring-2 ring-emerald-500/20 shadow-xs'
                            : 'border-slate-200 bg-white hover:border-slate-300'
                        }`}
                      >
                        <p className="text-xs font-black text-slate-900">{p.title}</p>
                        <p className="text-[11px] text-slate-500 mt-0.5">{p.desc}</p>
                      </button>
                    ))}
                  </div>
                </div>
              </div>

              {/* Right Column: Coupons & Exchange Order Summary (MATCHING SCREENSHOT 2) */}
              <div className="lg:col-span-5 space-y-6">
                {/* Available Coupon Codes Engine */}
                <div className="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                  <div className="flex items-center gap-2 mb-3">
                    <Tag size={16} className="text-emerald-600" />
                    <h3 className="text-sm font-black text-slate-900">Apply Exchange Coupon</h3>
                  </div>

                  {/* Coupons list */}
                  <div className="space-y-2.5 mb-4">
                    {availableCoupons.map((c) => {
                      const isApplied = appliedCoupon?.code === c.code;
                      return (
                        <div
                          key={c.code}
                          className={`p-3 rounded-2xl border transition-all flex items-center justify-between gap-3 ${
                            isApplied
                              ? 'border-emerald-500 bg-emerald-50/70 ring-1 ring-emerald-500'
                              : 'border-slate-200 bg-slate-50/70 hover:border-slate-300'
                          }`}
                        >
                          <div>
                            <div className="flex items-center gap-2">
                              <span className="text-xs font-black text-slate-900 px-2 py-0.5 rounded-md bg-white border border-slate-200">
                                {c.code}
                              </span>
                              <span className="text-xs font-extrabold text-emerald-700">Save ₹{c.discount}</span>
                            </div>
                            <p className="text-[11px] text-slate-500 font-medium mt-1">{c.description}</p>
                          </div>

                          <button
                            type="button"
                            onClick={() => (isApplied ? setAppliedCoupon(null) : handleApplyCoupon(c))}
                            className={`px-3 py-1.5 rounded-xl text-xs font-black cursor-pointer transition-all ${
                              isApplied
                                ? 'bg-slate-900 text-white'
                                : 'bg-emerald-600 hover:bg-emerald-700 text-white'
                            }`}
                          >
                            {isApplied ? 'Applied' : 'Apply'}
                          </button>
                        </div>
                      );
                    })}
                  </div>

                  {/* Custom Coupon Input */}
                  <form onSubmit={handleApplyCustomCoupon} className="flex gap-2">
                    <input
                      type="text"
                      placeholder="Have another promo code?"
                      value={customCouponInput}
                      onChange={(e) => setCustomCouponInput(e.target.value)}
                      className="flex-1 px-3.5 py-2 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 uppercase focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                    />
                    <button
                      type="submit"
                      className="px-4 py-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-white text-xs font-bold transition-all cursor-pointer"
                    >
                      Apply
                    </button>
                  </form>
                  {couponError && <p className="text-[11px] text-rose-600 mt-1.5 font-semibold">{couponError}</p>}
                </div>

                {/* ─────────────────────────────────────────────────────────────
                    FINAL DETAILED EXCHANGE ORDER SUMMARY (MATCHING SCREENSHOT 2)
                ────────────────────────────────────────────────────────────── */}
                <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-lg">
                  <h2 className="text-xl font-black text-slate-900 tracking-tight mb-1">
                    Exchange Order Summary
                  </h2>
                  <p className="text-xs text-slate-500 mb-6">
                    Review your trade-in breakdown before booking
                  </p>

                  <div className="space-y-3.5 p-4 rounded-2xl bg-slate-50 border border-slate-200/80 mb-6 text-xs sm:text-sm">
                    <div className="flex justify-between items-start gap-2">
                      <span className="text-slate-500 font-medium">Upgrading To</span>
                      <span className="font-bold text-slate-900 text-right">
                        {selectedUpgradeProduct.brand} {selectedUpgradeProduct.model} ({selectedUpgradeProduct.storage} · {selectedUpgradeProduct.color})
                      </span>
                    </div>

                    <div className="flex justify-between items-center">
                      <span className="text-slate-500 font-medium">Upgrade Product Price</span>
                      <span className="font-semibold text-slate-900">
                        ₹{upgradeDevicePrice.toLocaleString('en-IN')}
                      </span>
                    </div>

                    <div className="flex justify-between items-center text-emerald-700">
                      <span className="font-medium">
                        Your Gear Valuation ({selectedOldDevice.name})
                      </span>
                      <span className="font-bold">
                        - ₹{oldDeviceNetValuation.toLocaleString('en-IN')}
                      </span>
                    </div>

                    <div className="flex justify-between items-center text-emerald-700">
                      <span className="font-medium">Special Camsik Exchange Bonus</span>
                      <span className="font-bold">
                        - ₹{exchangeBonus.toLocaleString('en-IN')}
                      </span>
                    </div>

                    {appliedCoupon && (
                      <div className="flex justify-between items-center text-emerald-700 font-semibold">
                        <span>Coupon Discount ({appliedCoupon.code})</span>
                        <span>- ₹{appliedCoupon.discount.toLocaleString('en-IN')}</span>
                      </div>
                    )}

                    <div className="flex justify-between items-center pt-3.5 border-t border-slate-200 font-black text-base">
                      <span className="text-slate-900">Net Amount to Pay on Delivery</span>
                      <span className="text-emerald-600 text-2xl font-black">
                        ₹{netPayableAmount.toLocaleString('en-IN')}
                      </span>
                    </div>
                  </div>

                  {/* Confirm CTA */}
                  <button
                    type="button"
                    onClick={handleConfirmOrder}
                    className="w-full py-4 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-black text-sm uppercase tracking-wider shadow-lg shadow-emerald-600/30 hover:shadow-emerald-600/40 transition-all cursor-pointer flex items-center justify-center gap-2 group"
                  >
                    <span>Confirm Doorstep Exchange</span>
                    <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
                  </button>

                  <p className="text-[11px] text-slate-400 text-center mt-3 font-medium">
                    Simultaneous doorstep pickup &amp; delivery · 100% verified certified gear
                  </p>
                </div>
              </div>
            </div>
          </section>
        )}

        {/* ─────────────────────────────────────────────────────────────
            STEP 6: ORDER CONFIRMED SCREEN (SAVED TO /my-orders)
        ────────────────────────────────────────────────────────────── */}
        {step === 'confirmed' && confirmedOrder && (
          <section className="max-w-3xl mx-auto px-4 sm:px-6 py-12">
            <div className="bg-white rounded-3xl border border-slate-200 shadow-xl overflow-hidden text-center p-8 sm:p-12">
              <div className="w-20 h-20 rounded-full bg-emerald-50 text-emerald-600 border border-emerald-200 flex items-center justify-center mx-auto mb-6 shadow-sm">
                <CheckCircle size={44} />
              </div>

              <span className="text-xs font-extrabold uppercase px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200 mb-3 inline-block">
                Doorstep Exchange Scheduled
              </span>

              <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
                Exchange Order #{confirmedOrder.orderNumber} Confirmed! 🎉
              </h1>
              <p className="text-sm text-slate-500 mt-2 max-w-lg mx-auto">
                Our certified technician will visit your doorstep on <span className="font-bold text-slate-800">{confirmedOrder.pickupDate}</span> during <span className="font-bold text-slate-800">{confirmedOrder.pickupSlot}</span> with your new <span className="font-bold text-slate-800">{confirmedOrder.newDevice?.brand} {confirmedOrder.newDevice?.model}</span>.
              </p>

              {/* Itemized Order Breakdown Card */}
              <div className="mt-8 bg-slate-50 rounded-2xl border border-slate-200/80 p-6 text-left space-y-3 text-xs sm:text-sm">
                <div className="flex justify-between">
                  <span className="text-slate-500 font-medium">Your Handover Gear:</span>
                  <span className="font-bold text-slate-900">{confirmedOrder.oldDevice?.model}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500 font-medium">New Upgrade Gear Delivered:</span>
                  <span className="font-bold text-slate-900">
                    {confirmedOrder.newDevice?.brand} {confirmedOrder.newDevice?.model} ({confirmedOrder.newDevice?.storage})
                  </span>
                </div>
                <div className="flex justify-between text-emerald-700">
                  <span>Trade-In Valuation Applied:</span>
                  <span className="font-bold">- ₹{confirmedOrder.tradeInCredit.toLocaleString('en-IN')}</span>
                </div>
                <div className="flex justify-between text-emerald-700">
                  <span>Special Camsik Exchange Bonus:</span>
                  <span className="font-bold">- ₹{confirmedOrder.exchangeBonus.toLocaleString('en-IN')}</span>
                </div>
                {confirmedOrder.couponDiscount > 0 && (
                  <div className="flex justify-between text-emerald-700">
                    <span>Coupon Discount ({confirmedOrder.couponCode}):</span>
                    <span className="font-bold">- ₹{confirmedOrder.couponDiscount.toLocaleString('en-IN')}</span>
                  </div>
                )}
                <div className="flex justify-between pt-3 border-t border-slate-200 text-base font-black text-slate-900">
                  <span>Net Amount to Pay on Handover:</span>
                  <span className="text-emerald-600 text-xl font-black">
                    ₹{confirmedOrder.netPayable.toLocaleString('en-IN')}
                  </span>
                </div>
                <div className="flex justify-between pt-2 border-t border-slate-100 text-xs text-slate-500">
                  <span>Handover Address:</span>
                  <span className="font-semibold text-slate-800">
                    {confirmedOrder.customerAddress}, {confirmedOrder.city} - {confirmedOrder.pincode}
                  </span>
                </div>
              </div>

              {/* Action Buttons */}
              <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-3">
                <Link
                  href="/my-orders"
                  className="w-full sm:w-auto px-8 py-4 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-black text-xs uppercase tracking-wider transition-all shadow-md flex items-center justify-center gap-2"
                >
                  <Package size={15} />
                  <span>Check in My Orders</span>
                </Link>

                <Link
                  href={`/track-order?phone=${confirmedOrder.customerPhone}`}
                  className="w-full sm:w-auto px-8 py-4 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-black text-xs uppercase tracking-wider transition-all shadow-md shadow-emerald-600/30 flex items-center justify-center gap-2"
                >
                  <Truck size={15} />
                  <span>Track Live Status</span>
                  <ArrowRight size={14} />
                </Link>
              </div>
            </div>
          </section>
        )}

        {/* ─────────────────────────────────────────────────────────────
            AUTH MODAL: QUICK LOGIN GATE BEFORE CONFIRMING
        ────────────────────────────────────────────────────────────── */}
        {showAuthModal && (
          <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-md w-full p-6 sm:p-8 relative animate-in fade-in zoom-in-95 duration-200">
              <button
                type="button"
                onClick={() => setShowAuthModal(false)}
                className="absolute top-4 right-4 text-slate-400 hover:text-slate-700 p-1.5 rounded-full hover:bg-slate-100 transition-colors"
              >
                ✕
              </button>

              <div className="text-center mb-6">
                <div className="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center mx-auto mb-3 border border-emerald-200">
                  <LogIn size={22} />
                </div>
                <h3 className="text-xl font-black text-slate-900">Sign In to Book Exchange</h3>
                <p className="text-xs text-slate-500 mt-1">
                  Log in so your exchange order is saved to your account and trackable in &ldquo;My Orders&rdquo;
                </p>
              </div>

              <form onSubmit={handleQuickLoginSubmit} className="space-y-4">
                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-1">Your Full Name</label>
                  <div className="relative">
                    <User size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                    <input
                      type="text"
                      placeholder="e.g. Adarsh"
                      required
                      value={authName}
                      onChange={(e) => setAuthName(e.target.value)}
                      className="w-full pl-10 pr-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-1">Mobile Phone Number</label>
                  <div className="relative">
                    <Phone size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                    <input
                      type="tel"
                      placeholder="10-digit phone number"
                      required
                      value={authPhone}
                      onChange={(e) => setAuthPhone(e.target.value.replace(/\D/g, '').slice(0, 10))}
                      className="w-full pl-10 pr-3.5 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
                    />
                  </div>
                </div>

                {authOtpSent && (
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Enter 6-Digit OTP</label>
                    <input
                      type="text"
                      placeholder="Enter OTP (e.g. 123456)"
                      required
                      value={authOtp}
                      onChange={(e) => setAuthOtp(e.target.value)}
                      className="w-full px-3.5 py-2.5 rounded-xl border border-emerald-300 text-center tracking-widest text-sm font-black text-slate-900 focus:outline-none focus:ring-2 focus:ring-emerald-500/30 bg-emerald-50/40"
                    />
                    <p className="text-[10px] text-slate-400 text-center mt-1">Demo mode: Enter any 6 digits</p>
                  </div>
                )}

                <button
                  type="submit"
                  className="w-full py-3.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-black text-xs uppercase tracking-wider shadow-sm transition-all cursor-pointer"
                >
                  {authOtpSent ? 'Verify & Continue' : 'Send OTP'}
                </button>
              </form>
            </div>
          </div>
        )}
      </div>

      <CustomerFooter />
    </main>
  );
}
// CASMIK Shared Data Store — All panels use this data
// In production, this would be fetched from /api/v1/* endpoints

export interface Category {
  id: string;
  name: string;
  slug: string;
  icon: string;
  image: string;
  alt: string;
  description: string;
  brandCount: number;
  modelCount: number;
  active: boolean;
  sortOrder: number;
}

export interface Brand {
  id: string;
  categoryId: string;
  name: string;
  slug: string;
  logo: string;
  alt: string;
  modelCount: number;
  active: boolean;
}

export interface DeviceModel {
  id: string;
  brandId: string;
  categoryId: string;
  name: string;
  slug: string;
  image: string;
  alt: string;
  basePrice: number;
  storages: string[];
  colors: string[];
  specs: Record<string, string>;
  active: boolean;
}

export interface Question {
  id: string;
  categoryId: string;
  question: string;
  subtext: string;
  sortOrder: number;
  active: boolean;
  options: QuestionOption[];
}

export interface QuestionOption {
  id: string;
  questionId: string;
  label: string;
  description: string;
  icon: string;
  illustration: string;
  priceAdjustment: number;
  adjustmentType: 'fixed' | 'percentage';
  conditionGrade: string;
  bulletPoints: string[];
}

export interface Order {
  id: string;
  orderNumber: string;
  type: 'sell' | 'buy' | 'exchange' | 'repair';
  status: OrderStatus;
  customerId: string;
  customerName: string;
  customerPhone: string;
  customerEmail: string;
  customerAddress: string;
  pinCode: string;
  city: string;
  deviceName: string;
  deviceBrand: string;
  deviceModel: string;
  deviceStorage: string;
  deviceColor: string;
  quotedPrice: number;
  finalPrice: number;
  partnerId: string | null;
  partnerName: string | null;
  deliveryAgentId: string | null;
  deliveryAgentName: string | null;
  pickupDate: string;
  pickupSlot: string;
  createdAt: string;
  updatedAt: string;
  paymentStatus: 'pending' | 'processing' | 'paid' | 'failed';
  inspectionScore: number | null;
  notes: string;
}

export type OrderStatus =
'created' | 'assigned' | 'accepted' | 'pickup_scheduled' | 'picked_up' | 'inspection' | 'inspection_completed' | 'final_price' | 'customer_accepted' | 'payment_processing' | 'paid' | 'completed' | 'rejected' | 'cancelled' | 'rescheduled';

export interface Partner {
  id: string;
  name: string;
  storeName: string;
  phone: string;
  email: string;
  city: string;
  state: string;
  pinCodes: string[];
  categories: string[];
  status: 'active' | 'inactive' | 'pending' | 'suspended';
  rating: number;
  totalOrders: number;
  completedOrders: number;
  totalEarnings: number;
  pendingPayout: number;
  availableBalance: number;
  joinedAt: string;
  avatar: string;
  commission: number;
}

export interface DeliveryAgent {
  id: string;
  name: string;
  phone: string;
  email: string;
  city: string;
  pinCodes: string[];
  status: 'online' | 'offline' | 'on_trip';
  rating: number;
  todayPickups: number;
  todayDeliveries: number;
  totalDeliveries: number;
  earnings: number;
  vehicle: string;
  vehicleNumber: string;
  avatar: string;
  joinedAt: string;
}

export interface Customer {
  id: string;
  name: string;
  phone: string;
  email: string;
  city: string;
  pinCode: string;
  totalOrders: number;
  totalValue: number;
  joinedAt: string;
  status: 'active' | 'blocked';
  avatar: string;
}

// ─── CATEGORIES ───────────────────────────────────────────────────────────────

export const categories: Category[] = [
{
  id: 'cat-smartphone',
  name: 'Smartphones',
  slug: 'smartphones',
  icon: '📱',
  image: "https://img.rocket.new/generatedImages/rocket_gen_img_1a6bbc97c-1766486052960.png",
  alt: 'Various smartphones displayed on a white surface',
  description: 'Sell, buy or exchange your smartphone',
  brandCount: 15,
  modelCount: 180,
  active: true,
  sortOrder: 1
},
{
  id: 'cat-laptop',
  name: 'Laptops',
  slug: 'laptops',
  icon: '💻',
  image: "https://img.rocket.new/generatedImages/rocket_gen_img_1fbe29315-1773056140933.png",
  alt: 'Open laptop on a desk with clean workspace',
  description: 'Get the best value for your laptop',
  brandCount: 10,
  modelCount: 95,
  active: true,
  sortOrder: 2
},
{
  id: 'cat-tablet',
  name: 'Tablets',
  slug: 'tablets',
  icon: '📟',
  image: "https://images.unsplash.com/photo-1688296526355-c25c44c97d3e",
  alt: 'iPad tablet with Apple Pencil on wooden table',
  description: 'Sell or buy certified refurbished tablets',
  brandCount: 6,
  modelCount: 42,
  active: true,
  sortOrder: 3
},
{
  id: 'cat-smartwatch',
  name: 'Smartwatches',
  slug: 'smartwatches',
  icon: '⌚',
  image: "https://img.rocket.new/generatedImages/rocket_gen_img_14071888e-1772305512168.png",
  alt: 'Modern smartwatch with fitness tracking display',
  description: 'Trade in your smartwatch for instant cash',
  brandCount: 5,
  modelCount: 28,
  active: true,
  sortOrder: 4
},
{
  id: 'cat-gaming',
  name: 'Gaming Consoles',
  slug: 'gaming-consoles',
  icon: '🎮',
  image: "https://images.unsplash.com/photo-1598618929236-8c5dbf91c97f",
  alt: 'Gaming console controller on dark background',
  description: 'Sell your gaming console at best price',
  brandCount: 4,
  modelCount: 18,
  active: true,
  sortOrder: 5
},
{
  id: 'cat-earbuds',
  name: 'Earbuds & Headphones',
  slug: 'earbuds',
  icon: '🎧',
  image: "https://images.unsplash.com/photo-1606741965359-946075e4d550",
  alt: 'Wireless earbuds in charging case on white background',
  description: 'Get cash for your earbuds and headphones',
  brandCount: 8,
  modelCount: 35,
  active: true,
  sortOrder: 6
},
{
  id: 'cat-camera',
  name: 'Cameras',
  slug: 'cameras',
  icon: '📷',
  image: "https://images.unsplash.com/photo-1585704273201-354f62ad1eea",
  alt: 'DSLR camera with lens on wooden surface',
  description: 'Sell your DSLR, mirrorless or point-and-shoot',
  brandCount: 6,
  modelCount: 30,
  active: true,
  sortOrder: 7
},
{
  id: 'cat-tws',
  name: 'TWS Earphones',
  slug: 'tws',
  icon: '🎵',
  image: "https://img.rocket.new/generatedImages/rocket_gen_img_173e92f06-1772945973361.png",
  alt: 'True wireless earphones with charging case',
  description: 'Sell your TWS earphones instantly',
  brandCount: 7,
  modelCount: 22,
  active: true,
  sortOrder: 8
},
{
  id: 'cat-smarttv',
  name: 'Smart TVs',
  slug: 'smart-tvs',
  icon: '📺',
  image: "https://img.rocket.new/generatedImages/rocket_gen_img_19e4abe17-1772730729933.png",
  alt: 'Modern smart TV mounted on wall in living room',
  description: 'Upgrade your TV and sell the old one',
  brandCount: 8,
  modelCount: 45,
  active: true,
  sortOrder: 9
},
{
  id: 'cat-accessories',
  name: 'Accessories',
  slug: 'accessories',
  icon: '🔌',
  image: "https://img.rocket.new/generatedImages/rocket_gen_img_128c680c7-1779446750100.png",
  alt: 'Various phone accessories including cases and chargers',
  description: 'Sell phone accessories and peripherals',
  brandCount: 12,
  modelCount: 60,
  active: true,
  sortOrder: 10
}];


// ─── BRANDS ───────────────────────────────────────────────────────────────────

export const brands: Brand[] = [
// Smartphones
{ id: 'brand-apple', categoryId: 'cat-smartphone', name: 'Apple', slug: 'apple', logo: "https://img.rocket.new/generatedImages/rocket_gen_img_17770e405-1787593576108.png", alt: 'Apple logo', modelCount: 24, active: true },
{ id: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Samsung', slug: 'samsung', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_1f9249e7a-1787485872587.png', alt: 'Samsung logo', modelCount: 38, active: true },
{ id: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus', slug: 'oneplus', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_12b42f3b3-1773054280340.png', alt: 'OnePlus logo', modelCount: 16, active: true },
{ id: 'brand-google', categoryId: 'cat-smartphone', name: 'Google', slug: 'google', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_1f0bc1df9-1787485872354.png', alt: 'Google logo', modelCount: 8, active: true },
{ id: 'brand-xiaomi', categoryId: 'cat-smartphone', name: 'Xiaomi', slug: 'xiaomi', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_1877c99bb-1787485873555.png', alt: 'Xiaomi logo', modelCount: 22, active: true },
{ id: 'brand-realme', categoryId: 'cat-smartphone', name: 'Realme', slug: 'realme', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_1bd9882e8-1787485873026.png', alt: 'Realme logo', modelCount: 19, active: true },
{ id: 'brand-oppo', categoryId: 'cat-smartphone', name: 'Oppo', slug: 'oppo', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_18430dfae-1787485873533.png', alt: 'Oppo logo', modelCount: 14, active: true },
{ id: 'brand-vivo', categoryId: 'cat-smartphone', name: 'Vivo', slug: 'vivo', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_1d388f91b-1787485872512.png', alt: 'Vivo logo', modelCount: 17, active: true },
{ id: 'brand-nothing', categoryId: 'cat-smartphone', name: 'Nothing', slug: 'nothing', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_14f59b360-1787485873756.png', alt: 'Nothing logo', modelCount: 4, active: true },
{ id: 'brand-motorola', categoryId: 'cat-smartphone', name: 'Motorola', slug: 'motorola', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_15e536822-1787485873806.png', alt: 'Motorola logo', modelCount: 11, active: true },
{ id: 'brand-iqoo', categoryId: 'cat-smartphone', name: 'iQOO', slug: 'iqoo', logo: "https://img.rocket.new/generatedImages/rocket_gen_img_115e97c2a-1787576861158.png", alt: 'iQOO logo', modelCount: 9, active: true },
{ id: 'brand-poco', categoryId: 'cat-smartphone', name: 'Poco', slug: 'poco', logo: "https://img.rocket.new/generatedImages/rocket_gen_img_1997e39f3-1787576861139.png", alt: 'Poco logo', modelCount: 12, active: true },
// Laptops
{ id: 'brand-dell', categoryId: 'cat-laptop', name: 'Dell', slug: 'dell', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_17c14fe97-1787485873667.png', alt: 'Dell logo', modelCount: 9, active: true },
{ id: 'brand-hp', categoryId: 'cat-laptop', name: 'HP', slug: 'hp', logo: 'https://img.rocket.new/generatedImages/rocket_gen_img_194bf1756-1787485872504.png', alt: 'HP logo', modelCount: 12, active: true },
{ id: 'brand-lenovo', categoryId: 'cat-laptop', name: 'Lenovo', slug: 'lenovo', logo: "https://img.rocket.new/generatedImages/rocket_gen_img_1332ca9a3-1787576860528.png", alt: 'Lenovo logo', modelCount: 15, active: true },
{ id: 'brand-asus-laptop', categoryId: 'cat-laptop', name: 'Asus', slug: 'asus', logo: "https://img.rocket.new/generatedImages/rocket_gen_img_15f9c2d6b-1787576860322.png", alt: 'Asus logo', modelCount: 10, active: true },
{ id: 'brand-apple-mac', categoryId: 'cat-laptop', name: 'Apple MacBook', slug: 'apple-macbook', logo: "https://img.rocket.new/generatedImages/rocket_gen_img_17f46a8f4-1787593576505.png", alt: 'Apple MacBook logo', modelCount: 8, active: true }];


// ─── MODELS ───────────────────────────────────────────────────────────────────

export const deviceModels: DeviceModel[] = [
// Apple iPhones
{ id: 'iphone-17-pro-max', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 17 Pro Max', slug: 'iphone-17-pro-max', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1ac872aa5-1772414311954.png", alt: 'iPhone 17 Pro Max in titanium finish', basePrice: 105000, storages: ['256GB', '512GB', '1TB'], colors: ['Black Titanium', 'White Titanium', 'Desert Titanium', 'Natural Titanium'], specs: { display: '6.9" Super Retina XDR', chip: 'A19 Pro', camera: '48MP + 48MP + 12MP', battery: '4685 mAh' }, active: true },
{ id: 'iphone-17-pro', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 17 Pro', slug: 'iphone-17-pro', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1461344c3-1766499917621.png", alt: 'iPhone 17 Pro in titanium', basePrice: 92000, storages: ['256GB', '512GB', '1TB'], colors: ['Space Black', 'Silver', 'Gold', 'Desert Titanium'], specs: { display: '6.3" Super Retina XDR', chip: 'A19 Pro', camera: '48MP + 48MP + 12MP', battery: '3274 mAh' }, active: true },
{ id: 'iphone-17', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 17', slug: 'iphone-17', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_12539e762-1784129887409.png', alt: 'iPhone 17 in blue color', basePrice: 72000, storages: ['128GB', '256GB', '512GB'], colors: ['Ultramarine', 'Black', 'White', 'Pink'], specs: { display: '6.1" Super Retina XDR', chip: 'A19', camera: '48MP + 12MP', battery: '3279 mAh' }, active: true },
{ id: 'iphone-16-pro-max', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 16 Pro Max', slug: 'iphone-16-pro-max', image: "https://images.unsplash.com/photo-1676353410356-867313a96ed4", alt: 'iPhone 16 Pro Max in black titanium', basePrice: 85000, storages: ['256GB', '512GB', '1TB'], colors: ['Black Titanium', 'White Titanium', 'Desert Titanium'], specs: { display: '6.9" OLED', chip: 'A18 Pro', camera: '48MP Triple', battery: '4685 mAh' }, active: true },
{ id: 'iphone-16-pro', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 16 Pro', slug: 'iphone-16-pro', image: "https://img.rocket.new/generatedImages/rocket_gen_img_11ce4ee67-1764738511529.png", alt: 'iPhone 16 Pro in natural titanium', basePrice: 75000, storages: ['128GB', '256GB', '512GB', '1TB'], colors: ['Black Titanium', 'White Titanium', 'Natural Titanium', 'Desert Titanium'], specs: { display: '6.3" OLED', chip: 'A18 Pro', camera: '48MP Triple', battery: '3274 mAh' }, active: true },
{ id: 'iphone-16', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 16', slug: 'iphone-16', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1642b5cb5-1771887530981.png", alt: 'iPhone 16 in ultramarine color', basePrice: 62000, storages: ['128GB', '256GB', '512GB'], colors: ['Ultramarine', 'Teal', 'Pink', 'White', 'Black'], specs: { display: '6.1" OLED', chip: 'A18', camera: '48MP + 12MP', battery: '3561 mAh' }, active: true },
{ id: 'iphone-15-pro-max', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 15 Pro Max', slug: 'iphone-15-pro-max', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_17b82fb7a-1772960574407.png', alt: 'iPhone 15 Pro Max in natural titanium', basePrice: 75000, storages: ['256GB', '512GB', '1TB'], colors: ['Black Titanium', 'Natural Titanium', 'Blue Titanium', 'White Titanium'], specs: { display: '6.7" OLED', chip: 'A17 Pro', camera: '48MP Triple', battery: '4422 mAh' }, active: true },
{ id: 'iphone-15-pro', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 15 Pro', slug: 'iphone-15-pro', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_17e528213-1771903425581.png', alt: 'iPhone 15 Pro in natural titanium', basePrice: 65000, storages: ['128GB', '256GB', '512GB'], colors: ['Black Titanium', 'Natural Titanium', 'Blue Titanium', 'White Titanium'], specs: { display: '6.1" OLED', chip: 'A17 Pro', camera: '48MP Triple', battery: '3274 mAh' }, active: true },
{ id: 'iphone-15', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 15', slug: 'iphone-15', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1c95f6d14-1775058099616.png", alt: 'iPhone 15 in pink color', basePrice: 52000, storages: ['128GB', '256GB', '512GB'], colors: ['Pink', 'Yellow', 'Green', 'Blue', 'Black'], specs: { display: '6.1" OLED', chip: 'A16', camera: '48MP + 12MP', battery: '3349 mAh' }, active: true },
{ id: 'iphone-14-pro-max', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 14 Pro Max', slug: 'iphone-14-pro-max', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_103da8441-1770037000517.png', alt: 'iPhone 14 Pro Max in deep purple', basePrice: 58000, storages: ['128GB', '256GB', '512GB', '1TB'], colors: ['Deep Purple', 'Gold', 'Silver', 'Space Black'], specs: { display: '6.7" OLED', chip: 'A16', camera: '48MP Triple', battery: '4323 mAh' }, active: true },
{ id: 'iphone-14-pro', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 14 Pro', slug: 'iphone-14-pro', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_17e528213-1771903425581.png', alt: 'iPhone 14 Pro in deep purple', basePrice: 48000, storages: ['128GB', '256GB', '512GB', '1TB'], colors: ['Deep Purple', 'Gold', 'Silver', 'Space Black'], specs: { display: '6.1" OLED', chip: 'A16', camera: '48MP Triple', battery: '3200 mAh' }, active: true },
{ id: 'iphone-14', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 14', slug: 'iphone-14', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1a592c0ab-1773089370920.png", alt: 'iPhone 14 in midnight color', basePrice: 38000, storages: ['128GB', '256GB', '512GB'], colors: ['Midnight', 'Starlight', 'Blue', 'Purple', 'Red'], specs: { display: '6.1" OLED', chip: 'A15', camera: '12MP + 12MP', battery: '3279 mAh' }, active: true },
{ id: 'iphone-13-pro-max', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 13 Pro Max', slug: 'iphone-13-pro-max', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_17b82fb7a-1772960574407.png', alt: 'iPhone 13 Pro Max in sierra blue', basePrice: 42000, storages: ['128GB', '256GB', '512GB', '1TB'], colors: ['Sierra Blue', 'Silver', 'Gold', 'Graphite', 'Alpine Green'], specs: { display: '6.7" OLED', chip: 'A15', camera: '12MP Triple', battery: '4352 mAh' }, active: true },
{ id: 'iphone-13', brandId: 'brand-apple', categoryId: 'cat-smartphone', name: 'iPhone 13', slug: 'iphone-13', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_10e238774-1772285499687.png', alt: 'iPhone 13 in blue color', basePrice: 32000, storages: ['128GB', '256GB', '512GB'], colors: ['Midnight', 'Starlight', 'Blue', 'Pink', 'Red', 'Green'], specs: { display: '6.1" OLED', chip: 'A15', camera: '12MP + 12MP', battery: '3227 mAh' }, active: true },
// Samsung
{ id: 's25-ultra', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S25 Ultra', slug: 'galaxy-s25-ultra', image: "https://img.rocket.new/generatedImages/rocket_gen_img_122e5667e-1772368533819.png", alt: 'Samsung Galaxy S25 Ultra in titanium gray', basePrice: 78000, storages: ['256GB', '512GB', '1TB'], colors: ['Titanium Gray', 'Titanium Black', 'Titanium Violet', 'Titanium Yellow'], specs: { display: '6.9" Dynamic AMOLED', chip: 'Snapdragon 8 Elite', camera: '200MP + 50MP + 10MP', battery: '5000 mAh' }, active: true },
{ id: 's25-plus', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S25+', slug: 'galaxy-s25-plus', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1c8292dfe-1772328371986.png", alt: 'Samsung Galaxy S25 Plus in navy blue', basePrice: 62000, storages: ['256GB', '512GB'], colors: ['Navy', 'Icy Blue', 'Mint', 'Silver Shadow'], specs: { display: '6.7" Dynamic AMOLED', chip: 'Snapdragon 8 Elite', camera: '50MP + 10MP + 12MP', battery: '4900 mAh' }, active: true },
{ id: 's25', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S25', slug: 'galaxy-s25', image: "https://img.rocket.new/generatedImages/rocket_gen_img_175e093df-1771887531027.png", alt: 'Samsung Galaxy S25 in navy blue', basePrice: 52000, storages: ['128GB', '256GB'], colors: ['Navy', 'Icy Blue', 'Mint', 'Silver Shadow'], specs: { display: '6.2" Dynamic AMOLED', chip: 'Snapdragon 8 Elite', camera: '50MP + 10MP + 12MP', battery: '4000 mAh' }, active: true },
{ id: 's24-ultra', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S24 Ultra', slug: 'galaxy-s24-ultra', image: "https://images.unsplash.com/photo-1692647494155-ee2df7cf2869", alt: 'Samsung Galaxy S24 Ultra in titanium gray', basePrice: 68000, storages: ['256GB', '512GB', '1TB'], colors: ['Titanium Gray', 'Titanium Black', 'Titanium Violet', 'Titanium Yellow'], specs: { display: '6.8" Dynamic AMOLED', chip: 'Snapdragon 8 Gen 3', camera: '200MP + 50MP + 10MP', battery: '5000 mAh' }, active: true },
{ id: 's24-plus', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S24+', slug: 'galaxy-s24-plus', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1d0c22c0d-1775384135526.png", alt: 'Samsung Galaxy S24 Plus in cobalt violet', basePrice: 52000, storages: ['256GB', '512GB'], colors: ['Cobalt Violet', 'Onyx Black', 'Marble Gray', 'Sandstone Orange'], specs: { display: '6.7" Dynamic AMOLED', chip: 'Snapdragon 8 Gen 3', camera: '50MP + 10MP + 12MP', battery: '4900 mAh' }, active: true },
{ id: 's24', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S24', slug: 'galaxy-s24', image: "https://img.rocket.new/generatedImages/rocket_gen_img_122e5667e-1772368533819.png", alt: 'Samsung Galaxy S24 in cobalt violet', basePrice: 42000, storages: ['128GB', '256GB'], colors: ['Cobalt Violet', 'Onyx Black', 'Marble Gray', 'Amber Yellow'], specs: { display: '6.2" Dynamic AMOLED', chip: 'Exynos 2400', camera: '50MP + 10MP + 12MP', battery: '4000 mAh' }, active: true },
{ id: 's23-ultra', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S23 Ultra', slug: 'galaxy-s23-ultra', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1294d2923-1771486444013.png", alt: 'Samsung Galaxy S23 Ultra in phantom black', basePrice: 52000, storages: ['256GB', '512GB', '1TB'], colors: ['Phantom Black', 'Cream', 'Green', 'Lavender'], specs: { display: '6.8" Dynamic AMOLED', chip: 'Snapdragon 8 Gen 2', camera: '200MP + 10MP + 10MP', battery: '5000 mAh' }, active: true },
{ id: 's23', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy S23', slug: 'galaxy-s23', image: "https://img.rocket.new/generatedImages/rocket_gen_img_113618263-1765970693224.png", alt: 'Samsung Galaxy S23 in phantom black', basePrice: 32000, storages: ['128GB', '256GB'], colors: ['Phantom Black', 'Cream', 'Green', 'Lavender'], specs: { display: '6.1" Dynamic AMOLED', chip: 'Snapdragon 8 Gen 2', camera: '50MP + 10MP + 12MP', battery: '3900 mAh' }, active: true },
{ id: 'fold-5', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy Z Fold 5', slug: 'galaxy-z-fold-5', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_1d40efa47-1773056836850.png', alt: 'Samsung Galaxy Z Fold 5 in phantom black', basePrice: 72000, storages: ['256GB', '512GB', '1TB'], colors: ['Phantom Black', 'Cream', 'Icy Blue'], specs: { display: '7.6" Foldable AMOLED', chip: 'Snapdragon 8 Gen 2', camera: '50MP + 10MP + 12MP', battery: '4400 mAh' }, active: true },
{ id: 'flip-5', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy Z Flip 5', slug: 'galaxy-z-flip-5', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_190f3b871-1772624438215.png', alt: 'Samsung Galaxy Z Flip 5 in mint color', basePrice: 48000, storages: ['256GB', '512GB'], colors: ['Mint', 'Graphite', 'Cream', 'Lavender'], specs: { display: '6.7" Foldable AMOLED', chip: 'Snapdragon 8 Gen 2', camera: '12MP + 12MP', battery: '3700 mAh' }, active: true },
{ id: 'a55', brandId: 'brand-samsung', categoryId: 'cat-smartphone', name: 'Galaxy A55', slug: 'galaxy-a55', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_12f2039d9-1772329997056.png', alt: 'Samsung Galaxy A55 in awesome navy', basePrice: 22000, storages: ['128GB', '256GB'], colors: ['Awesome Navy', 'Awesome Iceblue', 'Awesome Lilac'], specs: { display: '6.6" Super AMOLED', chip: 'Exynos 1480', camera: '50MP + 12MP + 5MP', battery: '5000 mAh' }, active: true },
// OnePlus
{ id: 'oneplus-13', brandId: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus 13', slug: 'oneplus-13', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1bec49e58-1772994604500.png", alt: 'OnePlus 13 in silky black', basePrice: 55000, storages: ['256GB', '512GB'], colors: ['Midnight Ocean', 'Arctic Dawn', 'Black Eclipse'], specs: { display: '6.82" AMOLED', chip: 'Snapdragon 8 Elite', camera: '50MP + 50MP + 50MP', battery: '6000 mAh' }, active: true },
{ id: 'oneplus-12', brandId: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus 12', slug: 'oneplus-12', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1b76fef53-1765861644627.png", alt: 'OnePlus 12 in silky black', basePrice: 48000, storages: ['256GB', '512GB'], colors: ['Silky Black', 'Flowy Emerald'], specs: { display: '6.82" AMOLED', chip: 'Snapdragon 8 Gen 3', camera: '50MP + 48MP + 64MP', battery: '5400 mAh' }, active: true },
{ id: 'oneplus-12r', brandId: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus 12R', slug: 'oneplus-12r', image: "https://img.rocket.new/generatedImages/rocket_gen_img_17de8509d-1772994602317.png", alt: 'OnePlus 12R in iron gray', basePrice: 32000, storages: ['128GB', '256GB'], colors: ['Iron Gray', 'Cool Blue'], specs: { display: '6.78" AMOLED', chip: 'Snapdragon 8 Gen 1', camera: '50MP + 8MP + 2MP', battery: '5500 mAh' }, active: true },
{ id: 'oneplus-nord-4', brandId: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus Nord 4', slug: 'oneplus-nord-4', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1c9a7c7b6-1767529494953.png", alt: 'OnePlus Nord 4 in mercurial silver', basePrice: 22000, storages: ['128GB', '256GB'], colors: ['Mercurial Silver', 'Obsidian Midnight', 'Oasis Green'], specs: { display: '6.74" AMOLED', chip: 'Snapdragon 7+ Gen 3', camera: '50MP + 8MP', battery: '5500 mAh' }, active: true },
{ id: 'oneplus-nord-ce4', brandId: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus Nord CE 4', slug: 'oneplus-nord-ce4', image: "https://img.rocket.new/generatedImages/rocket_gen_img_141089125-1767743696819.png", alt: 'OnePlus Nord CE 4 in celadon marble', basePrice: 18000, storages: ['128GB', '256GB'], colors: ['Celadon Marble', 'Dark Chrome'], specs: { display: '6.67" AMOLED', chip: 'Snapdragon 7 Gen 3', camera: '50MP + 8MP', battery: '5500 mAh' }, active: true },
{ id: 'oneplus-11', brandId: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus 11', slug: 'oneplus-11', image: "https://img.rocket.new/generatedImages/rocket_gen_img_117b4c359-1772270618657.png", alt: 'OnePlus 11 in titan black', basePrice: 38000, storages: ['128GB', '256GB'], colors: ['Titan Black', 'Eternal Green'], specs: { display: '6.7" AMOLED', chip: 'Snapdragon 8 Gen 2', camera: '50MP + 48MP + 32MP', battery: '5000 mAh' }, active: true },
{ id: 'oneplus-10-pro', brandId: 'brand-oneplus', categoryId: 'cat-smartphone', name: 'OnePlus 10 Pro', slug: 'oneplus-10-pro', image: "https://img.rocket.new/generatedImages/rocket_gen_img_105ddfb08-1773070438946.png", alt: 'OnePlus 10 Pro in volcanic black', basePrice: 28000, storages: ['128GB', '256GB'], colors: ['Volcanic Black', 'Emerald Forest'], specs: { display: '6.7" AMOLED', chip: 'Snapdragon 8 Gen 1', camera: '48MP + 50MP + 8MP', battery: '5000 mAh' }, active: true },
// Google Pixel
{ id: 'pixel-9-pro-xl', brandId: 'brand-google', categoryId: 'cat-smartphone', name: 'Pixel 9 Pro XL', slug: 'pixel-9-pro-xl', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1e439c8ea-1772089098053.png", alt: 'Google Pixel 9 Pro XL in obsidian', basePrice: 62000, storages: ['128GB', '256GB', '512GB', '1TB'], colors: ['Obsidian', 'Porcelain', 'Hazel', 'Rose Quartz'], specs: { display: '6.8" OLED', chip: 'Tensor G4', camera: '50MP + 48MP + 48MP', battery: '5060 mAh' }, active: true },
{ id: 'pixel-9-pro', brandId: 'brand-google', categoryId: 'cat-smartphone', name: 'Pixel 9 Pro', slug: 'pixel-9-pro', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1aede3fd6-1773089372093.png", alt: 'Google Pixel 9 Pro in obsidian', basePrice: 52000, storages: ['128GB', '256GB', '512GB', '1TB'], colors: ['Obsidian', 'Porcelain', 'Hazel', 'Rose Quartz'], specs: { display: '6.3" OLED', chip: 'Tensor G4', camera: '50MP + 48MP + 48MP', battery: '4700 mAh' }, active: true },
{ id: 'pixel-9', brandId: 'brand-google', categoryId: 'cat-smartphone', name: 'Pixel 9', slug: 'pixel-9', image: "https://img.rocket.new/generatedImages/rocket_gen_img_182eccfbd-1765101833319.png", alt: 'Google Pixel 9 in obsidian', basePrice: 42000, storages: ['128GB', '256GB'], colors: ['Obsidian', 'Porcelain', 'Wintergreen', 'Peony'], specs: { display: '6.3" OLED', chip: 'Tensor G4', camera: '50MP + 10.5MP', battery: '4700 mAh' }, active: true },
{ id: 'pixel-8-pro', brandId: 'brand-google', categoryId: 'cat-smartphone', name: 'Pixel 8 Pro', slug: 'pixel-8-pro', image: "https://img.rocket.new/generatedImages/rocket_gen_img_14a858280-1773070440800.png", alt: 'Google Pixel 8 Pro in obsidian', basePrice: 38000, storages: ['128GB', '256GB', '512GB', '1TB'], colors: ['Obsidian', 'Porcelain', 'Bay', 'Mint'], specs: { display: '6.7" OLED', chip: 'Tensor G3', camera: '50MP + 48MP + 48MP', battery: '5050 mAh' }, active: true },
{ id: 'pixel-8', brandId: 'brand-google', categoryId: 'cat-smartphone', name: 'Pixel 8', slug: 'pixel-8', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_1d4bb2939-1773063468643.png', alt: 'Google Pixel 8 in obsidian', basePrice: 32000, storages: ['128GB', '256GB'], colors: ['Obsidian', 'Hazel', 'Rose'], specs: { display: '6.2" OLED', chip: 'Tensor G3', camera: '50MP + 12MP', battery: '4575 mAh' }, active: true },
// Xiaomi
{ id: 'xiaomi-14-ultra', brandId: 'brand-xiaomi', categoryId: 'cat-smartphone', name: 'Xiaomi 14 Ultra', slug: 'xiaomi-14-ultra', image: "https://img.rocket.new/generatedImages/rocket_gen_img_114245ef2-1773066531873.png", alt: 'Xiaomi 14 Ultra in titanium gray', basePrice: 45000, storages: ['256GB', '512GB'], colors: ['Titanium Gray', 'Titanium White', 'Titanium Blue'], specs: { display: '6.73" AMOLED', chip: 'Snapdragon 8 Gen 3', camera: '50MP + 50MP + 50MP + 50MP', battery: '5300 mAh' }, active: true },
{ id: 'xiaomi-14', brandId: 'brand-xiaomi', categoryId: 'cat-smartphone', name: 'Xiaomi 14', slug: 'xiaomi-14', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1c19d9064-1772285498505.png", alt: 'Xiaomi 14 in black', basePrice: 38000, storages: ['256GB', '512GB'], colors: ['Black', 'White', 'Jade Green'], specs: { display: '6.36" AMOLED', chip: 'Snapdragon 8 Gen 3', camera: '50MP + 50MP + 50MP', battery: '4610 mAh' }, active: true },
{ id: 'xiaomi-13-pro', brandId: 'brand-xiaomi', categoryId: 'cat-smartphone', name: 'Xiaomi 13 Pro', slug: 'xiaomi-13-pro', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1a1740c00-1773054280551.png", alt: 'Xiaomi 13 Pro in ceramic black', basePrice: 32000, storages: ['256GB', '512GB'], colors: ['Ceramic Black', 'Ceramic White', 'Mountain Blue'], specs: { display: '6.73" AMOLED', chip: 'Snapdragon 8 Gen 2', camera: '50MP + 50MP + 50MP', battery: '4820 mAh' }, active: true },
{ id: 'redmi-note-13-pro-plus', brandId: 'brand-xiaomi', categoryId: 'cat-smartphone', name: 'Redmi Note 13 Pro+', slug: 'redmi-note-13-pro-plus', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1a1740c00-1773054280551.png", alt: 'Redmi Note 13 Pro Plus in midnight black', basePrice: 22000, storages: ['256GB', '512GB'], colors: ['Midnight Black', 'Aurora Purple', 'Fusion White'], specs: { display: '6.67" AMOLED', chip: 'Dimensity 7200 Ultra', camera: '200MP + 8MP + 2MP', battery: '5000 mAh' }, active: true },
{ id: 'redmi-note-13-pro', brandId: 'brand-xiaomi', categoryId: 'cat-smartphone', name: 'Redmi Note 13 Pro', slug: 'redmi-note-13-pro', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_137629e57-1765615226355.png', alt: 'Redmi Note 13 Pro in midnight black', basePrice: 18000, storages: ['128GB', '256GB'], colors: ['Midnight Black', 'Arctic White', 'Coral Purple'], specs: { display: '6.67" AMOLED', chip: 'Snapdragon 7s Gen 2', camera: '200MP + 8MP + 2MP', battery: '5100 mAh' }, active: true },
// Laptops - Dell
{ id: 'dell-xps-15', brandId: 'brand-dell', categoryId: 'cat-laptop', name: 'Dell XPS 15', slug: 'dell-xps-15', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1fbe29315-1773056140933.png", alt: 'Dell XPS 15 laptop in platinum silver', basePrice: 85000, storages: ['512GB SSD', '1TB SSD', '2TB SSD'], colors: ['Platinum Silver', 'Graphite'], specs: { processor: 'Intel Core i7-13700H', ram: '16GB DDR5', display: '15.6" OLED 3.5K', gpu: 'NVIDIA RTX 4060' }, active: true },
{ id: 'dell-xps-13', brandId: 'brand-dell', categoryId: 'cat-laptop', name: 'Dell XPS 13', slug: 'dell-xps-13', image: "https://img.rocket.new/generatedImages/rocket_gen_img_113ea010f-1775181994070.png", alt: 'Dell XPS 13 laptop in platinum silver', basePrice: 72000, storages: ['512GB SSD', '1TB SSD'], colors: ['Platinum Silver', 'Sky'], specs: { processor: 'Intel Core i7-1360P', ram: '16GB LPDDR5', display: '13.4" OLED FHD+', gpu: 'Intel Iris Xe' }, active: true },
{ id: 'dell-inspiron-15', brandId: 'brand-dell', categoryId: 'cat-laptop', name: 'Dell Inspiron 15', slug: 'dell-inspiron-15', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1facacf56-1772089094540.png", alt: 'Dell Inspiron 15 laptop in carbon black', basePrice: 45000, storages: ['512GB SSD', '1TB SSD'], colors: ['Carbon Black', 'Platinum Silver'], specs: { processor: 'Intel Core i5-1335U', ram: '8GB DDR4', display: '15.6" FHD IPS', gpu: 'Intel UHD' }, active: true },
// MacBook
{ id: 'macbook-pro-16-m4', brandId: 'brand-apple-mac', categoryId: 'cat-laptop', name: 'MacBook Pro 16" M4 Pro', slug: 'macbook-pro-16-m4', image: "https://img.rocket.new/generatedImages/rocket_gen_img_179123d6d-1772091920622.png", alt: 'MacBook Pro 16 inch M4 Pro in space black', basePrice: 195000, storages: ['512GB SSD', '1TB SSD', '2TB SSD'], colors: ['Space Black', 'Silver'], specs: { processor: 'Apple M4 Pro', ram: '24GB Unified', display: '16.2" Liquid Retina XDR', gpu: 'M4 Pro GPU' }, active: true },
{ id: 'macbook-pro-14-m4', brandId: 'brand-apple-mac', categoryId: 'cat-laptop', name: 'MacBook Pro 14" M4', slug: 'macbook-pro-14-m4', image: "https://img.rocket.new/generatedImages/rocket_gen_img_11ad868de-1766607648821.png", alt: 'MacBook Pro 14 inch M4 in space gray', basePrice: 145000, storages: ['512GB SSD', '1TB SSD'], colors: ['Space Gray', 'Silver', 'Space Black'], specs: { processor: 'Apple M4', ram: '16GB Unified', display: '14.2" Liquid Retina XDR', gpu: 'M4 GPU' }, active: true },
{ id: 'macbook-air-m3', brandId: 'brand-apple-mac', categoryId: 'cat-laptop', name: 'MacBook Air M3', slug: 'macbook-air-m3', image: "https://img.rocket.new/generatedImages/rocket_gen_img_11003c8b0-1773211912290.png", alt: 'MacBook Air M3 in midnight color', basePrice: 95000, storages: ['256GB SSD', '512GB SSD', '1TB SSD', '2TB SSD'], colors: ['Midnight', 'Starlight', 'Space Gray', 'Silver'], specs: { processor: 'Apple M3', ram: '8GB Unified', display: '13.6" Liquid Retina', gpu: 'M3 GPU' }, active: true }];



// ─── QUESTIONS ────────────────────────────────────────────────────────────────

export const sellQuestions: Question[] = [
{
  id: 'q-power',
  categoryId: 'cat-smartphone',
  question: 'Does the device turn on?',
  subtext: 'Press the power button to check if the device powers on normally.',
  sortOrder: 1,
  active: true,
  options: [
  { id: 'q-power-yes', questionId: 'q-power', label: 'Yes, turns on', description: 'Device powers on and works normally', icon: '✅', illustration: '📱', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'good', bulletPoints: ['Powers on normally', 'Reaches home screen', 'All basic functions work'] },
  { id: 'q-power-no', questionId: 'q-power', label: 'No, does not turn on', description: 'Device is completely dead or stuck', icon: '❌', illustration: '📵', priceAdjustment: -20000, adjustmentType: 'fixed', conditionGrade: 'poor', bulletPoints: ['Device is dead', 'Does not boot', 'May need motherboard repair'] }]

},
{
  id: 'q-display',
  categoryId: 'cat-smartphone',
  question: 'How is your display?',
  subtext: 'Check for cracks, scratches, dead pixels or discolouration.',
  sortOrder: 2,
  active: true,
  options: [
  { id: 'q-display-perfect', questionId: 'q-display', label: 'Perfect', description: 'No scratches, no marks at all', icon: '✨', illustration: '🖥️', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'excellent', bulletPoints: ['No scratches visible', 'No dead pixels', 'Perfect display quality'] },
  { id: 'q-display-good', questionId: 'q-display', label: 'Good', description: 'Minor hairline scratches, not visible during use', icon: '👍', illustration: '📱', priceAdjustment: -1500, adjustmentType: 'fixed', conditionGrade: 'good', bulletPoints: ['Minor hairline scratches', 'Not visible during use', 'Display fully functional'] },
  { id: 'q-display-damaged', questionId: 'q-display', label: 'Damaged', description: 'Visible scratches or minor crack on screen', icon: '⚠️', illustration: '📱', priceAdjustment: -5000, adjustmentType: 'fixed', conditionGrade: 'fair', bulletPoints: ['Visible scratches', 'Minor crack present', 'Display still functional'] },
  { id: 'q-display-broken', questionId: 'q-display', label: 'Broken', description: 'Screen cracked or not displaying properly', icon: '💔', illustration: '📵', priceAdjustment: -12000, adjustmentType: 'fixed', conditionGrade: 'poor', bulletPoints: ['Screen cracked badly', 'Display issues present', 'Touch may not work'] }]

},
{
  id: 'q-body',
  categoryId: 'cat-smartphone',
  question: 'How is the body condition?',
  subtext: 'Dents, deep scratches, loose frame, heavy wear.',
  sortOrder: 3,
  active: true,
  options: [
  { id: 'q-body-likenew', questionId: 'q-body', label: 'Like New', description: 'No scratches, dents or marks on body', icon: '✨', illustration: '📱', priceAdjustment: 1000, adjustmentType: 'fixed', conditionGrade: 'excellent', bulletPoints: ['No scratches on body', 'No dents or marks', 'Looks brand new'] },
  { id: 'q-body-good', questionId: 'q-body', label: 'Good', description: 'Minor scratches, not easily visible', icon: '👍', illustration: '📱', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'good', bulletPoints: ['Minor scratches only', 'No dents', 'Normal wear and tear'] },
  { id: 'q-body-average', questionId: 'q-body', label: 'Average', description: 'Visible scratches on body, minor dents possible', icon: '😐', illustration: '📱', priceAdjustment: -2000, adjustmentType: 'fixed', conditionGrade: 'fair', bulletPoints: ['Visible scratches on body', 'Minor dents possible', 'Signs of normal wear and tear'] },
  { id: 'q-body-below', questionId: 'q-body', label: 'Below Average', description: 'Deep scratches, multiple dents or cracks', icon: '😟', illustration: '📵', priceAdjustment: -6000, adjustmentType: 'fixed', conditionGrade: 'poor', bulletPoints: ['Deep scratches present', 'Multiple dents or cracks', 'Heavy wear and tear'] }]

},
{
  id: 'q-battery',
  categoryId: 'cat-smartphone',
  question: 'Is the battery health above 90%?',
  subtext: 'Check Settings → Battery → Battery Health on iPhone.',
  sortOrder: 4,
  active: true,
  options: [
  { id: 'q-battery-yes', questionId: 'q-battery', label: 'Yes, above 90%', description: 'Battery is in great health', icon: '🔋', illustration: '🔋', priceAdjustment: 2000, adjustmentType: 'fixed', conditionGrade: 'excellent', bulletPoints: ['Battery health > 90%', 'Long battery life', 'No degradation'] },
  { id: 'q-battery-80', questionId: 'q-battery', label: '80% – 90%', description: 'Battery is decent', icon: '🔋', illustration: '🔋', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'good', bulletPoints: ['Battery health 80-90%', 'Decent battery life', 'Slight degradation'] },
  { id: 'q-battery-below', questionId: 'q-battery', label: 'Below 80%', description: 'Battery needs replacement soon', icon: '⚠️', illustration: '🪫', priceAdjustment: -3000, adjustmentType: 'fixed', conditionGrade: 'fair', bulletPoints: ['Battery health < 80%', 'Needs replacement soon', 'Reduced battery life'] },
  { id: 'q-battery-unknown', questionId: 'q-battery', label: "Don't Know", description: "I haven't checked", icon: '❓', illustration: '❓', priceAdjustment: -500, adjustmentType: 'fixed', conditionGrade: 'unknown', bulletPoints: ["Haven't checked battery health", 'Will be verified during inspection'] }]

},
{
  id: 'q-functional',
  categoryId: 'cat-smartphone',
  question: 'Is the device fully functional?',
  subtext: 'Check Face ID, cameras, speakers, microphone and charging.',
  sortOrder: 5,
  active: true,
  options: [
  { id: 'q-func-yes', questionId: 'q-functional', label: 'Everything Works', description: 'All features working perfectly', icon: '✅', illustration: '✅', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'excellent', bulletPoints: ['All features functional', 'Camera works', 'Face ID / fingerprint works', 'Speakers & mic work'] },
  { id: 'q-func-minor', questionId: 'q-functional', label: 'Minor Issue', description: 'One feature not working (e.g. Face ID)', icon: '⚠️', illustration: '⚠️', priceAdjustment: -3500, adjustmentType: 'fixed', conditionGrade: 'fair', bulletPoints: ['One feature not working', 'Rest of device functional', 'Repairable issue'] },
  { id: 'q-func-major', questionId: 'q-functional', label: 'Major Issue', description: 'Multiple features not working', icon: '❌', illustration: '❌', priceAdjustment: -8000, adjustmentType: 'fixed', conditionGrade: 'poor', bulletPoints: ['Multiple features broken', 'Significant repair needed', 'Reduced functionality'] }]

},
{
  id: 'q-water',
  categoryId: 'cat-smartphone',
  question: 'Has the device had water damage?',
  subtext: 'Check if the device has ever been submerged or heavily wet.',
  sortOrder: 6,
  active: true,
  options: [
  { id: 'q-water-no', questionId: 'q-water', label: 'No Water Damage', description: 'Device has never been water damaged', icon: '✅', illustration: '✅', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'excellent', bulletPoints: ['No water exposure', 'No corrosion', 'All ports clean'] },
  { id: 'q-water-yes', questionId: 'q-water', label: 'Yes, Water Damage', description: 'Device was exposed to water', icon: '💧', illustration: '💧', priceAdjustment: -15000, adjustmentType: 'fixed', conditionGrade: 'poor', bulletPoints: ['Water damage present', 'Possible corrosion', 'May have internal damage'] }]

},
{
  id: 'q-charger',
  categoryId: 'cat-smartphone',
  question: 'Do you have the original charger?',
  subtext: 'Original Apple/Samsung/OEM charger that came with the device.',
  sortOrder: 7,
  active: true,
  options: [
  { id: 'q-charger-yes', questionId: 'q-charger', label: 'Yes, Original Charger', description: 'Original charger included', icon: '🔌', illustration: '🔌', priceAdjustment: 500, adjustmentType: 'fixed', conditionGrade: 'good', bulletPoints: ['Original charger included', 'Genuine OEM accessory', 'Adds value to device'] },
  { id: 'q-charger-no', questionId: 'q-charger', label: 'No Charger', description: 'Charger not available', icon: '❌', illustration: '❌', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'neutral', bulletPoints: ['No charger available', 'Common situation', 'Does not significantly affect price'] }]

},
{
  id: 'q-box',
  categoryId: 'cat-smartphone',
  question: 'Do you have the original box?',
  subtext: 'Original retail box the device came in.',
  sortOrder: 8,
  active: true,
  options: [
  { id: 'q-box-yes', questionId: 'q-box', label: 'Yes, Original Box', description: 'Box and accessories included', icon: '📦', illustration: '📦', priceAdjustment: 300, adjustmentType: 'fixed', conditionGrade: 'good', bulletPoints: ['Original box available', 'Complete packaging', 'Adds resale value'] },
  { id: 'q-box-no', questionId: 'q-box', label: 'No Box', description: 'Box not available', icon: '❌', illustration: '❌', priceAdjustment: 0, adjustmentType: 'fixed', conditionGrade: 'neutral', bulletPoints: ['No original box', 'Very common', 'Minimal price impact'] }]

}];


// ─── ORDERS ───────────────────────────────────────────────────────────────────

export const orders: Order[] = [
{ id: 'ord-001', orderNumber: 'CSM-2024-001', type: 'sell', status: 'completed', customerId: 'cust-001', customerName: 'Rahul Sharma', customerPhone: '9876543210', customerEmail: 'rahul@email.com', customerAddress: '42 MG Road, Koramangala', pinCode: '560034', city: 'Bangalore', deviceName: 'iPhone 16 Pro Max 256GB', deviceBrand: 'Apple', deviceModel: 'iPhone 16 Pro Max', deviceStorage: '256GB', deviceColor: 'Black Titanium', quotedPrice: 78000, finalPrice: 76500, partnerId: 'partner-001', partnerName: 'TechHub Store', deliveryAgentId: 'delivery-001', deliveryAgentName: 'Ravi Kumar', pickupDate: '2024-12-15', pickupSlot: '10:00 AM - 12:00 PM', createdAt: '2024-12-14T09:30:00Z', updatedAt: '2024-12-16T14:20:00Z', paymentStatus: 'paid', inspectionScore: 88, notes: 'Device in excellent condition' },
{ id: 'ord-002', orderNumber: 'CSM-2024-002', type: 'sell', status: 'inspection', customerId: 'cust-002', customerName: 'Priya Patel', customerPhone: '9765432109', customerEmail: 'priya@email.com', customerAddress: '15 Bandra West, Near Station', pinCode: '400050', city: 'Mumbai', deviceName: 'Samsung Galaxy S24 Ultra 512GB', deviceBrand: 'Samsung', deviceModel: 'Galaxy S24 Ultra', deviceStorage: '512GB', deviceColor: 'Titanium Black', quotedPrice: 65000, finalPrice: 0, partnerId: 'partner-002', partnerName: 'MobileHub Store', deliveryAgentId: 'delivery-002', deliveryAgentName: 'Suresh Nair', pickupDate: '2024-12-20', pickupSlot: '2:00 PM - 4:00 PM', createdAt: '2024-12-19T11:00:00Z', updatedAt: '2024-12-20T15:30:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-003', orderNumber: 'CSM-2024-003', type: 'buy', status: 'completed', customerId: 'cust-003', customerName: 'Amit Singh', customerPhone: '9654321098', customerEmail: 'amit@email.com', customerAddress: '8 Sector 18, Noida', pinCode: '201301', city: 'Noida', deviceName: 'iPhone 15 Pro 128GB', deviceBrand: 'Apple', deviceModel: 'iPhone 15 Pro', deviceStorage: '128GB', deviceColor: 'Natural Titanium', quotedPrice: 58000, finalPrice: 58000, partnerId: 'partner-001', partnerName: 'TechHub Store', deliveryAgentId: 'delivery-003', deliveryAgentName: 'Deepak Verma', pickupDate: '2024-12-10', pickupSlot: '11:00 AM - 1:00 PM', createdAt: '2024-12-09T10:00:00Z', updatedAt: '2024-12-11T16:00:00Z', paymentStatus: 'paid', inspectionScore: 92, notes: 'Refurbished device - Grade A' },
{ id: 'ord-004', orderNumber: 'CSM-2024-004', type: 'exchange', status: 'assigned', customerId: 'cust-004', customerName: 'Sneha Reddy', customerPhone: '9543210987', customerEmail: 'sneha@email.com', customerAddress: '22 Jubilee Hills, Road 36', pinCode: '500033', city: 'Hyderabad', deviceName: 'OnePlus 12 256GB → iPhone 16 256GB', deviceBrand: 'OnePlus → Apple', deviceModel: 'OnePlus 12 → iPhone 16', deviceStorage: '256GB', deviceColor: 'Silky Black → Ultramarine', quotedPrice: 42000, finalPrice: 0, partnerId: 'partner-003', partnerName: 'GadgetZone', deliveryAgentId: null, deliveryAgentName: null, pickupDate: '2024-12-22', pickupSlot: '9:00 AM - 11:00 AM', createdAt: '2024-12-21T08:00:00Z', updatedAt: '2024-12-21T12:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: 'Exchange order - old device pickup + new device delivery' },
{ id: 'ord-005', orderNumber: 'CSM-2024-005', type: 'repair', status: 'picked_up', customerId: 'cust-005', customerName: 'Vikram Joshi', customerPhone: '9432109876', customerEmail: 'vikram@email.com', customerAddress: '5 Anna Nagar, Block B', pinCode: '600040', city: 'Chennai', deviceName: 'iPhone 14 Pro - Screen Replacement', deviceBrand: 'Apple', deviceModel: 'iPhone 14 Pro', deviceStorage: '256GB', deviceColor: 'Space Black', quotedPrice: 8500, finalPrice: 0, partnerId: 'partner-004', partnerName: 'iRepair Center', deliveryAgentId: 'delivery-001', deliveryAgentName: 'Ravi Kumar', pickupDate: '2024-12-20', pickupSlot: '3:00 PM - 5:00 PM', createdAt: '2024-12-19T14:00:00Z', updatedAt: '2024-12-20T16:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: 'Screen cracked - needs replacement' },
{ id: 'ord-006', orderNumber: 'CSM-2024-006', type: 'sell', status: 'created', customerId: 'cust-006', customerName: 'Meera Krishnan', customerPhone: '9321098765', customerEmail: 'meera@email.com', customerAddress: '18 Indiranagar, 100ft Road', pinCode: '560038', city: 'Bangalore', deviceName: 'MacBook Pro 14" M3 512GB', deviceBrand: 'Apple', deviceModel: 'MacBook Pro 14"', deviceStorage: '512GB', deviceColor: 'Space Gray', quotedPrice: 95000, finalPrice: 0, partnerId: null, partnerName: null, deliveryAgentId: null, deliveryAgentName: null, pickupDate: '2024-12-25', pickupSlot: '10:00 AM - 12:00 PM', createdAt: '2024-12-22T09:00:00Z', updatedAt: '2024-12-22T09:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-007', orderNumber: 'CSM-2024-007', type: 'sell', status: 'pickup_scheduled', customerId: 'cust-007', customerName: 'Arjun Mehta', customerPhone: '9210987654', customerEmail: 'arjun@email.com', customerAddress: '33 Powai, Hiranandani', pinCode: '400076', city: 'Mumbai', deviceName: 'Samsung Galaxy S23 Ultra 256GB', deviceBrand: 'Samsung', deviceModel: 'Galaxy S23 Ultra', deviceStorage: '256GB', deviceColor: 'Phantom Black', quotedPrice: 52000, finalPrice: 0, partnerId: 'partner-002', partnerName: 'MobileHub Store', deliveryAgentId: 'delivery-002', deliveryAgentName: 'Suresh Nair', pickupDate: '2024-12-23', pickupSlot: '1:00 PM - 3:00 PM', createdAt: '2024-12-21T10:00:00Z', updatedAt: '2024-12-22T11:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-008', orderNumber: 'CSM-2024-008', type: 'sell', status: 'payment_processing', customerId: 'cust-008', customerName: 'Kavya Nair', customerPhone: '9109876543', customerEmail: 'kavya@email.com', customerAddress: '7 Whitefield, ITPL Road', pinCode: '560066', city: 'Bangalore', deviceName: 'Google Pixel 8 Pro 256GB', deviceBrand: 'Google', deviceModel: 'Pixel 8 Pro', deviceStorage: '256GB', deviceColor: 'Obsidian', quotedPrice: 38000, finalPrice: 36500, partnerId: 'partner-001', partnerName: 'TechHub Store', deliveryAgentId: 'delivery-003', deliveryAgentName: 'Deepak Verma', pickupDate: '2024-12-18', pickupSlot: '11:00 AM - 1:00 PM', createdAt: '2024-12-17T09:00:00Z', updatedAt: '2024-12-19T14:00:00Z', paymentStatus: 'processing', inspectionScore: 85, notes: 'Minor scratches on back panel' },
{ id: 'ord-009', orderNumber: 'CSM-2024-009', type: 'buy', status: 'completed', customerId: 'cust-009', customerName: 'Rohit Gupta', customerPhone: '9098765432', customerEmail: 'rohit@email.com', customerAddress: '12 DLF Phase 2, Gurgaon', pinCode: '122002', city: 'Gurgaon', deviceName: 'OnePlus 11 256GB', deviceBrand: 'OnePlus', deviceModel: 'OnePlus 11', deviceStorage: '256GB', deviceColor: 'Titan Black', quotedPrice: 32000, finalPrice: 32000, partnerId: 'partner-003', partnerName: 'GadgetZone', deliveryAgentId: 'delivery-001', deliveryAgentName: 'Ravi Kumar', pickupDate: '2024-12-12', pickupSlot: '2:00 PM - 4:00 PM', createdAt: '2024-12-11T11:00:00Z', updatedAt: '2024-12-13T15:00:00Z', paymentStatus: 'paid', inspectionScore: 90, notes: 'Refurbished - Grade B' },
{ id: 'ord-010', orderNumber: 'CSM-2024-010', type: 'repair', status: 'inspection', customerId: 'cust-010', customerName: 'Ananya Sharma', customerPhone: '8987654321', customerEmail: 'ananya@email.com', customerAddress: '25 Koramangala 5th Block', pinCode: '560095', city: 'Bangalore', deviceName: 'Samsung S22 - Battery Replacement', deviceBrand: 'Samsung', deviceModel: 'Galaxy S22', deviceStorage: '128GB', deviceColor: 'Phantom White', quotedPrice: 3500, finalPrice: 0, partnerId: 'partner-004', partnerName: 'iRepair Center', deliveryAgentId: 'delivery-002', deliveryAgentName: 'Suresh Nair', pickupDate: '2024-12-20', pickupSlot: '10:00 AM - 12:00 PM', createdAt: '2024-12-19T08:00:00Z', updatedAt: '2024-12-20T11:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: 'Battery draining fast' },
{ id: 'ord-011', orderNumber: 'CSM-2024-011', type: 'sell', status: 'accepted', customerId: 'cust-011', customerName: 'Kiran Rao', customerPhone: '8876543210', customerEmail: 'kiran@email.com', customerAddress: '9 Banjara Hills, Road 12', pinCode: '500034', city: 'Hyderabad', deviceName: 'Xiaomi 14 Ultra 512GB', deviceBrand: 'Xiaomi', deviceModel: 'Xiaomi 14 Ultra', deviceStorage: '512GB', deviceColor: 'Titanium Gray', quotedPrice: 45000, finalPrice: 0, partnerId: 'partner-003', partnerName: 'GadgetZone', deliveryAgentId: null, deliveryAgentName: null, pickupDate: '2024-12-24', pickupSlot: '9:00 AM - 11:00 AM', createdAt: '2024-12-22T10:00:00Z', updatedAt: '2024-12-22T14:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-012', orderNumber: 'CSM-2024-012', type: 'sell', status: 'created', customerId: 'cust-012', customerName: 'Divya Menon', customerPhone: '8765432109', customerEmail: 'divya@email.com', customerAddress: '14 T Nagar, Chennai', pinCode: '600017', city: 'Chennai', deviceName: 'iPad Pro 12.9" M2 256GB', deviceBrand: 'Apple', deviceModel: 'iPad Pro 12.9"', deviceStorage: '256GB', deviceColor: 'Space Gray', quotedPrice: 55000, finalPrice: 0, partnerId: null, partnerName: null, deliveryAgentId: null, deliveryAgentName: null, pickupDate: '2024-12-26', pickupSlot: '11:00 AM - 1:00 PM', createdAt: '2024-12-23T09:00:00Z', updatedAt: '2024-12-23T09:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-013', orderNumber: 'CSM-2024-013', type: 'exchange', status: 'completed', customerId: 'cust-013', customerName: 'Suresh Kumar', customerPhone: '8654321098', customerEmail: 'suresh@email.com', customerAddress: '6 Marathahalli, Outer Ring Road', pinCode: '560037', city: 'Bangalore', deviceName: 'Realme GT 5 Pro → OnePlus 12', deviceBrand: 'Realme → OnePlus', deviceModel: 'GT 5 Pro → OnePlus 12', deviceStorage: '256GB', deviceColor: 'Titanium Gray → Silky Black', quotedPrice: 28000, finalPrice: 28000, partnerId: 'partner-001', partnerName: 'TechHub Store', deliveryAgentId: 'delivery-003', deliveryAgentName: 'Deepak Verma', pickupDate: '2024-12-08', pickupSlot: '2:00 PM - 4:00 PM', createdAt: '2024-12-07T10:00:00Z', updatedAt: '2024-12-09T16:00:00Z', paymentStatus: 'paid', inspectionScore: 82, notes: 'Exchange completed successfully' },
{ id: 'ord-014', orderNumber: 'CSM-2024-014', type: 'sell', status: 'inspection_completed', customerId: 'cust-014', customerName: 'Pooja Agarwal', customerPhone: '8543210987', customerEmail: 'pooja@email.com', customerAddress: '20 Sector 62, Noida', pinCode: '201309', city: 'Noida', deviceName: 'iPhone 13 Pro Max 256GB', deviceBrand: 'Apple', deviceModel: 'iPhone 13 Pro Max', deviceStorage: '256GB', deviceColor: 'Sierra Blue', quotedPrice: 42000, finalPrice: 40500, partnerId: 'partner-002', partnerName: 'MobileHub Store', deliveryAgentId: 'delivery-001', deliveryAgentName: 'Ravi Kumar', pickupDate: '2024-12-19', pickupSlot: '10:00 AM - 12:00 PM', createdAt: '2024-12-18T09:00:00Z', updatedAt: '2024-12-20T13:00:00Z', paymentStatus: 'pending', inspectionScore: 86, notes: 'Minor scratches on back panel noted' },
{ id: 'ord-015', orderNumber: 'CSM-2024-015', type: 'repair', status: 'completed', customerId: 'cust-015', customerName: 'Nikhil Verma', customerPhone: '8432109876', customerEmail: 'nikhil@email.com', customerAddress: '3 Andheri West, Mumbai', pinCode: '400058', city: 'Mumbai', deviceName: 'OnePlus 10 Pro - Charging Port', deviceBrand: 'OnePlus', deviceModel: 'OnePlus 10 Pro', deviceStorage: '256GB', deviceColor: 'Volcanic Black', quotedPrice: 2500, finalPrice: 2500, partnerId: 'partner-004', partnerName: 'iRepair Center', deliveryAgentId: 'delivery-002', deliveryAgentName: 'Suresh Nair', pickupDate: '2024-12-05', pickupSlot: '3:00 PM - 5:00 PM', createdAt: '2024-12-04T11:00:00Z', updatedAt: '2024-12-06T14:00:00Z', paymentStatus: 'paid', inspectionScore: null, notes: 'Charging port replaced successfully' },
// More orders
{ id: 'ord-016', orderNumber: 'CSM-2024-016', type: 'sell', status: 'created', customerId: 'cust-016', customerName: 'Aisha Khan', customerPhone: '8321098765', customerEmail: 'aisha@email.com', customerAddress: '11 Vasant Kunj, New Delhi', pinCode: '110070', city: 'Delhi', deviceName: 'Samsung Galaxy Z Fold 5 512GB', deviceBrand: 'Samsung', deviceModel: 'Galaxy Z Fold 5', deviceStorage: '512GB', deviceColor: 'Phantom Black', quotedPrice: 72000, finalPrice: 0, partnerId: null, partnerName: null, deliveryAgentId: null, deliveryAgentName: null, pickupDate: '2024-12-27', pickupSlot: '10:00 AM - 12:00 PM', createdAt: '2024-12-24T10:00:00Z', updatedAt: '2024-12-24T10:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-017', orderNumber: 'CSM-2024-017', type: 'buy', status: 'completed', customerId: 'cust-017', customerName: 'Rajan Pillai', customerPhone: '8210987654', customerEmail: 'rajan@email.com', customerAddress: '16 Ernakulam, Kochi', pinCode: '682011', city: 'Kochi', deviceName: 'iPhone 14 128GB', deviceBrand: 'Apple', deviceModel: 'iPhone 14', deviceStorage: '128GB', deviceColor: 'Midnight', quotedPrice: 42000, finalPrice: 42000, partnerId: 'partner-003', partnerName: 'GadgetZone', deliveryAgentId: 'delivery-003', deliveryAgentName: 'Deepak Verma', pickupDate: '2024-12-13', pickupSlot: '11:00 AM - 1:00 PM', createdAt: '2024-12-12T09:00:00Z', updatedAt: '2024-12-14T15:00:00Z', paymentStatus: 'paid', inspectionScore: 88, notes: 'Refurbished - Grade A' },
{ id: 'ord-018', orderNumber: 'CSM-2024-018', type: 'sell', status: 'assigned', customerId: 'cust-018', customerName: 'Tanvi Desai', customerPhone: '8109876543', customerEmail: 'tanvi@email.com', customerAddress: '28 Satellite, Ahmedabad', pinCode: '380015', city: 'Ahmedabad', deviceName: 'Vivo X100 Pro 256GB', deviceBrand: 'Vivo', deviceModel: 'X100 Pro', deviceStorage: '256GB', deviceColor: 'Asteroid Black', quotedPrice: 38000, finalPrice: 0, partnerId: 'partner-002', partnerName: 'MobileHub Store', deliveryAgentId: null, deliveryAgentName: null, pickupDate: '2024-12-25', pickupSlot: '2:00 PM - 4:00 PM', createdAt: '2024-12-23T11:00:00Z', updatedAt: '2024-12-23T15:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-019', orderNumber: 'CSM-2024-019', type: 'sell', status: 'picked_up', customerId: 'cust-019', customerName: 'Manish Tiwari', customerPhone: '7987654321', customerEmail: 'manish@email.com', customerAddress: '4 Hazratganj, Lucknow', pinCode: '226001', city: 'Lucknow', deviceName: 'Realme GT Neo 5 256GB', deviceBrand: 'Realme', deviceModel: 'GT Neo 5', deviceStorage: '256GB', deviceColor: 'Booster White', quotedPrice: 22000, finalPrice: 0, partnerId: 'partner-001', partnerName: 'TechHub Store', deliveryAgentId: 'delivery-001', deliveryAgentName: 'Ravi Kumar', pickupDate: '2024-12-21', pickupSlot: '9:00 AM - 11:00 AM', createdAt: '2024-12-20T10:00:00Z', updatedAt: '2024-12-21T10:30:00Z', paymentStatus: 'pending', inspectionScore: null, notes: '' },
{ id: 'ord-020', orderNumber: 'CSM-2024-020', type: 'repair', status: 'created', customerId: 'cust-020', customerName: 'Shreya Bose', customerPhone: '7876543210', customerEmail: 'shreya@email.com', customerAddress: '19 Salt Lake, Kolkata', pinCode: '700091', city: 'Kolkata', deviceName: 'Nothing Phone 2 - Camera Issue', deviceBrand: 'Nothing', deviceModel: 'Phone 2', deviceStorage: '256GB', deviceColor: 'Dark Gray', quotedPrice: 4500, finalPrice: 0, partnerId: null, partnerName: null, deliveryAgentId: null, deliveryAgentName: null, pickupDate: '2024-12-28', pickupSlot: '11:00 AM - 1:00 PM', createdAt: '2024-12-25T09:00:00Z', updatedAt: '2024-12-25T09:00:00Z', paymentStatus: 'pending', inspectionScore: null, notes: 'Front camera not working' }];


// ─── PARTNERS ─────────────────────────────────────────────────────────────────

export const partners: Partner[] = [
{ id: 'partner-001', name: 'Rajesh Kumar', storeName: 'TechHub Store', phone: '9876543210', email: 'rajesh@techhub.com', city: 'Bangalore', state: 'Karnataka', pinCodes: ['560034', '560038', '560095', '560037', '560066'], categories: ['Smartphones', 'Laptops', 'Tablets'], status: 'active', rating: 4.8, totalOrders: 342, completedOrders: 318, totalEarnings: 485000, pendingPayout: 28500, availableBalance: 45000, joinedAt: '2023-03-15', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&q=80', commission: 12 },
{ id: 'partner-002', name: 'Pradeep Sharma', storeName: 'MobileHub Store', phone: '9765432109', email: 'pradeep@mobilehub.com', city: 'Mumbai', state: 'Maharashtra', pinCodes: ['400050', '400076', '400058', '400001'], categories: ['Smartphones', 'Earbuds', 'Smartwatches'], status: 'active', rating: 4.6, totalOrders: 287, completedOrders: 265, totalEarnings: 392000, pendingPayout: 18200, availableBalance: 32000, joinedAt: '2023-05-20', avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&q=80', commission: 10 },
{ id: 'partner-003', name: 'Sunil Reddy', storeName: 'GadgetZone', phone: '9654321098', email: 'sunil@gadgetzone.com', city: 'Hyderabad', state: 'Telangana', pinCodes: ['500033', '500034', '500001'], categories: ['Smartphones', 'Gaming Consoles', 'Cameras'], status: 'active', rating: 4.5, totalOrders: 198, completedOrders: 182, totalEarnings: 265000, pendingPayout: 12800, availableBalance: 22000, joinedAt: '2023-07-10', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80&q=80', commission: 11 },
{ id: 'partner-004', name: 'Anil Menon', storeName: 'iRepair Center', phone: '9543210987', email: 'anil@irepair.com', city: 'Chennai', state: 'Tamil Nadu', pinCodes: ['600040', '600017', '600001'], categories: ['Smartphones', 'Tablets', 'Laptops'], status: 'active', rating: 4.7, totalOrders: 156, completedOrders: 148, totalEarnings: 198000, pendingPayout: 9500, availableBalance: 18000, joinedAt: '2023-09-05', avatar: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=80&q=80', commission: 13 },
{ id: 'partner-005', name: 'Vikash Singh', storeName: 'DigiWorld', phone: '9432109876', email: 'vikash@digiworld.com', city: 'Delhi', state: 'Delhi', pinCodes: ['110070', '110001', '110020'], categories: ['Smartphones', 'Laptops'], status: 'pending', rating: 0, totalOrders: 0, completedOrders: 0, totalEarnings: 0, pendingPayout: 0, availableBalance: 0, joinedAt: '2024-12-20', avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=80&q=80', commission: 10 }];


// ─── DELIVERY AGENTS ──────────────────────────────────────────────────────────

export const deliveryAgents: DeliveryAgent[] = [
{ id: 'delivery-001', name: 'Ravi Kumar', phone: '9876543210', email: 'ravi@casmik.com', city: 'Bangalore', pinCodes: ['560034', '560038', '560095'], status: 'on_trip', rating: 4.9, todayPickups: 3, todayDeliveries: 2, totalDeliveries: 892, earnings: 2850, vehicle: 'Bike', vehicleNumber: 'KA01AB1234', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&q=80', joinedAt: '2023-01-10' },
{ id: 'delivery-002', name: 'Suresh Nair', phone: '9765432109', email: 'suresh@casmik.com', city: 'Mumbai', pinCodes: ['400050', '400076', '400058'], status: 'online', rating: 4.7, todayPickups: 2, todayDeliveries: 3, totalDeliveries: 654, earnings: 2200, vehicle: 'Bike', vehicleNumber: 'MH02CD5678', avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&q=80', joinedAt: '2023-03-15' },
{ id: 'delivery-003', name: 'Deepak Verma', phone: '9654321098', email: 'deepak@casmik.com', city: 'Noida', pinCodes: ['201301', '201309', '122002'], status: 'online', rating: 4.8, todayPickups: 4, todayDeliveries: 1, totalDeliveries: 445, earnings: 1850, vehicle: 'Scooter', vehicleNumber: 'UP16EF9012', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80&q=80', joinedAt: '2023-06-20' },
{ id: 'delivery-004', name: 'Anand Pillai', phone: '9543210987', email: 'anand@casmik.com', city: 'Chennai', pinCodes: ['600040', '600017', '600001'], status: 'offline', rating: 4.6, todayPickups: 0, todayDeliveries: 0, totalDeliveries: 312, earnings: 0, vehicle: 'Bike', vehicleNumber: 'TN09GH3456', avatar: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=80&q=80', joinedAt: '2023-09-01' },
{ id: 'delivery-005', name: 'Mohit Sharma', phone: '9432109876', email: 'mohit@casmik.com', city: 'Hyderabad', pinCodes: ['500033', '500034', '500001'], status: 'online', rating: 4.5, todayPickups: 1, todayDeliveries: 2, totalDeliveries: 228, earnings: 1200, vehicle: 'Bike', vehicleNumber: 'TS10IJ7890', avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=80&q=80', joinedAt: '2023-11-15' }];


// ─── CUSTOMERS ────────────────────────────────────────────────────────────────

export const customers: Customer[] = [
{ id: 'cust-001', name: 'Rahul Sharma', phone: '9876543210', email: 'rahul@email.com', city: 'Bangalore', pinCode: '560034', totalOrders: 5, totalValue: 285000, joinedAt: '2023-06-15', status: 'active', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&q=80' },
{ id: 'cust-002', name: 'Priya Patel', phone: '9765432109', email: 'priya@email.com', city: 'Mumbai', pinCode: '400050', totalOrders: 3, totalValue: 145000, joinedAt: '2023-08-20', status: 'active', avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&q=80' },
{ id: 'cust-003', name: 'Amit Singh', phone: '9654321098', email: 'amit@email.com', city: 'Noida', pinCode: '201301', totalOrders: 2, totalValue: 90000, joinedAt: '2023-09-10', status: 'active', avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&q=80' },
{ id: 'cust-004', name: 'Sneha Reddy', phone: '9543210987', email: 'sneha@email.com', city: 'Hyderabad', pinCode: '500033', totalOrders: 4, totalValue: 198000, joinedAt: '2023-07-05', status: 'active', avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&q=80' },
{ id: 'cust-005', name: 'Vikram Joshi', phone: '9432109876', email: 'vikram@email.com', city: 'Chennai', pinCode: '600040', totalOrders: 1, totalValue: 8500, joinedAt: '2023-11-20', status: 'active', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80&q=80' }];


// ─── HELPER FUNCTIONS ─────────────────────────────────────────────────────────

export const getOrderStatusLabel = (status: OrderStatus): string => {
  const labels: Record<OrderStatus, string> = {
    created: 'Quote Created',
    assigned: 'Partner Assigned',
    accepted: 'Partner Accepted',
    pickup_scheduled: 'Pickup Scheduled',
    picked_up: 'Device Picked Up',
    inspection: 'Under Inspection',
    inspection_completed: 'Inspection Done',
    final_price: 'Final Price Set',
    customer_accepted: 'Customer Accepted',
    payment_processing: 'Payment Processing',
    paid: 'Payment Done',
    completed: 'Completed',
    rejected: 'Rejected',
    cancelled: 'Cancelled',
    rescheduled: 'Rescheduled'
  };
  return labels[status] || status;
};

export const getOrderStatusColor = (status: OrderStatus): string => {
  const colors: Record<OrderStatus, string> = {
    created: 'bg-blue-50 text-blue-700',
    assigned: 'bg-purple-50 text-purple-700',
    accepted: 'bg-indigo-50 text-indigo-700',
    pickup_scheduled: 'bg-cyan-50 text-cyan-700',
    picked_up: 'bg-teal-50 text-teal-700',
    inspection: 'bg-yellow-50 text-yellow-700',
    inspection_completed: 'bg-orange-50 text-orange-700',
    final_price: 'bg-amber-50 text-amber-700',
    customer_accepted: 'bg-lime-50 text-lime-700',
    payment_processing: 'bg-green-50 text-green-700',
    paid: 'bg-emerald-50 text-emerald-700',
    completed: 'bg-green-100 text-green-800',
    rejected: 'bg-red-50 text-red-700',
    cancelled: 'bg-gray-100 text-gray-600',
    failed: 'bg-red-100 text-red-800',
    rescheduled: 'bg-yellow-100 text-yellow-800'
  } as Record<string, string>;
  return colors[status] || 'bg-gray-100 text-gray-600';
};

export const getTypeColor = (type: Order['type']): string => {
  const colors = { sell: 'bg-green-50 text-green-700', buy: 'bg-blue-50 text-blue-700', exchange: 'bg-purple-50 text-purple-700', repair: 'bg-orange-50 text-orange-700' };
  return colors[type];
};
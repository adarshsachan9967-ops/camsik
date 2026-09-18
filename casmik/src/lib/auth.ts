export interface CustomerUser {
  id: string;
  name: string;
  phone: string;
  email?: string;
  avatar?: string;
  createdAt: string;
}

export interface CustomerOrderRecord {
  id: string;
  orderNumber: string;
  type: 'exchange' | 'buy' | 'sell' | 'repair';
  status: string;
  createdAt: string;
  customerName: string;
  customerPhone: string;
  customerAddress: string;
  city: string;
  pincode: string;
  pickupDate?: string;
  pickupSlot?: string;
  paymentMethod: string;
  paymentStatus: 'pending' | 'paid' | 'pay_on_delivery';
  
  // Exchange specific
  oldDevice?: {
    brand: string;
    model: string;
    image: string;
    category?: string;
    conditionSummary: string;
    valuation: number;
    exchangeBonus: number;
  };

  // Buy / Upgrade product specific
  newDevice?: {
    id: string;
    brand: string;
    model: string;
    storage: string;
    color: string;
    condition: string;
    price: number;
    originalPrice?: number;
    warranty: string;
    batteryHealth?: number | string;
    image: string;
  };

  // Pricing
  upgradePrice: number;
  tradeInCredit: number;
  exchangeBonus: number;
  couponCode?: string;
  couponDiscount: number;
  netPayable: number;
  balanceOwedToUser?: number;
  payoutDetails?: string;
}

const USER_STORAGE_KEY = 'camsik_customer_user';
const ORDERS_STORAGE_KEY = 'camsik_customer_orders';

export function getCurrentUser(): CustomerUser | null {
  if (typeof window === 'undefined') return null;
  try {
    const raw = localStorage.getItem(USER_STORAGE_KEY);
    if (!raw) return null;
    return JSON.parse(raw);
  } catch (err) {
    console.error('Failed to get customer user:', err);
    return null;
  }
}

export function setCurrentUser(user: CustomerUser): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(user));
    window.dispatchEvent(new CustomEvent('casmik_auth_change', { detail: user }));
  } catch (err) {
    console.error('Failed to save customer user:', err);
  }
}

export function logoutUser(): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.removeItem(USER_STORAGE_KEY);
    window.dispatchEvent(new CustomEvent('casmik_auth_change', { detail: null }));
  } catch (err) {
    console.error('Failed to logout:', err);
  }
}

export function saveCustomerOrder(order: CustomerOrderRecord): void {
  if (typeof window === 'undefined') return;
  try {
    const existing = getCustomerOrders();
    const updated = [order, ...existing.filter((o) => o.id !== order.id)];
    localStorage.setItem(ORDERS_STORAGE_KEY, JSON.stringify(updated));
    window.dispatchEvent(new CustomEvent('casmik_orders_updated', { detail: updated }));
  } catch (err) {
    console.error('Failed to save order:', err);
  }
}

export function getCustomerOrders(phone?: string): CustomerOrderRecord[] {
  if (typeof window === 'undefined') return [];
  try {
    const raw = localStorage.getItem(ORDERS_STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    if (phone && phone.trim() !== '') {
      const cleanPhone = phone.trim().replace(/\D/g, '').slice(-10);
      return parsed.filter((o) => o.customerPhone.replace(/\D/g, '').slice(-10) === cleanPhone);
    }
    return parsed;
  } catch (err) {
    console.error('Failed to read customer orders:', err);
    return [];
  }
}

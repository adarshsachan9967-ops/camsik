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

// Credential-based Registered Users Database
const USERS_DB_KEY = 'camsik_registered_users_db';

export interface RegisteredUser {
  id: string;
  name: string;
  phone: string;
  email: string;
  password?: string;
  createdAt: string;
}

export function getRegisteredUsers(): RegisteredUser[] {
  if (typeof window === 'undefined') return [];
  try {
    const raw = localStorage.getItem(USERS_DB_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

export function registerUser(user: { name: string; phone: string; email: string; password?: string }): CustomerUser {
  const existing = getRegisteredUsers();
  const cleanPhone = user.phone.trim().replace(/\D/g, '').slice(-10);
  const cleanEmail = user.email.trim().toLowerCase();

  const newUser: RegisteredUser = {
    id: 'user-' + Date.now(),
    name: user.name.trim(),
    phone: cleanPhone,
    email: cleanEmail,
    password: user.password || '',
    createdAt: new Date().toISOString(),
  };
  const updated = [...existing.filter((u) => u.email !== newUser.email && u.phone !== newUser.phone), newUser];
  if (typeof window !== 'undefined') {
    localStorage.setItem(USERS_DB_KEY, JSON.stringify(updated));
  }
  const customerUser: CustomerUser = {
    id: newUser.id,
    name: newUser.name,
    phone: newUser.phone,
    email: newUser.email,
    createdAt: newUser.createdAt,
  };
  setCurrentUser(customerUser);
  return customerUser;
}

export function authenticateUser(identifier: string, password?: string): CustomerUser {
  const users = getRegisteredUsers();
  const cleanId = identifier.trim().toLowerCase();
  const cleanPhone = identifier.trim().replace(/\D/g, '').slice(-10);

  const matched = users.find(
    (u) =>
      u.email.toLowerCase() === cleanId ||
      u.phone.replace(/\D/g, '').slice(-10) === cleanPhone
  );

  if (matched) {
    if (password && matched.password && matched.password !== password.trim()) {
      throw new Error('Incorrect password. Please enter your valid password.');
    }
    const customerUser: CustomerUser = {
      id: matched.id,
      name: matched.name,
      phone: matched.phone,
      email: matched.email,
      createdAt: matched.createdAt,
    };
    setCurrentUser(customerUser);
    return customerUser;
  }

  // If no user found, throw error instead of auto-logging in with random credentials
  throw new Error('Account not found. Please create an account or verify your credentials.');
}


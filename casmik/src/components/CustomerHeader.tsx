'use client';
import React, { useState, useEffect, useRef } from 'react';
import Link from 'next/link';
import { Search, MapPin, Heart, ShoppingCart, Zap, Menu, X, ChevronDown, Pin, LogIn } from 'lucide-react';
import { deviceModels, brands } from '@/lib/casmikData';

const navItems = [
  { label: 'Sell Device', href: '/sell-device-get-quote' },
  { label: 'Buy Refurbished', href: '/buy-refurbished' },
  { label: 'Exchange', href: '/exchange-device' },
  { label: 'Repair', href: '/repair-device' },
  { label: 'Track Order', href: '/track-order' },
  { label: 'How It Works', href: '#how-it-works' },
  { label: 'About Us', href: '#about' },
  { label: 'Contact', href: '#contact' },
];

interface SearchResult {
  id: string;
  type: 'model' | 'brand';
  name: string;
  brandName?: string;
  image?: string;
  href: string;
}

export default function CustomerHeader() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<SearchResult[]>([]);
  const [showResults, setShowResults] = useState(false);
  const [locationOpen, setLocationOpen] = useState(false);
  const [pinInput, setPinInput] = useState('');
  const [currentCity, setCurrentCity] = useState('Detect Location');
  const [pinError, setPinError] = useState('');
  const searchRef = useRef<HTMLDivElement>(null);
  const locationRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handler = () => setScrolled(window.scrollY > 10);
    window.addEventListener('scroll', handler, { passive: true });
    return () => window.removeEventListener('scroll', handler);
  }, []);

  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (searchRef.current && !searchRef.current.contains(e.target as Node)) {
        setShowResults(false);
      }
      if (locationRef.current && !locationRef.current.contains(e.target as Node)) {
        setLocationOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  const handleSearch = (q: string) => {
    setSearchQuery(q);
    if (q.length < 1) { setSearchResults([]); setShowResults(false); return; }
    const lower = q.toLowerCase();
    const results: SearchResult[] = [];
    // Search brands
    brands.filter(b => b.name.toLowerCase().includes(lower)).slice(0, 3).forEach(b => {
      results.push({ id: `brand-${b.id}`, type: 'brand', name: b.name, image: b.logo, href: '/sell-device-get-quote' });
    });
    // Search models
    deviceModels.filter(m => m.name.toLowerCase().includes(lower)).slice(0, 6).forEach(m => {
      const brand = brands.find(b => b.id === m.brandId);
      results.push({ id: `model-${m.id}`, type: 'model', name: m.name, brandName: brand?.name, image: m.image, href: '/sell-device-get-quote' });
    });
    setSearchResults(results.slice(0, 8));
    setShowResults(true);
  };

  const handlePinSubmit = () => {
    if (!/^\d{6}$/.test(pinInput)) { setPinError('Please enter a valid 6-digit PIN code'); return; }
    const pinCityMap: Record<string, string> = {
      '560': 'Bangalore', '400': 'Mumbai', '110': 'Delhi', '500': 'Hyderabad',
      '600': 'Chennai', '700': 'Kolkata', '380': 'Ahmedabad', '411': 'Pune',
      '302': 'Jaipur', '226': 'Lucknow', '201': 'Noida', '122': 'Gurgaon',
    };
    const prefix = pinInput.substring(0, 3);
    const city = pinCityMap[prefix] || 'Your City';
    setCurrentCity(`${city} - ${pinInput}`);
    setPinError('');
    setLocationOpen(false);
    setPinInput('');
  };

  const detectLocation = () => {
    if (typeof window !== 'undefined' && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        () => { setCurrentCity('Current Location'); setLocationOpen(false); },
        () => { setPinError('Location access denied. Please enter PIN code.'); }
      );
    }
  };

  return (
    <>
      <header className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${scrolled ? 'bg-white/95 backdrop-blur-md shadow-md border-b border-border' : 'bg-white border-b border-border'}`}>
        <div className="max-w-screen-2xl mx-auto px-4 lg:px-8 xl:px-10">
          <div className="flex items-center h-16 gap-4">
            {/* Logo */}
            <Link href="/" className="flex items-center gap-2 flex-shrink-0 group">
              <div className="w-9 h-9 rounded-xl gradient-green flex items-center justify-center shadow-green">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                  <path d="M12 2L3 7v5c0 5.25 3.75 10.15 9 11.35C17.25 22.15 21 17.25 21 12V7L12 2z" fill="white" fillOpacity="0.9"/>
                  <path d="M9 12l2 2 4-4" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </div>
              <div className="hidden sm:block">
                <span className="font-extrabold text-xl tracking-tight text-foreground">Cas</span>
                <span className="font-extrabold text-xl tracking-tight text-primary">mik</span>
              </div>
            </Link>

            {/* Nav — desktop */}
            <nav className="hidden xl:flex items-center gap-0.5 ml-4">
              {navItems.map((item) => (
                <Link key={`nav-${item.label}`} href={item.href}
                  className="text-sm font-medium text-muted-foreground hover:text-foreground px-3 py-2 rounded-lg hover:bg-muted transition-colors duration-150 whitespace-nowrap">
                  {item.label}
                </Link>
              ))}
            </nav>

            <div className="flex-1" />

            {/* Right actions */}
            <div className="flex items-center gap-2">
              {/* Search */}
              <div ref={searchRef} className="relative hidden md:block">
                <button onClick={() => { setSearchOpen(!searchOpen); if (!searchOpen) setTimeout(() => document.getElementById('header-search')?.focus(), 100); }}
                  className="w-9 h-9 flex items-center justify-center rounded-lg hover:bg-muted transition-colors text-muted-foreground hover:text-foreground" aria-label="Search">
                  <Search size={18} />
                </button>
                {searchOpen && (
                  <div className="absolute right-0 top-11 w-80 bg-white rounded-2xl border border-border shadow-xl z-50 overflow-hidden fade-in">
                    <div className="flex items-center gap-2 px-4 py-3 border-b border-border">
                      <Search size={15} className="text-muted-foreground flex-shrink-0" />
                      <input id="header-search" type="text" value={searchQuery} onChange={e => handleSearch(e.target.value)}
                        placeholder="Search brand, model..." autoFocus
                        className="flex-1 text-sm bg-transparent focus:outline-none text-foreground placeholder:text-muted-foreground" />
                      {searchQuery && <button onClick={() => { setSearchQuery(''); setSearchResults([]); }} className="text-muted-foreground hover:text-foreground"><X size={14} /></button>}
                    </div>
                    {showResults && searchResults.length > 0 ? (
                      <div className="py-2 max-h-72 overflow-y-auto">
                        {searchResults.map(r => (
                          <Link key={r.id} href={r.href} onClick={() => { setSearchOpen(false); setSearchQuery(''); setShowResults(false); }}
                            className="flex items-center gap-3 px-4 py-2.5 hover:bg-muted transition-colors">
                            {r.image && <img src={r.image} alt={r.name} className="w-8 h-8 rounded-lg object-cover bg-muted flex-shrink-0" />}
                            <div className="flex-1 min-w-0">
                              <p className="text-sm font-semibold text-foreground truncate">{r.name}</p>
                              {r.brandName && <p className="text-xs text-muted-foreground">{r.brandName}</p>}
                            </div>
                            <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${r.type === 'brand' ? 'bg-primary/10 text-primary' : 'bg-muted text-muted-foreground'}`}>
                              {r.type === 'brand' ? 'Brand' : 'Model'}
                            </span>
                          </Link>
                        ))}
                      </div>
                    ) : searchQuery.length > 0 ? (
                      <div className="px-4 py-6 text-center text-sm text-muted-foreground">No results for &quot;{searchQuery}&quot;</div>
                    ) : (
                      <div className="px-4 py-3">
                        <p className="text-xs font-semibold text-muted-foreground mb-2 uppercase tracking-wide">Popular Searches</p>
                        {['iPhone 15 Pro', 'Samsung S24', 'MacBook Air M3', 'OnePlus 12'].map(s => (
                          <button key={s} onClick={() => handleSearch(s)}
                            className="flex items-center gap-2 w-full px-2 py-2 rounded-lg hover:bg-muted text-sm text-foreground transition-colors">
                            <Search size={12} className="text-muted-foreground" />{s}
                          </button>
                        ))}
                      </div>
                    )}
                  </div>
                )}
              </div>

              {/* Location */}
              <div ref={locationRef} className="relative hidden md:block">
                <button onClick={() => setLocationOpen(!locationOpen)}
                  className="flex items-center gap-1.5 px-3 py-2 rounded-lg border border-border hover:bg-muted transition-colors text-sm font-medium text-muted-foreground hover:text-foreground max-w-36 truncate">
                  <MapPin size={14} className="text-primary flex-shrink-0" />
                  <span className="truncate">{currentCity}</span>
                  <ChevronDown size={12} className="flex-shrink-0" />
                </button>
                {locationOpen && (
                  <div className="absolute right-0 top-11 w-72 bg-white rounded-2xl border border-border shadow-xl z-50 p-4 fade-in">
                    <p className="font-bold text-sm text-foreground mb-3">Change Location</p>
                    <button onClick={detectLocation}
                      className="w-full flex items-center gap-2 px-3 py-2.5 rounded-xl border border-primary/30 bg-primary/5 text-primary text-sm font-medium mb-3 hover:bg-primary/10 transition-colors">
                      <MapPin size={14} /> Use Current Location
                    </button>
                    <div className="flex items-center gap-2 mb-1">
                      <div className="flex-1 h-px bg-border" />
                      <span className="text-xs text-muted-foreground">or enter PIN code</span>
                      <div className="flex-1 h-px bg-border" />
                    </div>
                    <div className="flex gap-2 mt-3">
                      <input type="text" value={pinInput} onChange={e => { setPinInput(e.target.value.replace(/\D/g, '').slice(0, 6)); setPinError(''); }}
                        placeholder="Enter 6-digit PIN" maxLength={6}
                        className="flex-1 px-3 py-2 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary" />
                      <button onClick={handlePinSubmit}
                        className="px-4 py-2 gradient-green text-white rounded-xl text-sm font-semibold shadow-green">
                        <Pin size={14} />
                      </button>
                    </div>
                    {pinError && <p className="text-xs text-danger mt-1.5">{pinError}</p>}
                    <p className="text-xs text-muted-foreground mt-2">We use your location to show available services in your area.</p>
                  </div>
                )}
              </div>

              {/* Login */}
              <Link href="/login"
                className="hidden md:flex items-center gap-1.5 px-3 py-2 rounded-lg border border-border hover:bg-muted transition-colors text-sm font-medium text-foreground">
                <LogIn size={14} />
                <span>Login</span>
              </Link>

              {/* Wishlist */}
              <button className="hidden lg:flex w-9 h-9 items-center justify-center rounded-lg hover:bg-muted transition-colors text-muted-foreground hover:text-foreground">
                <Heart size={18} />
              </button>

              {/* Cart */}
              <button className="hidden lg:flex w-9 h-9 items-center justify-center rounded-lg hover:bg-muted transition-colors text-muted-foreground hover:text-foreground relative">
                <ShoppingCart size={18} />
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-primary rounded-full"></span>
              </button>

              {/* Panel Links */}
              <div className="hidden lg:flex items-center gap-1 border-l border-border pl-2 ml-1">
                <Link href="/admin" className="text-xs font-semibold text-muted-foreground hover:text-primary px-2 py-1 rounded-lg hover:bg-primary/5 transition-colors">Admin</Link>
                <Link href="/partner" className="text-xs font-semibold text-muted-foreground hover:text-purple-600 px-2 py-1 rounded-lg hover:bg-purple-50 transition-colors">Partner</Link>
                <Link href="/delivery" className="text-xs font-semibold text-muted-foreground hover:text-blue-600 px-2 py-1 rounded-lg hover:bg-blue-50 transition-colors">Delivery</Link>
              </div>

              {/* CTA */}
              <Link href="/sell-device-get-quote"
                className="flex items-center gap-2 px-4 py-2 gradient-green text-white rounded-xl text-sm font-semibold shadow-green btn-press whitespace-nowrap">
                <Zap size={14} />
                <span className="hidden sm:inline">Get Instant Quote</span>
                <span className="sm:hidden">Quote</span>
              </Link>

              {/* Hamburger */}
              <button onClick={() => setMobileOpen(!mobileOpen)}
                className="xl:hidden w-9 h-9 flex items-center justify-center rounded-lg hover:bg-muted transition-colors" aria-label="Menu">
                {mobileOpen ? <X size={20} /> : <Menu size={20} />}
              </button>
            </div>
          </div>
        </div>

        {/* Mobile nav drawer */}
        {mobileOpen && (
          <div className="xl:hidden border-t border-border bg-white fade-in">
            <nav className="max-w-screen-2xl mx-auto px-4 py-3 flex flex-col gap-1">
              {navItems.map((item) => (
                <Link key={`mobile-nav-${item.label}`} href={item.href} onClick={() => setMobileOpen(false)}
                  className="text-sm font-medium text-foreground px-3 py-2.5 rounded-lg hover:bg-muted transition-colors">
                  {item.label}
                </Link>
              ))}
              {/* Mobile search */}
              <div className="border-t border-border mt-2 pt-3">
                <div className="relative">
                  <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
                  <input type="text" value={searchQuery} onChange={e => handleSearch(e.target.value)}
                    placeholder="Search device..." className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                </div>
                {showResults && searchResults.length > 0 && (
                  <div className="mt-2 bg-white rounded-xl border border-border shadow-sm overflow-hidden">
                    {searchResults.slice(0, 5).map(r => (
                      <Link key={r.id} href={r.href} onClick={() => setMobileOpen(false)}
                        className="flex items-center gap-3 px-3 py-2.5 hover:bg-muted text-sm border-b border-border last:border-0">
                        {r.image && <img src={r.image} alt={r.name} className="w-7 h-7 rounded-lg object-cover" />}
                        <span className="font-medium text-foreground">{r.name}</span>
                      </Link>
                    ))}
                  </div>
                )}
              </div>
              <div className="flex gap-2 mt-1">
                <Link href="/login" onClick={() => setMobileOpen(false)}
                  className="flex-1 text-center px-3 py-2 rounded-lg border border-border text-sm font-medium flex items-center justify-center gap-1.5">
                  <LogIn size={14} /> Login / Sign Up
                </Link>
              </div>
            </nav>
          </div>
        )}
      </header>
      {/* Spacer */}
      <div className="h-16" />
    </>
  );
}
import React from 'react';
import Link from 'next/link';

import { MapPin, Phone, Mail } from 'lucide-react';
import Icon from '@/components/ui/AppIcon';


const FacebookIcon = ({ size = 15 }: { size?: number }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor">
    <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>
  </svg>
);

const TwitterIcon = ({ size = 15 }: { size?: number }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor">
    <path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"/>
  </svg>
);

const InstagramIcon = ({ size = 15 }: { size?: number }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
    <rect x="2" y="2" width="20" height="20" rx="5" ry="5"/>
    <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/>
    <line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/>
  </svg>
);

const YoutubeIcon = ({ size = 15 }: { size?: number }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor">
    <path d="M22.54 6.42a2.78 2.78 0 0 0-1.95-1.96C18.88 4 12 4 12 4s-6.88 0-8.59.46a2.78 2.78 0 0 0-1.95 1.96A29 29 0 0 0 1 12a29 29 0 0 0 .46 5.58A2.78 2.78 0 0 0 3.41 19.6C5.12 20 12 20 12 20s6.88 0 8.59-.46a2.78 2.78 0 0 0 1.95-1.95A29 29 0 0 0 23 12a29 29 0 0 0-.46-5.58z"/>
    <polygon points="9.75 15.02 15.5 12 9.75 8.98 9.75 15.02" fill="white"/>
  </svg>
);

const LinkedinIcon = ({ size = 15 }: { size?: number }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor">
    <path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/>
    <rect x="2" y="9" width="4" height="12"/>
    <circle cx="4" cy="4" r="2"/>
  </svg>
);

const footerLinks = {
  'Services': [
    { label: 'Sell Device', href: '/sell-device-get-quote' },
    { label: 'Buy Refurbished', href: '/buy-refurbished' },
    { label: 'Exchange Device', href: '/exchange-device' },
    { label: 'Repair Services', href: '/repair-device' },
    { label: 'Bulk Deals', href: '#bulk' },
  ],
  'Company': [
    { label: 'About Us', href: '#about' },
    { label: 'How It Works', href: '#how-it-works' },
    { label: 'Careers', href: '#careers' },
    { label: 'Blog', href: '#blog' },
    { label: 'Press', href: '#press' },
  ],
  'Support': [
    { label: 'Help Center', href: '#help' },
    { label: 'Contact Us', href: '#contact' },
    { label: 'Track Order', href: '#track' },
    { label: 'Partner Portal', href: '/partner' },
    { label: 'Become a Partner', href: '#become-partner' },
  ],
  'Legal': [
    { label: 'Terms of Service', href: '#terms' },
    { label: 'Privacy Policy', href: '#privacy' },
    { label: 'Refund Policy', href: '#refund' },
    { label: 'Warranty Policy', href: '#warranty' },
    { label: 'Cookie Policy', href: '#cookies' },
  ],
};

const socialLinks = [
  { name: 'Facebook', href: 'https://facebook.com/casmik', Icon: FacebookIcon },
  { name: 'Twitter', href: 'https://twitter.com/casmik', Icon: TwitterIcon },
  { name: 'Instagram', href: 'https://instagram.com/casmik', Icon: InstagramIcon },
  { name: 'Youtube', href: 'https://youtube.com/casmik', Icon: YoutubeIcon },
  { name: 'LinkedIn', href: 'https://linkedin.com/company/casmik', Icon: LinkedinIcon },
];

export default function CustomerFooter() {
  return (
    <footer className="bg-secondary text-white">
      <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10 pt-16 pb-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-8 mb-12">
          {/* Brand */}
          <div className="lg:col-span-2">
            <div className="flex items-center gap-2 mb-4">
              <div className="w-9 h-9 rounded-xl gradient-green flex items-center justify-center">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                  <path d="M12 2L3 7v5c0 5.25 3.75 10.15 9 11.35C17.25 22.15 21 17.25 21 12V7L12 2z" fill="white" fillOpacity="0.9"/>
                  <path d="M9 12l2 2 4-4" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </div>
              <span className="font-extrabold text-xl text-white">Casmik</span>
            </div>
            <p className="text-sm text-slate-400 leading-relaxed mb-5">
              India&apos;s most trusted device lifecycle platform. Sell, buy, exchange or repair your devices with full transparency and instant payment.
            </p>
            <div className="flex flex-col gap-2 text-sm text-slate-400 mb-5">
              <div className="flex items-center gap-2">
                <MapPin size={14} className="text-primary flex-shrink-0" />
                <span>Casmik Technologies Pvt. Ltd., Bengaluru, Karnataka 560001</span>
              </div>
              <div className="flex items-center gap-2">
                <Phone size={14} className="text-primary flex-shrink-0" />
                <a href="tel:+919876543210" className="hover:text-white transition-colors">+91 98765 43210</a>
              </div>
              <div className="flex items-center gap-2">
                <Mail size={14} className="text-primary flex-shrink-0" />
                <a href="mailto:support@casmik.in" className="hover:text-white transition-colors">support@casmik.in</a>
              </div>
            </div>
            {/* Social links */}
            <div className="flex items-center gap-2">
              {socialLinks?.map(({ name, href, Icon }) => (
                <a key={name} href={href} target="_blank" rel="noopener noreferrer" aria-label={name}
                  className="w-9 h-9 rounded-lg bg-white/10 hover:bg-primary flex items-center justify-center transition-colors duration-150">
                  <Icon size={15} />
                </a>
              ))}
            </div>
          </div>

          {/* Link groups */}
          {Object.entries(footerLinks)?.map(([group, links]) => (
            <div key={`footer-group-${group}`}>
              <h4 className="font-semibold text-white text-sm mb-4 uppercase tracking-wide">{group}</h4>
              <ul className="flex flex-col gap-2">
                {links?.map(link => (
                  <li key={`footer-link-${link?.label}`}>
                    <Link href={link?.href} className="text-sm text-slate-400 hover:text-primary transition-colors duration-150">
                      {link?.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        {/* Newsletter */}
        <div className="border-t border-white/10 pt-8 pb-6">
          <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <div>
              <p className="font-semibold text-white mb-1">Stay updated with Casmik</p>
              <p className="text-sm text-slate-400">Get the latest deals, offers and device news.</p>
            </div>
            <div className="flex gap-2 w-full md:w-auto">
              <input type="email" placeholder="Enter your email" className="flex-1 md:w-64 px-4 py-2.5 rounded-xl bg-white/10 border border-white/20 text-sm text-white placeholder:text-slate-400 focus:outline-none focus:border-primary transition-colors" />
              <button className="px-5 py-2.5 gradient-green text-white rounded-xl text-sm font-semibold shadow-green btn-press whitespace-nowrap">Subscribe</button>
            </div>
          </div>
        </div>

        {/* App download */}
        <div className="border-t border-white/10 pt-6 pb-6">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <p className="text-sm text-slate-400">Download the Casmik app for a better experience</p>
            <div className="flex gap-3">
              <a href="#" className="flex items-center gap-2 px-4 py-2 bg-white/10 hover:bg-white/20 rounded-xl transition-colors">
                <span className="text-lg">🍎</span>
                <div>
                  <p className="text-xs text-slate-400 leading-none">Download on the</p>
                  <p className="text-sm font-semibold text-white leading-tight">App Store</p>
                </div>
              </a>
              <a href="#" className="flex items-center gap-2 px-4 py-2 bg-white/10 hover:bg-white/20 rounded-xl transition-colors">
                <span className="text-lg">▶️</span>
                <div>
                  <p className="text-xs text-slate-400 leading-none">Get it on</p>
                  <p className="text-sm font-semibold text-white leading-tight">Google Play</p>
                </div>
              </a>
            </div>
          </div>
        </div>

        {/* Bottom bar */}
        <div className="border-t border-white/10 pt-6 flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-sm text-slate-500">© 2026 Casmik Technologies Pvt. Ltd. All rights reserved.</p>
          <div className="flex items-center gap-6 text-xs text-slate-500">
            <span className="flex items-center gap-1.5"><span className="w-2 h-2 rounded-full bg-primary"></span>ISO 27001 Certified</span>
            <span className="flex items-center gap-1.5"><span className="w-2 h-2 rounded-full bg-primary"></span>100% Secure Transactions</span>
            <span className="flex items-center gap-1.5"><span className="w-2 h-2 rounded-full bg-primary"></span>Rated 4.9/5 on Google</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
'use client';
import React, { useState, useMemo } from 'react';
import { 
  ChevronDown, 
  HelpCircle, 
  Sparkles, 
  PhoneCall, 
  Search, 
  X, 
  MessageCircle, 
  Camera, 
  ArrowRight,
  ShieldCheck,
  CheckCircle2
} from 'lucide-react';
import Link from 'next/link';

interface FAQ {
  id: string;
  category: 'Valuation & Pricing' | 'Doorstep Inspection' | 'Payment & Safety' | 'Lenses & Gear';
  question: string;
  answer: string;
  badge: string;
}

const faqs: FAQ[] = [
  {
    id: 'faq-1',
    category: 'Valuation & Pricing',
    badge: 'AI Price Engine',
    question: 'How is the price of my camera or lens calculated on Camsik?',
    answer: 'Our proprietary valuation engine analyzes live secondary camera market demand across India, sensor resolution, mechanical shutter count actuations, body cosmetics (scratches, scuffs, grip rubber condition), autofocus calibration, and included original accessories (OEM charger, battery, neck strap, lens hood) to calculate the highest guaranteed payout.',
  },
  {
    id: 'faq-2',
    category: 'Valuation & Pricing',
    badge: 'KYC & Paperwork',
    question: 'Do I need the original box and invoice to sell my camera?',
    answer: 'No! An original bill and retail packaging are not mandatory. Having them will fetch you a slightly higher valuation, but you can always sell your camera or lens with just a valid government photo ID proof (Aadhaar Card, Driving License, or Voter ID) for standard KYC transfer.',
  },
  {
    id: 'faq-3',
    category: 'Doorstep Inspection',
    badge: 'Automated Diagnostics',
    question: 'How does the doorstep inspection and shutter count verification work?',
    answer: 'Our certified camera evaluation specialist visits your home or photography studio at your selected time slot. They connect the camera to diagnostic software to read the exact mechanical shutter count from the EXIF buffer, test sensor cleanlines at f/22, verify autofocus motors, and check optical glass for fungus or haze in under 15 minutes right before your eyes.',
  },
  {
    id: 'faq-4',
    category: 'Payment & Safety',
    badge: 'Instant Transfer',
    question: 'When and how will I receive payment for my camera?',
    answer: 'Payment is initiated on the spot before our technician leaves your doorstep. You can choose Instant UPI (Google Pay, PhonePe, Paytm) or direct IMPS bank transfer. We only pack and collect your camera after you verify receipt of funds in your account.',
  },
  {
    id: 'faq-5',
    category: 'Lenses & Gear',
    badge: 'Independent Liquidation',
    question: 'Can I sell individual lenses, gimbals, or action cameras without a camera body?',
    answer: 'Yes, absolutely! Camsik purchases prime lenses, zoom lenses, cinema glass, 3-axis motorized gimbals (DJI Ronin, Zhiyun), action cameras (GoPro, Insta360, DJI Action), and studio lighting gear individually without requiring a camera body.',
  },
  {
    id: 'faq-6',
    category: 'Lenses & Gear',
    badge: 'Optical Grading',
    question: 'What if my lens has minor dust or minor fungus inside the element?',
    answer: 'You can still sell it! During the valuation questions on Camsik, simply select the option for minor optical imperfections. Our algorithm will adjust the price transparently based on the optical restoration cost rather than rejecting your gear.',
  },
  {
    id: 'faq-7',
    category: 'Payment & Safety',
    badge: '100% Free Doorstep',
    question: 'Are there any pickup charges or cancellation fees if I decline the quote?',
    answer: 'Zero pickup charges! Doorstep evaluation is 100% free across 200+ cities in India. If the final on-site quote does not meet your expectations for any reason, you are free to cancel without paying a single rupee.',
  },
  {
    id: 'faq-8',
    category: 'Doorstep Inspection',
    badge: 'Studio & Bulk Trade-In',
    question: 'Do you buy bulk camera gear from wedding studios or rental houses?',
    answer: 'Yes! We have a dedicated Camsik Pro Studio Liquidation team that handles bulk sales of 5+ cameras, cine kits, lighting, and heavy lenses with custom valuation and single-day consolidated bank settlement.',
  },
  {
    id: 'faq-9',
    category: 'Payment & Safety',
    badge: 'Privacy & Data Protection',
    question: 'How is my private data and photos protected before camera resale?',
    answer: 'Every camera undergoes our certified factory buffer wipe process. Internal buffers, saved camera profiles, WiFi credentials, and EXIF storage are scrubbed to military standards. A legal bill of sale and liability release certificate is issued immediately.',
  },
  {
    id: 'faq-10',
    category: 'Valuation & Pricing',
    badge: '7-Day Guarantee',
    question: 'How long is the online camera price quote valid?',
    answer: 'Once you generate an instant price quote on Camsik, your valuation is locked for 7 days. You have full flexibility to schedule your free doorstep pickup at any date and time slot within that window without worrying about price drops.',
  },
];

const categories = [
  'All Questions',
  'Valuation & Pricing',
  'Doorstep Inspection',
  'Payment & Safety',
  'Lenses & Gear',
] as const;

type CategoryTab = typeof categories[number];

export default function CamsikFaqSection() {
  // Store set of open FAQ ids for independent accordion toggling
  const [openIds, setOpenIds] = useState<Set<string>>(new Set(['faq-1']));
  const [activeCategory, setActiveCategory] = useState<CategoryTab>('All Questions');
  const [searchQuery, setSearchQuery] = useState('');

  const toggleAccordion = (id: string) => {
    setOpenIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return next;
    });
  };

  const filteredFaqs = useMemo(() => {
    return faqs.filter((faq) => {
      const matchesCategory =
        activeCategory === 'All Questions' || faq.category === activeCategory;
      const matchesSearch =
        searchQuery.trim() === '' ||
        faq.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
        faq.answer.toLowerCase().includes(searchQuery.toLowerCase()) ||
        faq.category.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    });
  }, [activeCategory, searchQuery]);

  return (
    <section id="faq" className="py-16 lg:py-24 bg-surface border-t border-border/80 w-full overflow-hidden">
      <div className="w-full max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
        
        {/* Section Header */}
        <div className="text-center max-w-4xl mx-auto mb-10 sm:mb-12">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-3">
            <Sparkles size={13} />
            Got Questions? We&apos;ve Got Answers
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-foreground tracking-tight">
            Frequently Asked Questions
          </h2>
          <p className="text-muted-foreground mt-3 text-sm sm:text-base lg:text-lg max-w-2xl mx-auto">
            Everything you need to know about selling, upgrading, or evaluating your camera equipment safely on Camsik.
          </p>
        </div>

        {/* Filter Tabs & Search Bar — Full Width Row */}
        <div className="w-full flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8 sm:mb-10">
          
          {/* Category Filter Pills */}
          <div className="flex items-center gap-2 overflow-x-auto pb-2 md:pb-0 scrollbar-none w-full md:w-auto">
            {categories.map((cat) => {
              const isActive = activeCategory === cat;
              return (
                <button
                  key={cat}
                  onClick={() => setActiveCategory(cat)}
                  className={`px-4 py-2.5 rounded-2xl text-xs sm:text-sm font-bold whitespace-nowrap transition-all duration-200 btn-press ${
                    isActive
                      ? 'gradient-green text-white shadow-green ring-2 ring-primary/20'
                      : 'bg-white border border-border text-muted-foreground hover:text-foreground hover:border-primary/40 shadow-sm'
                  }`}
                >
                  {cat}
                </button>
              );
            })}
          </div>

          {/* Search Box */}
          <div className="relative w-full md:w-80 lg:w-96 shrink-0">
            <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <input
              type="text"
              placeholder="Search questions, e.g. shutter count, box, UPI..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-9 py-2.5 bg-white border border-border rounded-2xl text-xs sm:text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary shadow-sm transition-all"
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery('')}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                aria-label="Clear search"
              >
                <X size={15} />
              </button>
            )}
          </div>
        </div>

        {/* Full-Width Responsive 2-Column Grid of Accordion Cards */}
        {filteredFaqs.length === 0 ? (
          <div className="w-full bg-white rounded-3xl border border-border p-12 text-center my-8">
            <div className="w-14 h-14 rounded-2xl bg-primary/10 text-primary flex items-center justify-center mx-auto mb-4">
              <Search size={26} />
            </div>
            <h3 className="font-bold text-lg text-foreground mb-1">No matching questions found</h3>
            <p className="text-sm text-muted-foreground mb-5">
              Try searching with another keyword or browse by category.
            </p>
            <button
              onClick={() => {
                setSearchQuery('');
                setActiveCategory('All Questions');
              }}
              className="px-5 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-xs font-bold text-foreground transition-colors"
            >
              Reset Filters
            </button>
          </div>
        ) : (
          <div className="w-full grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6 items-start">
            {filteredFaqs.map((faq) => {
              const isOpen = openIds.has(faq.id);
              return (
                <div
                  key={faq.id}
                  className={`w-full bg-white rounded-2xl sm:rounded-3xl border transition-all duration-200 overflow-hidden shadow-sm hover:shadow-md ${
                    isOpen
                      ? 'border-primary/50 shadow-md ring-1 ring-primary/10'
                      : 'border-border/80 hover:border-primary/40'
                  }`}
                >
                  <button
                    onClick={() => toggleAccordion(faq.id)}
                    className="w-full text-left p-5 sm:p-6 flex items-start justify-between gap-4 transition-colors group"
                    aria-expanded={isOpen}
                  >
                    <div className="flex-1 pr-2">
                      <div className="flex items-center gap-2 mb-2 flex-wrap">
                        <span className="text-[11px] font-bold px-2.5 py-0.5 rounded-full bg-primary/10 text-primary">
                          {faq.category}
                        </span>
                        <span className="text-[11px] font-semibold text-muted-foreground bg-slate-100 px-2 py-0.5 rounded-md">
                          {faq.badge}
                        </span>
                      </div>
                      <h3 className="font-extrabold text-base sm:text-lg text-foreground group-hover:text-primary transition-colors leading-snug">
                        {faq.question}
                      </h3>
                    </div>

                    <div
                      className={`w-9 h-9 rounded-xl flex items-center justify-center shrink-0 transition-all duration-300 mt-1 ${
                        isOpen
                          ? 'rotate-180 bg-primary text-white shadow-sm'
                          : 'bg-slate-100 text-slate-600 group-hover:bg-primary/10 group-hover:text-primary'
                      }`}
                    >
                      <ChevronDown size={18} />
                    </div>
                  </button>

                  {isOpen && (
                    <div className="px-5 pb-6 sm:px-6 pt-0 text-sm sm:text-base text-muted-foreground leading-relaxed animate-fade-in">
                      <div className="pt-3 border-t border-border/60">
                        <p>{faq.answer}</p>
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}

        {/* Full-Width Bottom Help & Support Banner */}
        <div className="mt-12 sm:mt-16 w-full rounded-3xl bg-gradient-to-r from-slate-900 via-slate-800 to-slate-900 text-white p-6 sm:p-8 lg:p-10 shadow-xl border border-slate-700/60 relative overflow-hidden">
          {/* Subtle glow decorative shapes */}
          <div className="absolute top-0 right-1/4 w-80 h-80 bg-primary/20 rounded-full blur-3xl pointer-events-none" />
          <div className="absolute bottom-0 right-10 w-60 h-60 bg-emerald-500/15 rounded-full blur-3xl pointer-events-none" />

          <div className="relative z-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
            <div className="max-w-2xl">
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-slate-800 text-emerald-400 text-xs font-bold uppercase tracking-wider mb-3 border border-slate-700">
                <CheckCircle2 size={13} />
                Dedicated Camera Resale Support
              </div>
              <h3 className="text-2xl sm:text-3xl font-black text-white tracking-tight">
                Still have questions about your specific camera model?
              </h3>
              <p className="text-slate-300 text-sm sm:text-base mt-2 leading-relaxed">
                Our camera specialists and optical technicians are available 7 days a week to answer condition queries, explain shutter count readings, or assist with studio kit liquidations.
              </p>
            </div>

            <div className="flex flex-wrap items-center gap-3 shrink-0">
              <a
                href="tel:1800226745"
                className="inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-white/10 hover:bg-white/20 text-white border border-white/20 font-bold text-xs sm:text-sm backdrop-blur-sm transition-all"
              >
                <PhoneCall size={16} className="text-emerald-400" />
                Toll Free: 1800-CAMSIK
              </a>
              <a
                href="https://wa.me/919845012345?text=Hi%20Camsik%20team,%20I%20have%20a%20question%20about%20selling%20my%20camera"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-5 py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs sm:text-sm shadow-md transition-all"
              >
                <MessageCircle size={16} />
                WhatsApp Live
              </a>
              <Link
                href="/sell-device-get-quote"
                className="inline-flex items-center gap-2 px-6 py-3 rounded-2xl gradient-green text-white font-extrabold text-xs sm:text-sm shadow-green hover:shadow-lg transition-all btn-press"
              >
                <Camera size={16} />
                Get Exact Price Now <ArrowRight size={15} />
              </Link>
            </div>
          </div>
        </div>

      </div>
    </section>
  );
}

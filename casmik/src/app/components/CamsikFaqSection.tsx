'use client';
import React, { useState } from 'react';
import { ChevronDown, HelpCircle, Sparkles, PhoneCall, Mail } from 'lucide-react';
import Link from 'next/link';

interface FAQ {
  id: string;
  question: string;
  answer: string;
  category: string;
}

const faqs: FAQ[] = [
  {
    id: 'faq-1',
    category: 'Valuation & Pricing',
    question: 'How is the price of my camera or lens calculated on Camsik?',
    answer: 'Our valuation engine uses live market demand data, current sensor grade, body cosmetics (scratches, scuffs, grip condition), mechanical shutter count, autofocus accuracy, and included accessories (original charger, battery, neck strap, lens hood) to calculate the highest guaranteed market payout.',
  },
  {
    id: 'faq-2',
    category: 'Documentation',
    question: 'Do I need the original box and invoice to sell my camera?',
    answer: 'No! An original bill and box are not mandatory. Having them will fetch you a slightly higher valuation, but you can still sell your camera or lens with just a valid government ID proof (Aadhaar Card, Driving License, or Voter ID) for KYC verification.',
  },
  {
    id: 'faq-3',
    category: 'Doorstep Process',
    question: 'How does the doorstep inspection and shutter count verification work?',
    answer: 'Our trained camera specialist visits your home or studio at your chosen time slot. They connect the camera to diagnostic software to read the exact mechanical shutter count from the camera EXIF buffer, test sensor cleanlines at f/22, verify autofocus motors, and check the lens glass for scratches, fungus, or haze in under 15 minutes.',
  },
  {
    id: 'faq-4',
    category: 'Payment',
    question: 'When and how will I receive payment for my camera?',
    answer: 'Payment is made immediately on the spot before the technician leaves your doorstep. You can choose Instant UPI (Google Pay, PhonePe, Paytm) or direct IMPS/NEFT bank transfer. We only collect the camera after you confirm receipt of funds in your account.',
  },
  {
    id: 'faq-5',
    category: 'Accessories & Optics',
    question: 'Can I sell individual lenses, gimbals, or action cameras without a camera body?',
    answer: 'Yes, absolutely! Camsik buys prime lenses, zoom lenses, cinema lenses, 3-axis gimbals (DJI Ronin, Zhiyun), action cameras (GoPro, Insta360, DJI Action), and studio accessories individually without requiring a camera body.',
  },
  {
    id: 'faq-6',
    category: 'Gear Condition',
    question: 'What if my lens has minor dust or minor fungus inside the element?',
    answer: 'You can still sell it! During the valuation questions on Camsik, simply select the option for minor optical imperfections. Our algorithm will adjust the price transparently based on the optical restoration cost rather than rejecting your gear.',
  },
  {
    id: 'faq-7',
    category: 'Safety & Fees',
    question: 'Are there any pickup charges or cancellation fees if I decline the quote?',
    answer: 'Zero pickup charges! Doorstep evaluation is 100% free across 200+ cities in India. If the final on-site quote does not meet your expectations for any reason, you are free to cancel without paying a single rupee.',
  },
  {
    id: 'faq-8',
    category: 'Bulk Liquidation',
    question: 'Do you buy bulk camera gear from wedding studios or rental houses?',
    answer: 'Yes! We have a dedicated Camsik Pro Studio Liquidation team that handles bulk sales of 5+ cameras, cine kits, lighting, and heavy lenses with custom valuation and single-day consolidated bank settlement.',
  },
];

export default function CamsikFaqSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  const toggleAccordion = (index: number) => {
    setOpenIndex((prev) => (prev === index ? null : index));
  };

  return (
    <section className="py-16 lg:py-24 bg-surface border-t border-border/80">
      <div className="max-w-screen-xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-14">
          <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-3">
            <Sparkles size={13} />
            Got Questions? We&apos;ve Got Answers
          </div>
          <h2 className="text-3xl sm:text-4xl font-black text-foreground tracking-tight">
            Frequently Asked Questions
          </h2>
          <p className="text-muted-foreground mt-3 text-sm sm:text-base">
            Everything you need to know about selling your camera gear safely on Camsik.
          </p>
        </div>

        {/* Accordion Container */}
        <div className="space-y-4 max-w-3xl mx-auto">
          {faqs.map((faq, idx) => {
            const isOpen = openIndex === idx;
            return (
              <div
                key={faq.id}
                className="bg-white rounded-2xl border border-border/80 overflow-hidden transition-all duration-200 hover:border-primary/40 shadow-sm"
              >
                <button
                  onClick={() => toggleAccordion(idx)}
                  className="w-full text-left p-5 sm:p-6 flex items-center justify-between gap-4 transition-colors"
                  aria-expanded={isOpen}
                >
                  <span className="font-extrabold text-base sm:text-lg text-foreground">
                    {faq.question}
                  </span>
                  <div className={`w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center shrink-0 text-foreground transition-transform duration-300 ${isOpen ? 'rotate-180 bg-primary text-white' : ''}`}>
                    <ChevronDown size={18} />
                  </div>
                </button>

                {isOpen && (
                  <div className="px-5 pb-6 sm:px-6 pt-0 text-sm sm:text-base text-muted-foreground leading-relaxed animate-fade-in">
                    <p className="pt-2 border-t border-border/40">
                      {faq.answer}
                    </p>
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* Support Callout */}
        <div className="mt-14 p-6 rounded-3xl bg-white border border-border/80 max-w-xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4 shadow-sm text-center sm:text-left">
          <div className="flex items-center gap-3.5">
            <div className="w-11 h-11 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shrink-0">
              <HelpCircle size={24} />
            </div>
            <div>
              <h4 className="font-bold text-sm text-foreground">Still have questions?</h4>
              <p className="text-xs text-muted-foreground">Our camera gear experts are available 24/7</p>
            </div>
          </div>
          <div className="flex items-center gap-3 shrink-0">
            <a
              href="tel:+919876543210"
              className="px-4 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-xs font-bold text-foreground transition-colors flex items-center gap-1.5"
            >
              <PhoneCall size={14} />
              Call Support
            </a>
            <Link
              href="/contact-us"
              className="px-4 py-2 rounded-xl gradient-green text-white text-xs font-bold shadow-green hover:shadow transition-colors"
            >
              Contact Us
            </Link>
          </div>
        </div>
      </div>
    </section>
  );
}

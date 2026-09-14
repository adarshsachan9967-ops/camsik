'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { 
  MapPin, 
  Phone, 
  Mail, 
  Send, 
  CheckCircle2, 
  Clock, 
  MessageCircle, 
  ChevronRight,
  ShieldCheck,
  Building2,
  Sparkles
} from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';

export default function ContactUsPage() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    company: '',
    message: '',
  });
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setSubmitted(true);
    }, 800);
  };

  return (
    <main className="min-h-screen bg-background flex flex-col justify-between">
      <CustomerHeader />

      {/* Main Content */}
      <section className="flex-1 py-10 lg:py-16">
        <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10">
          
          {/* Breadcrumbs */}
          <nav className="flex items-center gap-2 text-xs font-semibold text-muted-foreground mb-6">
            <Link href="/" className="hover:text-primary transition-colors">
              Home
            </Link>
            <ChevronRight size={13} />
            <span className="text-foreground font-bold">Contact</span>
          </nav>

          {/* Page Title */}
          <div className="mb-10">
            <h1 className="text-4xl sm:text-5xl font-black text-foreground tracking-tight">
              Contact
            </h1>
            <p className="text-muted-foreground mt-2 text-sm sm:text-base">
              Get in touch with the Camsik team for camera valuations, studio kit liquidations, or doorstep pickup assistance.
            </p>
          </div>

          {/* Two-Column Contact Layout matching camsik.com */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-start">
            
            {/* Left Column: Contact Details */}
            <div className="lg:col-span-5 bg-white rounded-3xl border border-border/80 p-6 sm:p-8 lg:p-10 shadow-sm">
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider mb-4">
                <Sparkles size={13} />
                Get in Touch
              </div>

              <h2 className="text-2xl sm:text-3xl font-black text-foreground tracking-tight mb-6">
                Contact Details
              </h2>

              <div className="space-y-6">
                {/* Address */}
                <div className="flex items-start gap-4 p-4 rounded-2xl bg-surface border border-border/60">
                  <div className="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center shrink-0 shadow-sm">
                    <MapPin size={22} />
                  </div>
                  <div>
                    <h3 className="text-xs font-black uppercase tracking-wider text-muted-foreground mb-1">
                      Official Registered Office
                    </h3>
                    <p className="text-sm sm:text-base font-bold text-foreground leading-snug">
                      A-315, Shanti Shopping Center, Near Mira Road Station
                    </p>
                    <p className="text-sm font-semibold text-slate-600 mt-0.5">
                      Mumbai, Maharashtra - 401107
                    </p>
                  </div>
                </div>

                {/* Phone */}
                <div className="flex items-start gap-4 p-4 rounded-2xl bg-surface border border-border/60">
                  <div className="w-12 h-12 rounded-2xl bg-emerald-500/10 text-emerald-600 flex items-center justify-center shrink-0 shadow-sm">
                    <Phone size={22} />
                  </div>
                  <div>
                    <h3 className="text-xs font-black uppercase tracking-wider text-muted-foreground mb-1">
                      Direct Support &amp; Valuation Hotline
                    </h3>
                    <a
                      href="tel:+918976000010"
                      className="text-base sm:text-lg font-black text-foreground hover:text-primary transition-colors block"
                    >
                      +91 8976000010
                    </a>
                    <p className="text-xs text-muted-foreground mt-0.5 flex items-center gap-1">
                      <Clock size={12} /> Monday – Sunday: 9:00 AM – 9:00 PM IST
                    </p>
                  </div>
                </div>

                {/* Email */}
                <div className="flex items-start gap-4 p-4 rounded-2xl bg-surface border border-border/60">
                  <div className="w-12 h-12 rounded-2xl bg-indigo-500/10 text-indigo-600 flex items-center justify-center shrink-0 shadow-sm">
                    <Mail size={22} />
                  </div>
                  <div>
                    <h3 className="text-xs font-black uppercase tracking-wider text-muted-foreground mb-1">
                      Official Inquiries &amp; Payout Verification
                    </h3>
                    <a
                      href="mailto:sellatcamsik@gmail.com"
                      className="text-base sm:text-lg font-black text-foreground hover:text-primary transition-colors block break-all"
                    >
                      sellatcamsik@gmail.com
                    </a>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      Average response time: under 30 minutes
                    </p>
                  </div>
                </div>
              </div>

              {/* Quick WhatsApp Action */}
              <div className="mt-8 pt-6 border-t border-border">
                <a
                  href="https://wa.me/918976000010?text=Hi%20Camsik%20team,%20I%20want%20to%20sell/trade-in%20my%20camera"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full py-3.5 px-5 rounded-2xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-sm shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2 btn-press"
                >
                  <MessageCircle size={18} />
                  Chat on WhatsApp (+91 8976000010)
                </a>
              </div>
            </div>

            {/* Right Column: Submit Your Message Form */}
            <div className="lg:col-span-7 bg-white rounded-3xl border border-border/80 p-6 sm:p-8 lg:p-10 shadow-sm">
              <div className="mb-6">
                <h2 className="text-2xl sm:text-3xl font-black text-foreground tracking-tight">
                  Submit your message
                </h2>
                <p className="text-sm text-muted-foreground mt-1">
                  Fill out the details below and a Camsik camera advisor will get back to you immediately.
                </p>
              </div>

              {submitted ? (
                <div className="p-8 rounded-2xl bg-emerald-50 border border-emerald-200 text-center animate-fade-in my-8">
                  <div className="w-16 h-16 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto mb-4">
                    <CheckCircle2 size={36} />
                  </div>
                  <h3 className="text-xl font-bold text-emerald-900 mb-2">Message Sent Successfully!</h3>
                  <p className="text-sm text-emerald-700 max-w-md mx-auto mb-6">
                    Thank you, <strong>{formData.name}</strong>. Your message has been routed to our Mumbai executive desk. We will call you at <strong>{formData.phone}</strong> shortly.
                  </p>
                  <button
                    onClick={() => {
                      setSubmitted(false);
                      setFormData({ name: '', email: '', phone: '', company: '', message: '' });
                    }}
                    className="px-6 py-2.5 rounded-xl gradient-green text-white font-bold text-xs uppercase tracking-wider shadow-green"
                  >
                    Send Another Inquiry
                  </button>
                </div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-4 sm:space-y-5">
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {/* Name */}
                    <div>
                      <label className="block text-xs font-bold text-foreground mb-1.5 uppercase tracking-wider">
                        Name <span className="text-rose-500">*</span>
                      </label>
                      <input
                        type="text"
                        required
                        placeholder="Your full name"
                        value={formData.name}
                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                        className="w-full px-4 py-3 rounded-2xl bg-surface border border-border text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all"
                      />
                    </div>

                    {/* Email */}
                    <div>
                      <label className="block text-xs font-bold text-foreground mb-1.5 uppercase tracking-wider">
                        Email <span className="text-rose-500">*</span>
                      </label>
                      <input
                        type="email"
                        required
                        placeholder="youremail@example.com"
                        value={formData.email}
                        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                        className="w-full px-4 py-3 rounded-2xl bg-surface border border-border text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {/* Phone */}
                    <div>
                      <label className="block text-xs font-bold text-foreground mb-1.5 uppercase tracking-wider">
                        Phone Number <span className="text-rose-500">*</span>
                      </label>
                      <input
                        type="tel"
                        required
                        placeholder="e.g. 9876000010"
                        value={formData.phone}
                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                        className="w-full px-4 py-3 rounded-2xl bg-surface border border-border text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all"
                      />
                    </div>

                    {/* Company */}
                    <div>
                      <label className="block text-xs font-bold text-foreground mb-1.5 uppercase tracking-wider">
                        Company / Studio Name (Optional)
                      </label>
                      <input
                        type="text"
                        placeholder="Photography studio / Production house"
                        value={formData.company}
                        onChange={(e) => setFormData({ ...formData, company: e.target.value })}
                        className="w-full px-4 py-3 rounded-2xl bg-surface border border-border text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all"
                      />
                    </div>
                  </div>

                  {/* Message */}
                  <div>
                    <label className="block text-xs font-bold text-foreground mb-1.5 uppercase tracking-wider">
                      Message <span className="text-rose-500">*</span>
                    </label>
                    <textarea
                      required
                      rows={5}
                      placeholder="Tell us about the camera body, lenses, or accessories you wish to sell or inquire about..."
                      value={formData.message}
                      onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                      className="w-full px-4 py-3 rounded-2xl bg-surface border border-border text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all resize-none"
                    />
                  </div>

                  {/* Submit Button */}
                  <div>
                    <button
                      type="submit"
                      disabled={loading}
                      className="px-8 py-3.5 rounded-2xl gradient-green text-white font-extrabold text-sm uppercase tracking-wider shadow-green hover:shadow-lg transition-all flex items-center justify-center gap-2 btn-press disabled:opacity-60"
                    >
                      {loading ? (
                        <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                      ) : (
                        <>
                          <Send size={15} /> Send Message
                        </>
                      )}
                    </button>
                  </div>
                </form>
              )}
            </div>
          </div>
        </div>
      </section>

      {/* Floating Call & WhatsApp Buttons */}
      <div className="fixed bottom-6 right-6 z-40 flex flex-col gap-3">
        <a
          href="https://wa.me/918976000010?text=Hi%20Camsik%20team,%20I%20have%20an%20inquiry"
          target="_blank"
          rel="noopener noreferrer"
          className="w-13 h-13 rounded-full bg-emerald-500 text-white shadow-xl flex items-center justify-center hover:scale-110 transition-transform ring-4 ring-emerald-500/20"
          aria-label="Chat on WhatsApp"
        >
          <MessageCircle size={26} />
        </a>
        <a
          href="tel:+918976000010"
          className="w-13 h-13 rounded-full bg-blue-600 text-white shadow-xl flex items-center justify-center hover:scale-110 transition-transform ring-4 ring-blue-600/20"
          aria-label="Call Camsik Support"
        >
          <Phone size={24} />
        </a>
      </div>

      <CustomerFooter />
    </main>
  );
}

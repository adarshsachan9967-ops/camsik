'use client';
import React, { useState } from 'react';
import { Star, Layout, Smartphone, Truck, Handshake, Plus, Edit2, Trash2, Save } from 'lucide-react';
import Icon from '@/components/ui/AppIcon';


type CMSSection = 'website' | 'app' | 'partner' | 'delivery';
type CMSModule = 'logo' | 'banners' | 'testimonials' | 'faqs' | 'hero' | 'stats' | 'why' | 'howItWorks' | 'footer';

const cmsModules: Record<CMSSection, {id: CMSModule;label: string;icon: string;description: string;}[]> = {
  website: [
  { id: 'logo', label: 'Logo & Branding', icon: '🎨', description: 'Upload logo, set brand colors and tagline' },
  { id: 'banners', label: 'Hero Banners', icon: '🖼️', description: 'Manage homepage hero banners and CTAs' },
  { id: 'hero', label: 'Hero Content', icon: '✨', description: 'Edit headline, subtext and hero section' },
  { id: 'stats', label: 'Trust Statistics', icon: '📊', description: 'Happy customers, devices sold, cities covered' },
  { id: 'why', label: 'Why Camsik', icon: '💡', description: 'Manage trust cards and feature highlights' },
  { id: 'howItWorks', label: 'How It Works', icon: '🔄', description: 'Edit step-by-step process sections' },
  { id: 'testimonials', label: 'Testimonials', icon: '⭐', description: 'Add, edit and manage customer reviews' },
  { id: 'faqs', label: 'FAQs', icon: '❓', description: 'Manage frequently asked questions' },
  { id: 'footer', label: 'Footer Content', icon: '📄', description: 'Links, social media, contact info' }],

  app: [
  { id: 'banners', label: 'App Banners', icon: '📱', description: 'Home screen banners and promotions' },
  { id: 'hero', label: 'Onboarding Screens', icon: '🚀', description: 'Edit onboarding content and images' },
  { id: 'why', label: 'App Features', icon: '⚡', description: 'Feature highlights shown in app' },
  { id: 'faqs', label: 'App FAQs', icon: '❓', description: 'In-app help and FAQ content' }],

  partner: [
  { id: 'logo', label: 'Partner Portal Logo', icon: '🏪', description: 'Logo shown in partner portal' },
  { id: 'banners', label: 'Partner Banners', icon: '🖼️', description: 'Dashboard banners for partners' },
  { id: 'faqs', label: 'Partner FAQs', icon: '❓', description: 'Help content for partners' },
  { id: 'hero', label: 'Welcome Message', icon: '👋', description: 'Dashboard welcome text for partners' }],

  delivery: [
  { id: 'logo', label: 'Delivery App Logo', icon: '🚚', description: 'Logo shown in delivery app' },
  { id: 'banners', label: 'Delivery Banners', icon: '🖼️', description: 'Banners for delivery agents' },
  { id: 'faqs', label: 'Delivery FAQs', icon: '❓', description: 'Help content for delivery agents' },
  { id: 'hero', label: 'Agent Welcome', icon: '👋', description: 'Welcome message for delivery agents' }]

};

const sampleFAQs = [
{ id: 1, q: 'How does Camsik calculate the price of my device?', a: 'We use a dynamic pricing engine based on device model, condition, and market demand.', active: true },
{ id: 2, q: 'How long does pickup take after booking?', a: 'Our partner will pick up your device within 24-48 hours of booking.', active: true },
{ id: 3, q: 'When will I receive payment for my sold device?', a: 'Payment is processed within 24 hours after final inspection and price confirmation.', active: true },
{ id: 4, q: 'What documents do I need for selling?', a: 'Just a valid ID proof. No other documents required for selling.', active: false }];


const sampleTestimonials = [
{ id: 1, name: 'Rahul Sharma', city: 'Bangalore', rating: 5, review: 'Got the best price for my iPhone 15 Pro. Process was super smooth!', service: 'Sell', active: true },
{ id: 2, name: 'Priya Patel', city: 'Mumbai', rating: 5, review: 'Bought a refurbished Samsung S24 Ultra. Works perfectly, great value!', service: 'Buy', active: true },
{ id: 3, name: 'Amit Singh', city: 'Delhi', rating: 4, review: 'Exchange process was transparent. Got a fair value for my old phone.', service: 'Exchange', active: true }];


const sampleBanners = [
{ id: 1, title: 'Sell Your iPhone', subtitle: 'Get up to ₹1,05,000', cta: 'Sell Now', active: true, image: 'https://img.rocket.new/generatedImages/rocket_gen_img_1ac872aa5-1772414311954.png' },
{ id: 2, title: 'Buy Refurbished', subtitle: 'Certified devices from ₹8,999', cta: 'Shop Now', active: true, image: "https://img.rocket.new/generatedImages/rocket_gen_img_1bc78f452-1769260761278.png" },
{ id: 3, title: 'Exchange & Save', subtitle: 'Pay only the difference', cta: 'Exchange Now', active: false, image: 'https://img.rocket.new/generatedImages/rocket_gen_img_105ddfb08-1773070438946.png' }];


export default function AdminCMS() {
  const [activePanel, setActivePanel] = useState<CMSSection>('website');
  const [activeModule, setActiveModule] = useState<CMSModule>('banners');
  const [faqs, setFaqs] = useState(sampleFAQs);
  const [testimonials, setTestimonials] = useState(sampleTestimonials);
  const [banners, setBanners] = useState(sampleBanners);
  const [editingFAQ, setEditingFAQ] = useState<typeof sampleFAQs[0] | null>(null);
  const [showAddFAQ, setShowAddFAQ] = useState(false);
  const [newFAQ, setNewFAQ] = useState({ q: '', a: '' });

  const panelIcons: Record<CMSSection, React.ElementType> = { website: Layout, app: Smartphone, partner: Handshake, delivery: Truck };

  const handleAddFAQ = () => {
    if (!newFAQ.q.trim()) return;
    setFaqs((prev) => [...prev, { id: Date.now(), q: newFAQ.q, a: newFAQ.a, active: true }]);
    setNewFAQ({ q: '', a: '' });
    setShowAddFAQ(false);
  };

  const handleDeleteFAQ = (id: number) => setFaqs((prev) => prev.filter((f) => f.id !== id));
  const handleToggleFAQ = (id: number) => setFaqs((prev) => prev.map((f) => f.id === id ? { ...f, active: !f.active } : f));
  const handleToggleBanner = (id: number) => setBanners((prev) => prev.map((b) => b.id === id ? { ...b, active: !b.active } : b));
  const handleToggleTestimonial = (id: number) => setTestimonials((prev) => prev.map((t) => t.id === id ? { ...t, active: !t.active } : t));

  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-xl font-black text-gray-900">CMS Management</h2>
        <p className="text-sm text-gray-500">Manage all content for website, app, partner portal and delivery app</p>
      </div>

      {/* Panel Selector */}
      <div className="grid grid-cols-4 gap-3">
        {(Object.keys(cmsModules) as CMSSection[]).map((panel) => {
          const Icon = panelIcons[panel];
          return (
            <button key={panel} onClick={() => {setActivePanel(panel);setActiveModule(cmsModules[panel][0].id);}}
            className={`flex items-center gap-2 p-3 rounded-2xl border-2 transition-all ${activePanel === panel ? 'border-primary bg-primary/5 text-primary' : 'border-gray-100 bg-white text-gray-600 hover:border-gray-200'}`}>
              <Icon size={18} />
              <span className="text-sm font-bold capitalize">{panel}</span>
            </button>);

        })}
      </div>

      <div className="flex gap-5">
        {/* Module List */}
        <div className="w-48 flex-shrink-0 space-y-1">
          {cmsModules[activePanel].map((mod) =>
          <button key={mod.id} onClick={() => setActiveModule(mod.id)}
          className={`w-full flex items-center gap-2 px-3 py-2.5 rounded-xl text-left transition-all ${activeModule === mod.id ? 'bg-primary text-white' : 'text-gray-600 hover:bg-gray-100'}`}>
              <span className="text-base">{mod.icon}</span>
              <span className="text-xs font-semibold truncate">{mod.label}</span>
            </button>
          )}
        </div>

        {/* Content Editor */}
        <div className="flex-1 bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
          {activeModule === 'banners' &&
          <div>
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-bold text-gray-900">Banners</h3>
                <button className="flex items-center gap-1.5 px-3 py-2 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary/90">
                  <Plus size={13} /> Add Banner
                </button>
              </div>
              <div className="space-y-3">
                {banners.map((b) =>
              <div key={b.id} className="flex items-center gap-4 p-3 bg-gray-50 rounded-xl border border-gray-100">
                    <img src={b.image} alt={b.title} className="w-16 h-12 rounded-lg object-cover flex-shrink-0" />
                    <div className="flex-1">
                      <p className="font-bold text-gray-900 text-sm">{b.title}</p>
                      <p className="text-xs text-gray-500">{b.subtitle} · CTA: {b.cta}</p>
                    </div>
                    <div className="flex items-center gap-2">
                      <button onClick={() => handleToggleBanner(b.id)}
                  className={`text-xs font-bold px-2 py-1 rounded-lg ${b.active ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'}`}>
                        {b.active ? 'Active' : 'Inactive'}
                      </button>
                      <button className="p-1.5 rounded-lg hover:bg-gray-200 text-gray-500"><Edit2 size={13} /></button>
                      <button className="p-1.5 rounded-lg hover:bg-red-50 text-gray-400 hover:text-red-500"><Trash2 size={13} /></button>
                    </div>
                  </div>
              )}
              </div>
            </div>
          }

          {activeModule === 'testimonials' &&
          <div>
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-bold text-gray-900">Testimonials</h3>
                <button className="flex items-center gap-1.5 px-3 py-2 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary/90">
                  <Plus size={13} /> Add Testimonial
                </button>
              </div>
              <div className="space-y-3">
                {testimonials.map((t) =>
              <div key={t.id} className="p-4 bg-gray-50 rounded-xl border border-gray-100">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <p className="font-bold text-gray-900 text-sm">{t.name}</p>
                          <span className="text-xs text-gray-400">· {t.city}</span>
                          <span className="text-xs bg-blue-50 text-blue-700 font-bold px-2 py-0.5 rounded-lg">{t.service}</span>
                        </div>
                        <div className="flex gap-0.5 mb-1">
                          {Array.from({ length: t.rating }).map((_, i) => <Star key={i} size={12} className="text-yellow-400 fill-yellow-400" />)}
                        </div>
                        <p className="text-xs text-gray-600">{t.review}</p>
                      </div>
                      <div className="flex items-center gap-2 ml-3">
                        <button onClick={() => handleToggleTestimonial(t.id)}
                    className={`text-xs font-bold px-2 py-1 rounded-lg ${t.active ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'}`}>
                          {t.active ? 'Active' : 'Hidden'}
                        </button>
                        <button className="p-1.5 rounded-lg hover:bg-gray-200 text-gray-500"><Edit2 size={13} /></button>
                        <button className="p-1.5 rounded-lg hover:bg-red-50 text-gray-400 hover:text-red-500"><Trash2 size={13} /></button>
                      </div>
                    </div>
                  </div>
              )}
              </div>
            </div>
          }

          {activeModule === 'faqs' &&
          <div>
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-bold text-gray-900">FAQs</h3>
                <button onClick={() => setShowAddFAQ(true)} className="flex items-center gap-1.5 px-3 py-2 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary/90">
                  <Plus size={13} /> Add FAQ
                </button>
              </div>
              {showAddFAQ &&
            <div className="bg-gray-50 rounded-xl p-4 border border-gray-200 mb-4">
                  <h4 className="text-sm font-bold text-gray-900 mb-3">New FAQ</h4>
                  <div className="space-y-3">
                    <input value={newFAQ.q} onChange={(e) => setNewFAQ((p) => ({ ...p, q: e.target.value }))}
                placeholder="Question..." className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                    <textarea value={newFAQ.a} onChange={(e) => setNewFAQ((p) => ({ ...p, a: e.target.value }))}
                placeholder="Answer..." rows={3} className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 resize-none" />
                    <div className="flex gap-2">
                      <button onClick={() => setShowAddFAQ(false)} className="flex-1 py-2 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600">Cancel</button>
                      <button onClick={handleAddFAQ} disabled={!newFAQ.q.trim()} className="flex-1 py-2 rounded-xl bg-primary text-white text-sm font-semibold hover:bg-primary/90 disabled:opacity-50">Add FAQ</button>
                    </div>
                  </div>
                </div>
            }
              <div className="space-y-3">
                {faqs.map((faq) =>
              <div key={faq.id} className="p-4 bg-gray-50 rounded-xl border border-gray-100">
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex-1">
                        <p className="font-bold text-gray-900 text-sm mb-1">{faq.q}</p>
                        <p className="text-xs text-gray-500">{faq.a}</p>
                      </div>
                      <div className="flex items-center gap-2 flex-shrink-0">
                        <button onClick={() => handleToggleFAQ(faq.id)}
                    className={`text-xs font-bold px-2 py-1 rounded-lg ${faq.active ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'}`}>
                          {faq.active ? 'Active' : 'Hidden'}
                        </button>
                        <button className="p-1.5 rounded-lg hover:bg-gray-200 text-gray-500"><Edit2 size={13} /></button>
                        <button onClick={() => handleDeleteFAQ(faq.id)} className="p-1.5 rounded-lg hover:bg-red-50 text-gray-400 hover:text-red-500"><Trash2 size={13} /></button>
                      </div>
                    </div>
                  </div>
              )}
              </div>
            </div>
          }

          {activeModule === 'logo' &&
          <div className="space-y-5">
              <h3 className="font-bold text-gray-900">Logo & Branding</h3>
              <div className="grid grid-cols-2 gap-4">
                <div className="bg-gray-50 rounded-xl p-4 border border-dashed border-gray-300 text-center cursor-pointer hover:border-primary transition-colors">
                  <div className="w-12 h-12 bg-primary rounded-xl flex items-center justify-center mx-auto mb-2">
                    <span className="text-white font-black text-xl">C</span>
                  </div>
                  <p className="text-sm font-bold text-gray-700">Current Logo</p>
                  <button className="mt-2 text-xs text-primary font-bold hover:underline">Change Logo</button>
                </div>
                <div className="space-y-3">
                  <div>
                    <label className="text-xs font-bold text-gray-600 mb-1 block">Brand Name</label>
                    <input defaultValue="CAMSIK" className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                  </div>
                  <div>
                    <label className="text-xs font-bold text-gray-600 mb-1 block">Tagline</label>
                    <input defaultValue="Turn Your Old Devices Into Instant Value" className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                  </div>
                  <button className="w-full py-2 rounded-xl bg-primary text-white text-sm font-bold hover:bg-primary/90 flex items-center justify-center gap-2">
                    <Save size={14} /> Save Changes
                  </button>
                </div>
              </div>
            </div>
          }

          {(activeModule === 'hero' || activeModule === 'stats' || activeModule === 'why' || activeModule === 'howItWorks' || activeModule === 'footer') &&
          <div className="space-y-4">
              <h3 className="font-bold text-gray-900 capitalize">{cmsModules[activePanel].find((m) => m.id === activeModule)?.label}</h3>
              <p className="text-sm text-gray-500">{cmsModules[activePanel].find((m) => m.id === activeModule)?.description}</p>
              <div className="space-y-3">
                {activeModule === 'hero' &&
              <>
                    <div>
                      <label className="text-xs font-bold text-gray-600 mb-1 block">Headline</label>
                      <input defaultValue="Turn Your Old Devices Into Instant Value." className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                    </div>
                    <div>
                      <label className="text-xs font-bold text-gray-600 mb-1 block">Subtext</label>
                      <textarea defaultValue="Sell, buy, exchange or repair your devices with a simple, secure and transparent experience." rows={2} className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 resize-none" />
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="text-xs font-bold text-gray-600 mb-1 block">Primary CTA</label>
                        <input defaultValue="Sell My Device" className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                      </div>
                      <div>
                        <label className="text-xs font-bold text-gray-600 mb-1 block">Secondary CTA</label>
                        <input defaultValue="Explore Refurbished" className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                      </div>
                    </div>
                  </>
              }
                {activeModule === 'stats' &&
              <div className="grid grid-cols-2 gap-3">
                    {[
                { label: 'Happy Customers', value: '10L+' },
                { label: 'Devices Sold', value: '1L+' },
                { label: 'Amount Paid', value: '₹250Cr+' },
                { label: 'Cities Covered', value: '100+' },
                { label: 'Average Rating', value: '4.8/5' },
                { label: 'Service Centers', value: '500+' }].
                map((stat) =>
                <div key={stat.label}>
                        <label className="text-xs font-bold text-gray-600 mb-1 block">{stat.label}</label>
                        <input defaultValue={stat.value} className="w-full px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                      </div>
                )}
                  </div>
              }
              </div>
              <button className="px-5 py-2.5 bg-primary text-white rounded-xl text-sm font-bold hover:bg-primary/90 flex items-center gap-2">
                <Save size={14} /> Save Changes
              </button>
            </div>
          }
        </div>
      </div>
    </div>);

}
'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { ArrowRight, ChevronRight, CheckCircle, RefreshCw, Zap, TrendingDown } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import { deviceModels } from '@/lib/casmikData';


type ExchangeStep = 'select-old' | 'condition' | 'select-new' | 'summary' | 'confirmed';

const conditionQuestions = [
{ id: 'display', question: 'Display condition?', options: [{ label: 'Perfect', adj: 0 }, { label: 'Good', adj: -1500 }, { label: 'Damaged', adj: -5000 }, { label: 'Broken', adj: -12000 }] },
{ id: 'body', question: 'Body condition?', options: [{ label: 'Like New', adj: 1000 }, { label: 'Good', adj: 0 }, { label: 'Average', adj: -2000 }, { label: 'Poor', adj: -6000 }] },
{ id: 'battery', question: 'Battery health?', options: [{ label: 'Above 90%', adj: 2000 }, { label: '80-90%', adj: 0 }, { label: 'Below 80%', adj: -3000 }, { label: "Don\'t Know", adj: -500 }] },
{ id: 'functional', question: 'Is it fully functional?', options: [{ label: 'Yes, all works', adj: 0 }, { label: 'Minor issue', adj: -3500 }, { label: 'Major issue', adj: -8000 }] }];


const newDevices = [
{ id: 'new-001', brand: 'Apple', model: 'iPhone 16', storage: '128GB', price: 62000, image: 'https://img.rocket.new/generatedImages/rocket_gen_img_1d4bb2939-1773063468643.png', alt: 'iPhone 16 in ultramarine' },
{ id: 'new-002', brand: 'Apple', model: 'iPhone 16 Pro', storage: '256GB', price: 75000, image: "https://img.rocket.new/generatedImages/rocket_gen_img_103da8441-1770037000517.png", alt: 'iPhone 16 Pro in titanium' },
{ id: 'new-003', brand: 'Samsung', model: 'Galaxy S24', storage: '256GB', price: 42000, image: "https://img.rocket.new/generatedImages/rocket_gen_img_1e7db7ad2-1772624438542.png", alt: 'Samsung Galaxy S24' },
{ id: 'new-004', brand: 'Samsung', model: 'Galaxy S24 Ultra', storage: '256GB', price: 68000, image: "https://img.rocket.new/generatedImages/rocket_gen_img_18a4c708a-1772538143194.png", alt: 'Samsung Galaxy S24 Ultra' },
{ id: 'new-005', brand: 'OnePlus', model: 'OnePlus 13', storage: '256GB', price: 55000, image: "https://img.rocket.new/generatedImages/rocket_gen_img_1c295e652-1772414313618.png", alt: 'OnePlus 13' },
{ id: 'new-006', brand: 'Google', model: 'Pixel 9 Pro', storage: '256GB', price: 52000, image: "https://img.rocket.new/generatedImages/rocket_gen_img_1a592c0ab-1773089370920.png", alt: 'Google Pixel 9 Pro' }];


const howItWorks = [
{ step: 1, icon: '📱', title: 'Select Old Device', desc: 'Choose the device you want to exchange.' },
{ step: 2, icon: '💰', title: 'Get Exchange Value', desc: 'Receive instant valuation for your old device.' },
{ step: 3, icon: '🔄', title: 'Choose New Device', desc: 'Browse and select your new refurbished or upgraded device.' },
{ step: 4, icon: '💳', title: 'Pay Difference', desc: 'Pay only the difference between new device price and exchange value.' },
{ step: 5, icon: '📦', title: 'Get New Device', desc: 'Simultaneous pickup of old and delivery of new device.' }];


export default function ExchangeDevicePage() {
  const [step, setStep] = useState<ExchangeStep>('select-old');
  const [selectedOldModel, setSelectedOldModel] = useState<typeof deviceModels[0] | null>(null);
  const [selectedOldStorage, setSelectedOldStorage] = useState('');
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [selectedNewDevice, setSelectedNewDevice] = useState<typeof newDevices[0] | null>(null);
  const [exchangeBonus] = useState(3000);

  const oldDeviceValue = selectedOldModel ?
  Math.max(selectedOldModel.basePrice + Object.values(answers).reduce((a, b) => a + b, 0), 5000) :
  0;

  const payable = selectedNewDevice ? Math.max(selectedNewDevice.price - oldDeviceValue - exchangeBonus, 0) : 0;

  const smartphoneModels = deviceModels.filter((m) => m.categoryId === 'cat-smartphone').slice(0, 8);

  if (step === 'confirmed') {
    return (
      <main className="min-h-screen bg-background">
        <CustomerHeader />
        <div className="min-h-[calc(100vh-64px)] flex items-center justify-center py-12 px-4">
          <div className="text-center max-w-md">
            <div className="w-20 h-20 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-6">
              <CheckCircle size={40} className="text-primary" />
            </div>
            <h1 className="text-2xl font-extrabold text-foreground mb-2">Exchange Confirmed! 🎉</h1>
            <p className="text-muted-foreground mb-6">Your exchange order is confirmed. We&apos;ll pickup your old device and deliver the new one simultaneously.</p>
            <div className="bg-white rounded-2xl border border-border p-5 mb-6 text-left space-y-2">
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Old Device</span><span className="font-semibold">{selectedOldModel?.name}</span></div>
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">Exchange Value</span><span className="font-semibold text-primary">₹{oldDeviceValue.toLocaleString('en-IN')}</span></div>
              <div className="flex justify-between text-sm"><span className="text-muted-foreground">New Device</span><span className="font-semibold">{selectedNewDevice?.brand} {selectedNewDevice?.model}</span></div>
              <div className="flex justify-between text-sm font-bold border-t border-border pt-2"><span>Amount Paid</span><span className="text-primary">₹{payable.toLocaleString('en-IN')}</span></div>
            </div>
            <Link href="/" className="inline-flex items-center gap-2 px-6 py-3 gradient-green text-white rounded-xl font-semibold shadow-green">
              Back to Home <ArrowRight size={16} />
            </Link>
          </div>
        </div>
        <CustomerFooter />
      </main>);

  }

  return (
    <main className="min-h-screen bg-background">
      <CustomerHeader />
      {/* Hero */}
      <section className="bg-gradient-to-br from-purple-50 via-white to-white py-12 border-b border-border">
        <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-purple-100 text-purple-700 text-xs font-bold mb-4">
              <RefreshCw size={12} /> EXCHANGE YOUR DEVICE
            </div>
            <h1 className="text-4xl font-extrabold text-foreground mb-3">Exchange & Upgrade</h1>
            <p className="text-lg text-muted-foreground mb-4">Get the best value for your old device and upgrade to a new one. Pay only the difference.</p>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-8 bg-white border-b border-border">
        <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10">
          <div className="flex items-center gap-4 overflow-x-auto scrollbar-hide">
            {howItWorks.map((s, i) =>
            <React.Fragment key={s.step}>
                <div className="flex items-center gap-3 flex-shrink-0">
                  <div className="w-10 h-10 rounded-xl bg-purple-100 flex items-center justify-center text-xl flex-shrink-0">{s.icon}</div>
                  <div>
                    <p className="text-xs font-bold text-foreground">{s.title}</p>
                    <p className="text-xs text-muted-foreground max-w-28 leading-tight">{s.desc}</p>
                  </div>
                </div>
                {i < howItWorks.length - 1 && <ChevronRight size={16} className="text-muted-foreground flex-shrink-0" />}
              </React.Fragment>
            )}
          </div>
        </div>
      </section>

      <div className="max-w-screen-xl mx-auto px-4 lg:px-8 py-8">
        {/* Step indicator */}
        <div className="flex items-center gap-2 mb-8 overflow-x-auto scrollbar-hide">
          {(['select-old', 'condition', 'select-new', 'summary'] as ExchangeStep[]).map((s, i) => {
            const labels = ['Select Old Device', 'Condition Check', 'Choose New Device', 'Review & Pay'];
            const stepIndex = ['select-old', 'condition', 'select-new', 'summary'].indexOf(step);
            const done = i < stepIndex;
            const active = s === step;
            return (
              <React.Fragment key={s}>
                <div className={`flex items-center gap-2 flex-shrink-0 px-3 py-2 rounded-xl ${active ? 'bg-primary/10' : ''}`}>
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${done ? 'bg-primary text-white' : active ? 'bg-primary text-white' : 'bg-muted text-muted-foreground'}`}>
                    {done ? '✓' : i + 1}
                  </div>
                  <span className={`text-xs font-semibold whitespace-nowrap ${active ? 'text-primary' : 'text-muted-foreground'}`}>{labels[i]}</span>
                </div>
                {i < 3 && <div className={`h-0.5 w-6 flex-shrink-0 ${done ? 'bg-primary' : 'bg-border'}`} />}
              </React.Fragment>);

          })}
        </div>

        {/* Step: Select Old Device */}
        {step === 'select-old' &&
        <div className="bg-white rounded-2xl border border-border p-6 fade-in">
            <h2 className="text-xl font-bold text-foreground mb-1">Select Your Old Device</h2>
            <p className="text-sm text-muted-foreground mb-5">Choose the device you want to exchange</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 mb-5">
              {smartphoneModels.map((model) =>
            <button key={model.id} onClick={() => setSelectedOldModel(model)}
            className={`flex items-center gap-3 p-3 rounded-xl border-2 text-left transition-all btn-press ${selectedOldModel?.id === model.id ? 'border-primary bg-primary-50' : 'border-border hover:border-primary/40'}`}>
                  <img src={model.image} alt={model.alt} className="w-12 h-12 rounded-lg object-cover bg-muted flex-shrink-0" />
                  <div>
                    <p className="text-sm font-semibold text-foreground">{model.name}</p>
                    <p className="text-xs text-muted-foreground">Up to ₹{model.basePrice.toLocaleString('en-IN')}</p>
                  </div>
                </button>
            )}
            </div>
            {selectedOldModel &&
          <div className="fade-in">
                <p className="text-sm font-semibold text-foreground mb-2">Select Storage</p>
                <div className="flex gap-2 flex-wrap mb-5">
                  {selectedOldModel.storages.map((s) =>
              <button key={s} onClick={() => setSelectedOldStorage(s)}
              className={`px-4 py-2 rounded-xl border-2 text-sm font-semibold transition-all btn-press ${selectedOldStorage === s ? 'border-primary bg-primary text-white' : 'border-border hover:border-primary/40'}`}>
                      {s}
                    </button>
              )}
                </div>
                {selectedOldStorage &&
            <button onClick={() => setStep('condition')}
            className="px-8 py-3 gradient-green text-white rounded-xl font-semibold shadow-green btn-press flex items-center gap-2">
                    Continue <ArrowRight size={16} />
                  </button>
            }
              </div>
          }
          </div>
        }

        {/* Step: Condition */}
        {step === 'condition' &&
        <div className="bg-white rounded-2xl border border-border p-6 fade-in">
            <button onClick={() => setStep('select-old')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors">← Back</button>
            <h2 className="text-xl font-bold text-foreground mb-1">Device Condition</h2>
            <p className="text-sm text-muted-foreground mb-5">Answer honestly for accurate exchange value</p>
            <div className="bg-primary/5 rounded-xl p-4 mb-5 flex items-center justify-between">
              <div>
                <p className="text-xs text-muted-foreground">Current Exchange Value</p>
                <p className="text-2xl font-extrabold text-primary">₹{oldDeviceValue.toLocaleString('en-IN')}</p>
              </div>
              <div className="text-right">
                <p className="text-xs text-muted-foreground">{selectedOldModel?.name}</p>
                <p className="text-xs text-muted-foreground">{selectedOldStorage}</p>
              </div>
            </div>
            <div className="space-y-5">
              {conditionQuestions.map((q) =>
            <div key={q.id}>
                  <p className="text-sm font-semibold text-foreground mb-2">{q.question}</p>
                  <div className="flex flex-wrap gap-2">
                    {q.options.map((opt) =>
                <button key={opt.label} onClick={() => setAnswers((prev) => ({ ...prev, [q.id]: opt.adj }))}
                className={`px-4 py-2 rounded-xl border-2 text-sm font-medium transition-all btn-press ${answers[q.id] === opt.adj && q.id in answers ? 'border-primary bg-primary/5 text-primary' : 'border-border hover:border-primary/40'}`}>
                        {opt.label}
                        {opt.adj !== 0 && <span className={`ml-1 text-xs font-bold ${opt.adj > 0 ? 'text-primary' : 'text-danger'}`}>{opt.adj > 0 ? '+' : ''}₹{Math.abs(opt.adj / 1000)}K</span>}
                      </button>
                )}
                  </div>
                </div>
            )}
            </div>
            {Object.keys(answers).length === conditionQuestions.length &&
          <button onClick={() => setStep('select-new')} className="mt-6 px-8 py-3 gradient-green text-white rounded-xl font-semibold shadow-green btn-press flex items-center gap-2 fade-in">
                Continue — Exchange Value: ₹{oldDeviceValue.toLocaleString('en-IN')} <ArrowRight size={16} />
              </button>
          }
          </div>
        }

        {/* Step: Select New Device */}
        {step === 'select-new' &&
        <div className="bg-white rounded-2xl border border-border p-6 fade-in">
            <button onClick={() => setStep('condition')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors">← Back</button>
            <h2 className="text-xl font-bold text-foreground mb-1">Choose Your New Device</h2>
            <p className="text-sm text-muted-foreground mb-5">Your exchange value: <strong className="text-primary">₹{oldDeviceValue.toLocaleString('en-IN')}</strong> + Exchange Bonus: <strong className="text-primary">₹{exchangeBonus.toLocaleString('en-IN')}</strong></p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {newDevices.map((device) => {
              const diff = Math.max(device.price - oldDeviceValue - exchangeBonus, 0);
              return (
                <button key={device.id} onClick={() => setSelectedNewDevice(device)}
                className={`flex items-center gap-4 p-4 rounded-2xl border-2 text-left transition-all btn-press ${selectedNewDevice?.id === device.id ? 'border-primary bg-primary-50' : 'border-border hover:border-primary/40'}`}>
                    <img src={device.image} alt={device.alt} className="w-16 h-16 rounded-xl object-cover bg-muted flex-shrink-0" />
                    <div className="flex-1">
                      <p className="text-sm font-bold text-foreground">{device.brand} {device.model}</p>
                      <p className="text-xs text-muted-foreground mb-1">{device.storage}</p>
                      <p className="text-xs text-muted-foreground">MRP: ₹{device.price.toLocaleString('en-IN')}</p>
                      <p className="text-sm font-bold text-primary flex items-center gap-1">
                        <TrendingDown size={12} /> You Pay: ₹{diff.toLocaleString('en-IN')}
                      </p>
                    </div>
                  </button>);

            })}
            </div>
            {selectedNewDevice &&
          <button onClick={() => setStep('summary')} className="mt-6 px-8 py-3 gradient-green text-white rounded-xl font-semibold shadow-green btn-press flex items-center gap-2 fade-in">
                Review Exchange <ArrowRight size={16} />
              </button>
          }
          </div>
        }

        {/* Step: Summary */}
        {step === 'summary' && selectedNewDevice &&
        <div className="max-w-lg mx-auto fade-in">
            <button onClick={() => setStep('select-new')} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors">← Back</button>
            <h2 className="text-xl font-bold text-foreground mb-5">Exchange Summary</h2>
            <div className="bg-white rounded-2xl border border-border p-6 mb-5">
              <div className="flex items-center gap-4 pb-4 border-b border-border mb-4">
                <img src={selectedOldModel?.image} alt={selectedOldModel?.alt || 'Old device'} className="w-14 h-14 rounded-xl object-cover bg-muted" />
                <div className="flex-1">
                  <p className="text-xs text-muted-foreground">Your Old Device</p>
                  <p className="font-bold text-foreground">{selectedOldModel?.name} {selectedOldStorage}</p>
                </div>
                <div className="text-right">
                  <p className="text-xs text-muted-foreground">Exchange Value</p>
                  <p className="font-bold text-primary">₹{oldDeviceValue.toLocaleString('en-IN')}</p>
                </div>
              </div>
              <div className="flex items-center gap-4 pb-4 border-b border-border mb-4">
                <img src={selectedNewDevice.image} alt={selectedNewDevice.alt} className="w-14 h-14 rounded-xl object-cover bg-muted" />
                <div className="flex-1">
                  <p className="text-xs text-muted-foreground">New Device</p>
                  <p className="font-bold text-foreground">{selectedNewDevice.brand} {selectedNewDevice.model} {selectedNewDevice.storage}</p>
                </div>
                <div className="text-right">
                  <p className="text-xs text-muted-foreground">Price</p>
                  <p className="font-bold text-foreground">₹{selectedNewDevice.price.toLocaleString('en-IN')}</p>
                </div>
              </div>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between"><span className="text-muted-foreground">New Device Price</span><span>₹{selectedNewDevice.price.toLocaleString('en-IN')}</span></div>
                <div className="flex justify-between text-primary"><span>Old Device Value</span><span>- ₹{oldDeviceValue.toLocaleString('en-IN')}</span></div>
                <div className="flex justify-between text-primary"><span>Exchange Bonus</span><span>- ₹{exchangeBonus.toLocaleString('en-IN')}</span></div>
                <div className="flex justify-between font-extrabold text-base border-t border-border pt-2 mt-2">
                  <span>You Pay</span>
                  <span className="text-primary">₹{payable.toLocaleString('en-IN')}</span>
                </div>
              </div>
            </div>
            <div className="flex items-center gap-3 bg-primary/5 rounded-xl p-4 mb-5">
              <Zap size={16} className="text-primary flex-shrink-0" />
              <p className="text-sm text-foreground">Simultaneous pickup of your old device and delivery of new device within 2-3 business days.</p>
            </div>
            <button onClick={() => setStep('confirmed')}
          className="w-full py-4 gradient-green text-white rounded-xl font-bold text-base shadow-green btn-press flex items-center justify-center gap-2">
              <CheckCircle size={18} /> Confirm Exchange — Pay ₹{payable.toLocaleString('en-IN')}
            </button>
          </div>
        }
      </div>
      <CustomerFooter />
    </main>);

}
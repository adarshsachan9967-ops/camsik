'use client';
import React, { useState, useRef } from 'react';
import { ChevronLeft, TrendingUp, TrendingDown, X, Lock } from 'lucide-react';
import type { SellState } from './SellDeviceWorkflow';
import DeviceVerificationSection from './DeviceVerificationSection';
import DeviceVerificationModal from './DeviceVerificationModal';

// Illustrated condition questions with proper answer cards like reference screenshot
const questions = [
  {
    id: 'q-power',
    question: 'Does the device turn on?',
    subtext: 'Press the power button to check if the device powers on normally.',
    options: [
      { id: 'q-power-yes', label: 'Yes, turns on', desc: 'Device powers on and works normally', adjustment: 0, icon: '✅', illustration: '📱', bulletPoints: ['Powers on normally', 'Reaches home screen'] },
      { id: 'q-power-no', label: 'No, does not turn on', desc: 'Device is completely dead or stuck', adjustment: -20000, icon: '❌', illustration: '📵', bulletPoints: ['Device is dead', 'Does not boot'] },
    ],
  },
  {
    id: 'q-display',
    question: 'How is your display?',
    subtext: 'Check for cracks, scratches, dead pixels or discolouration.',
    options: [
      { id: 'q-display-perfect', label: 'Perfect', desc: 'No scratches, no marks at all', adjustment: 0, icon: '✨', illustration: '🖥️', bulletPoints: ['No scratches visible', 'No dead pixels', 'Perfect display quality'] },
      { id: 'q-display-good', label: 'Good', desc: 'Minor hairline scratches, not visible during use', adjustment: -1500, icon: '👍', illustration: '📱', bulletPoints: ['Minor hairline scratches', 'Not visible during use', 'Display fully functional'] },
      { id: 'q-display-damaged', label: 'Damaged', desc: 'Visible scratches or minor crack on screen', adjustment: -5000, icon: '⚠️', illustration: '📱', bulletPoints: ['Visible scratches', 'Minor crack present', 'Display still functional'] },
      { id: 'q-display-broken', label: 'Broken', desc: 'Screen cracked or not displaying properly', adjustment: -12000, icon: '💔', illustration: '📵', bulletPoints: ['Screen cracked badly', 'Display issues present', 'Touch may not work'] },
    ],
  },
  {
    id: 'q-body',
    question: 'How is the body condition?',
    subtext: 'Dents, deep scratches, loose frame, heavy wear.',
    options: [
      { id: 'q-body-likenew', label: 'Like New', desc: 'No scratches, dents or marks on body', adjustment: 1000, icon: '✨', illustration: '📱', bulletPoints: ['No scratches on body', 'No dents or marks', 'Looks brand new'] },
      { id: 'q-body-good', label: 'Good', desc: 'Minor scratches, not easily visible', adjustment: 0, icon: '👍', illustration: '📱', bulletPoints: ['Minor scratches only', 'No dents', 'Normal wear and tear'] },
      { id: 'q-body-average', label: 'Average', desc: 'Visible scratches on body, minor dents possible', adjustment: -2000, icon: '😐', illustration: '📱', bulletPoints: ['Visible scratches on body', 'Minor dents possible', 'Signs of normal wear and tear'] },
      { id: 'q-body-below', label: 'Below Average', desc: 'Deep scratches, multiple dents or cracks', adjustment: -6000, icon: '😟', illustration: '📵', bulletPoints: ['Deep scratches present', 'Multiple dents or cracks', 'Heavy wear and tear'] },
    ],
  },
  {
    id: 'q-battery',
    question: 'Is the battery health above 90%?',
    subtext: 'Check Settings → Battery → Battery Health on iPhone.',
    options: [
      { id: 'q-battery-yes', label: 'Yes, above 90%', desc: 'Battery is in great health', adjustment: 2000, icon: '🔋', illustration: '🔋', bulletPoints: ['Battery health > 90%', 'Long battery life', 'No degradation'] },
      { id: 'q-battery-80', label: '80% – 90%', desc: 'Battery is decent', adjustment: 0, icon: '🔋', illustration: '🔋', bulletPoints: ['Battery health 80-90%', 'Decent battery life', 'Slight degradation'] },
      { id: 'q-battery-below', label: 'Below 80%', desc: 'Battery needs replacement soon', adjustment: -3000, icon: '⚠️', illustration: '🪫', bulletPoints: ['Battery health < 80%', 'Needs replacement soon', 'Reduced battery life'] },
      { id: 'q-battery-unknown', label: "Don\'t Know", desc: "I haven\'t checked", adjustment: -500, icon: '❓', illustration: '❓', bulletPoints: ["Haven\'t checked battery health", 'Will be verified during inspection'] },
    ],
  },
  {
    id: 'q-functional',
    question: 'Is the device fully functional?',
    subtext: 'Check Face ID, cameras, speakers, microphone and charging.',
    options: [
      { id: 'q-func-yes', label: 'Everything Works', desc: 'All features working perfectly', adjustment: 0, icon: '✅', illustration: '✅', bulletPoints: ['All features functional', 'Camera works', 'Face ID / fingerprint works', 'Speakers & mic work'] },
      { id: 'q-func-minor', label: 'Minor Issue', desc: 'One feature not working (e.g. Face ID)', adjustment: -3500, icon: '⚠️', illustration: '⚠️', bulletPoints: ['One feature not working', 'Rest of device functional', 'Repairable issue'] },
      { id: 'q-func-major', label: 'Major Issue', desc: 'Multiple features not working', adjustment: -8000, icon: '❌', illustration: '❌', bulletPoints: ['Multiple features broken', 'Significant repair needed', 'Reduced functionality'] },
    ],
  },
  {
    id: 'q-water',
    question: 'Has the device had water damage?',
    subtext: 'Check if the device has ever been submerged or heavily wet.',
    options: [
      { id: 'q-water-no', label: 'No Water Damage', desc: 'Device has never been water damaged', adjustment: 0, icon: '✅', illustration: '✅', bulletPoints: ['No water exposure', 'No corrosion', 'All ports clean'] },
      { id: 'q-water-yes', label: 'Yes, Water Damage', desc: 'Device was exposed to water', adjustment: -15000, icon: '💧', illustration: '💧', bulletPoints: ['Water damage present', 'Possible corrosion', 'May have internal damage'] },
    ],
  },
  {
    id: 'q-charger',
    question: 'Do you have the original charger?',
    subtext: 'Original Apple/Samsung/OEM charger that came with the device.',
    options: [
      { id: 'q-charger-yes', label: 'Yes, Original Charger', desc: 'Original charger included', adjustment: 500, icon: '🔌', illustration: '🔌', bulletPoints: ['Original charger included', 'Genuine OEM accessory'] },
      { id: 'q-charger-no', label: 'No Charger', desc: 'Charger not available', adjustment: 0, icon: '❌', illustration: '❌', bulletPoints: ['No charger available', 'Common situation'] },
    ],
  },
  {
    id: 'q-box',
    question: 'Do you have the original box?',
    subtext: 'Original retail box the device came in.',
    options: [
      { id: 'q-box-yes', label: 'Yes, Original Box', desc: 'Box and accessories included', adjustment: 300, icon: '📦', illustration: '📦', bulletPoints: ['Original box available', 'Complete packaging'] },
      { id: 'q-box-no', label: 'No Box', desc: 'Box not available', adjustment: 0, icon: '❌', illustration: '❌', bulletPoints: ['No original box', 'Very common'] },
    ],
  },
];

interface Props {
  sellState: SellState;
  onUpdate: (updates: Partial<SellState>) => void;
  onNext: () => void;
  onBack: () => void;
  onSelectModel?: () => void;
}

export default function StepConditionQuestions({ sellState, onUpdate, onNext, onBack, onSelectModel }: Props) {
  const [activeQ, setActiveQ] = useState(0);
  const [priceAnimation, setPriceAnimation] = useState<'up' | 'down' | null>(null);
  const [lastDelta, setLastDelta] = useState<number>(0);
  const [showVerifyModal, setShowVerifyModal] = useState(false);
  const prevPrice = useRef(sellState.currentPrice);

  const handleAnswer = (qId: string, optId: string, adjustment: number) => {
    const newAnswers = { ...sellState.answers, [qId]: optId };
    let newPrice = sellState.basePrice;
    const newAdjustments: SellState['adjustments'] = [];

    questions.forEach(q => {
      const answeredOptId = q.id === qId ? optId : newAnswers[q.id];
      if (!answeredOptId) return;
      const opt = q.options.find(o => o.id === answeredOptId);
      if (opt && opt.adjustment !== 0) {
        newPrice += opt.adjustment;
        newAdjustments.push({
          label: q.question.replace('?', '').slice(0, 30),
          amount: opt.adjustment,
          reason: opt.label,
        });
      }
    });

    const delta = newPrice - prevPrice.current;
    setLastDelta(delta);
    setPriceAnimation(delta > 0 ? 'up' : delta < 0 ? 'down' : null);
    setTimeout(() => setPriceAnimation(null), 800);
    prevPrice.current = newPrice;

    onUpdate({ answers: newAnswers, currentPrice: Math.max(newPrice, 5000), adjustments: newAdjustments });

    setTimeout(() => {
      if (activeQ < questions.length - 1) setActiveQ(q => q + 1);
    }, 350);
  };

  const allAnswered = questions.every(q => sellState.answers[q.id]);
  const isVerified = sellState.deviceVerification?.status === 'verified';
  const progress = (Object.keys(sellState.answers).length / questions.length) * 100;

  return (
    <div className="space-y-4 fade-in">
      {/* Price bar */}
      <div className={`bg-white rounded-2xl border border-border shadow-sm p-5 flex items-center justify-between ${priceAnimation ? 'price-pulse' : ''}`}>
        <div>
          <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wide mb-1">Current Estimated Value</p>
          <div className={`text-3xl font-extrabold font-tabular transition-all duration-300 ${
            priceAnimation === 'up' ? 'text-primary scale-105' : priceAnimation === 'down' ? 'text-danger scale-105' : 'text-foreground'
          }`}>
            ₹{sellState.currentPrice.toLocaleString('en-IN')}
          </div>
        </div>
        {lastDelta !== 0 && priceAnimation && (
          <div className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-sm font-bold fade-in ${
            lastDelta > 0 ? 'bg-primary-100 text-primary' : 'bg-red-50 text-danger'
          }`}>
            {lastDelta > 0 ? <TrendingUp size={14} /> : <TrendingDown size={14} />}
            {lastDelta > 0 ? '+' : ''}₹{Math.abs(lastDelta).toLocaleString('en-IN')}
          </div>
        )}
        <div className="text-right hidden sm:block">
          <p className="text-xs text-muted-foreground">{Object.keys(sellState.answers).length} of {questions.length} answered</p>
          <div className="w-24 h-1.5 bg-muted rounded-full mt-1.5 overflow-hidden">
            <div className="h-full gradient-green rounded-full transition-all duration-500" style={{ width: `${progress}%` }} />
          </div>
        </div>
      </div>

      {/* Question card */}
      <div className="bg-white rounded-2xl border border-border shadow-sm overflow-hidden">
        <button onClick={onBack} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground px-6 pt-5 transition-colors">
          <ChevronLeft size={16} /> Back to Model
        </button>

        <div className="p-6">
          <div className="flex items-center justify-between mb-1">
            <h2 className="text-xl font-bold text-foreground">Device Condition</h2>
            <span className="text-xs text-muted-foreground font-medium">Question {Math.min(activeQ + 1, questions.length)} of {questions.length}</span>
          </div>
          <p className="text-sm text-muted-foreground mb-5">Answer honestly for the most accurate price</p>

          {/* Question tabs */}
          <div className="flex gap-1.5 mb-6 overflow-x-auto scrollbar-hide pb-1">
            {questions.map((q, i) => {
              const answered = !!sellState.answers[q.id];
              return (
                <button key={`qtab-${q.id}`} onClick={() => setActiveQ(i)}
                  className={`flex-shrink-0 w-7 h-7 rounded-lg text-xs font-bold transition-all ${
                    i === activeQ ? 'bg-primary text-white' : answered ? 'bg-primary-100 text-primary' : 'bg-muted text-muted-foreground'
                  }`}>
                  {answered ? '✓' : i + 1}
                </button>
              );
            })}
          </div>

          {/* Active question */}
          {questions.map((q, qi) => qi === activeQ && (
            <div key={`q-${q.id}`} className="fade-in">
              <h3 className="text-base font-bold text-foreground mb-1">{q.question}</h3>
              <p className="text-xs text-muted-foreground mb-5">{q.subtext}</p>

              {/* Answer cards — with direct selection and full inline details */}
              <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3.5">
                {q.options.map((opt) => {
                  const selected = sellState.answers[q.id] === opt.id;
                  return (
                    <button
                      key={`opt-${opt.id}`}
                      type="button"
                      onClick={() => handleAnswer(q.id, opt.id, opt.adjustment)}
                      className={`relative flex flex-col items-center gap-2 p-4 rounded-2xl border-2 text-center transition-all duration-150 btn-press group cursor-pointer ${
                        selected
                          ? 'border-primary bg-primary-50/80 shadow-green ring-2 ring-primary/20'
                          : 'border-border bg-white hover:border-primary/50 hover:bg-primary-50/20'
                      }`}
                    >
                      {/* Check badge */}
                      {selected && (
                        <div className="absolute top-2.5 right-2.5 w-5 h-5 rounded-full bg-primary flex items-center justify-center shadow-sm">
                          <span className="text-white text-xs font-bold leading-none">✓</span>
                        </div>
                      )}

                      {/* Illustration */}
                      <div className={`w-14 h-14 rounded-2xl flex items-center justify-center text-3xl transition-all ${selected ? 'bg-primary/10' : 'bg-gray-50 group-hover:bg-primary/5'}`}>
                        {opt.illustration}
                      </div>
                      
                      <p className={`text-sm font-bold leading-tight ${selected ? 'text-primary' : 'text-foreground'}`}>{opt.label}</p>
                      <p className="text-xs text-muted-foreground leading-tight">{opt.desc}</p>
                      
                      {/* Detailed bullets shown directly inline */}
                      {opt.bulletPoints && opt.bulletPoints.length > 0 && (
                        <div className="w-full text-left space-y-1 mt-1 pt-2 border-t border-border/60">
                          {opt.bulletPoints.map((bp, bpi) => (
                            <p key={bpi} className="text-[11px] text-muted-foreground flex items-start gap-1 leading-tight">
                              <span className="text-primary font-bold text-[9px] mt-0.5">•</span>
                              <span>{bp}</span>
                            </p>
                          ))}
                        </div>
                      )}

                      {opt.adjustment !== 0 && (
                        <span className={`text-xs font-black px-2.5 py-0.5 rounded-full mt-auto ${opt.adjustment > 0 ? 'bg-primary-100 text-primary' : 'bg-red-50 text-danger'}`}>
                          {opt.adjustment > 0 ? '+' : ''}₹{Math.abs(opt.adjustment).toLocaleString('en-IN')}
                        </span>
                      )}
                    </button>
                  );
                })}
              </div>

              {/* Prominent Device Verification Section immediately ABOVE Get My Quote */}
              {qi === questions.length - 1 && (
                <DeviceVerificationSection
                  selectedBrand={sellState.brandName}
                  selectedModel={sellState.modelName}
                  selectedVariant={sellState.storage || undefined}
                  verificationReport={sellState.deviceVerification}
                  onVerified={(report) => {
                    onUpdate({ deviceVerification: report });
                  }}
                  onRecheck={() => {
                    onUpdate({ deviceVerification: null });
                    if (onSelectModel) onSelectModel();
                  }}
                />
              )}

              {/* Navigation */}
              <div className="flex items-center justify-between mt-6 pt-4 border-t border-border/60">
                <button onClick={() => setActiveQ(q => Math.max(q - 1, 0))} disabled={activeQ === 0}
                  className="flex items-center gap-1.5 px-4 py-2 rounded-xl border border-border text-sm font-medium text-muted-foreground hover:text-foreground disabled:opacity-40 disabled:cursor-not-allowed transition-colors">
                  <ChevronLeft size={14} /> Previous
                </button>

                <div className="flex items-center gap-2">
                  {activeQ < questions.length - 1 ? (
                    <button
                      type="button"
                      onClick={() => setActiveQ(q => q + 1)}
                      className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-slate-100 text-sm font-semibold text-slate-700 hover:bg-slate-200 transition-colors"
                    >
                      Skip Question →
                    </button>
                  ) : isVerified ? (
                    <button onClick={onNext} className="flex items-center gap-2 px-6 py-2.5 gradient-green text-white rounded-xl font-semibold text-sm shadow-green btn-press">
                      Get My Quote →
                    </button>
                  ) : (
                    <button
                      onClick={() => setShowVerifyModal(true)}
                      className="flex items-center gap-2 px-5 py-2.5 bg-slate-900 hover:bg-slate-800 text-white rounded-xl font-bold text-sm shadow-md transition-all btn-press"
                    >
                      <Lock size={14} className="text-emerald-400" />
                      <span>Verify Device to Unlock Quote →</span>
                    </button>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Continue button — allow proceeding whether answered or skipped */}
      {(allAnswered || activeQ === questions.length - 1 || Object.keys(sellState.answers).length >= 1) && (
        <div className="fade-in">
          {isVerified ? (
            <button onClick={onNext} className="w-full py-4 gradient-green text-white rounded-2xl font-bold text-base shadow-green btn-press flex items-center justify-center gap-2">
              <span>🎉 Get My Final Quote — ₹{sellState.currentPrice.toLocaleString('en-IN')}</span>
            </button>
          ) : (
            <button
              onClick={() => setShowVerifyModal(true)}
              className="w-full py-4 bg-slate-900 hover:bg-slate-800 text-white rounded-2xl font-bold text-base shadow-md btn-press flex items-center justify-center gap-2.5 transition-all"
            >
              <Lock size={18} className="text-emerald-400" />
              <span>🔒 Verify Device to Get Quote — ₹{sellState.currentPrice.toLocaleString('en-IN')}</span>
            </button>
          )}
        </div>
      )}

      {/* Verification Modal */}
      {showVerifyModal && (
        <DeviceVerificationModal
          selectedBrand={sellState.brandName}
          selectedModel={sellState.modelName}
          selectedVariant={sellState.storage || undefined}
          onSuccess={(report) => {
            onUpdate({ deviceVerification: report });
            setShowVerifyModal(false);
          }}
          onClose={() => setShowVerifyModal(false)}
        />
      )}
    </div>
  );
}
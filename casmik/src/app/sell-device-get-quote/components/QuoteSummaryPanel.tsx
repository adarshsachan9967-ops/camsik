'use client';
import React from 'react';
import { CheckCircle, Star, Phone, MessageCircle, TrendingDown, TrendingUp } from 'lucide-react';
import type { SellState } from './SellDeviceWorkflow';
import { deviceModels } from '@/lib/casmikData';

interface Props {
  sellState: SellState;
  currentStep: number;
}

export default function QuoteSummaryPanel({ sellState, currentStep }: Props) {
  const hasDevice = sellState.model !== null;
  const hasPrice = sellState.currentPrice > 0;

  const matchedModel = deviceModels.find(m => m.id === sellState.model || m.slug === sellState.model);

  const positiveAdj = sellState.adjustments.filter(a => a.amount > 0);
  const negativeAdj = sellState.adjustments.filter(a => a.amount < 0);

  return (
    <div className="space-y-4 sticky top-24">
      {/* Quote summary card */}
      <div className="bg-white rounded-2xl border border-border shadow-sm p-5">
        <h3 className="font-bold text-foreground mb-4 text-base">Your Quote Summary</h3>

        {!hasDevice ? (
          <div className="text-center py-8">
            <div className="w-14 h-14 rounded-2xl bg-muted flex items-center justify-center mx-auto mb-3">
              <span className="text-2xl">📱</span>
            </div>
            <p className="text-sm font-semibold text-foreground mb-1">No device selected yet</p>
            <p className="text-xs text-muted-foreground">Select your device brand and model to see the quote summary here.</p>
          </div>
        ) : (
          <>
            {/* Device info */}
            <div className="flex items-center gap-3 mb-4 pb-4 border-b border-border">
              <div className="w-14 h-14 rounded-xl overflow-hidden bg-muted flex-shrink-0 p-1 flex items-center justify-center border border-border/80">
                <img
                  src={matchedModel?.image || "/assets/images/categories/smartphone.png"}
                  alt={`${sellState.brandName} ${sellState.modelName}`}
                  className="w-full h-full object-contain"
                />
              </div>
              <div className="flex-1 min-w-0">
                <p className="font-bold text-sm text-foreground leading-tight">
                  {sellState.brandName} {sellState.modelName}
                </p>
                {sellState.storage && (
                  <span className="inline-block mt-1 px-2 py-0.5 rounded-lg bg-primary/10 text-primary text-xs font-semibold">
                    {sellState.storage}
                  </span>
                )}
                {sellState.color && (
                  <p className="text-xs text-muted-foreground mt-1 flex items-center gap-1">
                    <span className="w-2 h-2 rounded-full bg-slate-400 inline-block"></span>
                    {sellState.color}
                  </p>
                )}
              </div>
            </div>

            {/* Price breakdown */}
            <div className="space-y-2.5 mb-4">
              <div className="flex items-center justify-between text-sm">
                <span className="text-muted-foreground">Base Market Price</span>
                <span className="font-semibold text-foreground font-tabular">
                  ₹{sellState.basePrice.toLocaleString('en-IN')}
                </span>
              </div>

              {positiveAdj.map((adj, ai) => (
                <div key={`adj-pos-${ai}`} className="flex items-center justify-between text-sm">
                  <span className="text-muted-foreground flex items-center gap-1.5 truncate max-w-[55%]">
                    <TrendingUp size={11} className="text-primary flex-shrink-0" />
                    <span className="truncate">{adj.reason}</span>
                  </span>
                  <span className="font-semibold text-primary font-tabular flex-shrink-0">
                    +₹{Math.abs(adj.amount).toLocaleString('en-IN')}
                  </span>
                </div>
              ))}

              {negativeAdj.map((adj, ai) => (
                <div key={`adj-neg-${ai}`} className="flex items-center justify-between text-sm">
                  <span className="text-muted-foreground flex items-center gap-1.5 truncate max-w-[55%]">
                    <TrendingDown size={11} className="text-danger flex-shrink-0" />
                    <span className="truncate">{adj.reason}</span>
                  </span>
                  <span className="font-semibold text-danger font-tabular flex-shrink-0">
                    -₹{Math.abs(adj.amount).toLocaleString('en-IN')}
                  </span>
                </div>
              ))}

              {positiveAdj.length === 0 && negativeAdj.length === 0 && currentStep === 2 && (
                <p className="text-xs text-muted-foreground italic">Answer questions to see price adjustments</p>
              )}

              {/* Instant payment bonus */}
              {hasPrice && (
                <div className="flex items-center justify-between text-sm">
                  <span className="text-muted-foreground flex items-center gap-1.5">
                    <TrendingUp size={11} className="text-primary flex-shrink-0" />
                    Instant Payment Bonus
                  </span>
                  <span className="font-semibold text-primary font-tabular">+₹1,000</span>
                </div>
              )}
            </div>

            {/* Divider */}
            <div className="border-t-2 border-dashed border-border pt-3 mb-4">
              <div className="flex items-center justify-between">
                <span className="text-sm font-bold text-foreground">You Get</span>
                <span className="text-2xl font-extrabold text-primary font-tabular">
                  ₹{sellState.currentPrice.toLocaleString('en-IN')}
                </span>
              </div>
            </div>

            {/* No hidden charges */}
            <div className="flex items-start gap-2 p-3 rounded-xl bg-primary-50 border border-primary/20">
              <CheckCircle size={14} className="text-primary flex-shrink-0 mt-0.5" />
              <p className="text-xs text-foreground leading-relaxed">
                <strong>No hidden charges.</strong> What you see is what you get!
              </p>
            </div>
          </>
        )}
      </div>

      {/* Trust panel */}
      <div className="bg-white rounded-2xl border border-border shadow-sm p-5">
        <div className="flex items-center gap-2 mb-3">
          <div className="flex items-center gap-0.5">
            {[1,2,3,4].map(s => (
              <Star key={`panel-star-${s}`} size={13} className="text-warning fill-warning" />
            ))}
            <Star size={13} className="text-warning fill-warning opacity-50" />
          </div>
          <span className="text-sm font-bold text-foreground">4.8/5</span>
        </div>
        <p className="text-xs text-muted-foreground mb-1">Trusted by <strong className="text-foreground">10,00,000+ users</strong></p>
        <div className="flex items-center gap-1.5 text-xs text-muted-foreground">
          <span className="text-green-600 font-bold">★</span>
          <span>Excellent</span>
          <span className="font-semibold text-foreground">Trustpilot</span>
        </div>
      </div>

      {/* Help panel */}
      <div className="bg-white rounded-2xl border border-border shadow-sm p-5">
        <h4 className="font-bold text-sm text-foreground mb-1">Need Help?</h4>
        <p className="text-xs text-muted-foreground mb-4">Our support team is here for you</p>
        <div className="space-y-2">
          <a
            href="tel:+918976000010"
            className="flex items-center gap-3 p-3 rounded-xl border border-border hover:bg-muted hover:border-primary/30 transition-all duration-150"
          >
            <div className="w-8 h-8 rounded-lg bg-primary/10 flex items-center justify-center flex-shrink-0">
              <Phone size={14} className="text-primary" />
            </div>
            <span className="text-sm font-semibold text-foreground">+91 8976000010</span>
          </a>
          <a
            href="https://wa.me/918976000010?text=Hi%20Camsik%20team,%20I%20need%20help%20with%20my%20device%20valuation"
            target="_blank"
            rel="noopener noreferrer"
            className="w-full flex items-center gap-3 p-3 rounded-xl border border-border hover:bg-muted hover:border-emerald-500/30 transition-all duration-150"
          >
            <div className="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center flex-shrink-0">
              <MessageCircle size={14} className="text-emerald-600" />
            </div>
            <span className="text-sm font-semibold text-foreground">Live WhatsApp Chat</span>
          </a>
        </div>
      </div>
    </div>
  );
}
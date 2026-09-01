import React from 'react';
import { Smartphone, Star } from 'lucide-react';
import AppImage from '@/components/ui/AppImage';

export default function AppDownloadCTA() {
  return (
    <section className="py-14 lg:py-20 bg-secondary overflow-hidden relative">
      <div className="absolute inset-0 opacity-5 hero-dots" />
      <div className="max-w-screen-2xl mx-auto px-6 lg:px-8 xl:px-10 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-10 items-center">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/20 text-xs font-semibold text-primary mb-5">
              <Smartphone size={12} />
              CASMIK APP
            </div>
            <h2 className="text-3xl lg:text-4xl font-extrabold text-white mb-4 leading-tight">
              Sell smarter with the{' '}
              <span className="text-primary">Casmik App</span>
            </h2>
            <p className="text-slate-400 mb-6 leading-relaxed">
              Get instant quotes, track your orders in real-time, and manage everything from your pocket. Available on Android and iOS.
            </p>
            <div className="flex items-center gap-3 mb-8">
              <div className="flex items-center gap-1.5">
                {[1, 2, 3, 4, 5]?.map((s) =>
                <Star key={`app-star-${s}`} size={14} className="text-warning fill-warning" />
                )}
              </div>
              <span className="text-sm text-slate-400">4.8/5 · 50,000+ reviews</span>
            </div>
            <div className="flex flex-wrap gap-3">
              <button className="flex items-center gap-3 px-5 py-3 bg-white rounded-xl hover:bg-muted transition-colors btn-press">
                <img
                  src="https://img.rocket.new/generatedImages/rocket_gen_img_101eff038-1768807121102.png"
                  alt="Get it on Google Play Store"
                  className="h-7" />

              </button>
              <button className="flex items-center gap-3 px-5 py-3 bg-white rounded-xl hover:bg-muted transition-colors btn-press">
                <img
                  src="https://img.rocket.new/generatedImages/rocket_gen_img_1589826e0-1768549935063.png"
                  alt="Download on the Apple App Store"
                  className="h-7" />

              </button>
            </div>
          </div>
          <div className="flex justify-center lg:justify-end">
            <div className="relative w-64 h-64 lg:w-80 lg:h-80">
              <div className="absolute inset-0 rounded-full bg-primary/10 blur-3xl" />
              <AppImage
                src="https://img.rocket.new/generatedImages/rocket_gen_img_188da6c66-1765371375098.png"
                alt="Person holding smartphone with Casmik app showing sell device interface"
                width={320}
                height={320}
                className="relative z-10 w-full h-full object-contain drop-shadow-2xl" />

            </div>
          </div>
        </div>
      </div>
    </section>);

}
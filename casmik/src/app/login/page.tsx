'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { Eye, EyeOff, Phone, Mail, Lock, User, ArrowLeft, CheckCircle, Smartphone } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';

type AuthMode = 'login' | 'register' | 'otp';

export default function LoginPage() {
  const [mode, setMode] = useState<AuthMode>('login');
  const [showPassword, setShowPassword] = useState(false);
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [otp, setOtp] = useState(['', '', '', '', '', '']);
  const [loading, setLoading] = useState(false);
  const [loginMethod, setLoginMethod] = useState<'phone' | 'email'>('phone');

  const handleOtpChange = (index: number, value: string) => {
    if (value.length > 1) return;
    const newOtp = [...otp];
    newOtp[index] = value;
    setOtp(newOtp);
    if (value && index < 5) {
      document.getElementById(`otp-${index + 1}`)?.focus();
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      if (mode === 'login' || mode === 'register') setMode('otp');
    }, 1000);
  };

  const handleOtpVerify = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      window.location.href = '/';
    }, 1200);
  };

  return (
    <main className="min-h-screen bg-background">
      <CustomerHeader />
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center py-12 px-4">
        <div className="w-full max-w-md">
          {/* Back link */}
          <Link href="/" className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors">
            <ArrowLeft size={14} /> Back to Home
          </Link>

          <div className="bg-white rounded-3xl border border-border shadow-lg overflow-hidden">
            {/* Header */}
            <div className="gradient-green p-8 text-white text-center">
              <div className="w-16 h-16 rounded-2xl bg-white/20 flex items-center justify-center mx-auto mb-4">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none">
                  <path d="M12 2L3 7v5c0 5.25 3.75 10.15 9 11.35C17.25 22.15 21 17.25 21 12V7L12 2z" fill="white" fillOpacity="0.9"/>
                  <path d="M9 12l2 2 4-4" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </div>
              <h1 className="text-2xl font-extrabold mb-1">
                {mode === 'otp' ? 'Verify OTP' : mode === 'register' ? 'Create Account' : 'Welcome Back'}
              </h1>
              <p className="text-white/80 text-sm">
                {mode === 'otp' ? `OTP sent to ${loginMethod === 'phone' ? phone : email}` : mode === 'register' ? 'Join 10 lakh+ happy customers' : 'Sign in to your Camsik account'}
              </p>
            </div>

            <div className="p-8">
              {mode === 'otp' ? (
                <form onSubmit={handleOtpVerify} className="space-y-6">
                  <div>
                    <p className="text-sm text-muted-foreground text-center mb-4">Enter the 6-digit OTP sent to your {loginMethod === 'phone' ? 'phone number' : 'email'}</p>
                    <div className="flex gap-2 justify-center">
                      {otp.map((digit, i) => (
                        <input key={`otp-${i}`} id={`otp-${i}`} type="text" inputMode="numeric" maxLength={1} value={digit}
                          onChange={e => handleOtpChange(i, e.target.value)}
                          className="w-11 h-12 text-center text-lg font-bold border-2 border-border rounded-xl focus:outline-none focus:border-primary transition-colors" />
                      ))}
                    </div>
                  </div>
                  <button type="submit" disabled={loading || otp.join('').length < 6}
                    className="w-full py-3 gradient-green text-white rounded-xl font-semibold shadow-green btn-press disabled:opacity-60 flex items-center justify-center gap-2">
                    {loading ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <><CheckCircle size={16} /> Verify & Continue</>}
                  </button>
                  <div className="text-center">
                    <button type="button" onClick={() => setMode('login')} className="text-sm text-muted-foreground hover:text-foreground transition-colors">
                      ← Change number/email
                    </button>
                    <span className="mx-3 text-border">|</span>
                    <button type="button" className="text-sm text-primary font-semibold hover:underline">Resend OTP</button>
                  </div>
                </form>
              ) : (
                <>
                  {/* Tab switcher */}
                  <div className="flex bg-muted rounded-xl p-1 mb-6">
                    <button onClick={() => setMode('login')}
                      className={`flex-1 py-2 rounded-lg text-sm font-semibold transition-all ${mode === 'login' ? 'bg-white shadow-sm text-foreground' : 'text-muted-foreground'}`}>
                      Sign In
                    </button>
                    <button onClick={() => setMode('register')}
                      className={`flex-1 py-2 rounded-lg text-sm font-semibold transition-all ${mode === 'register' ? 'bg-white shadow-sm text-foreground' : 'text-muted-foreground'}`}>
                      Register
                    </button>
                  </div>

                  {/* Login method toggle */}
                  {mode === 'login' && (
                    <div className="flex gap-2 mb-5">
                      <button onClick={() => setLoginMethod('phone')}
                        className={`flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl border text-sm font-medium transition-all ${loginMethod === 'phone' ? 'border-primary bg-primary/5 text-primary' : 'border-border text-muted-foreground'}`}>
                        <Phone size={14} /> Phone
                      </button>
                      <button onClick={() => setLoginMethod('email')}
                        className={`flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl border text-sm font-medium transition-all ${loginMethod === 'email' ? 'border-primary bg-primary/5 text-primary' : 'border-border text-muted-foreground'}`}>
                        <Mail size={14} /> Email
                      </button>
                    </div>
                  )}

                  <form onSubmit={handleSubmit} className="space-y-4">
                    {mode === 'register' && (
                      <div>
                        <label className="block text-sm font-semibold text-foreground mb-1.5">Full Name</label>
                        <div className="relative">
                          <User size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-muted-foreground" />
                          <input type="text" value={name} onChange={e => setName(e.target.value)} placeholder="Your full name" required
                            className="w-full pl-10 pr-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all" />
                        </div>
                      </div>
                    )}

                    {(mode === 'register' || loginMethod === 'phone') && (
                      <div>
                        <label className="block text-sm font-semibold text-foreground mb-1.5">Phone Number</label>
                        <div className="relative">
                          <div className="absolute left-3.5 top-1/2 -translate-y-1/2 flex items-center gap-1.5">
                            <Smartphone size={15} className="text-muted-foreground" />
                            <span className="text-sm text-muted-foreground border-r border-border pr-2">+91</span>
                          </div>
                          <input type="tel" value={phone} onChange={e => setPhone(e.target.value.replace(/\D/g, '').slice(0, 10))} placeholder="10-digit mobile number" required
                            className="w-full pl-20 pr-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all" />
                        </div>
                      </div>
                    )}

                    {(mode === 'register' || loginMethod === 'email') && (
                      <div>
                        <label className="block text-sm font-semibold text-foreground mb-1.5">Email Address</label>
                        <div className="relative">
                          <Mail size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-muted-foreground" />
                          <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="your@email.com" required={loginMethod === 'email' || mode === 'register'}
                            className="w-full pl-10 pr-4 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all" />
                        </div>
                      </div>
                    )}

                    {mode === 'register' && (
                      <div>
                        <label className="block text-sm font-semibold text-foreground mb-1.5">Password</label>
                        <div className="relative">
                          <Lock size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-muted-foreground" />
                          <input type={showPassword ? 'text' : 'password'} value={password} onChange={e => setPassword(e.target.value)} placeholder="Create a strong password" required
                            className="w-full pl-10 pr-10 py-3 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all" />
                          <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3.5 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground">
                            {showPassword ? <EyeOff size={15} /> : <Eye size={15} />}
                          </button>
                        </div>
                      </div>
                    )}

                    <button type="submit" disabled={loading}
                      className="w-full py-3 gradient-green text-white rounded-xl font-semibold shadow-green btn-press disabled:opacity-60 flex items-center justify-center gap-2 mt-2">
                      {loading ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : mode === 'register' ? 'Create Account & Get OTP' : 'Send OTP'}
                    </button>
                  </form>

                  {mode === 'login' && (
                    <p className="text-center text-sm text-muted-foreground mt-4">
                      New to Camsik?{' '}
                      <button onClick={() => setMode('register')} className="text-primary font-semibold hover:underline">Create account</button>
                    </p>
                  )}

                  <div className="mt-5 pt-5 border-t border-border">
                    <p className="text-xs text-muted-foreground text-center leading-relaxed">
                      By continuing, you agree to Camsik&apos;s{' '}
                      <Link href="#terms" className="text-primary hover:underline">Terms of Service</Link> and{' '}
                      <Link href="#privacy" className="text-primary hover:underline">Privacy Policy</Link>
                    </p>
                  </div>
                </>
              )}
            </div>
          </div>
        </div>
      </div>
      <CustomerFooter />
    </main>
  );
}

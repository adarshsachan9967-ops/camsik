'use client';
import React, { useState } from 'react';
import { partners, orders } from '@/lib/casmikData';
import { 
  BarChart3, 
  TrendingUp, 
  Download, 
  Calendar, 
  DollarSign, 
  ShoppingBag, 
  CheckCircle2, 
  ArrowUpRight,
  Filter,
  Clock
} from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar } from 'recharts';

const weeklyRevenue = [
  { day: 'Mon', revenue: 24000, orders: 4 },
  { day: 'Tue', revenue: 38000, orders: 6 },
  { day: 'Wed', revenue: 31000, orders: 5 },
  { day: 'Thu', revenue: 52000, orders: 8 },
  { day: 'Fri', revenue: 64000, orders: 10 },
  { day: 'Sat', revenue: 78000, orders: 12 },
  { day: 'Sun', revenue: 45000, orders: 7 },
];

const categoryBreakdown = [
  { category: 'Smartphones', count: 48, revenue: 1650000 },
  { category: 'MacBooks & Laptops', count: 22, revenue: 1420000 },
  { category: 'DSLR & Mirrorless', count: 18, revenue: 1840000 },
  { category: 'iPads & Tablets', count: 12, revenue: 520000 },
];

export default function PartnerReports() {
  const [timeframe, setTimeframe] = useState<'week' | 'month' | 'quarter'>('month');

  return (
    <div className="space-y-6 w-full max-w-7xl mx-auto font-sans">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-black text-gray-900 flex items-center gap-2">
            Store Performance &amp; Reports
          </h1>
          <p className="text-sm text-gray-500 mt-0.5">
            Real-time analytics on fulfilled orders, commission yield, and category trends.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <div className="flex items-center bg-white border border-gray-200 rounded-xl p-1 shadow-sm text-xs font-bold">
            <button
              onClick={() => setTimeframe('week')}
              className={`px-3 py-1.5 rounded-lg transition-all ${timeframe === 'week' ? 'bg-primary text-white' : 'text-gray-600 hover:text-black'}`}
            >
              This Week
            </button>
            <button
              onClick={() => setTimeframe('month')}
              className={`px-3 py-1.5 rounded-lg transition-all ${timeframe === 'month' ? 'bg-primary text-white' : 'text-gray-600 hover:text-black'}`}
            >
              This Month
            </button>
            <button
              onClick={() => setTimeframe('quarter')}
              className={`px-3 py-1.5 rounded-lg transition-all ${timeframe === 'quarter' ? 'bg-primary text-white' : 'text-gray-600 hover:text-black'}`}
            >
              Quarterly
            </button>
          </div>
          <button
            onClick={() => alert('Financial ledger report downloaded successfully.')}
            className="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-slate-900 text-white hover:bg-slate-800 text-xs font-bold shadow-sm transition-all"
          >
            <Download size={14} /> Export Report
          </button>
        </div>
      </div>

      {/* Summary KPI Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
          <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">Gross Transaction Value</p>
          <p className="text-2xl sm:text-3xl font-black text-gray-900 mt-1">₹54.3L</p>
          <div className="flex items-center gap-1 text-xs text-emerald-600 font-bold mt-2">
            <TrendingUp size={13} />
            <span>+19.4% vs last period</span>
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
          <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">Net Partner Commission</p>
          <p className="text-2xl sm:text-3xl font-black text-emerald-600 mt-1">₹2,44,350</p>
          <div className="flex items-center gap-1 text-xs text-emerald-600 font-bold mt-2">
            <TrendingUp size={13} />
            <span>4.5% flat studio commission</span>
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
          <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">Inspection Pass Rate</p>
          <p className="text-2xl sm:text-3xl font-black text-blue-600 mt-1">94.8%</p>
          <div className="flex items-center gap-1 text-xs text-blue-600 font-bold mt-2">
            <CheckCircle2 size={13} />
            <span>108/114 devices approved</span>
          </div>
        </div>

        <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
          <p className="text-xs font-bold text-gray-400 uppercase tracking-wider">Avg Settlement Time</p>
          <p className="text-2xl sm:text-3xl font-black text-purple-600 mt-1">&lt; 4 Hours</p>
          <div className="flex items-center gap-1 text-xs text-purple-600 font-bold mt-2">
            <Clock size={13} />
            <span>Instant IMPS / UPI transfer</span>
          </div>
        </div>
      </div>

      {/* Visual Charts Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Weekly Throughput */}
        <div className="lg:col-span-7 bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="font-bold text-gray-900">Weekly Payout Flow</h3>
              <p className="text-xs text-gray-400">Daily store transaction volume (INR)</p>
            </div>
            <span className="text-xs font-bold text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-lg border border-emerald-100">
              Avg ₹47.5k/day
            </span>
          </div>
          <ResponsiveContainer width="100%" height={260}>
            <AreaChart data={weeklyRevenue}>
              <defs>
                <linearGradient id="partnerRevGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#16a34a" stopOpacity={0.25} />
                  <stop offset="95%" stopColor="#16a34a" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="day" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} tickFormatter={(v) => `₹${v / 1000}k`} />
              <Tooltip formatter={(v: number) => [`₹${v.toLocaleString('en-IN')}`, 'Daily Volume']} />
              <Area type="monotone" dataKey="revenue" stroke="#16a34a" strokeWidth={3} fill="url(#partnerRevGrad)" dot={{ fill: '#16a34a', r: 4 }} />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Category Share */}
        <div className="lg:col-span-5 bg-white rounded-2xl p-5 border border-gray-100 shadow-sm flex flex-col justify-between">
          <div>
            <h3 className="font-bold text-gray-900 mb-1">Category Revenue Breakdown</h3>
            <p className="text-xs text-gray-400 mb-4">Volume by product vertical</p>
            <div className="space-y-3.5">
              {categoryBreakdown.map((cat) => (
                <div key={cat.category} className="p-2.5 rounded-xl bg-gray-50/70 border border-gray-100">
                  <div className="flex justify-between text-xs font-bold mb-1">
                    <span className="text-gray-800">{cat.category}</span>
                    <span className="text-gray-900">₹{(cat.revenue / 100000).toFixed(1)}L ({cat.count} units)</span>
                  </div>
                  <div className="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
                    <div
                      className="h-full bg-primary rounded-full"
                      style={{ width: `${Math.round((cat.revenue / 5430000) * 100)}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="mt-4 pt-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
            <span>Next Payout Cycle: <strong>Tomorrow 10:00 AM</strong></span>
            <span className="text-primary font-bold">Automatic Settlement</span>
          </div>
        </div>
      </div>
    </div>
  );
}

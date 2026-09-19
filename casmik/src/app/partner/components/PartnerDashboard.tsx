'use client';
import React, { useState } from 'react';
import { orders, partners } from '@/lib/casmikData';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const partner = partners[1] || partners[0] || {
  totalEarnings: 385000,
  totalOrders: 420,
  commission: 4.5,
  pendingPayout: 18500,
};

const earningsData = [
  { day: '06 May', earnings: 8200 },
  { day: '07 May', earnings: 9500 },
  { day: '08 May', earnings: 11200 },
  { day: '09 May', earnings: 10800 },
  { day: '10 May', earnings: 14850 },
  { day: '11 May', earnings: 13200 },
  { day: '12 May', earnings: 15000 },
];

const topCategories = [
  { name: 'Mobile Phones', pct: 62, count: 78, color: 'bg-green-500' },
  { name: 'Laptops & MacBooks', pct: 18, count: 23, color: 'bg-blue-500' },
  { name: 'DSLR & Cameras', pct: 12, count: 16, color: 'bg-purple-500' },
  { name: 'iPads & Tablets', pct: 6, count: 8, color: 'bg-orange-500' },
  { name: 'Accessories', pct: 2, count: 3, color: 'bg-gray-400' },
];

const recentOrders = orders.slice(0, 4);

interface PartnerDashboardProps {
  onNavigate?: (section: any) => void;
}

export default function PartnerDashboard({ onNavigate }: PartnerDashboardProps = {}) {
  const [dateRange, setDateRange] = useState('This Week');

  const kpis = [
    { label: 'TOTAL EARNINGS', value: `₹${partner.totalEarnings.toLocaleString('en-IN')}`, sub: '↑ 18.6% vs last week', icon: '💰', color: 'text-green-600', action: () => onNavigate?.('payouts') },
    { label: 'TOTAL ORDERS', value: partner.totalOrders.toString(), sub: '↑ 12.4% vs last week', icon: '🛒', color: 'text-blue-600', action: () => onNavigate?.('orders') },
    { label: 'TOTAL COMMISSION', value: `₹${Math.round(partner.totalEarnings * partner.commission / 100).toLocaleString('en-IN')}`, sub: '↑ 15.3% vs last week', icon: '🏅', color: 'text-yellow-600', action: () => onNavigate?.('reports') },
    { label: 'PRODUCTS SOLD', value: '156', sub: '↑ 10.7% vs last week', icon: '📦', color: 'text-purple-600', action: () => onNavigate?.('orders') },
    { label: 'PENDING PAYOUT', value: `₹${partner.pendingPayout.toLocaleString('en-IN')}`, sub: 'Will be paid on 15 May 2025', icon: '⏳', color: 'text-orange-600', action: () => onNavigate?.('payouts') },
  ];

  return (
    <div className="space-y-5 w-full max-w-7xl mx-auto font-sans">
      {/* Welcome */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl sm:text-2xl font-black text-gray-900">Welcome back, MobileHub Store! 👋</h2>
          <p className="text-xs sm:text-sm text-gray-500">Here&apos;s what&apos;s happening with your business today.</p>
        </div>
        <div className="flex items-center gap-2 bg-white border border-gray-200 rounded-xl px-3 py-2 text-sm shadow-sm self-start sm:self-auto">
          <span className="text-gray-500">📅</span>
          <select value={dateRange} onChange={e => setDateRange(e.target.value)} className="text-xs sm:text-sm font-semibold text-gray-700 bg-transparent focus:outline-none">
            <option>This Week</option>
            <option>This Month</option>
            <option>Last Month</option>
          </select>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
        {kpis.map((kpi) => (
          <div
            key={kpi.label}
            onClick={kpi.action}
            className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4 hover:shadow-md hover:border-primary/40 cursor-pointer transition-all hover:scale-[1.02]"
            title={`Click to view details in ${kpi.label}`}
          >
            <div className="flex items-center justify-between mb-2">
              <p className="text-xs font-bold text-gray-400 uppercase tracking-wide leading-tight">{kpi.label}</p>
              <span className="text-xl">{kpi.icon}</span>
            </div>
            <p className={`text-xl font-black ${kpi.color}`}>{kpi.value}</p>
            <p className="text-xs text-green-600 font-semibold mt-0.5">{kpi.sub}</p>
          </div>
        ))}
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
        {/* Earnings Chart */}
        <div className="lg:col-span-2 bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex flex-col justify-between">
          <div className="flex items-center justify-between mb-4 flex-wrap gap-2">
            <h3 className="font-bold text-gray-900 uppercase text-xs sm:text-sm tracking-wide">Earnings Overview</h3>
            <button
              onClick={() => onNavigate?.('reports')}
              className="text-xs font-bold text-primary hover:underline bg-primary/10 px-2.5 py-1 rounded-lg"
            >
              Full Analytics Report &rarr;
            </button>
          </div>
          <ResponsiveContainer width="100%" height={220}>
            <AreaChart data={earningsData}>
              <defs>
                <linearGradient id="earnGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#16a34a" stopOpacity={0.2} />
                  <stop offset="95%" stopColor="#16a34a" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="day" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} tickFormatter={v => `₹${v / 1000}K`} />
              <Tooltip formatter={(v: number) => [`₹${v.toLocaleString('en-IN')}`, 'Earnings']} />
              <Area type="monotone" dataKey="earnings" stroke="#16a34a" strokeWidth={2.5} fill="url(#earnGrad)" dot={{ fill: '#16a34a', r: 5, strokeWidth: 2, stroke: '#fff' }} activeDot={{ r: 7 }} />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Top Categories */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex flex-col justify-between">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-bold text-gray-900 uppercase text-xs sm:text-sm tracking-wide">Top Selling Categories</h3>
            <span
              onClick={() => onNavigate?.('reports')}
              className="text-xs text-primary font-bold cursor-pointer hover:underline"
            >
              View All
            </span>
          </div>
          <div className="space-y-3">
            {topCategories.map((cat) => (
              <div key={cat.name}>
                <div className="flex items-center justify-between text-xs mb-1">
                  <div className="flex items-center gap-2">
                    <div className={`w-2 h-2 rounded-full ${cat.color}`} />
                    <span className="font-semibold text-gray-700">{cat.name}</span>
                  </div>
                  <span className="font-bold text-gray-900">{cat.pct}% ({cat.count})</span>
                </div>
                <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                  <div className={`h-full rounded-full ${cat.color}`} style={{ width: `${cat.pct}%` }} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Bottom Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
        {/* Recent Orders */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-bold text-gray-900 uppercase text-xs sm:text-sm tracking-wide">Recent Orders</h3>
            <span
              onClick={() => onNavigate?.('orders')}
              className="text-xs text-primary font-bold cursor-pointer hover:underline"
            >
              View All &rarr;
            </span>
          </div>
          <div className="space-y-3">
            {recentOrders.map((order) => (
              <div
                key={order.id}
                onClick={() => onNavigate?.('orders')}
                className="flex items-center justify-between py-2.5 border-b border-gray-50 last:border-0 hover:bg-gray-50 px-2 rounded-xl cursor-pointer transition-colors"
              >
                <div>
                  <p className="text-sm font-bold text-gray-900">{order.deviceName.split(' ').slice(0, 4).join(' ')}</p>
                  <p className="text-xs text-gray-400">ID: {order.orderNumber} · {new Date(order.createdAt).toLocaleDateString('en-IN')}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm font-black text-gray-900">₹{order.quotedPrice.toLocaleString('en-IN')}</p>
                  <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${order.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>
                    {order.status.replace(/_/g, ' ')}
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Payout Overview + Account Summary */}
        <div className="space-y-4">
          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <div className="flex items-center justify-between mb-3">
              <h3 className="font-bold text-gray-900 uppercase text-xs sm:text-sm tracking-wide">Payout Overview</h3>
              <span
                onClick={() => onNavigate?.('payouts')}
                className="text-xs text-primary font-bold cursor-pointer hover:underline"
              >
                View Ledger &rarr;
              </span>
            </div>
            <div className="flex items-center justify-between mb-3 flex-wrap gap-2">
              <div>
                <p className="text-xs text-gray-500">AVAILABLE BALANCE</p>
                <p className="text-2xl font-black text-gray-900">₹{partner.availableBalance.toLocaleString('en-IN')}</p>
              </div>
              <button
                onClick={() => onNavigate?.('payouts')}
                className="px-4 py-2 bg-primary text-white rounded-xl text-sm font-bold hover:bg-primary/90 shadow-lg shadow-primary/20"
              >
                Request Payout
              </button>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div className="bg-green-50 rounded-xl p-3">
                <p className="text-xs text-gray-500">Total Paid</p>
                <p className="text-sm font-black text-green-700">₹{(partner.totalEarnings - partner.pendingPayout).toLocaleString('en-IN')}</p>
              </div>
              <div className="bg-orange-50 rounded-xl p-3">
                <p className="text-xs text-gray-500">Pending</p>
                <p className="text-sm font-black text-orange-700">₹{partner.pendingPayout.toLocaleString('en-IN')}</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
            <h3 className="font-bold text-gray-900 uppercase text-xs sm:text-sm tracking-wide mb-3">Account Summary</h3>
            <div className="space-y-2">
              {[
                { label: 'Partner Name', value: partner.storeName },
                { label: 'Partner ID', value: 'CFN12345' },
                { label: 'City', value: partner.city },
                { label: 'Commission Rate', value: `${partner.commission}%` },
                { label: 'Rating', value: `⭐ ${partner.rating}/5` },
                { label: 'Member Since', value: new Date(partner.joinedAt).toLocaleDateString('en-IN', { month: 'short', year: 'numeric' }) },
              ].map(item => (
                <div key={item.label} className="flex justify-between text-xs">
                  <span className="text-gray-500">{item.label}</span>
                  <span className="font-bold text-gray-900">{item.value}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

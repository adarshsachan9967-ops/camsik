'use client';
import React from 'react';
import { deliveryAgents } from '@/lib/casmikData';
import { TrendingUp, Star, Download } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const agent = deliveryAgents[0];

const weeklyData = [
  { day: 'Mon', deliveries: 8, earnings: 640 },
  { day: 'Tue', deliveries: 12, earnings: 960 },
  { day: 'Wed', deliveries: 10, earnings: 800 },
  { day: 'Thu', deliveries: 15, earnings: 1200 },
  { day: 'Fri', deliveries: 11, earnings: 880 },
  { day: 'Sat', deliveries: 18, earnings: 1440 },
  { day: 'Sun', deliveries: 14, earnings: 1120 },
];

const incentives = [
  { label: 'Base Pay', amount: 1850, desc: '37 deliveries × ₹50' },
  { label: 'Peak Hour Bonus', amount: 350, desc: '7 peak deliveries × ₹50' },
  { label: 'Rating Bonus', amount: 200, desc: '4.9 rating bonus' },
  { label: 'Attendance Bonus', amount: 100, desc: 'Full week attendance' },
];

export default function DeliveryEarnings() {
  const totalToday = incentives.reduce((s, i) => s + i.amount, 0);

  return (
    <div className="space-y-5 max-w-2xl mx-auto">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black text-gray-900">Earnings</h2>
          <p className="text-sm text-gray-500">Track your daily and weekly earnings</p>
        </div>
        <button className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
          <Download size={13} /> Statement
        </button>
      </div>

      {/* Today's Earnings */}
      <div className="bg-gradient-to-r from-primary to-green-600 rounded-2xl p-5 text-white">
        <p className="text-sm font-semibold text-white/70 mb-1">Today&apos;s Earnings</p>
        <p className="text-4xl font-black mb-1">₹{totalToday.toLocaleString('en-IN')}</p>
        <p className="text-sm text-white/70">{agent.todayPickups + agent.todayDeliveries} tasks completed</p>
        <div className="flex items-center gap-2 mt-3">
          <TrendingUp size={14} className="text-green-300" />
          <span className="text-sm font-semibold text-green-300">+23% vs yesterday</span>
        </div>
      </div>

      {/* Incentive Breakdown */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        <div className="px-4 py-3 border-b border-gray-50">
          <h3 className="font-bold text-gray-900">Today&apos;s Breakdown</h3>
        </div>
        <div className="divide-y divide-gray-50">
          {incentives.map((item) => (
            <div key={item.label} className="flex items-center justify-between px-4 py-3">
              <div>
                <p className="text-sm font-semibold text-gray-900">{item.label}</p>
                <p className="text-xs text-gray-400">{item.desc}</p>
              </div>
              <p className="text-sm font-black text-green-700">+₹{item.amount}</p>
            </div>
          ))}
          <div className="flex items-center justify-between px-4 py-3 bg-green-50">
            <p className="font-black text-gray-900">Total</p>
            <p className="text-lg font-black text-green-700">₹{totalToday.toLocaleString('en-IN')}</p>
          </div>
        </div>
      </div>

      {/* Weekly Chart */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
        <h3 className="font-bold text-gray-900 mb-4">This Week</h3>
        <ResponsiveContainer width="100%" height={180}>
          <BarChart data={weeklyData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="day" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
            <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} tickFormatter={v => `₹${v}`} />
            <Tooltip formatter={(v: number) => [`₹${v}`, 'Earnings']} />
            <Bar dataKey="earnings" fill="#16a34a" radius={[6, 6, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
        <div className="grid grid-cols-3 gap-3 mt-4">
          <div className="bg-gray-50 rounded-xl p-3 text-center">
            <p className="text-lg font-black text-gray-900">{weeklyData.reduce((s, d) => s + d.deliveries, 0)}</p>
            <p className="text-xs text-gray-500">Deliveries</p>
          </div>
          <div className="bg-gray-50 rounded-xl p-3 text-center">
            <p className="text-lg font-black text-green-700">₹{weeklyData.reduce((s, d) => s + d.earnings, 0).toLocaleString('en-IN')}</p>
            <p className="text-xs text-gray-500">Total Earned</p>
          </div>
          <div className="bg-gray-50 rounded-xl p-3 text-center">
            <p className="text-lg font-black text-yellow-600 flex items-center justify-center gap-1"><Star size={14} className="fill-yellow-400 text-yellow-400" />{agent.rating}</p>
            <p className="text-xs text-gray-500">Avg Rating</p>
          </div>
        </div>
      </div>

      {/* Performance Stats */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
        <h3 className="font-bold text-gray-900 mb-4">All-Time Performance</h3>
        <div className="grid grid-cols-2 gap-4">
          {[
            { label: 'Total Deliveries', value: agent.totalDeliveries, color: 'text-blue-600' },
            { label: 'Total Earnings', value: `₹${(agent.totalDeliveries * 80).toLocaleString('en-IN')}`, color: 'text-green-600' },
            { label: 'Avg Rating', value: `${agent.rating}/5`, color: 'text-yellow-600' },
            { label: 'On-time Rate', value: '98%', color: 'text-purple-600' },
          ].map(stat => (
            <div key={stat.label} className="bg-gray-50 rounded-xl p-3">
              <p className={`text-xl font-black ${stat.color}`}>{stat.value}</p>
              <p className="text-xs text-gray-500">{stat.label}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

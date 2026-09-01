'use client';
import React, { useState } from 'react';
import { partners, deliveryAgents, orders } from '@/lib/casmikData';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line, PieChart, Pie, Cell } from 'recharts';
import { Download, TrendingUp, Package, Star, CheckCircle } from 'lucide-react';

const monthlyData = [
  { month: 'Jul', orders: 42, revenue: 285000, completed: 38 },
  { month: 'Aug', orders: 58, revenue: 412000, completed: 52 },
  { month: 'Sep', orders: 71, revenue: 538000, completed: 65 },
  { month: 'Oct', orders: 85, revenue: 624000, completed: 78 },
  { month: 'Nov', orders: 94, revenue: 712000, completed: 88 },
  { month: 'Dec', orders: 112, revenue: 892000, completed: 105 },
];

const COLORS = ['#22c55e', '#3b82f6', '#8b5cf6', '#f59e0b', '#ef4444'];

export default function AdminReports() {
  const [activeTab, setActiveTab] = useState<'partners' | 'delivery' | 'orders'>('partners');
  const [dateRange, setDateRange] = useState('last30');

  const partnerStats = partners.map(p => ({
    ...p,
    completionRate: p.totalOrders > 0 ? Math.round((p.completedOrders / p.totalOrders) * 100) : 0,
    avgOrderValue: p.totalOrders > 0 ? Math.round(p.totalEarnings / p.totalOrders) : 0,
  }));

  const agentStats = deliveryAgents.map(a => ({
    ...a,
    successRate: a.totalDeliveries > 0 ? Math.round(((a.totalDeliveries - Math.floor(a.totalDeliveries * 0.05)) / a.totalDeliveries) * 100) : 0,
    avgDailyDeliveries: Math.round(a.totalDeliveries / 180),
  }));

  const orderTypeData = [
    { name: 'Sell', value: orders.filter(o => o.type === 'sell').length },
    { name: 'Buy', value: orders.filter(o => o.type === 'buy').length },
    { name: 'Exchange', value: orders.filter(o => o.type === 'exchange').length },
    { name: 'Repair', value: orders.filter(o => o.type === 'repair').length },
  ];

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black text-gray-900">Reports & Analytics</h2>
          <p className="text-sm text-gray-500">Detailed performance reports for partners and delivery agents</p>
        </div>
        <div className="flex items-center gap-3">
          <select value={dateRange} onChange={e => setDateRange(e.target.value)}
            className="px-3 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none bg-white">
            <option value="last7">Last 7 days</option>
            <option value="last30">Last 30 days</option>
            <option value="last90">Last 90 days</option>
            <option value="thisYear">This Year</option>
          </select>
          <button className="flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-xl text-sm font-semibold hover:bg-gray-200">
            <Download size={14} /> Export
          </button>
        </div>
      </div>

      {/* Overview KPIs */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: 'Total Revenue', value: '₹8.92L', change: '+18%', icon: '💰', color: 'bg-green-50 text-green-700' },
          { label: 'Total Orders', value: '112', change: '+19%', icon: '📦', color: 'bg-blue-50 text-blue-700' },
          { label: 'Active Partners', value: '4', change: '+0%', icon: '🤝', color: 'bg-purple-50 text-purple-700' },
          { label: 'Delivery Agents', value: '5', change: '+25%', icon: '🚚', color: 'bg-orange-50 text-orange-700' },
        ].map(kpi => (
          <div key={kpi.label} className={`${kpi.color} rounded-2xl p-4 border border-white`}>
            <div className="flex items-center justify-between mb-2">
              <span className="text-2xl">{kpi.icon}</span>
              <span className="text-xs font-bold text-green-600 bg-green-100 px-2 py-0.5 rounded-full">{kpi.change}</span>
            </div>
            <p className="text-2xl font-black">{kpi.value}</p>
            <p className="text-xs font-semibold opacity-80 mt-0.5">{kpi.label}</p>
          </div>
        ))}
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-3 gap-4">
        <div className="col-span-2 bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
          <h3 className="font-bold text-gray-900 mb-4">Monthly Revenue & Orders</h3>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={monthlyData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="month" tick={{ fontSize: 11 }} />
              <YAxis tick={{ fontSize: 11 }} />
              <Tooltip formatter={(v: number, n: string) => [n === 'revenue' ? `₹${v.toLocaleString('en-IN')}` : v, n === 'revenue' ? 'Revenue' : 'Orders']} />
              <Bar dataKey="orders" fill="#22c55e" radius={[4, 4, 0, 0]} />
              <Bar dataKey="completed" fill="#86efac" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
          <h3 className="font-bold text-gray-900 mb-4">Order Types</h3>
          <ResponsiveContainer width="100%" height={160}>
            <PieChart>
              <Pie data={orderTypeData} cx="50%" cy="50%" innerRadius={45} outerRadius={70} dataKey="value">
                {orderTypeData.map((_, i) => <Cell key={i} fill={COLORS[i]} />)}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
          <div className="space-y-1.5 mt-2">
            {orderTypeData.map((d, i) => (
              <div key={d.name} className="flex items-center justify-between text-xs">
                <div className="flex items-center gap-1.5">
                  <div className="w-2.5 h-2.5 rounded-full" style={{ background: COLORS[i] }} />
                  <span className="text-gray-600">{d.name}</span>
                </div>
                <span className="font-bold text-gray-900">{d.value}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit">
        {[
          { key: 'partners', label: 'Partner Reports' },
          { key: 'delivery', label: 'Delivery Reports' },
          { key: 'orders', label: 'Order Reports' },
        ].map(tab => (
          <button key={tab.key} onClick={() => setActiveTab(tab.key as typeof activeTab)}
            className={`px-4 py-2 rounded-lg text-xs font-bold transition-all ${activeTab === tab.key ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}>
            {tab.label}
          </button>
        ))}
      </div>

      {/* Partner Reports */}
      {activeTab === 'partners' && (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-50 flex items-center justify-between">
            <h3 className="font-bold text-gray-900">Partner Performance Report</h3>
            <button className="flex items-center gap-1.5 text-xs text-gray-500 hover:text-primary font-semibold">
              <Download size={13} /> Export CSV
            </button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-gray-50 border-b border-gray-100">
                  <th className="text-left px-5 py-3 text-xs font-bold text-gray-500 uppercase">Partner</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">City</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Total Orders</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Completed</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Completion %</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Total Earnings</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Avg Order Value</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Rating</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {partnerStats.map(p => (
                  <tr key={p.id} className="hover:bg-gray-50/50">
                    <td className="px-5 py-3.5">
                      <div className="flex items-center gap-2">
                        <img src={p.avatar} alt={p.name} className="w-8 h-8 rounded-lg object-cover" />
                        <div>
                          <p className="font-bold text-gray-900 text-xs">{p.storeName}</p>
                          <p className="text-xs text-gray-400">{p.name}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-3.5 text-xs text-gray-600">{p.city}</td>
                    <td className="px-4 py-3.5 text-xs font-bold text-gray-900">{p.totalOrders}</td>
                    <td className="px-4 py-3.5 text-xs font-bold text-green-700">{p.completedOrders}</td>
                    <td className="px-4 py-3.5">
                      <div className="flex items-center gap-2">
                        <div className="flex-1 bg-gray-100 rounded-full h-1.5 w-16">
                          <div className="bg-green-500 h-1.5 rounded-full" style={{ width: `${p.completionRate}%` }} />
                        </div>
                        <span className="text-xs font-bold text-gray-700">{p.completionRate}%</span>
                      </div>
                    </td>
                    <td className="px-4 py-3.5 text-xs font-bold text-gray-900">₹{p.totalEarnings.toLocaleString('en-IN')}</td>
                    <td className="px-4 py-3.5 text-xs font-bold text-gray-700">₹{p.avgOrderValue.toLocaleString('en-IN')}</td>
                    <td className="px-4 py-3.5">
                      <div className="flex items-center gap-1 text-xs font-bold text-yellow-600">
                        <Star size={11} className="fill-yellow-400 text-yellow-400" />
                        {p.rating || 'N/A'}
                      </div>
                    </td>
                    <td className="px-4 py-3.5">
                      <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${p.status === 'active' ? 'bg-green-100 text-green-700' : p.status === 'pending' ? 'bg-yellow-100 text-yellow-700' : 'bg-gray-100 text-gray-600'}`}>
                        {p.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Delivery Reports */}
      {activeTab === 'delivery' && (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-50 flex items-center justify-between">
            <h3 className="font-bold text-gray-900">Delivery Agent Performance Report</h3>
            <button className="flex items-center gap-1.5 text-xs text-gray-500 hover:text-primary font-semibold">
              <Download size={13} /> Export CSV
            </button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-gray-50 border-b border-gray-100">
                  <th className="text-left px-5 py-3 text-xs font-bold text-gray-500 uppercase">Agent</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">City</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Status</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Today Pickups</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Today Deliveries</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Total Deliveries</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Success Rate</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Today Earnings</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Rating</th>
                  <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase">Vehicle</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {agentStats.map(a => (
                  <tr key={a.id} className="hover:bg-gray-50/50">
                    <td className="px-5 py-3.5">
                      <div className="flex items-center gap-2">
                        <img src={a.avatar} alt={a.name} className="w-8 h-8 rounded-lg object-cover" />
                        <div>
                          <p className="font-bold text-gray-900 text-xs">{a.name}</p>
                          <p className="text-xs text-gray-400">{a.phone}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-3.5 text-xs text-gray-600">{a.city}</td>
                    <td className="px-4 py-3.5">
                      <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${a.status === 'online' ? 'bg-green-100 text-green-700' : a.status === 'on_trip' ? 'bg-blue-100 text-blue-700' : 'bg-gray-100 text-gray-600'}`}>
                        {a.status.replace('_', ' ')}
                      </span>
                    </td>
                    <td className="px-4 py-3.5 text-xs font-bold text-gray-900">{a.todayPickups}</td>
                    <td className="px-4 py-3.5 text-xs font-bold text-gray-900">{a.todayDeliveries}</td>
                    <td className="px-4 py-3.5 text-xs font-bold text-gray-900">{a.totalDeliveries}</td>
                    <td className="px-4 py-3.5">
                      <div className="flex items-center gap-2">
                        <div className="flex-1 bg-gray-100 rounded-full h-1.5 w-16">
                          <div className="bg-green-500 h-1.5 rounded-full" style={{ width: `${a.successRate}%` }} />
                        </div>
                        <span className="text-xs font-bold text-gray-700">{a.successRate}%</span>
                      </div>
                    </td>
                    <td className="px-4 py-3.5 text-xs font-bold text-green-700">₹{a.earnings.toLocaleString('en-IN')}</td>
                    <td className="px-4 py-3.5">
                      <div className="flex items-center gap-1 text-xs font-bold text-yellow-600">
                        <Star size={11} className="fill-yellow-400 text-yellow-400" />
                        {a.rating}
                      </div>
                    </td>
                    <td className="px-4 py-3.5 text-xs text-gray-600">{a.vehicle} · {a.vehicleNumber}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Order Reports */}
      {activeTab === 'orders' && (
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
          <div className="px-5 py-4 border-b border-gray-50">
            <h3 className="font-bold text-gray-900">Order Summary Report</h3>
          </div>
          <div className="p-5">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-5">
              {[
                { label: 'Total Orders', value: orders.length, icon: <Package size={18} className="text-blue-600" />, bg: 'bg-blue-50' },
                { label: 'Completed', value: orders.filter(o => o.status === 'completed').length, icon: <CheckCircle size={18} className="text-green-600" />, bg: 'bg-green-50' },
                { label: 'Total Revenue', value: `₹${orders.reduce((s, o) => s + (o.finalPrice || o.quotedPrice), 0).toLocaleString('en-IN')}`, icon: <TrendingUp size={18} className="text-purple-600" />, bg: 'bg-purple-50' },
                { label: 'Avg Order Value', value: `₹${Math.round(orders.reduce((s, o) => s + o.quotedPrice, 0) / orders.length).toLocaleString('en-IN')}`, icon: <Star size={18} className="text-yellow-600" />, bg: 'bg-yellow-50' },
              ].map(kpi => (
                <div key={kpi.label} className={`${kpi.bg} rounded-xl p-4`}>
                  <div className="mb-2">{kpi.icon}</div>
                  <p className="text-xl font-black text-gray-900">{kpi.value}</p>
                  <p className="text-xs text-gray-600 mt-0.5">{kpi.label}</p>
                </div>
              ))}
            </div>
            <ResponsiveContainer width="100%" height={200}>
              <LineChart data={monthlyData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                <XAxis dataKey="month" tick={{ fontSize: 11 }} />
                <YAxis tick={{ fontSize: 11 }} />
                <Tooltip />
                <Line type="monotone" dataKey="orders" stroke="#22c55e" strokeWidth={2} dot={{ r: 4 }} />
                <Line type="monotone" dataKey="completed" stroke="#3b82f6" strokeWidth={2} dot={{ r: 4 }} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        </div>
      )}
    </div>
  );
}

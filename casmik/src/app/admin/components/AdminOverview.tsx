'use client';
import React from 'react';
import { orders, partners, deliveryAgents, customers } from '@/lib/casmikData';
import { TrendingUp, TrendingDown, ShoppingBag, Users, Handshake, Truck, DollarSign, CheckCircle, Clock, Zap } from 'lucide-react';
import { XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, AreaChart, Area } from 'recharts';

const revenueData = [
  { day: 'Mon', revenue: 125000, orders: 18 },
  { day: 'Tue', revenue: 148000, orders: 22 },
  { day: 'Wed', revenue: 132000, orders: 19 },
  { day: 'Thu', revenue: 165000, orders: 26 },
  { day: 'Fri', revenue: 189000, orders: 31 },
  { day: 'Sat', revenue: 210000, orders: 35 },
  { day: 'Sun', revenue: 178000, orders: 28 },
];

const categoryData = [
  { name: 'Smartphones', value: 62 },
  { name: 'Laptops', value: 18 },
  { name: 'Tablets', value: 10 },
  { name: 'Smartwatches', value: 6 },
  { name: 'Others', value: 4 },
];

export default function AdminOverview() {
  const totalRevenue = orders.filter(o => o.paymentStatus === 'paid').reduce((s, o) => s + o.finalPrice, 0);
  const completedOrders = orders.filter(o => o.status === 'completed').length;
  const pendingOrders = orders.filter(o => ['created', 'assigned', 'accepted', 'pickup_scheduled'].includes(o.status)).length;
  const activePartners = partners.filter(p => p.status === 'active').length;

  const kpis = [
    { label: 'Total Revenue', value: `₹${(totalRevenue / 100000).toFixed(1)}L`, sub: '+18.6% vs last week', icon: DollarSign, color: 'bg-green-50 text-green-600', trend: 'up' },
    { label: 'Total Orders', value: orders.length.toString(), sub: '+12.4% vs last week', icon: ShoppingBag, color: 'bg-blue-50 text-blue-600', trend: 'up' },
    { label: 'Completed', value: completedOrders.toString(), sub: `${Math.round(completedOrders / orders.length * 100)}% completion rate`, icon: CheckCircle, color: 'bg-emerald-50 text-emerald-600', trend: 'up' },
    { label: 'Pending', value: pendingOrders.toString(), sub: 'Needs attention', icon: Clock, color: 'bg-yellow-50 text-yellow-600', trend: 'neutral' },
    { label: 'Active Partners', value: activePartners.toString(), sub: `${partners.filter(p => p.status === 'pending').length} pending approval`, icon: Handshake, color: 'bg-purple-50 text-purple-600', trend: 'up' },
    { label: 'Delivery Agents', value: deliveryAgents.length.toString(), sub: `${deliveryAgents.filter(d => d.status === 'online').length} online now`, icon: Truck, color: 'bg-cyan-50 text-cyan-600', trend: 'up' },
    { label: 'Customers', value: `${customers.length}+`, sub: 'Registered users', icon: Users, color: 'bg-indigo-50 text-indigo-600', trend: 'up' },
    { label: 'Pending Payouts', value: `₹${(partners.reduce((s, p) => s + p.pendingPayout, 0) / 1000).toFixed(0)}K`, sub: 'Due to partners', icon: Zap, color: 'bg-orange-50 text-orange-600', trend: 'neutral' },
  ];

  const recentOrders = orders.slice(0, 8);

  return (
    <div className="space-y-6">
      {/* KPI Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {kpis.map((kpi) => (
          <div key={kpi.label} className="bg-white rounded-2xl p-4 border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-start justify-between mb-3">
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${kpi.color}`}>
                <kpi.icon size={18} />
              </div>
              {kpi.trend === 'up' && <TrendingUp size={14} className="text-green-500 mt-1" />}
              {kpi.trend === 'down' && <TrendingDown size={14} className="text-red-500 mt-1" />}
            </div>
            <p className="text-2xl font-black text-gray-900">{kpi.value}</p>
            <p className="text-xs font-semibold text-gray-500 mt-0.5">{kpi.label}</p>
            <p className="text-xs text-gray-400 mt-0.5">{kpi.sub}</p>
          </div>
        ))}
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Revenue Chart */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="font-bold text-gray-900">Revenue Overview</h3>
              <p className="text-xs text-gray-500">This week</p>
            </div>
            <span className="text-xs font-bold text-green-600 bg-green-50 px-2 py-1 rounded-lg">+18.6% ↑</span>
          </div>
          <ResponsiveContainer width="100%" height={200}>
            <AreaChart data={revenueData}>
              <defs>
                <linearGradient id="revGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#16a34a" stopOpacity={0.15} />
                  <stop offset="95%" stopColor="#16a34a" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="day" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} tickFormatter={v => `₹${v / 1000}K`} />
              <Tooltip formatter={(v: number) => [`₹${v.toLocaleString('en-IN')}`, 'Revenue']} />
              <Area type="monotone" dataKey="revenue" stroke="#16a34a" strokeWidth={2.5} fill="url(#revGrad)" dot={{ fill: '#16a34a', r: 4 }} />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Category Breakdown */}
        <div className="bg-white rounded-2xl p-5 border border-gray-100 shadow-sm">
          <h3 className="font-bold text-gray-900 mb-4">Top Categories</h3>
          <div className="space-y-3">
            {categoryData.map((cat, i) => {
              const colors = ['bg-green-500', 'bg-blue-500', 'bg-purple-500', 'bg-orange-500', 'bg-gray-400'];
              return (
                <div key={cat.name}>
                  <div className="flex justify-between text-xs mb-1">
                    <span className="font-medium text-gray-700">{cat.name}</span>
                    <span className="font-bold text-gray-900">{cat.value}%</span>
                  </div>
                  <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                    <div className={`h-full rounded-full ${colors[i]}`} style={{ width: `${cat.value}%` }} />
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Recent Orders */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        <div className="flex items-center justify-between px-5 py-4 border-b border-gray-50">
          <h3 className="font-bold text-gray-900">Recent Orders</h3>
          <span className="text-xs text-primary font-semibold cursor-pointer hover:underline">View All →</span>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-gray-50">
                <th className="text-left px-5 py-3 text-xs font-bold text-gray-500 uppercase tracking-wide">Order</th>
                <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase tracking-wide">Customer</th>
                <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase tracking-wide">Device</th>
                <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase tracking-wide">Type</th>
                <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase tracking-wide">Amount</th>
                <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase tracking-wide">Status</th>
                <th className="text-left px-4 py-3 text-xs font-bold text-gray-500 uppercase tracking-wide">Partner</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {recentOrders.map((order) => (
                <tr key={order.id} className="hover:bg-gray-50/50 transition-colors">
                  <td className="px-5 py-3.5">
                    <p className="font-bold text-gray-900 text-xs">{order.orderNumber}</p>
                    <p className="text-xs text-gray-400">{new Date(order.createdAt).toLocaleDateString('en-IN')}</p>
                  </td>
                  <td className="px-4 py-3.5">
                    <p className="font-semibold text-gray-800 text-xs">{order.customerName}</p>
                    <p className="text-xs text-gray-400">{order.city}</p>
                  </td>
                  <td className="px-4 py-3.5 max-w-[140px]">
                    <p className="text-xs text-gray-700 truncate">{order.deviceName}</p>
                  </td>
                  <td className="px-4 py-3.5">
                    <span className={`text-xs font-bold px-2 py-1 rounded-lg capitalize ${
                      order.type === 'sell' ? 'bg-green-50 text-green-700' :
                      order.type === 'buy' ? 'bg-blue-50 text-blue-700' :
                      order.type === 'exchange'? 'bg-purple-50 text-purple-700' : 'bg-orange-50 text-orange-700'
                    }`}>{order.type}</span>
                  </td>
                  <td className="px-4 py-3.5">
                    <p className="font-bold text-gray-900 text-xs">₹{(order.quotedPrice).toLocaleString('en-IN')}</p>
                  </td>
                  <td className="px-4 py-3.5">
                    <span className={`text-xs font-semibold px-2 py-1 rounded-lg ${
                      order.status === 'completed' ? 'bg-green-100 text-green-800' :
                      order.status === 'created' ? 'bg-blue-50 text-blue-700' :
                      order.status === 'inspection'? 'bg-yellow-50 text-yellow-700' : 'bg-gray-100 text-gray-600'
                    }`}>{order.status.replace(/_/g, ' ')}</span>
                  </td>
                  <td className="px-4 py-3.5">
                    <p className="text-xs text-gray-600">{order.partnerName || <span className="text-red-500 font-semibold">Unassigned</span>}</p>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

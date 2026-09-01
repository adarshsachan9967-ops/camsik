'use client';
import React from 'react';
import { orders, deliveryAgents } from '@/lib/casmikData';
import { MapPin, Package, CheckCircle, Clock, Star, Truck } from 'lucide-react';

const agent = deliveryAgents?.[0];
const myTasks = orders?.filter(o => o?.deliveryAgentId === 'delivery-001');
const todayPickups = myTasks?.filter(o => ['assigned', 'accepted', 'pickup_scheduled']?.includes(o?.status));
const todayDeliveries = myTasks?.filter(o => ['picked_up', 'inspection']?.includes(o?.status));
const completed = myTasks?.filter(o => o?.status === 'completed');

export default function DeliveryDashboard() {
  return (
    <div className="space-y-5 max-w-2xl mx-auto">
      {/* Agent Card */}
      <div className="bg-gradient-to-r from-primary to-green-600 rounded-2xl p-5 text-white">
        <div className="flex items-center gap-4 mb-4">
          <div className="relative">
            <img src={agent?.avatar} alt={agent?.name} className="w-14 h-14 rounded-2xl object-cover border-2 border-white/30" />
            <div className="absolute -bottom-1 -right-1 w-4 h-4 rounded-full bg-green-400 border-2 border-white" />
          </div>
          <div>
            <p className="font-black text-lg">{agent?.name}</p>
            <p className="text-white/70 text-sm">{agent?.vehicle} · {agent?.vehicleNumber}</p>
            <div className="flex items-center gap-1 mt-0.5">
              <Star size={12} className="fill-yellow-300 text-yellow-300" />
              <span className="text-sm font-bold">{agent?.rating}</span>
              <span className="text-white/60 text-xs">· {agent?.totalDeliveries} deliveries</span>
            </div>
          </div>
        </div>
        <div className="grid grid-cols-3 gap-3">
          <div className="bg-white/20 rounded-xl p-3 text-center">
            <p className="text-xl font-black">{agent?.todayPickups}</p>
            <p className="text-xs text-white/70">Pickups Today</p>
          </div>
          <div className="bg-white/20 rounded-xl p-3 text-center">
            <p className="text-xl font-black">{agent?.todayDeliveries}</p>
            <p className="text-xs text-white/70">Deliveries Today</p>
          </div>
          <div className="bg-white/20 rounded-xl p-3 text-center">
            <p className="text-xl font-black">₹{agent?.earnings?.toLocaleString('en-IN')}</p>
            <p className="text-xs text-white/70">Today&apos;s Earnings</p>
          </div>
        </div>
      </div>
      {/* Quick Stats */}
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center">
              <Package size={18} className="text-blue-600" />
            </div>
            <div>
              <p className="text-xl font-black text-gray-900">{todayPickups?.length}</p>
              <p className="text-xs text-gray-500">Pending Pickups</p>
            </div>
          </div>
          <div className="h-1.5 bg-gray-100 rounded-full overflow-hidden">
            <div className="h-full bg-blue-500 rounded-full" style={{ width: `${(todayPickups?.length / (myTasks?.length || 1)) * 100}%` }} />
          </div>
        </div>
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center">
              <CheckCircle size={18} className="text-green-600" />
            </div>
            <div>
              <p className="text-xl font-black text-gray-900">{completed?.length}</p>
              <p className="text-xs text-gray-500">Completed</p>
            </div>
          </div>
          <div className="h-1.5 bg-gray-100 rounded-full overflow-hidden">
            <div className="h-full bg-green-500 rounded-full" style={{ width: `${(completed?.length / (myTasks?.length || 1)) * 100}%` }} />
          </div>
        </div>
      </div>
      {/* Today's Tasks */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        <div className="px-4 py-3 border-b border-gray-50 flex items-center justify-between">
          <h3 className="font-bold text-gray-900">Today&apos;s Tasks</h3>
          <span className="text-xs font-bold text-primary">{myTasks?.length} total</span>
        </div>
        <div className="divide-y divide-gray-50">
          {myTasks?.slice(0, 5)?.map((task) => (
            <div key={task?.id} className="flex items-center gap-3 px-4 py-3">
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 ${
                task?.status === 'completed' ? 'bg-green-100' : task?.status === 'picked_up' ? 'bg-blue-100' : 'bg-yellow-100'
              }`}>
                {task?.status === 'completed' ? <CheckCircle size={18} className="text-green-600" /> :
                 task?.status === 'picked_up' ? <Truck size={18} className="text-blue-600" /> :
                 <Clock size={18} className="text-yellow-600" />}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-bold text-gray-900 truncate">{task?.deviceName?.split(' ')?.slice(0, 3)?.join(' ')}</p>
                <p className="text-xs text-gray-500">{task?.customerName} · {task?.city}</p>
                <div className="flex items-center gap-1 mt-0.5">
                  <MapPin size={10} className="text-gray-400" />
                  <span className="text-xs text-gray-400">{task?.pinCode}</span>
                  <span className="text-xs text-gray-300">·</span>
                  <span className="text-xs text-gray-400">{task?.pickupSlot}</span>
                </div>
              </div>
              <div className="text-right flex-shrink-0">
                <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${
                  task?.status === 'completed' ? 'bg-green-100 text-green-700' :
                  task?.status === 'picked_up'? 'bg-blue-100 text-blue-700' : 'bg-yellow-100 text-yellow-700'
                }`}>{task?.status?.replace(/_/g, ' ')}</span>
                <p className="text-xs font-bold text-gray-900 mt-1">₹{task?.quotedPrice?.toLocaleString('en-IN')}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
      {/* Performance */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
        <h3 className="font-bold text-gray-900 mb-3">This Week&apos;s Performance</h3>
        <div className="grid grid-cols-3 gap-3">
          <div className="text-center">
            <p className="text-2xl font-black text-green-600">{agent?.totalDeliveries}</p>
            <p className="text-xs text-gray-500">Total Deliveries</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-black text-yellow-600 flex items-center justify-center gap-1"><Star size={16} className="fill-yellow-400 text-yellow-400" />{agent?.rating}</p>
            <p className="text-xs text-gray-500">Rating</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-black text-blue-600">98%</p>
            <p className="text-xs text-gray-500">On-time Rate</p>
          </div>
        </div>
      </div>
    </div>
  );
}

'use client';
import React, { useState } from 'react';
import { deviceModels } from '@/lib/casmikData';
import { Search, Plus, Edit2, Trash2, ChevronDown } from 'lucide-react';

interface RefurbishedDevice {
  id: string;
  modelId: string;
  modelName: string;
  brand: string;
  category: string;
  condition: 'Superb' | 'Good' | 'Fair';
  storage: string;
  color: string;
  originalPrice: number;
  sellingPrice: number;
  discount: number;
  batteryHealth: number;
  warranty: string;
  image: string;
  alt: string;
  stock: number;
  status: 'available' | 'sold' | 'reserved';
  inspectionScore: number;
}

const refurbishedDevices: RefurbishedDevice[] = [
{ id: 'ref-001', modelId: 'iphone-15-pro-max', modelName: 'iPhone 15 Pro Max', brand: 'Apple', category: 'Smartphones', condition: 'Superb', storage: '256GB', color: 'Natural Titanium', originalPrice: 159900, sellingPrice: 75000, discount: 53, batteryHealth: 95, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_13d56481d-1776977065110.png", alt: 'iPhone 15 Pro Max refurbished', stock: 3, status: 'available', inspectionScore: 92 },
{ id: 'ref-002', modelId: 'iphone-15-pro', modelName: 'iPhone 15 Pro', brand: 'Apple', category: 'Smartphones', condition: 'Good', storage: '128GB', color: 'Black Titanium', originalPrice: 134900, sellingPrice: 62000, discount: 54, batteryHealth: 88, warranty: '6 Months', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_17e528213-1771903425581.png', alt: 'iPhone 15 Pro refurbished', stock: 5, status: 'available', inspectionScore: 85 },
{ id: 'ref-003', modelId: 'iphone-14-pro-max', modelName: 'iPhone 14 Pro Max', brand: 'Apple', category: 'Smartphones', condition: 'Superb', storage: '256GB', color: 'Deep Purple', originalPrice: 139900, sellingPrice: 58000, discount: 59, batteryHealth: 91, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1a43fe270-1765259226080.png", alt: 'iPhone 14 Pro Max refurbished', stock: 2, status: 'available', inspectionScore: 90 },
{ id: 'ref-004', modelId: 's25-ultra', modelName: 'Galaxy S25 Ultra', brand: 'Samsung', category: 'Smartphones', condition: 'Superb', storage: '256GB', color: 'Titanium Black', originalPrice: 129999, sellingPrice: 72000, discount: 45, batteryHealth: 96, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_171298d6a-1777439708559.png", alt: 'Samsung Galaxy S25 Ultra refurbished', stock: 4, status: 'available', inspectionScore: 94 },
{ id: 'ref-005', modelId: 's24-ultra', modelName: 'Galaxy S24 Ultra', brand: 'Samsung', category: 'Smartphones', condition: 'Good', storage: '256GB', color: 'Titanium Gray', originalPrice: 124999, sellingPrice: 62000, discount: 50, batteryHealth: 87, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_171298d6a-1777439708559.png", alt: 'Samsung Galaxy S24 Ultra refurbished', stock: 6, status: 'available', inspectionScore: 83 },
{ id: 'ref-006', modelId: 'oneplus-13', modelName: 'OnePlus 13', brand: 'OnePlus', category: 'Smartphones', condition: 'Superb', storage: '256GB', color: 'Midnight Ocean', originalPrice: 69999, sellingPrice: 48000, discount: 31, batteryHealth: 97, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1c295e652-1772414313618.png", alt: 'OnePlus 13 refurbished', stock: 7, status: 'available', inspectionScore: 96 },
{ id: 'ref-007', modelId: 'pixel-9-pro', modelName: 'Pixel 9 Pro', brand: 'Google', category: 'Smartphones', condition: 'Good', storage: '128GB', color: 'Obsidian', originalPrice: 109999, sellingPrice: 45000, discount: 59, batteryHealth: 89, warranty: '6 Months', image: 'https://img.rocket.new/generatedImages/rocket_gen_img_1aede3fd6-1773089372093.png', alt: 'Google Pixel 9 Pro refurbished', stock: 3, status: 'available', inspectionScore: 87 },
{ id: 'ref-008', modelId: 'iphone-13-pro-max', modelName: 'iPhone 13 Pro Max', brand: 'Apple', category: 'Smartphones', condition: 'Fair', storage: '256GB', color: 'Sierra Blue', originalPrice: 129900, sellingPrice: 42000, discount: 68, batteryHealth: 82, warranty: '3 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_10f874a0f-1777439707504.png", alt: 'iPhone 13 Pro Max refurbished', stock: 8, status: 'available', inspectionScore: 78 },
{ id: 'ref-009', modelId: 'macbook-pro-14-m4', modelName: 'MacBook Pro 14" M4', brand: 'Apple', category: 'Laptops', condition: 'Superb', storage: '512GB SSD', color: 'Space Gray', originalPrice: 199900, sellingPrice: 138000, discount: 31, batteryHealth: 94, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_179123d6d-1772091920622.png", alt: 'MacBook Pro 14 M4 refurbished', stock: 2, status: 'available', inspectionScore: 93 },
{ id: 'ref-010', modelId: 'macbook-air-m3', modelName: 'MacBook Air M3', brand: 'Apple', category: 'Laptops', condition: 'Good', storage: '256GB SSD', color: 'Midnight', originalPrice: 114900, sellingPrice: 82000, discount: 29, batteryHealth: 90, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1e556c7d3-1772208754888.png", alt: 'MacBook Air M3 refurbished', stock: 4, status: 'available', inspectionScore: 88 },
{ id: 'ref-011', modelId: 'dell-xps-15', modelName: 'Dell XPS 15', brand: 'Dell', category: 'Laptops', condition: 'Good', storage: '512GB SSD', color: 'Platinum Silver', originalPrice: 149900, sellingPrice: 72000, discount: 52, batteryHealth: 85, warranty: '6 Months', image: "https://img.rocket.new/generatedImages/rocket_gen_img_1baaf40e6-1774959862217.png", alt: 'Dell XPS 15 refurbished', stock: 3, status: 'available', inspectionScore: 84 },
{ id: 'ref-012', modelId: 'fold-5', modelName: 'Galaxy Z Fold 5', brand: 'Samsung', category: 'Smartphones', condition: 'Good', storage: '256GB', color: 'Phantom Black', originalPrice: 154999, sellingPrice: 68000, discount: 56, batteryHealth: 88, warranty: '6 Months', image: "https://images.unsplash.com/photo-1692647494155-ee2df7cf2869", alt: 'Samsung Galaxy Z Fold 5 refurbished', stock: 2, status: 'available', inspectionScore: 86 },
{ id: 'ref-013', modelId: 'ipad-pro-129', modelName: 'iPad Pro 12.9" M2', brand: 'Apple', category: 'Tablets', condition: 'Superb', storage: '128GB Wi-Fi', color: 'Space Gray', originalPrice: 112900, sellingPrice: 58000, discount: 49, batteryHealth: 95, warranty: '6 Months', image: "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop", alt: 'iPad Pro 12.9 M2 refurbished', stock: 4, status: 'available', inspectionScore: 94 },
{ id: 'ref-014', modelId: 'tab-s9-ultra', modelName: 'Galaxy Tab S9 Ultra', brand: 'Samsung', category: 'Tablets', condition: 'Good', storage: '256GB Wi-Fi', color: 'Graphite', originalPrice: 108999, sellingPrice: 52000, discount: 52, batteryHealth: 92, warranty: '6 Months', image: "https://images.unsplash.com/photo-1561154464-82e9adf32764?w=300&h=300&fit=crop", alt: 'Galaxy Tab S9 Ultra refurbished', stock: 3, status: 'available', inspectionScore: 89 },
{ id: 'ref-015', modelId: 'ipad-air-m1', modelName: 'iPad Air 5th Gen', brand: 'Apple', category: 'Tablets', condition: 'Superb', storage: '64GB Wi-Fi', color: 'Blue', originalPrice: 59900, sellingPrice: 36000, discount: 40, batteryHealth: 96, warranty: '6 Months', image: "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop", alt: 'iPad Air 5th Gen refurbished', stock: 5, status: 'available', inspectionScore: 91 }];


const conditionColors = { Superb: 'bg-green-100 text-green-700', Good: 'bg-blue-100 text-blue-700', Fair: 'bg-yellow-100 text-yellow-700' };
const statusColors = { available: 'bg-emerald-50 text-emerald-700', sold: 'bg-gray-100 text-gray-500', reserved: 'bg-orange-50 text-orange-700' };

export default function AdminRefurbished() {
  const [search, setSearch] = useState('');
  const [filterCondition, setFilterCondition] = useState('all');
  const [filterCategory, setFilterCategory] = useState('all');
  const [showAddModal, setShowAddModal] = useState(false);
  const [editId, setEditId] = useState<string | null>(null);
  const [devices, setDevices] = useState(refurbishedDevices);

  const filtered = devices.filter((d) => {
    const matchSearch = d.modelName.toLowerCase().includes(search.toLowerCase()) || d.brand.toLowerCase().includes(search.toLowerCase());
    const matchCond = filterCondition === 'all' || d.condition === filterCondition;
    const matchCat = filterCategory === 'all' || d.category === filterCategory;
    return matchSearch && matchCond && matchCat;
  });

  const totalStock = devices.reduce((s, d) => s + d.stock, 0);
  const avgDiscount = Math.round(devices.reduce((s, d) => s + d.discount, 0) / devices.length);

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-black text-gray-900">Refurbished Devices</h2>
          <p className="text-sm text-gray-500">Manage certified refurbished inventory</p>
        </div>
        <button onClick={() => setShowAddModal(true)}
        className="flex items-center gap-2 bg-primary text-white px-4 py-2.5 rounded-xl text-sm font-bold hover:bg-primary/90 transition-colors">
          <Plus size={16} /> Add Device
        </button>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
        { label: 'Total Listings', value: devices.length, color: 'bg-blue-50 text-blue-600' },
        { label: 'Total Stock', value: totalStock + ' units', color: 'bg-green-50 text-green-600' },
        { label: 'Avg Discount', value: avgDiscount + '%', color: 'bg-purple-50 text-purple-600' },
        { label: 'Available', value: devices.filter((d) => d.status === 'available').length, color: 'bg-emerald-50 text-emerald-600' }].
        map((kpi) =>
        <div key={kpi.label} className="bg-white rounded-2xl p-4 border border-gray-100 shadow-sm">
            <p className="text-2xl font-black text-gray-900">{kpi.value}</p>
            <p className={`text-xs font-bold mt-1 ${kpi.color.split(' ')[1]}`}>{kpi.label}</p>
          </div>
        )}
      </div>

      {/* Filters */}
      <div className="bg-white rounded-2xl border border-gray-100 p-4 flex flex-wrap gap-3">
        <div className="relative flex-1 min-w-48">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
          <input value={search} onChange={(e) => setSearch(e.target.value)}
          placeholder="Search devices..." className="w-full pl-9 pr-3 py-2 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20" />
        </div>
        <div className="relative">
          <select value={filterCategory} onChange={(e) => setFilterCategory(e.target.value)}
          className="appearance-none pl-3 pr-8 py-2 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white">
            <option value="all">All Categories</option>
            <option value="Smartphones">Smartphones</option>
            <option value="Laptops">Laptops</option>
            <option value="Tablets">Tablets</option>
          </select>
          <ChevronDown size={14} className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
        </div>
        <div className="relative">
          <select value={filterCondition} onChange={(e) => setFilterCondition(e.target.value)}
          className="appearance-none pl-3 pr-8 py-2 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white">
            <option value="all">All Conditions</option>
            <option value="Superb">Superb</option>
            <option value="Good">Good</option>
            <option value="Fair">Fair</option>
          </select>
          <ChevronDown size={14} className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
        </div>
      </div>

      {/* Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {filtered.map((device) =>
        <div key={device.id} className="bg-white rounded-2xl border border-gray-100 overflow-hidden hover:shadow-md transition-shadow">
            <div className="relative bg-gray-50 h-40 flex items-center justify-center">
              <img src={device.image} alt={device.alt} className="h-32 object-contain" />
              <span className={`absolute top-3 left-3 text-xs font-bold px-2 py-1 rounded-lg ${conditionColors[device.condition]}`}>{device.condition}</span>
              <span className="absolute top-3 right-3 text-xs font-bold px-2 py-1 rounded-lg bg-red-50 text-red-600">-{device.discount}%</span>
            </div>
            <div className="p-4">
              <div className="flex items-start justify-between mb-2">
                <div>
                  <h3 className="font-bold text-gray-900 text-sm">{device.modelName}</h3>
                  <p className="text-xs text-gray-500">{device.brand} · {device.storage}</p>
                </div>
                <span className={`text-xs font-bold px-2 py-0.5 rounded-lg ${statusColors[device.status]}`}>{device.status}</span>
              </div>
              <div className="flex items-center gap-2 mb-3">
                <span className="text-lg font-black text-gray-900">₹{device.sellingPrice.toLocaleString()}</span>
                <span className="text-xs text-gray-400 line-through">₹{device.originalPrice.toLocaleString()}</span>
              </div>
              <div className="grid grid-cols-3 gap-2 mb-3 text-center">
                <div className="bg-gray-50 rounded-xl p-2">
                  <p className="text-xs font-black text-gray-900">{device.batteryHealth}%</p>
                  <p className="text-xs text-gray-400">Battery</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2">
                  <p className="text-xs font-black text-gray-900">{device.inspectionScore}/100</p>
                  <p className="text-xs text-gray-400">Score</p>
                </div>
                <div className="bg-gray-50 rounded-xl p-2">
                  <p className="text-xs font-black text-gray-900">{device.stock}</p>
                  <p className="text-xs text-gray-400">Stock</p>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-xs text-gray-500">{device.warranty} warranty</span>
                <div className="flex gap-2">
                  <button onClick={() => setEditId(device.id)}
                className="p-1.5 rounded-lg hover:bg-blue-50 text-blue-600 transition-colors"><Edit2 size={14} /></button>
                  <button onClick={() => setDevices((d) => d.filter((x) => x.id !== device.id))}
                className="p-1.5 rounded-lg hover:bg-red-50 text-red-500 transition-colors"><Trash2 size={14} /></button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Add/Edit Modal */}
      {(showAddModal || editId) &&
      <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl w-full max-w-lg p-6 shadow-2xl max-h-[90vh] overflow-y-auto">
            <h3 className="text-lg font-black text-gray-900 mb-4">{editId ? 'Edit Refurbished Device' : 'Add Refurbished Device'}</h3>
            <div className="space-y-3">
              <div>
                <label className="text-xs font-bold text-gray-600 mb-1 block">Select Model</label>
                <select className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20">
                  {deviceModels.map((m) => <option key={m.id} value={m.id}>{m.name}</option>)}
                </select>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Condition</label>
                  <select className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20">
                    <option>Superb</option><option>Good</option><option>Fair</option>
                  </select>
                </div>
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Storage</label>
                  <input className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" placeholder="256GB" />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Selling Price (₹)</label>
                  <input type="number" className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                </div>
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Stock Qty</label>
                  <input type="number" className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Battery Health %</label>
                  <input type="number" className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" placeholder="90" />
                </div>
                <div>
                  <label className="text-xs font-bold text-gray-600 mb-1 block">Warranty</label>
                  <select className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20">
                    <option>3 Months</option><option>6 Months</option><option>1 Year</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="flex gap-3 mt-5">
              <button onClick={() => {setShowAddModal(false);setEditId(null);}}
            className="flex-1 border border-gray-200 text-gray-700 py-2.5 rounded-xl text-sm font-bold hover:bg-gray-50">Cancel</button>
              <button onClick={() => {setShowAddModal(false);setEditId(null);}}
            className="flex-1 bg-primary text-white py-2.5 rounded-xl text-sm font-bold hover:bg-primary/90">
                {editId ? 'Save Changes' : 'Add Device'}
              </button>
            </div>
          </div>
        </div>
      }
    </div>);

}
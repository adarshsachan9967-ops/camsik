'use client';
import React, { useState } from 'react';
import { orders } from '@/lib/casmikData';
import { Camera, CheckCircle, XCircle, Upload, ClipboardCheck } from 'lucide-react';

const inspectionItems = [
  { id: 'display', label: 'Display', subtext: 'Check for cracks, dead pixels, touch issues' },
  { id: 'body', label: 'Body Condition', subtext: 'Scratches, dents, frame damage' },
  { id: 'camera', label: 'Camera', subtext: 'Front and rear camera functionality' },
  { id: 'speaker', label: 'Speaker & Mic', subtext: 'Audio output and microphone' },
  { id: 'charging', label: 'Charging Port', subtext: 'Charging and data transfer' },
  { id: 'faceid', label: 'Face ID / Fingerprint', subtext: 'Biometric authentication' },
  { id: 'battery', label: 'Battery', subtext: 'Battery health and charging' },
  { id: 'wifi', label: 'WiFi & Bluetooth', subtext: 'Wireless connectivity' },
  { id: 'network', label: 'Network / SIM', subtext: 'Cellular connectivity' },
  { id: 'buttons', label: 'Physical Buttons', subtext: 'Volume, power, mute buttons' },
  { id: 'water', label: 'Water Damage', subtext: 'Check water damage indicators' },
  { id: 'accessories', label: 'Accessories', subtext: 'Charger, box, earphones' },
];

const pendingInspectionOrders = orders.filter(o => o.partnerId === 'partner-002' && ['picked_up', 'inspection'].includes(o.status));

export default function PartnerInspection() {
  const [selectedOrder, setSelectedOrder] = useState(pendingInspectionOrders[0] || null);
  const [inspectionResults, setInspectionResults] = useState<Record<string, 'pass' | 'fail' | 'na'>>({});
  const [imei, setImei] = useState('');
  const [notes, setNotes] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const handleResult = (itemId: string, result: 'pass' | 'fail' | 'na') => {
    setInspectionResults(prev => ({ ...prev, [itemId]: result }));
  };

  const score = Object.values(inspectionResults).filter(v => v === 'pass').length;
  const total = inspectionItems.length;
  const scorePercent = Math.round((score / total) * 100);

  const handleSubmit = () => {
    setSubmitted(true);
  };

  if (submitted) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-center">
        <div className="w-20 h-20 rounded-full bg-green-100 flex items-center justify-center mb-4">
          <CheckCircle size={40} className="text-green-600" />
        </div>
        <h2 className="text-2xl font-black text-gray-900 mb-2">Inspection Submitted!</h2>
        <p className="text-gray-500 mb-2">Inspection score: <span className="font-black text-green-600">{scorePercent}/100</span></p>
        <p className="text-sm text-gray-400 mb-6">The final price will be calculated and sent to the customer.</p>
        <button onClick={() => setSubmitted(false)} className="px-6 py-3 bg-primary text-white rounded-xl font-bold hover:bg-primary/90">
          Start New Inspection
        </button>
      </div>
    );
  }

  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-xl font-black text-gray-900">Device Inspection</h2>
        <p className="text-sm text-gray-500">Inspect device condition and submit report</p>
      </div>

      {/* Order Selector */}
      {pendingInspectionOrders.length > 0 ? (
        <div className="flex gap-3 overflow-x-auto scrollbar-hide pb-1">
          {pendingInspectionOrders.map(order => (
            <button key={order.id} onClick={() => setSelectedOrder(order)}
              className={`flex-shrink-0 p-3 rounded-2xl border-2 text-left transition-all ${selectedOrder?.id === order.id ? 'border-primary bg-primary/5' : 'border-gray-100 bg-white hover:border-gray-200'}`}>
              <p className="text-xs font-black text-gray-900">{order.orderNumber}</p>
              <p className="text-xs text-gray-500 mt-0.5">{order.deviceName.split(' ').slice(0, 3).join(' ')}</p>
              <p className="text-xs text-gray-400">{order.customerName}</p>
            </button>
          ))}
        </div>
      ) : (
        <div className="text-center py-12 bg-white rounded-2xl border border-gray-100">
          <ClipboardCheck size={40} className="mx-auto text-gray-300 mb-3" />
          <p className="text-gray-500 font-semibold">No devices pending inspection</p>
        </div>
      )}

      {selectedOrder && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
          {/* Inspection Checklist */}
          <div className="lg:col-span-2 space-y-3">
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
              <div className="flex items-center justify-between mb-3">
                <div>
                  <p className="font-bold text-gray-900">{selectedOrder.deviceName}</p>
                  <p className="text-xs text-gray-500">{selectedOrder.customerName} · {selectedOrder.orderNumber}</p>
                </div>
                <div className="text-right">
                  <p className="text-xs text-gray-500">Score</p>
                  <p className={`text-xl font-black ${scorePercent >= 80 ? 'text-green-600' : scorePercent >= 60 ? 'text-yellow-600' : 'text-red-600'}`}>{scorePercent}%</p>
                </div>
              </div>
              <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                <div className={`h-full rounded-full transition-all duration-500 ${scorePercent >= 80 ? 'bg-green-500' : scorePercent >= 60 ? 'bg-yellow-500' : 'bg-red-500'}`} style={{ width: `${scorePercent}%` }} />
              </div>
            </div>

            {/* IMEI */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
              <label className="text-xs font-bold text-gray-600 mb-1.5 block">IMEI / Serial Number</label>
              <input value={imei} onChange={e => setImei(e.target.value)} placeholder="Enter IMEI number..."
                className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
            </div>

            {/* Checklist */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
              <div className="px-4 py-3 border-b border-gray-50">
                <h3 className="font-bold text-gray-900 text-sm">Inspection Checklist</h3>
              </div>
              <div className="divide-y divide-gray-50">
                {inspectionItems.map((item) => {
                  const result = inspectionResults[item.id];
                  return (
                    <div key={item.id} className="flex items-center justify-between px-4 py-3">
                      <div>
                        <p className="text-sm font-semibold text-gray-900">{item.label}</p>
                        <p className="text-xs text-gray-400">{item.subtext}</p>
                      </div>
                      <div className="flex gap-2">
                        <button onClick={() => handleResult(item.id, 'pass')}
                          className={`flex items-center gap-1 px-2.5 py-1.5 rounded-xl text-xs font-bold transition-all ${result === 'pass' ? 'bg-green-500 text-white' : 'bg-gray-100 text-gray-500 hover:bg-green-100 hover:text-green-700'}`}>
                          <CheckCircle size={12} /> Pass
                        </button>
                        <button onClick={() => handleResult(item.id, 'fail')}
                          className={`flex items-center gap-1 px-2.5 py-1.5 rounded-xl text-xs font-bold transition-all ${result === 'fail' ? 'bg-red-500 text-white' : 'bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-700'}`}>
                          <XCircle size={12} /> Fail
                        </button>
                        <button onClick={() => handleResult(item.id, 'na')}
                          className={`flex items-center gap-1 px-2.5 py-1.5 rounded-xl text-xs font-bold transition-all ${result === 'na' ? 'bg-gray-500 text-white' : 'bg-gray-100 text-gray-500 hover:bg-gray-200'}`}>
                          N/A
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Notes */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
              <label className="text-xs font-bold text-gray-600 mb-1.5 block">Inspection Notes</label>
              <textarea value={notes} onChange={e => setNotes(e.target.value)} placeholder="Add any additional notes about the device condition..."
                rows={3} className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 resize-none" />
            </div>
          </div>

          {/* Right Panel */}
          <div className="space-y-4">
            {/* Photo Upload */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
              <h3 className="font-bold text-gray-900 text-sm mb-3">Device Photos</h3>
              <div className="grid grid-cols-2 gap-2">
                {['Front', 'Back', 'Left Side', 'Right Side', 'Top', 'Bottom'].map(side => (
                  <button key={side} className="aspect-square rounded-xl border-2 border-dashed border-gray-200 flex flex-col items-center justify-center gap-1 hover:border-primary/40 hover:bg-primary/5 transition-all">
                    <Camera size={18} className="text-gray-400" />
                    <span className="text-xs text-gray-400">{side}</span>
                  </button>
                ))}
              </div>
              <button className="w-full mt-3 flex items-center justify-center gap-2 py-2.5 rounded-xl border border-gray-200 text-xs font-semibold text-gray-600 hover:bg-gray-50">
                <Upload size={14} /> Upload Photos
              </button>
            </div>

            {/* Score Summary */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-4">
              <h3 className="font-bold text-gray-900 text-sm mb-3">Score Summary</h3>
              <div className="space-y-2">
                <div className="flex justify-between text-xs">
                  <span className="text-gray-500">Passed</span>
                  <span className="font-bold text-green-600">{Object.values(inspectionResults).filter(v => v === 'pass').length}</span>
                </div>
                <div className="flex justify-between text-xs">
                  <span className="text-gray-500">Failed</span>
                  <span className="font-bold text-red-600">{Object.values(inspectionResults).filter(v => v === 'fail').length}</span>
                </div>
                <div className="flex justify-between text-xs">
                  <span className="text-gray-500">N/A</span>
                  <span className="font-bold text-gray-500">{Object.values(inspectionResults).filter(v => v === 'na').length}</span>
                </div>
                <div className="flex justify-between text-xs">
                  <span className="text-gray-500">Pending</span>
                  <span className="font-bold text-yellow-600">{total - Object.keys(inspectionResults).length}</span>
                </div>
              </div>
              <div className="mt-3 pt-3 border-t border-gray-100">
                <div className="flex justify-between text-sm">
                  <span className="font-bold text-gray-700">Overall Score</span>
                  <span className={`font-black text-lg ${scorePercent >= 80 ? 'text-green-600' : scorePercent >= 60 ? 'text-yellow-600' : 'text-red-600'}`}>{scorePercent}%</span>
                </div>
              </div>
            </div>

            <button onClick={handleSubmit} disabled={Object.keys(inspectionResults).length < 6}
              className="w-full py-3.5 bg-primary text-white rounded-2xl font-bold text-sm hover:bg-primary/90 disabled:opacity-50 disabled:cursor-not-allowed shadow-lg shadow-primary/20">
              Submit Inspection Report
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

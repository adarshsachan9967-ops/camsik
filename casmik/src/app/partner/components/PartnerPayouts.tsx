'use client';
import React, { useState } from 'react';
import { partners } from '@/lib/casmikData';
import { CheckCircle, Plus, Download, X, CreditCard, Building2, Upload } from 'lucide-react';

const partner = partners?.[1];

const payoutHistory = [
  { id: 'pay-001', date: '2024-12-01', amount: 28500, status: 'paid', method: 'Bank Transfer', txnId: 'TXN2024120001' },
  { id: 'pay-002', date: '2024-11-15', amount: 32000, status: 'paid', method: 'Bank Transfer', txnId: 'TXN2024111501' },
  { id: 'pay-003', date: '2024-11-01', amount: 25800, status: 'paid', method: 'Bank Transfer', txnId: 'TXN2024110101' },
  { id: 'pay-004', date: '2024-10-15', amount: 19500, status: 'paid', method: 'Bank Transfer', txnId: 'TXN2024101501' },
  { id: 'pay-005', date: '2024-12-15', amount: 18200, status: 'pending', method: 'Bank Transfer', txnId: 'Pending' },
];

export default function PartnerPayouts() {
  const [showAddFund, setShowAddFund] = useState(false);
  const [balance, setBalance] = useState(partner?.availableBalance);
  const [showSuccess, setShowSuccess] = useState(false);
  const [successMsg, setSuccessMsg] = useState('');

  // Add Fund Modal State
  const [addFundAmount, setAddFundAmount] = useState('10000');
  const [paymentMethod, setPaymentMethod] = useState<'gateway' | 'bank'>('bank');
  const [txnId, setTxnId] = useState('');
  const [receiptFile, setReceiptFile] = useState<string | null>(null);

  const handleAddFund = () => {
    const amount = parseInt(addFundAmount);
    if (amount > 0) {
      if (paymentMethod === 'gateway') {
        setBalance((prev: number) => prev + amount);
        setSuccessMsg(`₹${amount.toLocaleString('en-IN')} added via Payment Gateway successfully!`);
      } else {
        setSuccessMsg(`Bank transfer request for ₹${amount.toLocaleString('en-IN')} submitted. Admin will verify and credit within 24 hours.`);
      }
      setAddFundAmount('10000');
      setTxnId('');
      setReceiptFile(null);
      setShowAddFund(false);
      setShowSuccess(true);
      setTimeout(() => setShowSuccess(false), 4000);
    }
  };

  const handleRequestPayout = () => {
    setSuccessMsg('Payout request submitted! Will be processed within 2-3 business days.');
    setShowSuccess(true);
    setTimeout(() => setShowSuccess(false), 3000);
  };

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black text-gray-900">Wallet Payouts & Settings</h2>
          <p className="text-sm text-gray-500">Track your wallet balances, disburse client payouts and manage bank accounts</p>
        </div>
        <button onClick={() => setShowAddFund(true)} className="flex items-center gap-2 px-4 py-2.5 bg-primary text-white rounded-xl text-sm font-semibold hover:bg-primary/90 shadow-lg shadow-primary/20">
          <Plus size={16} /> Request Add Funds
        </button>
      </div>

      {showSuccess && (
        <div className="flex items-center gap-3 p-4 bg-green-50 border border-green-200 rounded-2xl">
          <CheckCircle size={20} className="text-green-600 flex-shrink-0" />
          <p className="text-sm font-semibold text-green-800">{successMsg}</p>
        </div>
      )}

      {/* Balance Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: 'Available Balance', value: `₹${balance?.toLocaleString('en-IN')}`, icon: '💳', color: 'bg-blue-50 text-blue-700', sub: 'Ready for instant withdrawal transfer' },
          { label: 'Total Earnings', value: `₹${partner?.totalEarnings?.toLocaleString('en-IN')}`, icon: '💰', color: 'bg-green-50 text-green-700', sub: 'All time' },
          { label: 'Pending Payout', value: `₹${partner?.pendingPayout?.toLocaleString('en-IN')}`, icon: '⏳', color: 'bg-orange-50 text-orange-700', sub: 'Processing' },
          { label: 'Total Paid', value: `₹${(partner?.totalEarnings - partner?.pendingPayout)?.toLocaleString('en-IN')}`, icon: '✅', color: 'bg-purple-50 text-purple-700', sub: 'Lifetime' },
        ]?.map(card => (
          <div key={card?.label} className={`${card?.color} rounded-2xl p-4 border border-white`}>
            <div className="flex items-center justify-between mb-2">
              <span className="text-2xl">{card?.icon}</span>
            </div>
            <p className="text-xl font-black">{card?.value}</p>
            <p className="text-xs font-semibold mt-0.5 opacity-80">{card?.label}</p>
            <p className="text-xs opacity-60">{card?.sub}</p>
          </div>
        ))}
      </div>

      {/* Request Payout */}
      <div className="bg-gradient-to-r from-primary/5 to-green-50 rounded-2xl border border-primary/20 p-5">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="font-bold text-gray-900 mb-1">Request Payout</h3>
            <p className="text-sm text-gray-500">Available balance: <span className="font-black text-green-700">₹{balance?.toLocaleString('en-IN')}</span></p>
            <p className="text-xs text-gray-400 mt-0.5">Payouts are processed within 2-3 business days</p>
          </div>
          <button onClick={handleRequestPayout} disabled={balance === 0}
            className="px-6 py-3 bg-primary text-white rounded-xl font-bold hover:bg-primary/90 disabled:opacity-50 shadow-lg shadow-primary/20">
            Request Payout
          </button>
        </div>
      </div>

      {/* Bank Details */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-bold text-gray-900">Bank Details</h3>
          <button className="text-xs text-primary font-bold hover:underline">Update Bank Account</button>
        </div>
        <div className="grid grid-cols-2 gap-4">
          {[
            { label: 'Account Holder', value: partner?.name },
            { label: 'Bank Name', value: 'HDFC Bank' },
            { label: 'Account Number', value: '****4521' },
            { label: 'IFSC Code', value: 'HDFC0001234' },
          ]?.map(item => (
            <div key={item?.label} className="bg-gray-50 rounded-xl p-3">
              <p className="text-xs text-gray-500">{item?.label}</p>
              <p className="text-sm font-bold text-gray-900">{item?.value}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Recent Transaction History */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        <div className="flex items-center justify-between px-5 py-4 border-b border-gray-50">
          <h3 className="font-bold text-gray-900">Recent Transaction History</h3>
          <button className="flex items-center gap-1.5 text-xs text-gray-500 hover:text-primary font-semibold">
            <Download size={13} /> Export
          </button>
        </div>
        <div className="divide-y divide-gray-50">
          {payoutHistory?.map((payout) => (
            <div key={payout?.id} className="flex items-center justify-between px-5 py-4">
              <div>
                <p className="text-sm font-bold text-gray-900">{payout?.id}</p>
                <p className="text-xs text-gray-500">{payout?.method === 'Bank Transfer' ? 'Bank Refill Wallet' : payout?.method}</p>
                <p className="text-xs text-gray-400">{new Date(payout.date)?.toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}</p>
              </div>
              <div className="text-right">
                <p className="text-sm font-black text-green-700">+₹{payout?.amount?.toLocaleString('en-IN')}</p>
                <span className={`text-xs font-bold px-2 py-1 rounded-lg ${payout?.status === 'paid' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>
                  {payout?.status === 'paid' ? 'Success' : 'Pending'}
                </span>
                <p className="text-xs text-gray-400 mt-1">{payout?.txnId}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Request Add Funds Modal - matching screenshot exactly */}
      {showAddFund && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setShowAddFund(false)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-lg z-10 overflow-hidden">
            {/* Modal Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100">
              <div className="text-center flex-1">
                <h3 className="text-lg font-black text-gray-900">Request to Add Funds</h3>
                <p className="text-xs text-gray-500">Add funds using payment gateway or direct bank transfer</p>
              </div>
              <button onClick={() => setShowAddFund(false)} className="p-2 rounded-xl hover:bg-gray-100 ml-2"><X size={18} /></button>
            </div>

            <div className="p-6 space-y-5 max-h-[80vh] overflow-y-auto">
              {/* Amount */}
              <div>
                <label className="text-sm font-bold text-gray-700 mb-2 block">Amount to Add (₹)</label>
                <input type="number" value={addFundAmount} onChange={e => setAddFundAmount(e.target.value)}
                  className="w-full px-4 py-3 rounded-xl border border-gray-200 text-base font-bold focus:outline-none focus:ring-2 focus:ring-primary/30 text-gray-900" />
              </div>

              {/* Quick amounts */}
              <div className="flex gap-2">
                {[5000, 10000, 25000, 50000].map(amt => (
                  <button key={amt} onClick={() => setAddFundAmount(amt.toString())}
                    className={`flex-1 py-2 rounded-xl border text-xs font-bold transition-colors ${addFundAmount === amt.toString() ? 'border-primary bg-primary/5 text-primary' : 'border-gray-200 text-gray-600 hover:border-primary hover:text-primary'}`}>
                    ₹{amt >= 1000 ? `${amt / 1000}K` : amt}
                  </button>
                ))}
              </div>

              {/* Payment Method */}
              <div>
                <label className="text-sm font-bold text-gray-700 mb-2 block">Select Payment Method</label>
                <div className="grid grid-cols-2 gap-3">
                  <button onClick={() => setPaymentMethod('gateway')}
                    className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${paymentMethod === 'gateway' ? 'border-primary bg-primary/5' : 'border-gray-200 hover:border-gray-300'}`}>
                    <CreditCard size={24} className={paymentMethod === 'gateway' ? 'text-primary' : 'text-gray-400'} />
                    <span className={`text-sm font-bold ${paymentMethod === 'gateway' ? 'text-primary' : 'text-gray-600'}`}>Payment Gateway</span>
                  </button>
                  <button onClick={() => setPaymentMethod('bank')}
                    className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${paymentMethod === 'bank' ? 'border-primary bg-primary/5' : 'border-gray-200 hover:border-gray-300'}`}>
                    <Building2 size={24} className={paymentMethod === 'bank' ? 'text-primary' : 'text-gray-400'} />
                    <span className={`text-sm font-bold ${paymentMethod === 'bank' ? 'text-primary' : 'text-gray-600'}`}>Bank Transfer</span>
                  </button>
                </div>
              </div>

              {/* Bank Transfer Details */}
              {paymentMethod === 'bank' && (
                <>
                  <div className="bg-gray-50 rounded-xl p-4 border border-gray-200">
                    <p className="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3">ADMIN BANK DETAILS</p>
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <p className="text-xs text-gray-400">Bank Name</p>
                        <p className="text-sm font-bold text-gray-900">ICICI Bank</p>
                      </div>
                      <div>
                        <p className="text-xs text-gray-400">IFSC Code</p>
                        <p className="text-sm font-bold text-gray-900">ICIC0000004</p>
                      </div>
                      <div>
                        <p className="text-xs text-gray-400">Account Name</p>
                        <p className="text-sm font-bold text-gray-900">Cashify Recommerce Pvt Ltd</p>
                      </div>
                      <div>
                        <p className="text-xs text-gray-400">Account Number</p>
                        <p className="text-sm font-bold text-green-700">000405001289</p>
                      </div>
                    </div>
                  </div>

                  <div>
                    <label className="text-sm font-bold text-gray-700 mb-2 block">Transaction ID / Reference Number</label>
                    <input value={txnId} onChange={e => setTxnId(e.target.value)}
                      placeholder="e.g. UTR1287635292"
                      className="w-full px-4 py-3 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                  </div>

                  <div>
                    <label className="text-sm font-bold text-gray-700 mb-2 block">Attach Receipt / Payment Screenshot</label>
                    <div className="border-2 border-dashed border-gray-200 rounded-xl p-6 text-center cursor-pointer hover:border-primary transition-colors"
                      onClick={() => setReceiptFile('uploaded')}>
                      {receiptFile ? (
                        <div className="flex items-center justify-center gap-2 text-green-600">
                          <CheckCircle size={20} />
                          <span className="text-sm font-bold">Receipt uploaded</span>
                        </div>
                      ) : (
                        <>
                          <Upload size={24} className="mx-auto text-gray-400 mb-2" />
                          <p className="text-sm text-gray-500">Click to upload transfer screenshot</p>
                          <p className="text-xs text-gray-400 mt-1">PNG, JPG up to 5MB</p>
                        </>
                      )}
                    </div>
                  </div>
                </>
              )}

              {paymentMethod === 'gateway' && (
                <div className="bg-blue-50 rounded-xl p-4 border border-blue-100">
                  <p className="text-xs text-blue-700 font-semibold">💳 You will be redirected to the payment gateway to complete the transaction. Funds will be credited instantly upon successful payment.</p>
                </div>
              )}
            </div>

            <div className="px-6 pb-6">
              <button onClick={handleAddFund}
                disabled={!addFundAmount || parseInt(addFundAmount) <= 0 || (paymentMethod === 'bank' && !txnId.trim())}
                className="w-full py-3.5 rounded-xl bg-primary text-white font-bold text-sm hover:bg-primary/90 disabled:opacity-50 shadow-lg shadow-primary/20 transition-all">
                {paymentMethod === 'gateway' ? `Pay ₹${addFundAmount ? parseInt(addFundAmount).toLocaleString('en-IN') : '0'} via Gateway` : `Submit Bank Transfer Request`}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

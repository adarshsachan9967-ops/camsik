'use client';
import React, { useState } from 'react';
import { sellQuestions } from '@/lib/casmikData';
import type { Question, QuestionOption } from '@/lib/casmikData';
import { Plus, TrendingUp, TrendingDown, Minus, ChevronDown, ChevronUp, X, Save, Trash2 } from 'lucide-react';

export default function AdminPricing() {
  const [questions, setQuestions] = useState<Question[]>(sellQuestions);
  const [expandedQ, setExpandedQ] = useState<string | null>('q-display');
  const [editingOption, setEditingOption] = useState<{ qId: string; optId: string; adjustment: number } | null>(null);
  const [showAddQuestion, setShowAddQuestion] = useState(false);
  const [showAddOption, setShowAddOption] = useState<string | null>(null);

  // New question form state
  const [newQ, setNewQ] = useState({ question: '', subtext: '', categoryId: 'cat-smartphone' });
  // New option form state
  const [newOpt, setNewOpt] = useState({ label: '', description: '', icon: '📱', priceAdjustment: 0 });

  const handleAdjustmentSave = () => {
    if (!editingOption) return;
    setQuestions(prev => prev.map(q => q.id === editingOption.qId ? {
      ...q,
      options: q.options.map(o => o.id === editingOption.optId ? { ...o, priceAdjustment: editingOption.adjustment } : o)
    } : q));
    setEditingOption(null);
  };

  const handleAddQuestion = () => {
    if (!newQ.question.trim()) return;
    const id = `q-custom-${Date.now()}`;
    const newQuestion: Question = {
      id,
      categoryId: newQ.categoryId,
      question: newQ.question,
      subtext: newQ.subtext,
      sortOrder: questions.length + 1,
      active: true,
      options: []
    };
    setQuestions(prev => [...prev, newQuestion]);
    setNewQ({ question: '', subtext: '', categoryId: 'cat-smartphone' });
    setShowAddQuestion(false);
    setExpandedQ(id);
  };

  const handleDeleteQuestion = (qId: string) => {
    setQuestions(prev => prev.filter(q => q.id !== qId));
  };

  const handleToggleActive = (qId: string) => {
    setQuestions(prev => prev.map(q => q.id === qId ? { ...q, active: !q.active } : q));
  };

  const handleAddOption = (qId: string) => {
    if (!newOpt.label.trim()) return;
    const optId = `opt-${qId}-${Date.now()}`;
    const option: QuestionOption = {
      id: optId,
      questionId: qId,
      label: newOpt.label,
      description: newOpt.description,
      icon: newOpt.icon,
      illustration: newOpt.icon,
      priceAdjustment: newOpt.priceAdjustment,
      adjustmentType: 'fixed',
      conditionGrade: 'good',
      bulletPoints: [newOpt.description]
    };
    setQuestions(prev => prev.map(q => q.id === qId ? { ...q, options: [...q.options, option] } : q));
    setNewOpt({ label: '', description: '', icon: '📱', priceAdjustment: 0 });
    setShowAddOption(null);
  };

  const handleDeleteOption = (qId: string, optId: string) => {
    setQuestions(prev => prev.map(q => q.id === qId ? { ...q, options: q.options.filter(o => o.id !== optId) } : q));
  };

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black text-gray-900">Pricing Engine</h2>
          <p className="text-sm text-gray-500">Manage sell questions, answers and price adjustments</p>
        </div>
        <button
          onClick={() => setShowAddQuestion(true)}
          className="flex items-center gap-2 px-4 py-2.5 bg-primary text-white rounded-xl text-sm font-semibold hover:bg-primary/90 shadow-lg shadow-primary/20 transition-all"
        >
          <Plus size={16} /> Add Question
        </button>
      </div>

      {/* Price Rule Summary */}
      <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-5 border border-green-100">
        <h3 className="font-bold text-gray-900 mb-3">Price Calculation Formula</h3>
        <div className="flex items-center gap-3 flex-wrap text-sm">
          <span className="bg-white px-3 py-1.5 rounded-xl font-bold text-gray-900 shadow-sm">Base Price</span>
          <span className="text-green-600 font-bold">+</span>
          <span className="bg-green-100 px-3 py-1.5 rounded-xl font-bold text-green-700">Positive Adjustments</span>
          <span className="text-red-500 font-bold">−</span>
          <span className="bg-red-50 px-3 py-1.5 rounded-xl font-bold text-red-600">Negative Adjustments</span>
          <span className="text-gray-500 font-bold">=</span>
          <span className="bg-primary px-3 py-1.5 rounded-xl font-bold text-white">Final Price</span>
        </div>
      </div>

      {/* Questions & Answers */}
      <div className="space-y-3">
        {questions.map((q, qi) => (
          <div key={q.id} className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
            <div className="flex items-center">
              <button
                onClick={() => setExpandedQ(expandedQ === q.id ? null : q.id)}
                className="flex-1 flex items-center justify-between p-4 hover:bg-gray-50 transition-colors text-left"
              >
                <div className="flex items-center gap-3">
                  <div className="w-7 h-7 rounded-xl bg-primary/10 text-primary flex items-center justify-center text-xs font-black">{qi + 1}</div>
                  <div>
                    <p className="font-bold text-gray-900 text-sm">{q.question}</p>
                    <p className="text-xs text-gray-500">{q.options.length} answer options · {q.active ? 'Active' : 'Inactive'}</p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${q.active ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'}`}>
                    {q.active ? 'Active' : 'Inactive'}
                  </span>
                  {expandedQ === q.id ? <ChevronUp size={16} className="text-gray-400" /> : <ChevronDown size={16} className="text-gray-400" />}
                </div>
              </button>
              <div className="flex items-center gap-1 pr-3">
                <button onClick={() => handleToggleActive(q.id)} className="p-1.5 rounded-lg hover:bg-gray-100 text-gray-400 hover:text-gray-700 text-xs font-bold transition-colors" title="Toggle Active">
                  {q.active ? '⏸' : '▶'}
                </button>
                <button onClick={() => handleDeleteQuestion(q.id)} className="p-1.5 rounded-lg hover:bg-red-50 text-gray-400 hover:text-red-600 transition-colors" title="Delete Question">
                  <Trash2 size={13} />
                </button>
              </div>
            </div>

            {expandedQ === q.id && (
              <div className="border-t border-gray-50 p-4">
                <p className="text-xs text-gray-500 mb-4">{q.subtext}</p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-4">
                  {q.options.map((opt) => (
                    <div key={opt.id} className={`rounded-xl border-2 p-3 ${opt.priceAdjustment > 0 ? 'border-green-100 bg-green-50/50' : opt.priceAdjustment < 0 ? 'border-red-100 bg-red-50/50' : 'border-gray-100 bg-gray-50/50'}`}>
                      <div className="flex items-start justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <span className="text-lg">{opt.icon}</span>
                          <div>
                            <p className="text-sm font-bold text-gray-900">{opt.label}</p>
                            <p className="text-xs text-gray-500">{opt.description}</p>
                          </div>
                        </div>
                        <div className="flex items-center gap-1">
                          <div className={`flex items-center gap-1 text-sm font-black ${opt.priceAdjustment > 0 ? 'text-green-600' : opt.priceAdjustment < 0 ? 'text-red-600' : 'text-gray-500'}`}>
                            {opt.priceAdjustment > 0 ? <TrendingUp size={14} /> : opt.priceAdjustment < 0 ? <TrendingDown size={14} /> : <Minus size={14} />}
                            {opt.priceAdjustment > 0 ? '+' : ''}{opt.priceAdjustment === 0 ? '₹0' : `₹${Math.abs(opt.priceAdjustment).toLocaleString('en-IN')}`}
                          </div>
                          <button onClick={() => handleDeleteOption(q.id, opt.id)} className="p-1 rounded-lg hover:bg-red-50 text-gray-300 hover:text-red-500 transition-colors ml-1">
                            <X size={12} />
                          </button>
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        <input
                          type="number"
                          defaultValue={opt.priceAdjustment}
                          onFocus={() => setEditingOption({ qId: q.id, optId: opt.id, adjustment: opt.priceAdjustment })}
                          onChange={(e) => setEditingOption(prev => prev ? { ...prev, adjustment: parseInt(e.target.value) || 0 } : null)}
                          className="flex-1 px-2 py-1.5 rounded-lg border border-gray-200 text-xs font-bold focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white"
                        />
                        {editingOption?.optId === opt.id && (
                          <button onClick={handleAdjustmentSave} className="px-2 py-1.5 rounded-lg bg-primary text-white text-xs font-bold hover:bg-primary/90 flex items-center gap-1">
                            <Save size={11} /> Save
                          </button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>

                {/* Add Option Button */}
                {showAddOption === q.id ? (
                  <div className="bg-gray-50 rounded-xl p-4 border border-gray-200">
                    <h4 className="text-sm font-bold text-gray-900 mb-3">Add New Answer Option</h4>
                    <div className="grid grid-cols-2 gap-3 mb-3">
                      <div>
                        <label className="text-xs font-semibold text-gray-600 mb-1 block">Label *</label>
                        <input value={newOpt.label} onChange={e => setNewOpt(p => ({ ...p, label: e.target.value }))}
                          placeholder="e.g. Perfect" className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                      </div>
                      <div>
                        <label className="text-xs font-semibold text-gray-600 mb-1 block">Icon (emoji)</label>
                        <input value={newOpt.icon} onChange={e => setNewOpt(p => ({ ...p, icon: e.target.value }))}
                          placeholder="e.g. ✅" className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                      </div>
                      <div>
                        <label className="text-xs font-semibold text-gray-600 mb-1 block">Description</label>
                        <input value={newOpt.description} onChange={e => setNewOpt(p => ({ ...p, description: e.target.value }))}
                          placeholder="Short description" className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                      </div>
                      <div>
                        <label className="text-xs font-semibold text-gray-600 mb-1 block">Price Adjustment (₹)</label>
                        <input type="number" value={newOpt.priceAdjustment} onChange={e => setNewOpt(p => ({ ...p, priceAdjustment: parseInt(e.target.value) || 0 }))}
                          placeholder="e.g. -5000 or 2000" className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <button onClick={() => setShowAddOption(null)} className="flex-1 py-2 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600">Cancel</button>
                      <button onClick={() => handleAddOption(q.id)} disabled={!newOpt.label.trim()}
                        className="flex-1 py-2 rounded-xl bg-primary text-white text-sm font-semibold hover:bg-primary/90 disabled:opacity-50">
                        Add Option
                      </button>
                    </div>
                  </div>
                ) : (
                  <button onClick={() => setShowAddOption(q.id)}
                    className="w-full py-2.5 rounded-xl border-2 border-dashed border-gray-200 text-sm font-semibold text-gray-500 hover:border-primary hover:text-primary transition-colors flex items-center justify-center gap-2">
                    <Plus size={14} /> Add Answer Option
                  </button>
                )}
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Add Question Modal */}
      {showAddQuestion && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setShowAddQuestion(false)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 z-10">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-lg font-black text-gray-900">Add New Question</h3>
              <button onClick={() => setShowAddQuestion(false)} className="p-2 rounded-xl hover:bg-gray-100"><X size={18} /></button>
            </div>
            <div className="space-y-4">
              <div>
                <label className="text-xs font-bold text-gray-600 mb-1.5 block">Question *</label>
                <input value={newQ.question} onChange={e => setNewQ(p => ({ ...p, question: e.target.value }))}
                  placeholder="e.g. Is the device under warranty?" className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
              </div>
              <div>
                <label className="text-xs font-bold text-gray-600 mb-1.5 block">Subtext / Helper</label>
                <input value={newQ.subtext} onChange={e => setNewQ(p => ({ ...p, subtext: e.target.value }))}
                  placeholder="e.g. Check the warranty card or box" className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30" />
              </div>
              <div>
                <label className="text-xs font-bold text-gray-600 mb-1.5 block">Category</label>
                <select value={newQ.categoryId} onChange={e => setNewQ(p => ({ ...p, categoryId: e.target.value }))}
                  className="w-full px-3 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 bg-white">
                  <option value="cat-smartphone">Smartphones</option>
                  <option value="cat-laptop">Laptops</option>
                  <option value="cat-tablet">Tablets</option>
                  <option value="cat-smartwatch">Smartwatches</option>
                </select>
              </div>
            </div>
            <div className="flex gap-3 mt-5">
              <button onClick={() => setShowAddQuestion(false)} className="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600">Cancel</button>
              <button onClick={handleAddQuestion} disabled={!newQ.question.trim()}
                className="flex-1 py-2.5 rounded-xl bg-primary text-white text-sm font-semibold hover:bg-primary/90 disabled:opacity-50">
                Add Question
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

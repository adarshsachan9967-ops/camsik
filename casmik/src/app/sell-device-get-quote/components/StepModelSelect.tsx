'use client';
import React, { useState } from 'react';
import { ChevronLeft, Search } from 'lucide-react';
import { deviceModels } from '@/lib/casmikData';

interface Props {
  brand: string;
  brandId: string | null;
  categoryId?: string | null;
  selectedModel: string | null;
  selectedStorage: string | null;
  selectedColor: string | null;
  onSelect: (modelId: string, modelName: string, storage: string, color: string, basePrice: number) => void;
  onBack: () => void;
}

export default function StepModelSelect({ brand, brandId, categoryId, selectedModel, selectedStorage, selectedColor, onSelect, onBack }: Props) {
  const modelsForCat = deviceModels.filter(m => {
    const matchesBrand = brandId ? m.brandId === brandId : true;
    const matchesCat = categoryId ? m.categoryId === categoryId : true;
    return matchesBrand && matchesCat && m.active;
  });

  const models = modelsForCat.length > 0 
    ? modelsForCat 
    : deviceModels.filter(m => (brandId ? m.brandId === brandId : true) && m.active);

  const [query, setQuery] = useState('');
  
  const initialModel = models.find(m => m.id === selectedModel || m.slug === selectedModel) || null;
  const [chosenModel, setChosenModel] = useState<typeof models[0] | null>(initialModel);
  const [chosenStorage, setChosenStorage] = useState<string | null>(selectedStorage || initialModel?.storages[0] || null);
  const [chosenColor, setChosenColor] = useState<string | null>(selectedColor || initialModel?.colors[0] || null);

  React.useEffect(() => {
    if (selectedModel) {
      const found = models.find(m => m.id === selectedModel || m.slug === selectedModel);
      if (found) {
        setChosenModel(found);
        setChosenStorage(selectedStorage || found.storages[0] || null);
        setChosenColor(selectedColor || found.colors[0] || null);
      }
    }
  }, [selectedModel, selectedStorage, selectedColor, models]);

  const filtered = models.filter(m => m.name.toLowerCase().includes(query.toLowerCase()));
  const canContinue = chosenModel && chosenStorage && chosenColor;

  return (
    <div className="bg-white rounded-2xl border border-border shadow-sm p-6 fade-in">
      <button onClick={onBack} className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground mb-5 transition-colors">
        <ChevronLeft size={16} /> Back to Brand
      </button>
      <h2 className="text-xl font-bold text-foreground mb-1">Select Model</h2>
      <p className="text-sm text-muted-foreground mb-5">Showing models for <span className="font-semibold text-foreground">{brand}</span></p>

      <div className="relative mb-4">
        <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
        <input type="text" value={query} onChange={e => setQuery(e.target.value)} placeholder="Search model..."
          className="w-full pl-9 pr-4 py-2.5 rounded-xl border border-border text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary bg-surface transition-all" />
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-5 max-h-64 overflow-y-auto scrollbar-hide">
        {filtered.length > 0 ? filtered.map((model) => (
          <button key={`model-btn-${model.id}`} onClick={() => { setChosenModel(model); setChosenStorage(model.storages[0] || null); setChosenColor(model.colors[0] || null); }}
            className={`flex items-center gap-3 p-3 rounded-xl border-2 text-left transition-all duration-150 btn-press ${chosenModel?.id === model.id ? 'border-primary bg-primary-50 shadow-sm ring-1 ring-primary/20' : 'border-border bg-white hover:border-primary/40 hover:bg-primary-50/30'}`}>
            <div className="w-12 h-12 rounded-lg overflow-hidden bg-muted flex-shrink-0">
              <img src={model.image} alt={model.alt} className="w-full h-full object-cover" />
            </div>
            <div>
              <p className="text-sm font-semibold text-foreground">{model.name}</p>
              <p className="text-xs text-muted-foreground">Up to ₹{model.basePrice.toLocaleString('en-IN')}</p>
            </div>
          </button>
        )) : (
          <div className="col-span-2 text-center py-8 text-muted-foreground text-sm">
            {query ? `No model found for "${query}"` : 'No models available for this brand'}
          </div>
        )}
      </div>

      {chosenModel && (
        <div className="space-y-4 fade-in border-t border-border pt-5">
          <div>
            <p className="text-sm font-semibold text-foreground mb-2">Select Storage</p>
            <div className="flex flex-wrap gap-2">
              {chosenModel.storages.map(s => (
                <button key={`storage-${s}`} onClick={() => setChosenStorage(s)}
                  className={`px-4 py-2 rounded-xl border-2 text-sm font-semibold transition-all btn-press ${chosenStorage === s ? 'border-primary bg-primary text-white' : 'border-border bg-white text-foreground hover:border-primary/40'}`}>
                  {s}
                </button>
              ))}
            </div>
          </div>
          {chosenStorage && (
            <div className="fade-in">
              <p className="text-sm font-semibold text-foreground mb-2">Select Color</p>
              <div className="flex flex-wrap gap-2">
                {chosenModel.colors.map(c => (
                  <button key={`color-${c}`} onClick={() => setChosenColor(c)}
                    className={`px-4 py-2 rounded-xl border-2 text-sm font-medium transition-all btn-press ${chosenColor === c ? 'border-primary bg-primary-50 text-primary font-semibold' : 'border-border bg-white text-foreground hover:border-primary/40'}`}>
                    {c}
                  </button>
                ))}
              </div>
            </div>
          )}
        </div>
      )}

      {canContinue && (
        <div className="mt-6 fade-in">
          <button onClick={() => onSelect(chosenModel!.id, chosenModel!.name, chosenStorage!, chosenColor!, chosenModel!.basePrice)}
            className="w-full py-3.5 gradient-green text-white rounded-xl font-semibold text-sm shadow-green btn-press">
            Continue — Check Condition Questions
          </button>
        </div>
      )}
    </div>
  );
}

import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class SellVariantStep extends StatelessWidget {
  final Map<String, dynamic>? selectedModel;
  final int basePrice;
  final String selectedStorage;
  final String selectedColor;
  final Function(String storage) onStorageChanged;
  final Function(String color) onColorChanged;
  final VoidCallback onProceed;

  const SellVariantStep({
    super.key,
    required this.selectedModel,
    required this.basePrice,
    required this.selectedStorage,
    required this.selectedColor,
    required this.onStorageChanged,
    required this.onColorChanged,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final storages = (selectedModel?['storages'] as List?)?.cast<String>() ?? ['Standard'];
    final colors = (selectedModel?['colors'] as List?)?.cast<String>() ?? ['Standard Color'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: CamsikSmartImage(
                  image: selectedModel?['image'] as String? ?? 'assets/images/categories/dslr.png',
                  fit: BoxFit.contain,
                  iconSize: 32,
                  iconColor: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedModel?['name'] as String? ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Base Valuation: ${formatCurrency(basePrice)}',
                      style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Select Storage / Configuration:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: storages.map((s) {
              final isSel = selectedStorage == s;
              return ChoiceChip(
                label: Text(s),
                selected: isSel,
                onSelected: (val) => onStorageChanged(s),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Select Color:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: colors.map((c) {
              final isSel = selectedColor == c;
              return ChoiceChip(
                label: Text(c),
                selected: isSel,
                onSelected: (val) => onColorChanged(c),
                selectedColor: const Color(0xFF059669),
                labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 12),
              );
            }).toList(),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onProceed,
              child: const Text('Proceed to Diagnostic Questions', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

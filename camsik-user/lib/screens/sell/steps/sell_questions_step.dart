import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';

class SellQuestionsStep extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final Map<int, int> selectedAnswers;
  final int calculatedPrice;
  final Function(int qIdx, int optIdx) onAnswerSelected;
  final VoidCallback onProceed;

  const SellQuestionsStep({
    super.key,
    required this.questions,
    required this.selectedAnswers,
    required this.calculatedPrice,
    required this.onAnswerSelected,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Live Price Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: const Color(0xFF0F172A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Payout:', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                formatCurrency(calculatedPrice),
                style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (ctx, qIdx) {
              final q = questions[qIdx];
              final qText = q['question'] as String;
              final options = (q['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final selectedOptIdx = selectedAnswers[qIdx] ?? 0;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${qIdx + 1}. $qText',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(options.length, (optIdx) {
                      final opt = options[optIdx];
                      final label = opt['label'] as String;
                      final sublabel = opt['sublabel'] as String? ?? '';
                      final adj = (opt['adj'] as num?)?.toInt() ?? 0;
                      final isSelected = selectedOptIdx == optIdx;

                      return InkWell(
                        onTap: () => onAnswerSelected(qIdx, optIdx),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF059669).withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 16,
                                color: isSelected ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    if (sublabel.isNotEmpty)
                                      Text(sublabel, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              if (adj != 0)
                                Text(
                                  adj > 0 ? '+${formatCurrency(adj)}' : '-${formatCurrency(adj.abs())}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: adj > 0 ? const Color(0xFF059669) : const Color(0xFFEF4444),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onProceed,
              child: const Text('View Final Quote Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}

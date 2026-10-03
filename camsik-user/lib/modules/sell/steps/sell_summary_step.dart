import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';

class SellSummaryStep extends StatelessWidget {
  final Map<String, dynamic>? selectedModel;
  final String selectedStorage;
  final String selectedColor;
  final int basePrice;
  final int calculatedPrice;
  final List<Map<String, dynamic>> questions;
  final Map<int, int> selectedAnswers;
  final VoidCallback onProceed;

  const SellSummaryStep({
    super.key,
    required this.selectedModel,
    required this.selectedStorage,
    required this.selectedColor,
    required this.basePrice,
    required this.calculatedPrice,
    required this.questions,
    required this.selectedAnswers,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Guaranteed Instant Payout Quote', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  formatCurrency(calculatedPrice),
                  style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  '${selectedModel?['name']} ($selectedStorage, $selectedColor)',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Valuation Breakdown:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildBreakdownRow('Base Market Value', formatCurrency(basePrice), isNeutral: true),
                const Divider(height: 16),
                ...List.generate(questions.length, (qIdx) {
                  final optIdx = selectedAnswers[qIdx] ?? 0;
                  final options = questions[qIdx]['options'] as List?;
                  if (options == null || optIdx >= options.length) return const SizedBox.shrink();
                  final opt = options[optIdx];
                  final label = opt['label'] as String;
                  final adj = (opt['adj'] as num?)?.toInt() ?? 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                          ),
                        ),
                        Text(
                          adj == 0
                              ? '$kRupee 0'
                              : adj > 0
                                  ? '+${formatCurrency(adj)}'
                                  : '-${formatCurrency(adj.abs())}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: adj > 0
                                ? const Color(0xFF059669)
                                : adj < 0
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 16),
                _buildBreakdownRow('Final Handover Cash', formatCurrency(calculatedPrice), isHighlight: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
              child: const Text('Schedule Doorstep Handover', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool isNeutral = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isHighlight ? 13 : 12,
            fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w600,
            color: isHighlight ? const Color(0xFF0F172A) : const Color(0xFF475569),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 15 : 12,
            fontWeight: isHighlight ? FontWeight.w900 : FontWeight.bold,
            color: isHighlight ? const Color(0xFF059669) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

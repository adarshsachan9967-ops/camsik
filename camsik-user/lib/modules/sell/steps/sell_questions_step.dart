import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class SellQuestionsStep extends StatelessWidget {
  final Map<String, dynamic>? selectedModel;
  final String selectedStorage;
  final String selectedColor;
  final int basePrice;
  final int calculatedPrice;
  final List<Map<String, dynamic>> questions;
  final Map<int, int> selectedAnswers;
  final Function(int qIdx, int optIdx) onAnswerSelected;
  final VoidCallback onProceed;

  const SellQuestionsStep({
    super.key,
    this.selectedModel,
    this.selectedStorage = 'Standard',
    this.selectedColor = 'Standard Color',
    this.basePrice = 50000,
    required this.calculatedPrice,
    required this.questions,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final modelName = selectedModel?['name'] as String? ?? 'Selected Device';
    final modelImage = selectedModel?['image'] as String? ?? 'assets/images/categories/dslr.png';
    final priceDiff = calculatedPrice - basePrice;
    final bool allAnswered = questions.isNotEmpty &&
        List.generate(questions.length, (i) => i).every((i) => selectedAnswers.containsKey(i));
    final int answeredCount = questions.isEmpty
        ? 0
        : List.generate(questions.length, (i) => i).where((i) => selectedAnswers.containsKey(i)).length;

    return Column(
      children: [
        // ── 1. STICKY LIVE VALUATION STRIP ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF34D399),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'LIVE VALUATION ENGINE',
                        style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    priceDiff == 0
                        ? '100% Base Valuation Intact'
                        : priceDiff > 0
                            ? 'Bonus Applied: +${formatCurrency(priceDiff)}'
                            : 'Adjusted: -${formatCurrency(priceDiff.abs())}',
                    style: TextStyle(
                      color: priceDiff >= 0 ? const Color(0xFF34D399) : const Color(0xFFFCA5A5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(calculatedPrice),
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const Text(
                    'Instant Bank / UPI Transfer',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── 2. SCROLLABLE QUESTIONS & CHOSEN DEVICE SUMMARY ──
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            children: [
              // ── CHOSEN DEVICE & REAL PRICE BREAKDOWN CARD ──
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Device Image in soft container
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: CamsikSmartImage(
                            image: modelImage,
                            fit: BoxFit.contain,
                            iconSize: 28,
                            iconColor: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFECFDF5),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: const Color(0xFFA7F3D0), width: 0.8),
                                    ),
                                    child: const Text(
                                      'CHOSEN DEVICE',
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF047857),
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                  const Row(
                                    children: [
                                      Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF059669)),
                                      SizedBox(width: 3),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Color(0xFF059669),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                modelName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Config: $selectedStorage • $selectedColor',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    const SizedBox(height: 10),

                    // Price Breakdown Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Base Price: ',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                            Text(
                              formatCurrency(basePrice),
                              style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A), fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Current Quote: ',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                            ),
                            Text(
                              formatCurrency(calculatedPrice),
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF059669),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section Heading for Questions
              const Row(
                children: [
                  Icon(Icons.checklist_rounded, size: 16, color: Color(0xFF059669)),
                  SizedBox(width: 6),
                  Text(
                    'Physical & Functional Health Checks',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Answer honestly to get accurate doorstep payout with zero negotiations',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
              ),
              const SizedBox(height: 12),

              // Diagnostic Questions Cards
              ...List.generate(questions.length, (qIdx) {
                final q = questions[qIdx];
                final qText = q['question'] as String? ?? 'Diagnostic Check';
                final subtext = q['subtext'] as String? ?? '';
                final options = (q['options'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                final isAnswered = selectedAnswers.containsKey(qIdx);
                final selectedOptIdx = selectedAnswers[qIdx];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isAnswered ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Number Capsule, Text & Answered Status Pill
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: isAnswered ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isAnswered ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              'Q${qIdx + 1} of ${questions.length}',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: isAnswered ? const Color(0xFF047857) : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              qText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                                color: Color(0xFF0F172A),
                                height: 1.25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: isAnswered ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isAnswered ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                                  size: 11,
                                  color: isAnswered ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  isAnswered ? 'Answered' : 'Required',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: isAnswered ? const Color(0xFF15803D) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (subtext.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 12, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  subtext,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Options List
                      ...List.generate(options.length, (optIdx) {
                        final opt = options[optIdx];
                        final label = opt['label'] as String? ?? '';
                        final sublabel = opt['sublabel'] as String? ?? '';
                        final adj = (opt['adj'] as num?)?.toInt() ?? 0;
                        final isSelected = selectedOptIdx != null && selectedOptIdx == optIdx;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => onAnswerSelected(qIdx, optIdx),
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
                                    width: isSelected ? 1.6 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF059669).withValues(alpha: 0.12),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    // Selection Indicator Circle
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? const Color(0xFF059669) : Colors.white,
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                                          width: isSelected ? 0 : 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 10),

                                    // Labels
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                              color: isSelected ? const Color(0xFF065F46) : const Color(0xFF1E293B),
                                            ),
                                          ),
                                          if (sublabel.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                sublabel,
                                                style: TextStyle(
                                                  fontSize: 10.5,
                                                  color: isSelected ? const Color(0xFF047857) : const Color(0xFF64748B),
                                                  height: 1.25,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Value Adjustment Badge
                                    const SizedBox(width: 6),
                                    if (adj == 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFFD1FAE5) : const Color(0xFFE2E8F0),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Best Value',
                                          style: TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w800,
                                            color: isSelected ? const Color(0xFF065F46) : const Color(0xFF475569),
                                          ),
                                        ),
                                      )
                                    else if (adj > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDCFCE7),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFF86EFAC), width: 0.8),
                                        ),
                                        child: Text(
                                          '+${formatCurrency(adj)}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF15803D),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFFFECACA), width: 0.8),
                                        ),
                                        child: Text(
                                          '-${formatCurrency(adj.abs())}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFFDC2626),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        // ── 3. BOTTOM PROCEED BAR ──
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: allAnswered
                      ? const LinearGradient(
                          colors: [Color(0xFF059669), Color(0xFF10B981)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: allAnswered ? null : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: allAnswered
                      ? [
                          BoxShadow(
                            color: const Color(0xFF059669).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: allAnswered ? onProceed : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Final Quote Summary',
                          style: TextStyle(
                            color: allAnswered ? Colors.white : const Color(0xFF94A3B8),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: allAnswered ? Colors.white : const Color(0xFF94A3B8),
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (allAnswered)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_rounded, size: 12, color: Color(0xFF059669)),
                    SizedBox(width: 4),
                    Text(
                      '100% Free doorstep pickup & instant UPI payout',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 13, color: Color(0xFFD97706)),
                    const SizedBox(width: 4),
                    Text(
                      'Answer all questions to unlock final quote ($answeredCount of ${questions.length} completed)',
                      style: const TextStyle(
                        color: Color(0xFFD97706),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../data/models/responses/device_verification_report_model.dart';
import '../widgets/device_imei_verification_sheet.dart';

class SellSummaryStep extends StatefulWidget {
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
  State<SellSummaryStep> createState() => _SellSummaryStepState();
}

class _SellSummaryStepState extends State<SellSummaryStep> {
  DeviceVerificationReportModel? _verificationReport;

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
                  formatCurrency(widget.calculatedPrice),
                  style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.selectedModel?['name']} (${widget.selectedStorage}, ${widget.selectedColor})',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Instant IMEI Verification Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _verificationReport != null ? const Color(0xFFF0FDF4) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _verificationReport != null ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (_verificationReport != null ? const Color(0xFF16A34A) : const Color(0xFF4F46E5))
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _verificationReport != null ? Icons.verified : Icons.phonelink_setup,
                    color: _verificationReport != null ? const Color(0xFF16A34A) : const Color(0xFF4F46E5),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _verificationReport != null
                            ? 'IMEI Verified: ${_verificationReport!.imei}'
                            : 'Verify Device Authenticity',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        _verificationReport != null
                            ? 'Diagnostics Passed · Status: ${_verificationReport!.status}'
                            : 'Validate IMEI with live backend diagnostics',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: _verificationReport != null ? const Color(0xFF15803D) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: const Size(60, 28),
                  ),
                  onPressed: () async {
                    final report = await DeviceImeiVerificationSheet.show(
                      context,
                      selectedModel: widget.selectedModel,
                      selectedVariant: widget.selectedStorage,
                    );
                    if (report != null && mounted) {
                      setState(() => _verificationReport = report);
                    }
                  },
                  child: Text(
                    _verificationReport != null ? 'Re-verify' : 'Verify',
                    style: TextStyle(
                      color: _verificationReport != null ? const Color(0xFF15803D) : const Color(0xFF4F46E5),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
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
                _buildBreakdownRow('Base Market Value', formatCurrency(widget.basePrice), isNeutral: true),
                const Divider(height: 16),
                ...List.generate(widget.questions.length, (qIdx) {
                  final optIdx = widget.selectedAnswers[qIdx] ?? 0;
                  final options = widget.questions[qIdx]['options'] as List?;
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
                _buildBreakdownRow('Final Handover Cash', formatCurrency(widget.calculatedPrice), isHighlight: true),
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
              onPressed: widget.onProceed,
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

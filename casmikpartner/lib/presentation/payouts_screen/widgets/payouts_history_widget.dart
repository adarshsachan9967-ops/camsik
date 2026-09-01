import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class PayoutsHistoryWidget extends StatelessWidget {
  const PayoutsHistoryWidget({super.key});

  static const List<Map<String, dynamic>> _history = [
    {
      'date': '15 Aug 2026',
      'amount': '₹18,400',
      'method': 'Bank Transfer',
      'status': 'Paid',
      'ref': 'PAY-8821',
    },
    {
      'date': '01 Aug 2026',
      'amount': '₹22,000',
      'method': 'Bank Transfer',
      'status': 'Paid',
      'ref': 'PAY-8764',
    },
    {
      'date': '15 Jul 2026',
      'amount': '₹16,500',
      'method': 'Payment Gateway',
      'status': 'Paid',
      'ref': 'PAY-8712',
    },
    {
      'date': '01 Jul 2026',
      'amount': '₹11,200',
      'method': 'Bank Transfer',
      'status': 'Paid',
      'ref': 'PAY-8689',
    },
    {
      'date': '28 Aug 2026',
      'amount': '₹22,600',
      'method': 'Bank Transfer',
      'status': 'Processing',
      'ref': 'PAY-8901',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payout History',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${_history.length} records',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Table header
          Container(
            color: AppTheme.surfaceLight,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: _HeaderCell('Date')),
                Expanded(flex: 2, child: _HeaderCell('Amount')),
                Expanded(flex: 2, child: _HeaderCell('Method')),
                Expanded(flex: 2, child: _HeaderCell('Status')),
                Expanded(flex: 2, child: _HeaderCell('Ref ID')),
              ],
            ),
          ),
          ..._history.asMap().entries.map((entry) {
            final i = entry.key;
            final payout = entry.value;
            return Column(
              children: [
                Divider(height: 1, color: const Color(0xFFF5F5F5)),
                Container(
                  color: payout['status'] == 'Processing'
                      ? AppTheme.warning.withAlpha(10)
                      : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          payout['date'],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          payout['amount'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          payout['method'] == 'Bank Transfer' ? 'Bank' : 'PG',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: StatusBadgeWidget(
                          status: payout['status'],
                          fontSize: 10,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          payout['ref'],
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppTheme.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}

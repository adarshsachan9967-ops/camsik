import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class PayoutsSummaryWidget extends StatelessWidget {
  const PayoutsSummaryWidget({super.key});

  static const List<Map<String, dynamic>> _cards = [
    {
      'label': 'Total Earnings',
      'value': '₹97,400',
      'icon': Icons.currency_rupee_rounded,
      'color': Color(0xFF1565C0),
      'sub': 'Since joining',
    },
    {
      'label': 'Amount Paid',
      'value': '₹74,800',
      'icon': Icons.check_circle_outline_rounded,
      'color': Color(0xFF00C853),
      'sub': '8 payouts done',
    },
    {
      'label': 'Pending',
      'value': '₹22,600',
      'icon': Icons.hourglass_empty_rounded,
      'color': Color(0xFFE65100),
      'sub': 'Awaiting release',
    },
    {
      'label': 'Next Payout',
      'value': '28 Aug',
      'icon': Icons.event_rounded,
      'color': Color(0xFF6A1B9A),
      'sub': '3 days away',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.3,
        ),
        itemCount: _cards.length,
        itemBuilder: (_, i) => _SummaryCard(card: _cards[i]),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: _cards.length,
      itemBuilder: (_, i) => _SummaryCard(card: _cards[i]),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic> card;
  const _SummaryCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final color = card['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(card['icon'] as IconData, size: 16, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card['value'],
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                card['label'],
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                card['sub'],
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

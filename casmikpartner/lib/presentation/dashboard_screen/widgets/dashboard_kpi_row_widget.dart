import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardKpiRowWidget extends StatelessWidget {
  final bool isTablet;
  const DashboardKpiRowWidget({required this.isTablet, super.key});

  static const List<Map<String, dynamic>> _kpis = [
    {
      'label': "Today's Orders",
      'value': '7',
      'icon': Icons.assignment_outlined,
      'color': Color(0xFF1565C0),
      'delta': '+3 vs yesterday',
      'positive': true,
    },
    {
      'label': 'Pending Pickups',
      'value': '4',
      'icon': Icons.local_shipping_outlined,
      'color': Color(0xFFE65100),
      'delta': '2 overdue',
      'positive': false,
    },
    {
      'label': 'Active Orders',
      'value': '11',
      'icon': Icons.pending_actions_outlined,
      'color': Color(0xFF6A1B9A),
      'delta': '+1 this hour',
      'positive': true,
    },
    {
      'label': 'Total Earnings',
      'value': '₹97,400',
      'icon': Icons.currency_rupee_rounded,
      'color': Color(0xFF00C853),
      'delta': 'This month',
      'positive': true,
    },
    {
      'label': 'Pending Payout',
      'value': '₹22,600',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Color(0xFF00695C),
      'delta': 'Next: 28 Aug',
      'positive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
        ),
        itemCount: _kpis.length,
        itemBuilder: (_, i) => _KpiCard(kpi: _kpis[i]),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) =>
            SizedBox(width: 150, child: _KpiCard(kpi: _kpis[i])),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final Map<String, dynamic> kpi;
  const _KpiCard({required this.kpi});

  @override
  Widget build(BuildContext context) {
    final color = kpi['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withAlpha(31),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(kpi['icon'] as IconData, size: 15, color: color),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kpi['positive'] == true
                      ? AppTheme.success.withAlpha(26)
                      : AppTheme.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  kpi['delta'],
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: kpi['positive'] == true
                        ? AppTheme.success
                        : AppTheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            kpi['value'],
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            kpi['label'],
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

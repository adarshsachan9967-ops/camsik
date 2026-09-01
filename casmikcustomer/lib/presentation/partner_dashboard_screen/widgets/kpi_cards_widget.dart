import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class KpiCardsWidget extends StatelessWidget {
  const KpiCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final kpis = [
      _KpiData(
        label: "Today's Orders",
        value: '14',
        icon: 'receipt_long',
        color: const Color(0xFF00C853),
        bg: const Color(0xFFE8FFF0),
        trend: '+3 vs yesterday',
        trendUp: true,
      ),
      _KpiData(
        label: 'Pending Pickups',
        value: '6',
        icon: 'local_shipping',
        color: const Color(0xFFF59E0B),
        bg: const Color(0xFFFFFBEB),
        trend: '2 overdue',
        trendUp: false,
      ),
      _KpiData(
        label: 'Active Orders',
        value: '9',
        icon: 'inventory_2',
        color: const Color(0xFF3B82F6),
        bg: const Color(0xFFEFF6FF),
        trend: 'In progress',
        trendUp: null,
      ),
      _KpiData(
        label: 'Total Earnings',
        value: '₹1.24L',
        icon: 'account_balance_wallet',
        color: const Color(0xFF8B5CF6),
        bg: const Color(0xFFF5F3FF),
        trend: '+₹8,200 today',
        trendUp: true,
      ),
      _KpiData(
        label: 'Pending Payout',
        value: '₹18,500',
        icon: 'payments',
        color: const Color(0xFFEF4444),
        bg: const Color(0xFFFEF2F2),
        trend: 'Due in 2 days',
        trendUp: false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Overview',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: kpis.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => _KpiCard(data: kpis[i]),
          ),
        ),
      ],
    );
  }
}

class _KpiData {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final Color bg;
  final String trend;
  final bool? trendUp;

  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
    required this.trend,
    required this.trendUp,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: data.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_iconData(data.icon), color: data.color, size: 17),
              ),
              if (data.trendUp != null)
                Icon(
                  data.trendUp! ? Icons.trending_up : Icons.trending_down,
                  color: data.trendUp!
                      ? const Color(0xFF00C853)
                      : const Color(0xFFEF4444),
                  size: 14,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            data.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            data.trend,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: data.trendUp == null
                  ? const Color(0xFF3B82F6)
                  : data.trendUp!
                  ? const Color(0xFF00C853)
                  : const Color(0xFFEF4444),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _iconData(String name) {
    switch (name) {
      case 'receipt_long':
        return Icons.receipt_long;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'payments':
        return Icons.payments;
      default:
        return Icons.circle;
    }
  }
}

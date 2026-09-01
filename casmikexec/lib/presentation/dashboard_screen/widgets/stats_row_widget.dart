import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StatsRowWidget extends StatelessWidget {
  final int pickups;
  final int deliveries;
  final double earnings;

  const StatsRowWidget({
    super.key,
    required this.pickups,
    required this.deliveries,
    required this.earnings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.arrow_upward_rounded,
            iconColor: AppTheme.statusAssigned,
            label: 'Pickups',
            value: '$pickups',
            subtitle: 'Today',
            accentColor: AppTheme.statusAssigned,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.arrow_downward_rounded,
            iconColor: AppTheme.statusCompleted,
            label: 'Deliveries',
            value: '$deliveries',
            subtitle: 'Today',
            accentColor: AppTheme.statusCompleted,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.currency_rupee_rounded,
            iconColor: AppTheme.warning,
            label: 'Earnings',
            value: '₹${earnings.toStringAsFixed(0)}',
            subtitle: 'Today',
            accentColor: AppTheme.warning,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;
  final Color accentColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
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
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withAlpha(31),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PerformanceStatsWidget extends StatelessWidget {
  final double completionRate;
  final double avgRating;
  final int totalDeliveries;
  final int totalPickups;

  const PerformanceStatsWidget({
    super.key,
    required this.completionRate,
    required this.avgRating,
    required this.totalDeliveries,
    required this.totalPickups,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          const Text(
            'Performance Stats',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppTheme.success,
                  label: 'Completion Rate',
                  value: '${(completionRate * 100).toStringAsFixed(0)}%',
                  subtitle: 'This month',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatItem(
                  icon: Icons.star_rounded,
                  iconColor: AppTheme.warning,
                  label: 'Avg Rating',
                  value: avgRating.toStringAsFixed(1),
                  subtitle: '127 reviews',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.arrow_downward_rounded,
                  iconColor: AppTheme.statusCompleted,
                  label: 'Total Deliveries',
                  value: '$totalDeliveries',
                  subtitle: 'This month',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatItem(
                  icon: Icons.arrow_upward_rounded,
                  iconColor: AppTheme.statusAssigned,
                  label: 'Total Pickups',
                  value: '$totalPickups',
                  subtitle: 'This month',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Completion rate progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Monthly Target Progress',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '${(completionRate * 100).toStringAsFixed(0)}% / 90%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completionRate,
                  backgroundColor: AppTheme.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completionRate >= 0.9 ? AppTheme.success : AppTheme.warning,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: iconColor, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(38),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

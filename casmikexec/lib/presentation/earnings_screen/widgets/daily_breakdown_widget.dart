import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DailyBreakdownWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const DailyBreakdownWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final earnings = data['earnings'] as double;
    final tasks = data['tasks'] as int;
    final rate = data['completionRate'] as double;
    final isToday = data['date'] == '25 Aug';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isToday ? AppTheme.primary.withAlpha(15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? AppTheme.primary.withAlpha(64)
              : const Color(0xFFEEEEEE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isToday ? AppTheme.primary : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['day'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? Colors.white.withAlpha(204)
                        : AppTheme.textSecondary,
                  ),
                ),
                Text(
                  (data['date'] as String).split(' ').first,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isToday ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data['date'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (isToday) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _miniChip('$tasks tasks', AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    _miniChip(
                      '${(rate * 100).toStringAsFixed(0)}% complete',
                      rate >= 0.9 ? AppTheme.success : AppTheme.warning,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '₹${earnings.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isToday ? AppTheme.primary : AppTheme.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class IncentivesSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> incentives;

  const IncentivesSectionWidget({super.key, required this.incentives});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Incentives & Bonuses',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.warning.withAlpha(38),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${incentives.where((i) => i['earned'] == true).length} earned',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...incentives.map((incentive) {
          final earned = incentive['earned'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: earned ? AppTheme.warning.withAlpha(15) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: earned
                    ? AppTheme.warning.withAlpha(77)
                    : const Color(0xFFEEEEEE),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: earned
                        ? AppTheme.warning.withAlpha(38)
                        : AppTheme.surfaceLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    earned
                        ? Icons.emoji_events_rounded
                        : Icons.lock_outline_rounded,
                    size: 20,
                    color: earned ? AppTheme.warning : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incentive['title'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: earned
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        incentive['description'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+₹${(incentive['amount'] as double).toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: earned ? AppTheme.warning : AppTheme.textMuted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: earned
                            ? AppTheme.success.withAlpha(31)
                            : AppTheme.textMuted.withAlpha(31),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        earned ? 'Earned' : 'Locked',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: earned ? AppTheme.success : AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

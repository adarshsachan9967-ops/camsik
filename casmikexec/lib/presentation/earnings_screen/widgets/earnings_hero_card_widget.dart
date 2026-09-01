import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class EarningsHeroCardWidget extends StatelessWidget {
  final double todayEarnings;
  final double weeklyEarnings;
  final double incentives;

  const EarningsHeroCardWidget({
    super.key,
    required this.todayEarnings,
    required this.weeklyEarnings,
    required this.incentives,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(89),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                "Today's Earnings",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withAlpha(217),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '25 Aug 2026',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withAlpha(230),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹${todayEarnings.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '+₹${incentives.toStringAsFixed(0)} incentives earned',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withAlpha(204),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withAlpha(51)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  'Weekly Total',
                  '₹${weeklyEarnings.toStringAsFixed(0)}',
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withAlpha(51),
              ),
              Expanded(
                child: _miniStat(
                  'Incentives',
                  '₹${incentives.toStringAsFixed(0)}',
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withAlpha(51),
              ),
              Expanded(child: _miniStat('Pending', '₹0')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(191)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

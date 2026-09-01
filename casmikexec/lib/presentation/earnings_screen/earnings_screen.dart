import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import './widgets/daily_breakdown_widget.dart';
import './widgets/earnings_hero_card_widget.dart';
import './widgets/incentives_section_widget.dart';
import './widgets/performance_stats_widget.dart';
import './widgets/weekly_chart_widget.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production
  String _selectedPeriod = 'This Week';
  final _periods = ['Today', 'This Week', 'This Month'];

  final List<Map<String, dynamic>> _dailyDataMaps = [
    {
      'day': 'Mon',
      'date': '19 Aug',
      'earnings': 520.0,
      'tasks': 7,
      'completionRate': 0.86,
    },
    {
      'day': 'Tue',
      'date': '20 Aug',
      'earnings': 680.0,
      'tasks': 9,
      'completionRate': 0.89,
    },
    {
      'day': 'Wed',
      'date': '21 Aug',
      'earnings': 420.0,
      'tasks': 5,
      'completionRate': 0.80,
    },
    {
      'day': 'Thu',
      'date': '22 Aug',
      'earnings': 750.0,
      'tasks': 10,
      'completionRate': 0.90,
    },
    {
      'day': 'Fri',
      'date': '23 Aug',
      'earnings': 890.0,
      'tasks': 12,
      'completionRate': 0.92,
    },
    {
      'day': 'Sat',
      'date': '24 Aug',
      'earnings': 960.0,
      'tasks': 13,
      'completionRate': 0.93,
    },
    {
      'day': 'Sun',
      'date': '25 Aug',
      'earnings': 620.0,
      'tasks': 8,
      'completionRate': 0.88,
    },
  ];

  final List<Map<String, dynamic>> _incentiveMaps = [
    {
      'title': 'Weekend Warrior',
      'description': '10+ deliveries on Sat/Sun',
      'amount': 150.0,
      'earned': true,
    },
    {
      'title': 'Speed Star',
      'description': 'Avg delivery under 45 min',
      'amount': 100.0,
      'earned': true,
    },
    {
      'title': 'Perfect Week',
      'description': '90%+ completion rate all 7 days',
      'amount': 200.0,
      'earned': false,
    },
    {
      'title': 'High Value',
      'description': 'Complete 3 high-priority tasks',
      'amount': 75.0,
      'earned': true,
    },
  ];

  double get _totalWeeklyEarnings =>
      _dailyDataMaps.fold(0.0, (sum, d) => sum + (d['earnings'] as double));

  double get _totalIncentives => _incentiveMaps
      .where((i) => i['earned'] == true)
      .fold(0.0, (sum, i) => sum + (i['amount'] as double));

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'My Earnings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: _periods.map((p) {
                        final isSelected = p == _selectedPeriod;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedPeriod = p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: () async =>
                    await Future.delayed(const Duration(milliseconds: 600)),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: EarningsHeroCardWidget(
                          todayEarnings:
                              _dailyDataMaps.last['earnings'] as double,
                          weeklyEarnings: _totalWeeklyEarnings,
                          incentives: _totalIncentives,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: WeeklyChartWidget(
                          dailyData: _dailyDataMaps,
                          isTablet: isTablet,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: PerformanceStatsWidget(
                          completionRate: 0.88,
                          avgRating: 4.7,
                          totalDeliveries: 64,
                          totalPickups: 58,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: IncentivesSectionWidget(
                          incentives: _incentiveMaps,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          children: [
                            const Text(
                              'Daily Breakdown',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Last updated: 06:15 AM',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final reversed = _dailyDataMaps.reversed.toList();
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 250 + i * 40),
                            curve: Curves.easeOutCubic,
                            builder: (context, v, child) => Opacity(
                              opacity: v,
                              child: Transform.translate(
                                offset: Offset(0, (1 - v) * 12),
                                child: child,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: DailyBreakdownWidget(data: reversed[i]),
                            ),
                          );
                        }, childCount: _dailyDataMaps.length),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

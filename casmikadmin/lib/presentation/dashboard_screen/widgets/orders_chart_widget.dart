import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';

class OrdersChartWidget extends StatelessWidget {
  const OrdersChartWidget({super.key});

  static const List<Map<String, dynamic>> _ordersByType = [
    {'type': 'Sell', 'count': 1240, 'color': Color(0xFF00C853)},
    {'type': 'Buy', 'count': 890, 'color': Color(0xFF2196F3)},
    {'type': 'Exchange', 'count': 620, 'color': Color(0xFF9C27B0)},
    {'type': 'Repair', 'count': 740, 'color': Color(0xFFFF9800)},
    {'type': 'Pickup', 'count': 357, 'color': Color(0xFF00BCD4)},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orders by Type',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1400,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: AppTheme.surfaceElevatedDark,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                          '${_ordersByType[groupIndex]['type']}\n${rod.toY.toInt()} orders',
                          const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 11,
                          ),
                        ),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        if (i < 0 || i >= _ordersByType.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _ordersByType[i]['type'] as String,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 9,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 400,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 400,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: Color(0xFF2A2A2A), strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  _ordersByType.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (_ordersByType[i]['count'] as int).toDouble(),
                        color: _ordersByType[i]['color'] as Color,
                        width: 28,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 1400,
                          color: const Color(0xFF1E1E1E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
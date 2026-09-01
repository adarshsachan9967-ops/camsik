import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';

class RevenueChartWidget extends StatefulWidget {
  const RevenueChartWidget({super.key});

  @override
  State<RevenueChartWidget> createState() => _RevenueChartWidgetState();
}

class _RevenueChartWidgetState extends State<RevenueChartWidget> {
  int _touchedIndex = -1;

  static const List<Map<String, dynamic>> _revenueData = [
    {'day': 'Mon', 'value': 110000.0},
    {'day': 'Tue', 'value': 148000.0},
    {'day': 'Wed', 'value': 130000.0},
    {'day': 'Thu', 'value': 165000.0},
    {'day': 'Fri', 'value': 180000.0},
    {'day': 'Sat', 'value': 195000.0},
    {'day': 'Sun', 'value': 210000.0},
  ];

  String _formatRupee(double val) {
    if (val >= 100000) return '₹${(val / 100000).toStringAsFixed(0)}L';
    if (val >= 1000) return '₹${(val / 1000).toStringAsFixed(0)}K';
    return '₹${val.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    final spots = List.generate(
      _revenueData.length,
      (i) => FlSpot(i.toDouble(), (_revenueData[i]['value'] as double) / 1000),
    );

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenue Overview',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'This week',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xff00c85315),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xff00c85330)),
                ),
                child: const Row(
                  children: [
                    Text(
                      '+18.6% ',
                      style: TextStyle(
                        color: AppTheme.casmikGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.arrow_upward,
                      color: AppTheme.casmikGreen,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 55,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0xFF2A2A2A),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: 55,
                      getTitlesWidget: (value, _) => Text(
                        '₹${value.toInt()}K',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _revenueData.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _revenueData[idx]['day'] as String,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 80,
                maxY: 230,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: AppTheme.casmikGreen,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, i) => FlDotCirclePainter(
                        radius: i == _touchedIndex ? 5 : 3,
                        color: AppTheme.casmikGreen,
                        strokeWidth: 2,
                        strokeColor: AppTheme.backgroundDark,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.casmikGreen.withAlpha(50),
                          AppTheme.casmikGreen.withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchCallback: (event, response) {
                    if (response?.lineBarSpots != null) {
                      setState(
                        () => _touchedIndex =
                            response!.lineBarSpots!.first.spotIndex,
                      );
                    } else {
                      setState(() => _touchedIndex = -1);
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (spots) => spots.map((s) {
                      final day = _revenueData[s.spotIndex]['day'];
                      final val = _revenueData[s.spotIndex]['value'] as double;
                      return LineTooltipItem(
                        '$day\nRevenue : ${_formatRupee(val)}',
                        const TextStyle(
                          color: AppTheme.casmikGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
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

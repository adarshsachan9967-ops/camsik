
import '../../../core/app_export.dart';

class _KpiData {
  final String title;
  final String value;
  final String subtitle;
  final bool isPositive;
  final String icon;
  final Color accentColor;

  const _KpiData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.isPositive,
    required this.icon,
    required this.accentColor,
  });
}

class KpiBentoGridWidget extends StatelessWidget {
  const KpiBentoGridWidget({super.key});

  static const List<_KpiData> _kpis = [
    _KpiData(
      title: 'Total Revenue',
      value: '₹2.4L',
      subtitle: '+18.6% vs last week',
      isPositive: true,
      icon: 'attach_money',
      accentColor: Color(0xFF00C853),
    ),
    _KpiData(
      title: 'Total Orders',
      value: '20',
      subtitle: '+12.4% vs last week',
      isPositive: true,
      icon: 'shopping_bag',
      accentColor: Color(0xFF2196F3),
    ),
    _KpiData(
      title: 'Completed',
      value: '6',
      subtitle: '30% completion rate',
      isPositive: true,
      icon: 'check_circle',
      accentColor: Color(0xFF00C853),
    ),
    _KpiData(
      title: 'Pending',
      value: '8',
      subtitle: 'Needs attention',
      isPositive: false,
      icon: 'schedule',
      accentColor: Color(0xFFFF9800),
    ),
    _KpiData(
      title: 'Active Partners',
      value: '4',
      subtitle: '1 pending approval',
      isPositive: true,
      icon: 'handshake',
      accentColor: Color(0xFF9C27B0),
    ),
    _KpiData(
      title: 'Delivery Agents',
      value: '5',
      subtitle: '3 online now',
      isPositive: true,
      icon: 'delivery_dining',
      accentColor: Color(0xFF00BCD4),
    ),
    _KpiData(
      title: 'Customers',
      value: '5+',
      subtitle: 'Registered users',
      isPositive: true,
      icon: 'group',
      accentColor: Color(0xFF7C4DFF),
    ),
    _KpiData(
      title: 'Pending Payouts',
      value: '₹69K',
      subtitle: 'Due to partners',
      isPositive: false,
      icon: 'bolt',
      accentColor: Color(0xFFFF5722),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Platform Overview',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Aug 25, 2026',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.55,
          ),
          itemCount: _kpis.length,
          itemBuilder: (_, i) => _KpiCard(data: _kpis[i]),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: data.accentColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: data.icon,
                    color: data.accentColor,
                    size: 15,
                  ),
                ),
              ),
              CustomIconWidget(
                iconName: 'trending_up',
                color: data.isPositive
                    ? AppTheme.casmikGreen
                    : AppTheme.warning,
                size: 14,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                data.subtitle,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 9),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

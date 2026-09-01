
import '../../../core/app_export.dart';

class PartnerPerformanceWidget extends StatelessWidget {
  const PartnerPerformanceWidget({super.key});

  static const List<Map<String, dynamic>> _partners = [
    {
      'name': 'TechZone Solutions',
      'orders': 284,
      'revenue': '\$68,400',
      'rating': 4.8,
      'fill': 0.87,
    },
    {
      'name': 'FixIt Pro Services',
      'orders': 196,
      'revenue': '\$42,100',
      'rating': 4.6,
      'fill': 0.72,
    },
    {
      'name': 'DeviceHub Store',
      'orders': 312,
      'revenue': '\$81,250',
      'rating': 4.9,
      'fill': 0.95,
    },
    {
      'name': 'QuickPick Logistics',
      'orders': 158,
      'revenue': '\$19,800',
      'rating': 4.3,
      'fill': 0.58,
    },
    {
      'name': 'Gadget Galaxy',
      'orders': 94,
      'revenue': '\$22,600',
      'rating': 3.9,
      'fill': 0.38,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Partner Performance',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'This Month',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(_partners.length, (i) {
            final p = _partners[i];
            final fillValue = p['fill'] as double;
            Color barColor = AppTheme.casmikGreen;
            if (fillValue < 0.5) {
              barColor = AppTheme.error;
            } else if (fillValue < 0.7)
              barColor = AppTheme.warning;

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p['name'],
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        p['revenue'],
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: const Color(0xFFFFD700),
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${p['rating']}',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fillValue,
                            backgroundColor: const Color(0xFF2A2A2A),
                            valueColor: AlwaysStoppedAnimation<Color>(barColor),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${p['orders']} orders',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

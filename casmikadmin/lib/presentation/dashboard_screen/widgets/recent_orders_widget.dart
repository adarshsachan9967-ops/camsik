import '../../../core/app_export.dart';

class RecentOrdersWidget extends StatelessWidget {
  const RecentOrdersWidget({super.key});

  static const List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD-8821',
      'customer': 'Arjun Mehta',
      'type': 'Sell',
      'amount': '\$248',
      'status': 'processing',
      'time': '2m ago',
      'partner': 'TechZone',
    },
    {
      'id': '#ORD-8820',
      'customer': 'Priya Sharma',
      'type': 'Repair',
      'amount': '\$85',
      'status': 'active',
      'time': '8m ago',
      'partner': 'FixIt Pro',
    },
    {
      'id': '#ORD-8819',
      'customer': 'Mohamed Al-Rashid',
      'type': 'Buy',
      'amount': '\$412',
      'status': 'inTransit',
      'time': '15m ago',
      'partner': 'DeviceHub',
    },
    {
      'id': '#ORD-8818',
      'customer': 'Fatima Zahra',
      'type': 'Exchange',
      'amount': '\$190',
      'status': 'pending',
      'time': '24m ago',
      'partner': 'Unassigned',
    },
    {
      'id': '#ORD-8817',
      'customer': 'Ravi Krishnan',
      'type': 'Pickup',
      'amount': '\$55',
      'status': 'completed',
      'time': '1h ago',
      'partner': 'QuickPick',
    },
  ];

  static const Map<String, Color> _typeColors = {
    'Sell': Color(0xFF00C853),
    'Buy': Color(0xFF2196F3),
    'Exchange': Color(0xFF9C27B0),
    'Repair': Color(0xFFFF9800),
    'Pickup': Color(0xFF00BCD4),
  };

  static BadgeStatus _parseStatus(String s) {
    switch (s) {
      case 'active':
        return BadgeStatus.active;
      case 'pending':
        return BadgeStatus.pending;
      case 'completed':
        return BadgeStatus.completed;
      case 'cancelled':
        return BadgeStatus.cancelled;
      case 'processing':
        return BadgeStatus.processing;
      case 'inTransit':
        return BadgeStatus.inTransit;
      default:
        return BadgeStatus.pending;
    }
  }

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
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Orders',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'View All →',
                  style: const TextStyle(
                    color: AppTheme.casmikGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_orders.length, (i) {
            final o = _orders[i];
            final typeColor = _typeColors[o['type']] ?? AppTheme.casmikGreen;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: typeColor.withAlpha(31),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            o['type'][0],
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  o['id'],
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: typeColor.withAlpha(31),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    o['type'],
                                    style: TextStyle(
                                      color: typeColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${o['customer']} · ${o['partner']}',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            o['amount'],
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StatusBadgeWidget(
                            status: _parseStatus(o['status']),
                            fontSize: 9,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (i < _orders.length - 1)
                  const Divider(
                    height: 1,
                    color: Color(0xFF1E1E1E),
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class LiveTrackerWidget extends StatelessWidget {
  const LiveTrackerWidget({super.key});

  static const List<Map<String, dynamic>> _liveOrders = [
    {
      'id': 'CSM-2024-001',
      'customer': 'Rahul Sharma',
      'device': 'iPhone 16 Pro Max',
      'status': 'active',
      'partner': 'TechHub Store',
      'agent': 'Ravi Kumar',
      'location': 'Koramangala, Bangalore',
      'eta': '10 min',
    },
    {
      'id': 'CSM-2024-002',
      'customer': 'Priya Patel',
      'device': 'Samsung Galaxy S24',
      'status': 'pending',
      'partner': 'MobileHub Store',
      'agent': 'Unassigned',
      'location': 'Bandra, Mumbai',
      'eta': '—',
    },
    {
      'id': 'CSM-2024-005',
      'customer': 'Amit Singh',
      'device': 'iPhone 15 Pro 128GB',
      'status': 'inTransit',
      'partner': 'TechHub Store',
      'agent': 'Suresh Rao',
      'location': 'Sector 18, Noida',
      'eta': '25 min',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff00c85310),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.casmikGreenMuted),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.casmikGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Live tracking — 3 active orders',
                style: TextStyle(
                  color: AppTheme.casmikGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._liveOrders.map((o) => _LiveOrderCard(order: o)),
      ],
    );
  }
}

class _LiveOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const _LiveOrderCard({required this.order});

  Color get _statusColor {
    switch (order['status']) {
      case 'active':
        return AppTheme.casmikGreen;
      case 'inTransit':
        return const Color(0xFF2196F3);
      default:
        return AppTheme.warning;
    }
  }

  String get _statusLabel {
    switch (order['status']) {
      case 'active':
        return 'Active';
      case 'inTransit':
        return 'In Transit';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order['id'] as String,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'person',
                color: AppTheme.textMuted,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                order['customer'] as String,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              const CustomIconWidget(
                iconName: 'smartphone',
                color: AppTheme.textMuted,
                size: 13,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order['device'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.textMuted,
                size: 13,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order['location'] as String,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (order['eta'] != '—') ...[
                const CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.casmikGreen,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  'ETA: ${order['eta']}',
                  style: const TextStyle(
                    color: AppTheme.casmikGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const CustomIconWidget(
                iconName: 'store',
                color: AppTheme.textMuted,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                order['partner'] as String,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 12),
              const CustomIconWidget(
                iconName: 'delivery_dining',
                color: AppTheme.textMuted,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                order['agent'] as String,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class ServiceCardGridWidget extends StatelessWidget {
  const ServiceCardGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Sell Device',
        'subtitle': 'Instant quote',
        'icon': 'sell',
        'color': const Color(0xFF00C853),
        'bg': const Color(0xFFE8FFF0),
        'route': AppRoutes.sellDeviceScreen,
      },
      {
        'title': 'Buy Refurbished',
        'subtitle': 'Certified & warranted',
        'icon': 'shopping_bag',
        'color': const Color(0xFF3B82F6),
        'bg': const Color(0xFFEFF6FF),
        'route': AppRoutes.buyRefurbishedScreen,
      },
      {
        'title': 'Exchange',
        'subtitle': 'Upgrade & save',
        'icon': 'trending',
        'color': const Color(0xFFF59E0B),
        'bg': const Color(0xFFFFFBEB),
        'route': AppRoutes.sellDeviceScreen,
      },
      {
        'title': 'Repair',
        'subtitle': 'Expert service',
        'icon': 'speed',
        'color': const Color(0xFFEF4444),
        'bg': const Color(0xFFFFF1F2),
        'route': AppRoutes.homeScreen,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Our Services', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: services.map((s) {
            return _ServiceCard(service: s);
          }).toList(),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(service['route'] as String),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: service['bg'] as Color,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: service['color'] as Color, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: (service['color'] as Color).withAlpha(20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (service['color'] as Color).withAlpha(38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: service['icon'] as String,
                  color: service['color'] as Color,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    service['title'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    service['subtitle'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

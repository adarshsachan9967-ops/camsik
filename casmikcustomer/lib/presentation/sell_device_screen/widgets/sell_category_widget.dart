import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SellCategoryWidget extends StatelessWidget {
  final void Function(String category) onSelected;

  const SellCategoryWidget({required this.onSelected, super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Smartphones',
      'icon': 'smartphone',
      'color': Color(0xFF00C853),
      'bg': Color(0xFFE8FFF0),
      'desc': 'iPhones, Android phones',
    },
    {
      'name': 'Tablets',
      'icon': 'tablet',
      'color': Color(0xFF3B82F6),
      'bg': Color(0xFFEFF6FF),
      'desc': 'iPads, Android tablets',
    },
    {
      'name': 'Laptops',
      'icon': 'laptop',
      'color': Color(0xFFF59E0B),
      'bg': Color(0xFFFFFBEB),
      'desc': 'MacBooks, Windows laptops',
    },
    {
      'name': 'Smartwatches',
      'icon': 'watch',
      'color': Color(0xFF8B5CF6),
      'bg': Color(0xFFF5F3FF),
      'desc': 'Apple Watch, Galaxy Watch',
    },
    {
      'name': 'TWS / Earbuds',
      'icon': 'earbuds',
      'color': Color(0xFFEF4444),
      'bg': Color(0xFFFFF1F2),
      'desc': 'AirPods, Galaxy Buds',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What do you\nwant to sell?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Select the category of your device',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          ...(_categories.map((cat) {
            return InkWell(
              onTap: () => onSelected(cat['name'] as String),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cat['bg'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: cat['color'] as Color, width: 3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: (cat['color'] as Color).withAlpha(38),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: cat['icon'] as String,
                          color: cat['color'] as Color,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat['name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cat['desc'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: cat['color'] as Color,
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          })),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// FilterChips anatomy locked: horizontal scroll Row, pill chips,
// first/active chip filled dark, rest outlined (from Image 2.2)
class BuyFilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final void Function(String filter) onFilterChanged;

  const BuyFilterChipsWidget({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  final List<String> _filters = const [
    'All',
    'Smartphones',
    'Tablets',
    'Laptops',
    'Smartwatches',
    'TWS',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == selectedFilter;
          return InkWell(
            onTap: () => onFilterChanged(filter),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                // Active chip = filled dark (anatomy from Image 2.2)
                color: isSelected
                    ? AppTheme.textPrimary
                    : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.textPrimary
                      : AppTheme.borderLight,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

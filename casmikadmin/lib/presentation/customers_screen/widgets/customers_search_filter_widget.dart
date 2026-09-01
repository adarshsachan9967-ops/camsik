
import '../../../core/app_export.dart';

class CustomersSearchFilterWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const CustomersSearchFilterWidget({
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  static const List<String> _filters = ['All', 'Active', 'Blocked'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: onSearchChanged,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search customers...',
                      hintStyle: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: _filters.map((f) {
              final isSelected = f == selectedFilter;
              return GestureDetector(
                onTap: () => onFilterChanged(f),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.casmikGreenDim
                        : AppTheme.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.casmikGreen
                          : const Color(0xFF2A2A2A),
                    ),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.casmikGreen
                          : AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

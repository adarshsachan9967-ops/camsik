import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class ExchangeSelectNewStep extends StatelessWidget {
  final List<Map<String, dynamic>> refurbishedProducts;
  final String categoryFilter;
  final String searchQuery;
  final int totalTradeIn;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<Map<String, dynamic>> onProductSelected;

  const ExchangeSelectNewStep({
    super.key,
    required this.refurbishedProducts,
    required this.categoryFilter,
    required this.searchQuery,
    required this.totalTradeIn,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    final catList = [
      {'id': 'all', 'label': 'All Upgrades'},
      {'id': 'cameras', 'label': 'Cameras'},
      {'id': 'lenses', 'label': 'Lenses'},
      {'id': 'smartphones', 'label': 'Smartphones'},
      {'id': 'laptops', 'label': 'Laptops'},
    ];

    var filtered = refurbishedProducts;
    if (categoryFilter != 'all') {
      filtered = filtered
          .where((p) =>
              (p['category'] as String? ?? '').toLowerCase() ==
              categoryFilter.toLowerCase())
          .toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      filtered = filtered
          .where((p) =>
              (p['model'] as String? ?? '').toLowerCase().contains(q) ||
              (p['brand'] as String? ?? '').toLowerCase().contains(q))
          .toList();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText:
                      'Search upgrade flagships (Sony, Canon, iPhone, Mac)...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: catList.map((cat) {
                    final isSel = categoryFilter == cat['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(cat['label']!),
                        selected: isSel,
                        onSelected: (val) {
                          if (val) onCategoryChanged(cat['id']!);
                        },
                        selectedColor: const Color(0xFF4F46E5),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : const Color(0xFF0F172A),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (ctx, idx) {
              final p = filtered[idx];
              final name = p['model'] as String? ?? 'Device';
              final price = p['sellingPrice'] as int? ?? 65000;
              final image =
                  p['image'] as String? ?? 'assets/images/categories/dslr.png';
              final diff = price - totalTradeIn;

              return InkWell(
                onTap: () => onProductSelected(p),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CamsikSmartImage(
                          image: image,
                          fit: BoxFit.contain,
                          iconSize: 28,
                          iconColor: const Color(0xFF4F46E5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Price: ${formatCurrency(price)}',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              diff > 0
                                  ? 'Pay Difference: ${formatCurrency(diff)}'
                                  : 'You Receive: +${formatCurrency(diff.abs())} Cash',
                              style: TextStyle(
                                color: diff > 0
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFF059669),
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

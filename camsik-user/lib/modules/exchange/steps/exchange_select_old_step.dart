import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class ExchangeSelectOldStep extends StatelessWidget {
  final List<Map<String, dynamic>> tradeInDevices;
  final String categoryFilter;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<Map<String, dynamic>> onDeviceSelected;

  const ExchangeSelectOldStep({
    super.key,
    required this.tradeInDevices,
    required this.categoryFilter,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onDeviceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final catList = [
      {'id': 'all', 'label': 'All Devices'},
      {'id': 'cat-dslr', 'label': 'Cameras'},
      {'id': 'cat-lens', 'label': 'Lenses'},
      {'id': 'cat-smartphone', 'label': 'Smartphones'},
      {'id': 'cat-laptop', 'label': 'Laptops'},
    ];

    var filtered = tradeInDevices;
    if (categoryFilter != 'all') {
      filtered = filtered
          .where((d) =>
              (d['categoryId'] as String? ?? '').toLowerCase() ==
              categoryFilter.toLowerCase())
          .toList();
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      filtered = filtered
          .where((d) =>
              (d['name'] as String? ?? '').toLowerCase().contains(q) ||
              (d['brand'] as String? ?? '').toLowerCase().contains(q))
          .toList();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search old iPhone, Sony A7, Canon, MacBook...',
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: Color(0xFF64748B)),
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
                        selectedColor: const Color(0xFF7C3AED),
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
              final d = filtered[idx];
              final name = d['name'] as String? ?? 'Device';
              final base = (d['basePrice'] as num?)?.toInt() ?? 45000;
              final image =
                  d['image'] as String? ?? 'assets/images/categories/dslr.png';
              final specs =
                  d['specs'] as String? ?? 'Verified hardware valuation';

              return InkWell(
                onTap: () => onDeviceSelected(d),
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
                          iconColor: const Color(0xFF7C3AED),
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
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              specs,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Base: ${formatCurrency(base)}',
                                  style: const TextStyle(
                                    color: Color(0xFF059669),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '+$kRupee 5,000 Bonus',
                                    style: TextStyle(
                                      color: Color(0xFF7C3AED),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
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

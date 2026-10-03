import 'package:flutter/material.dart';
import '../../../widgets/camsik_smart_image.dart';

class EightCategoriesBar extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String catId) onCategorySelected;
  final VoidCallback onViewAll;

  const EightCategoriesBar({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Tech Categories',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    'Sell or upgrade across 8 device categories',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View All', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (ctx, idx) {
              final cat = categories[idx];
              final catId = cat['id'] as String;
              final catName = cat['name'] as String;
              final catImg = cat['image'] as String;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () => onCategorySelected(catId),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 88,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: CamsikSmartImage(
                              image: catImg,
                              fit: BoxFit.contain,
                              iconSize: 28,
                              iconColor: const Color(0xFF059669),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          catName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.1),
                        ),
                      ],
                    ),
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

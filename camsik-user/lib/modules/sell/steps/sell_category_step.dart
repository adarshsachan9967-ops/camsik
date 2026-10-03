import 'package:flutter/material.dart';
import '../../../widgets/camsik_smart_image.dart';

class SellCategoryStep extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(Map<String, dynamic> category) onSelectCategory;

  const SellCategoryStep({
    super.key,
    required this.categories,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.15,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (ctx, idx) {
        final cat = categories[idx];
        return InkWell(
          onTap: () => onSelectCategory(cat),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
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
                  child: CamsikSmartImage(
                    image: cat['image'] as String?,
                    fit: BoxFit.contain,
                    iconSize: 36,
                    iconColor: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class SellModelStep extends StatelessWidget {
  final List<Map<String, dynamic>> models;
  final Function(Map<String, dynamic> model) onSelectModel;

  const SellModelStep({
    super.key,
    required this.models,
    required this.onSelectModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: models.length,
      separatorBuilder: (c, i) => const SizedBox(height: 10),
      itemBuilder: (ctx, idx) {
        final m = models[idx];
        final name = m['name'] as String? ?? 'Device';
        final brand = m['brand'] as String? ?? '';
        final basePrice = (m['basePrice'] as num?)?.toInt() ?? 50000;
        final image = m['image'] as String? ?? 'assets/images/categories/dslr.png';
        final specsRaw = m['specs'];
        final specs = specsRaw is Map
            ? (specsRaw.entries.map((e) => '${e.key}: ${e.value}').take(2).join(' · '))
            : (specsRaw?.toString() ?? '');

        return InkWell(
          onTap: () => onSelectModel(m),
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
                // Real Model Image
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CamsikSmartImage(
                    image: image,
                    fit: BoxFit.contain,
                    iconSize: 30,
                    iconColor: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                      if (brand.isNotEmpty)
                        Text(brand, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                      if (specs.isNotEmpty)
                        Text(
                          specs,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Up to', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    Text(
                      formatCurrency(basePrice),
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF059669), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

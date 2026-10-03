import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class TopDealsShowcase extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final VoidCallback onShopAll;

  const TopDealsShowcase({
    super.key,
    required this.products,
    required this.onShopAll,
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certified Refurbished Deals',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '45-Point certified · 12 months warranty · 90%+ battery',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onShopAll,
                child: const Text('Shop All', style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (ctx, idx) {
              final p = products[idx];
              final name = p['model'] as String? ?? 'Device';
              final price = (p['sellingPrice'] as num?)?.toInt() ?? 0;
              final origPrice = (p['originalPrice'] as num?)?.toInt() ?? 0;
              final discount = (p['discount'] as num?)?.toInt() ?? 0;
              final bRaw = p['batteryHealth'];
              final battery = bRaw is num ? '$bRaw% Battery' : (bRaw?.toString() ?? '98% Battery');
              final image = p['image'] as String? ?? '';

              return Container(
                width: 170,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$discount% OFF',
                            style: const TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          battery,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: CamsikSmartImage(
                          image: image,
                          fit: BoxFit.contain,
                          iconSize: 40,
                          iconColor: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          formatCurrency(price),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF059669)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatCurrency(origPrice),
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

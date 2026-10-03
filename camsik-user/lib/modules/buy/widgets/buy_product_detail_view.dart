import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class BuyProductDetailView extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onBack;
  final Function(int finalPrice) onCheckout;

  const BuyProductDetailView({
    super.key,
    required this.product,
    required this.onBack,
    required this.onCheckout,
  });

  @override
  State<BuyProductDetailView> createState() => _BuyProductDetailViewState();
}

class _BuyProductDetailViewState extends State<BuyProductDetailView> {
  int _selectedUnitIndex = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    var units = (p['availableUnits'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (units.isEmpty) {
      final brand = p['brand']?.toString() ?? 'Camsik';
      final cond = p['condition']?.toString() ?? 'Superb';
      final sellP = (p['sellingPrice'] as num?)?.toInt() ?? 0;
      final origP = (p['originalPrice'] as num?)?.toInt() ?? 0;
      final battRaw = p['batteryHealth'];
      final batt = battRaw is num ? '$battRaw% Battery' : (battRaw?.toString() ?? '98% Battery');
      units = [
        {
          'unitId': 'U-${p['id']}-01',
          'storage': p['storage']?.toString() ?? 'Standard',
          'color': p['color']?.toString() ?? 'Standard',
          'condition': cond,
          'batteryHealth': batt,
          'price': sellP,
          'originalPrice': origP,
          'serial': 'CSM-${brand.toUpperCase().replaceAll(' ', '')}-8811',
          'note': 'Tracked Unit 1 · $batt · $cond Condition · 45-Point Tested',
        },
        {
          'unitId': 'U-${p['id']}-02',
          'storage': p['storage']?.toString() ?? 'Standard',
          'color': p['color']?.toString() ?? 'Standard',
          'condition': cond,
          'batteryHealth': batt,
          'price': sellP,
          'originalPrice': origP,
          'serial': 'CSM-${brand.toUpperCase().replaceAll(' ', '')}-8812',
          'note': 'Tracked Unit 2 · $batt · Like-New Flawless · Verified',
        },
      ];
    }
    final activeUnit = units.isNotEmpty && _selectedUnitIndex < units.length
        ? units[_selectedUnitIndex]
        : <String, dynamic>{};

    final currentPrice = (activeUnit['price'] as num?)?.toInt() ?? ((p['sellingPrice'] as num?)?.toInt() ?? 0);
    final bRaw = activeUnit['batteryHealth'] ?? p['batteryHealth'];
    final currentBattery = bRaw is num ? '$bRaw% Battery' : (bRaw?.toString() ?? '98% Battery');
    final gallery = (p['gallery'] as List?)?.map((e) => e.toString()).toList() ?? [p['image']?.toString() ?? 'assets/images/categories/dslr.png'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: Text(p['model'] as String? ?? 'Device', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gallery
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: gallery.length,
                itemBuilder: (c, i) => Center(
                  child: CamsikSmartImage(
                    image: gallery[i],
                    fit: BoxFit.contain,
                    iconSize: 60,
                    iconColor: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              p['model'] as String? ?? 'Device',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            Text(
              p['specs'] as String? ?? '',
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  formatCurrency(currentPrice),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                ),
                const SizedBox(width: 8),
                Text(
                  formatCurrency((p['originalPrice'] as num?)?.toInt() ?? 0),
                  style: const TextStyle(decoration: TextDecoration.lineThrough, color: Color(0xFF94A3B8), fontSize: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '${(p['discount'] as num?)?.toInt() ?? 0}% OFF',
                    style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // MULTIPLE UNITS SELECTOR ON SAME PAGE
            const Text('Select Tracked Available Unit:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            ...List.generate(units.length, (uIdx) {
              final u = units[uIdx];
              final isSel = _selectedUnitIndex == uIdx;
              final uNote = u['note'] as String? ?? 'Unit ${uIdx + 1}';
              final uPrice = (u['price'] as num?)?.toInt() ?? currentPrice;

              return InkWell(
                onTap: () => setState(() => _selectedUnitIndex = uIdx),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF059669).withValues(alpha: 0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSel ? const Color(0xFF059669) : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSel ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(uNote, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('Battery / Health: $currentBattery', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Text(
                        formatCurrency(uPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            // Inspection Scorecard
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: Color(0xFF059669), size: 16),
                      SizedBox(width: 6),
                      Text('45-Point Hardware Diagnostics Passed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('✓ OLED / Retinal Panel: 100% Passed\n✓ TrueTone & 120Hz ProMotion: Verified\n✓ Battery Longevity: Verified Operational\n✓ Cameras & OIS Stabilization: 100% Tested\n✓ 12-Month Camsik Comprehensive Warranty Included',
                    style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                onPressed: () => widget.onCheckout(currentPrice),
                child: const Text('Proceed to Instant Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

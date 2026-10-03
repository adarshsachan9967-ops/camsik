import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class ExchangeProductDetailStep extends StatelessWidget {
  final Map<String, dynamic>? selectedNewDevice;
  final String selectedCondition;
  final int selectedUnitIndex;
  final int calculatedOldValue;
  final int exchangeBonus;
  final ValueChanged<String> onConditionChanged;
  final ValueChanged<int> onUnitSelected;
  final VoidCallback onProceedToCheckout;

  const ExchangeProductDetailStep({
    super.key,
    required this.selectedNewDevice,
    required this.selectedCondition,
    required this.selectedUnitIndex,
    required this.calculatedOldValue,
    required this.exchangeBonus,
    required this.onConditionChanged,
    required this.onUnitSelected,
    required this.onProceedToCheckout,
  });

  int _getAdjustedNewDevicePrice() {
    final basePrice =
        (selectedNewDevice?['sellingPrice'] as int?) ?? 70000;
    if (selectedCondition == 'Good') return (basePrice * 0.92).toInt();
    if (selectedCondition == 'Fair') return (basePrice * 0.85).toInt();
    return basePrice;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedNewDevice == null) {
      return const Center(child: Text('Device not selected'));
    }

    final p = selectedNewDevice!;
    final name = p['model'] as String? ?? 'Device';
    final brand = p['brand'] as String? ?? 'Brand';
    final image = p['image'] as String? ?? 'assets/images/categories/dslr.png';
    final specs = p['specs'] as String? ??
        'Certified 45-point hardware tested with comprehensive warranty.';
    final units = (p['availableUnits'] as List?) ?? [
      {'serial': 'CSM-8821', 'batteryHealth': '96%', 'warranty': '12 Months'},
      {'serial': 'CSM-8822', 'batteryHealth': '92%', 'warranty': '12 Months'},
    ];

    final adjustedPrice = _getAdjustedNewDevicePrice();
    final totalTradeIn = calculatedOldValue + exchangeBonus;
    final netDiff = adjustedPrice - totalTradeIn;
    final netPayable = netDiff > 0 ? netDiff : 0;
    final cashback = netDiff < 0 ? netDiff.abs() : 0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Main Image
                Center(
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: CamsikSmartImage(
                      image: image,
                      fit: BoxFit.contain,
                      iconSize: 64,
                      iconColor: const Color(0xFF4F46E5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title and Brand
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '$brand · Certified Refurbished',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
                const SizedBox(height: 14),

                // Condition Selector Tabs (Superb, Good, Fair)
                const Text(
                  'Select Refurbished Grade:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildConditionChip('Superb', 'Superb (Like New)'),
                    const SizedBox(width: 8),
                    _buildConditionChip('Good', 'Good Condition'),
                    const SizedBox(width: 8),
                    _buildConditionChip('Fair', 'Fair Condition'),
                  ],
                ),
                const SizedBox(height: 16),

                // Available Unit Selector
                const Text(
                  'Select Verified Serial Unit:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(units.length, (uIdx) {
                    final u = units[uIdx] as Map<String, dynamic>;
                    final isSel = selectedUnitIndex == uIdx;
                    final serial = u['serial']?.toString() ?? 'Unit ${uIdx + 1}';
                    final battery = u['batteryHealth']?.toString() ?? '95%';
                    final warranty = u['warranty']?.toString() ?? '12 Months';

                    return InkWell(
                      onTap: () => onUnitSelected(uIdx),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSel
                              ? const Color(0xFF4F46E5).withValues(alpha: 0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSel
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isSel
                                      ? Icons.check_circle
                                      : Icons.radio_button_off,
                                  color: isSel
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFF94A3B8),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  serial,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Battery: $battery',
                                    style: const TextStyle(
                                      color: Color(0xFF059669),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    warranty,
                                    style: const TextStyle(
                                      color: Color(0xFF7C3AED),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // 45-Point Inspection Checklist Badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified,
                              color: Color(0xFF059669), size: 18),
                          SizedBox(width: 6),
                          Text(
                            '45-Point Hardware Certified',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        specs,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Live Exchange Calculation Sticky Bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cashback > 0 ? 'Cashback to You:' : 'Net Difference:',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        cashback > 0
                            ? '+$kRupee${formatCurrency(cashback)}'
                            : formatCurrency(netPayable),
                        style: TextStyle(
                          color: cashback > 0
                              ? const Color(0xFF059669)
                              : const Color(0xFF4F46E5),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onProceedToCheckout,
                    child: const Row(
                      children: [
                        Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConditionChip(String key, String label) {
    final isSel = selectedCondition == key;
    return Expanded(
      child: InkWell(
        onTap: () => onConditionChanged(key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? const Color(0xFF4F46E5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSel ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSel ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

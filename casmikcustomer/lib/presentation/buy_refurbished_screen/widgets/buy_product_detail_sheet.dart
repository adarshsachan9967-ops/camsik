import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

// Product detail anatomy locked from Image 2.3:
// image full-width ~45% + color/condition selector right overlay
// + name bold 2-line + size/condition chips row + fixed bottom price + buy button
class BuyProductDetailSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onWishlist;
  final VoidCallback onAddToCart;

  const BuyProductDetailSheet({
    required this.product,
    required this.onWishlist,
    required this.onAddToCart,
    super.key,
  });

  @override
  State<BuyProductDetailSheet> createState() => _BuyProductDetailSheetState();
}

class _BuyProductDetailSheetState extends State<BuyProductDetailSheet> {
  // TODO: Replace with Riverpod/Bloc for production
  String _selectedCondition = '';
  bool _inspectionExpanded = false;

  final List<Map<String, dynamic>> _conditions = [
    {
      'label': 'Fair',
      'multiplier': 0.88,
      'desc': 'Minor wear, fully functional',
    },
    {'label': 'Good', 'multiplier': 1.0, 'desc': 'Light use, great condition'},
    {'label': 'Superb', 'multiplier': 1.12, 'desc': 'Like new, minimal use'},
  ];

  final List<Map<String, dynamic>> _inspectionPoints = [
    {
      'label': 'Display',
      'status': 'Pass',
      'desc': 'No dead pixels, perfect touch response',
    },
    {'label': 'Battery', 'status': 'Pass', 'desc': 'Health above threshold'},
    {
      'label': 'Camera',
      'status': 'Pass',
      'desc': 'All lenses functional, clear output',
    },
    {
      'label': 'Connectivity',
      'status': 'Pass',
      'desc': 'WiFi, Bluetooth, cellular working',
    },
    {
      'label': 'Speakers/Mic',
      'status': 'Pass',
      'desc': 'Clear audio input and output',
    },
    {
      'label': 'Charging Port',
      'status': 'Pass',
      'desc': 'Fast charging functional',
    },
    {
      'label': 'Face ID / Touch ID',
      'status': 'Pass',
      'desc': 'Biometrics working perfectly',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCondition = widget.product['condition'] as String;
  }

  double get _displayPrice {
    final base = (widget.product['price'] as int).toDouble();
    final conditionData = _conditions.firstWhere(
      (c) => c['label'] == _selectedCondition,
      orElse: () => _conditions[1],
    );
    return base * (conditionData['multiplier'] as double);
  }

  @override
  Widget build(BuildContext context) {
    final isWishlisted = widget.product['isWishlisted'] as bool;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar row (anatomy locked from Image 2.3)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderLight),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'arrow_back',
                                color: AppTheme.textPrimary,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Product Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: widget.onWishlist,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderLight),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: isWishlisted
                                    ? 'wishlist_filled'
                                    : 'wishlist',
                                color: isWishlisted
                                    ? AppTheme.error
                                    : AppTheme.textMuted,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Product image + condition selector (anatomy locked from Image 2.3)
                  Stack(
                    children: [
                      // Full-width image ~45% viewport (anatomy locked)
                      CustomImageWidget(
                        imageUrl: widget.product['imageUrl'] as String,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.35,
                        fit: BoxFit.cover,
                        semanticLabel:
                            widget.product['semanticLabel'] as String,
                      ),
                      // Condition selector — vertical column right overlay (anatomy locked from Image 2.3)
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Column(
                          children: _conditions.map((c) {
                            final isSelected = c['label'] == _selectedCondition;
                            return GestureDetector(
                              onTap: () => setState(
                                () => _selectedCondition = c['label'] as String,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primary
                                        : AppTheme.borderLight,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(26),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    (c['label'] as String)[0],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product name bold 2-line (anatomy locked from Image 2.3)
                        Text(
                          widget.product['name'] as String,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.product['brand']} • ${widget.product['warranty']} warranty',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Condition chips row (anatomy locked from Image 2.3 — rectangular chips, selected = filled)
                        const Text(
                          'Condition',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: _conditions.map((c) {
                            final isSelected = c['label'] == _selectedCondition;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => setState(
                                  () =>
                                      _selectedCondition = c['label'] as String,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    // Anatomy locked: selected = filled dark, unselected = outlined rectangular
                                    color: isSelected
                                        ? AppTheme.textPrimary
                                        : AppTheme.surfaceLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.textPrimary
                                          : AppTheme.borderLight,
                                    ),
                                  ),
                                  child: Text(
                                    c['label'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Battery health
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'battery',
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Battery Health',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '${widget.product['batteryHealth']}%',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withAlpha(38),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  (widget.product['batteryHealth'] as int) > 90
                                      ? 'Excellent'
                                      : (widget.product['batteryHealth']
                                                as int) >
                                            80
                                      ? 'Good'
                                      : 'Fair',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Inspection report accordion
                        InkWell(
                          onTap: () => setState(
                            () => _inspectionExpanded = !_inspectionExpanded,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'verified',
                                  color: AppTheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Inspection Report (7 points)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                                CustomIconWidget(
                                  iconName: _inspectionExpanded
                                      ? 'expand_less'
                                      : 'expand_more',
                                  color: AppTheme.textSecondary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_inspectionExpanded) ...[
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: Column(
                              children: _inspectionPoints.map((point) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'check_circle',
                                        color: AppTheme.primary,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              point['label'] as String,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              point['desc'] as String,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      StatusBadgeWidget(
                                        label: point['status'] as String,
                                        style: BadgeStyle.success,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fixed bottom price + buy button (anatomy locked from Image 2.3)
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              border: Border(top: BorderSide(color: AppTheme.borderLight)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${_displayPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

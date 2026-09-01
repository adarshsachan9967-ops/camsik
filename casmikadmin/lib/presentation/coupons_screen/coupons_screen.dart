import 'package:flutter/material.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  final List<Map<String, dynamic>> _coupons = [
    {
      'code': 'CASMIK20',
      'title': 'Flat 20% Off',
      'desc': 'Get 20% off on all sell orders',
      'discount': 20,
      'type': 'percent',
      'minOrder': 5000,
      'maxDiscount': 2000,
      'used': 142,
      'limit': 500,
      'expiry': '31 Dec 2026',
      'active': true,
    },
    {
      'code': 'FIRST500',
      'title': '₹500 Off First Order',
      'desc': 'New user first order discount',
      'discount': 500,
      'type': 'flat',
      'minOrder': 2000,
      'maxDiscount': 500,
      'used': 89,
      'limit': 200,
      'expiry': '30 Sep 2026',
      'active': true,
    },
    {
      'code': 'REPAIR15',
      'title': '15% Off Repairs',
      'desc': 'Discount on all repair services',
      'discount': 15,
      'type': 'percent',
      'minOrder': 1000,
      'maxDiscount': 1500,
      'used': 67,
      'limit': 300,
      'expiry': '15 Oct 2026',
      'active': true,
    },
    {
      'code': 'REFURB10',
      'title': '10% Off Refurbished',
      'desc': 'On certified refurbished devices',
      'discount': 10,
      'type': 'percent',
      'minOrder': 10000,
      'maxDiscount': 5000,
      'used': 34,
      'limit': 100,
      'expiry': '31 Aug 2026',
      'active': false,
    },
    {
      'code': 'DIWALI25',
      'title': 'Diwali Special 25%',
      'desc': 'Festival season mega discount',
      'discount': 25,
      'type': 'percent',
      'minOrder': 8000,
      'maxDiscount': 3000,
      'used': 0,
      'limit': 1000,
      'expiry': '20 Oct 2026',
      'active': false,
    },
  ];

  void _copyCode(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon code "$code" copied!'),
        backgroundColor: const Color(0xFF00C853),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddDialog() {
    final codeCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final discountCtrl = TextEditingController();
    final minOrderCtrl = TextEditingController();
    final limitCtrl = TextEditingController();
    String discountType = 'percent';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add Coupon',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  'Coupon Code *',
                  codeCtrl,
                  'e.g. CASMIK20',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 10),
                _field(
                  'Title',
                  titleCtrl,
                  'e.g. Flat 20% Off',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 10),
                _field(
                  'Description',
                  descCtrl,
                  'Brief description',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        'Discount Value',
                        discountCtrl,
                        '20',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A2A)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: discountType,
                                isExpanded: true,
                                dropdownColor: bgColor,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13,
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'percent',
                                    child: Text('%'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'flat',
                                    child: Text('₹'),
                                  ),
                                ],
                                onChanged: (v) => setS(() => discountType = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        'Min Order (₹)',
                        minOrderCtrl,
                        '5000',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        'Usage Limit',
                        limitCtrl,
                        '500',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF888888)
                      : const Color(0xFF666666),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (codeCtrl.text.isNotEmpty) {
                  setState(() {
                    _coupons.add({
                      'code': codeCtrl.text.toUpperCase(),
                      'title': titleCtrl.text,
                      'desc': descCtrl.text,
                      'discount': int.tryParse(discountCtrl.text) ?? 0,
                      'type': discountType,
                      'minOrder': int.tryParse(minOrderCtrl.text) ?? 0,
                      'maxDiscount': 5000,
                      'used': 0,
                      'limit': int.tryParse(limitCtrl.text) ?? 100,
                      'expiry': '31 Dec 2026',
                      'active': true,
                    });
                  });
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Add Coupon',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl,
    String hint,
    bool isDark,
    Color textColor,
    Color borderColor, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: textColor, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? const Color(0xFF666666) : const Color(0xFF999999),
            ),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00C853)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF141414) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111111) : Colors.white,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coupons & Offers',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${_coupons.length} coupons · ${_coupons.where((c) => c['active'] == true).length} active',
                        style: TextStyle(color: subColor, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showAddDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.black, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Add Coupon',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _coupons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final coupon = _coupons[i];
                  final usagePercent = coupon['limit'] > 0
                      ? (coupon['used'] / coupon['limit']).clamp(0.0, 1.0)
                      : 0.0;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: coupon['active']
                            ? const Color(0xFF00C853).withAlpha(80)
                            : borderColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coupon['title'],
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    coupon['desc'],
                                    style: TextStyle(
                                      color: subColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: coupon['active'],
                              onChanged: (v) => setState(
                                () => _coupons[i] = {...coupon, 'active': v},
                              ),
                              activeColor: const Color(0xFF00C853),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _copyCode(coupon['code']),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: borderColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      coupon['code'],
                                      style: TextStyle(
                                        color: const Color(0xFF00C853),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.copy_outlined,
                                      size: 14,
                                      color: subColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C853).withAlpha(30),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                coupon['type'] == 'percent'
                                    ? '${coupon['discount']}% OFF'
                                    : '₹${coupon['discount']} OFF',
                                style: const TextStyle(
                                  color: Color(0xFF00C853),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Expires: ${coupon['expiry']}',
                              style: TextStyle(color: subColor, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Usage: ${coupon['used']}/${coupon['limit']}',
                              style: TextStyle(color: subColor, fontSize: 11),
                            ),
                            const Spacer(),
                            Text(
                              'Min: ₹${coupon['minOrder']}',
                              style: TextStyle(color: subColor, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: usagePercent,
                            backgroundColor: isDark
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFFE0E0E0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              usagePercent > 0.8
                                  ? const Color(0xFFFF9800)
                                  : const Color(0xFF00C853),
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
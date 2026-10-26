import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/helpers.dart';
import '../../../models/admin_models.dart';

class AdminCouponsScreen extends StatefulWidget {
  const AdminCouponsScreen({super.key});

  @override
  State<AdminCouponsScreen> createState() => _AdminCouponsScreenState();
}

class _AdminCouponsScreenState extends State<AdminCouponsScreen> {
  final List<AdminCoupon> _coupons = [
    const AdminCoupon(
      id: 'cpn-1',
      code: 'CAMSIK15',
      description: '15% Off on DSLR & Cinema Rentals',
      discountType: 'percentage',
      discountValue: 15.0,
      minOrderValue: 2000.0,
      maxDiscount: 1500.0,
      expiryDate: '2026-12-31',
      usageLimit: 500,
      usedCount: 142,
      active: true,
    ),
    const AdminCoupon(
      id: 'cpn-2',
      code: 'FIRSTBONUS',
      description: '₹500 Flat Bonus on First Camera Buyback',
      discountType: 'fixed',
      discountValue: 500.0,
      minOrderValue: 10000.0,
      maxDiscount: 500.0,
      expiryDate: '2026-11-30',
      usageLimit: 200,
      usedCount: 88,
      active: true,
    ),
    const AdminCoupon(
      id: 'cpn-3',
      code: 'FESTIVE2026',
      description: 'Festive Flash Discount ₹1,000 Off',
      discountType: 'fixed',
      discountValue: 1000.0,
      minOrderValue: 25000.0,
      maxDiscount: 1000.0,
      expiryDate: '2026-10-31',
      usageLimit: 100,
      usedCount: 97,
      active: false,
    ),
  ];

  void _showAddCouponDialog() {
    final codeController = TextEditingController();
    final descController = TextEditingController();
    final valController = TextEditingController(text: '10');
    final minController = TextEditingController(text: '1000');
    final maxController = TextEditingController(text: '500');
    String type = 'percentage';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Create Promo Coupon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Coupon Code (e.g. SONY10)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description / Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Discount Type', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'percentage', child: Text('Percentage (%) Off')),
                    DropdownMenuItem(value: 'fixed', child: Text('Fixed Flat (₹) Off')),
                  ],
                  onChanged: (v) => setModalState(() => type = v ?? 'percentage'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: valController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: type == 'percentage' ? 'Percentage (e.g. 15%)' : 'Flat Amount (₹)', border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: minController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Min Order Value (₹)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: maxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Max Discount Limit (₹)', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () {
                final code = codeController.text.trim().toUpperCase();
                if (code.isEmpty) return;
                setState(() {
                  _coupons.insert(
                    0,
                    AdminCoupon(
                      id: 'cpn-${DateTime.now().millisecondsSinceEpoch}',
                      code: code,
                      description: descController.text.trim().isEmpty ? 'Special Promo Code' : descController.text.trim(),
                      discountType: type,
                      discountValue: double.tryParse(valController.text) ?? 10.0,
                      minOrderValue: double.tryParse(minController.text) ?? 0.0,
                      maxDiscount: double.tryParse(maxController.text) ?? 500.0,
                      expiryDate: '2026-12-31',
                      usageLimit: 500,
                      usedCount: 0,
                      active: true,
                    ),
                  );
                });
                Navigator.pop(ctx);
                showCustomSnackBar(context, 'Coupon $code created successfully!', isError: false);
              },
              child: const Text('Save Coupon'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCoupon(int index) {
    setState(() {
      final c = _coupons[index];
      _coupons[index] = AdminCoupon(
        id: c.id,
        code: c.code,
        description: c.description,
        discountType: c.discountType,
        discountValue: c.discountValue,
        minOrderValue: c.minOrderValue,
        maxDiscount: c.maxDiscount,
        expiryDate: c.expiryDate,
        usageLimit: c.usageLimit,
        usedCount: c.usedCount,
        active: !c.active,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons & Offers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Coupon', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _showAddCouponDialog,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _coupons.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final c = _coupons[idx];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.active ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), style: BorderStyle.solid),
                      ),
                      child: Text(
                        c.code,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.primary, letterSpacing: 1.0),
                      ),
                    ),
                    Switch(
                      value: c.active,
                      activeTrackColor: AppColors.primary,
                      onChanged: (_) => _toggleCoupon(idx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(c.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      c.discountType == 'percentage' ? '${c.discountValue.toInt()}% OFF' : CurrencyFormatter.format(c.discountValue),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.success),
                    ),
                    const SizedBox(width: 12),
                    Text('Min Order: ${CurrencyFormatter.format(c.minOrderValue)}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(width: 12),
                    Text('Max: ${CurrencyFormatter.format(c.maxDiscount)}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
                const Divider(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Redeemed: ${c.usedCount} / ${c.usageLimit}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    Text('Expires: ${c.expiryDate}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

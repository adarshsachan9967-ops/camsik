import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';
import '../../services/api_service.dart';
import '../../widgets/camsik_smart_image.dart';
import 'widgets/buy_product_detail_view.dart';

class BuyRefurbishedWidget extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;

  const BuyRefurbishedWidget({
    super.key,
    required this.products,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
  });

  @override
  State<BuyRefurbishedWidget> createState() => _BuyRefurbishedWidgetState();
}

class _BuyRefurbishedWidgetState extends State<BuyRefurbishedWidget> {
  String _selectedCategory = 'all';
  String _selectedCondition = 'all';
  String _searchQuery = '';
  Map<String, dynamic>? _activeDetailProduct;

  @override
  Widget build(BuildContext context) {
    if (_activeDetailProduct != null) {
      return BuyProductDetailView(
        product: _activeDetailProduct!,
        onBack: () => setState(() => _activeDetailProduct = null),
        onCheckout: (finalPrice) => _handleBuyCheckout(finalPrice),
      );
    }

    var filtered = widget.products;
    if (_selectedCategory != 'all') {
      filtered = filtered.where((p) => (p['category'] as String).toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    if (_selectedCondition != 'all') {
      filtered = filtered.where((p) => (p['condition'] as String).toLowerCase() == _selectedCondition.toLowerCase()).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      filtered = filtered.where((p) =>
        (p['model'] as String).toLowerCase().contains(q) ||
        (p['brand'] as String).toLowerCase().contains(q)
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 1,
        title: const Text('Buy Certified Refurbished', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search iPhone, MacBook, Canon, Sony...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('all', 'All Categories'),
                      _buildCategoryChip('smartphones', 'Smartphones'),
                      _buildCategoryChip('cameras', 'Cameras'),
                      _buildCategoryChip('laptops', 'Laptops'),
                      _buildCategoryChip('tablets', 'Tablets'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildConditionChip('all', 'All Conditions'),
                      _buildConditionChip('superb', 'Superb (Like New)'),
                      _buildConditionChip('good', 'Good Condition'),
                      _buildConditionChip('fair', 'Fair Condition'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No devices found matching your criteria.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, idx) {
                      final p = filtered[idx];
                      final name = p['model'] as String? ?? 'Device';
                      final price = (p['sellingPrice'] as num?)?.toInt() ?? 0;
                      final origPrice = (p['originalPrice'] as num?)?.toInt() ?? 0;
                      final bRaw = p['batteryHealth'];
                      final battery = bRaw is num ? '$bRaw% Battery' : (bRaw?.toString() ?? '98% Battery');
                      final condition = p['condition'] as String? ?? 'Superb';
                      final image = p['image'] as String? ?? '';
                      final units = (p['availableUnits'] as List?) ?? [];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _activeDetailProduct = p;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                                      color: const Color(0xFFEDE9FE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      condition,
                                      style: const TextStyle(color: Color(0xFF6D28D9), fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    '${units.isEmpty ? 2 : units.length} Units',
                                    style: const TextStyle(color: Color(0xFF059669), fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Center(
                                  child: CamsikSmartImage(
                                    image: image,
                                    fit: BoxFit.contain,
                                    iconSize: 36,
                                    iconColor: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                battery,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                              ),
                              const SizedBox(height: 4),
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
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String val, String label) {
    final isSel = _selectedCategory == val;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        onSelected: (s) => setState(() => _selectedCategory = val),
        selectedColor: const Color(0xFF059669),
        labelStyle: TextStyle(
          color: isSel ? Colors.white : const Color(0xFF0F172A),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConditionChip(String val, String label) {
    final isSel = _selectedCondition == val;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        onSelected: (s) => setState(() => _selectedCondition = val),
        selectedColor: const Color(0xFF4F46E5),
        labelStyle: TextStyle(
          color: isSel ? Colors.white : const Color(0xFF0F172A),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleBuyCheckout(int finalPrice) async {
    final orderData = {
      'type': 'buy',
      'customerName': widget.userProfile.name,
      'customerPhone': widget.userProfile.phone,
      'customerAddress': widget.userProfile.address,
      'amount': finalPrice,
      'deviceName': 'Refurbished ${_activeDetailProduct!['model']}',
      'status': 'Order Placed',
      'paymentMethod': 'Prepaid / Online UPI',
    };

    final created = await ApiService.createOrder(orderData);
    if (created != null && mounted) {
      setState(() => _activeDetailProduct = null);
      widget.onOrderCreated(UserOrder.fromJson(created));
    }
  }
}

import 'package:flutter/material.dart';

class RefurbishedScreen extends StatefulWidget {
  const RefurbishedScreen({super.key});

  @override
  State<RefurbishedScreen> createState() => _RefurbishedScreenState();
}

class _RefurbishedScreenState extends State<RefurbishedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  String _selectedCondition = 'All Conditions';

  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'iPhone 15 Pro Max',
      'brand': 'Apple',
      'storage': '256GB',
      'condition': 'Superb',
      'price': 75000,
      'originalPrice': 159900,
      'battery': 95,
      'score': 92,
      'stock': 3,
      'warranty': '6 Months',
      'image':
          'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
      'status': 'available',
      'category': 'Smartphones',
    },
    {
      'name': 'iPhone 15 Pro',
      'brand': 'Apple',
      'storage': '128GB',
      'condition': 'Good',
      'price': 62000,
      'originalPrice': 134900,
      'battery': 88,
      'score': 85,
      'stock': 5,
      'warranty': '6 Months',
      'image':
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300&h=300&fit=crop',
      'status': 'available',
      'category': 'Smartphones',
    },
    {
      'name': 'Samsung Galaxy S24 Ultra',
      'brand': 'Samsung',
      'storage': '512GB',
      'condition': 'Superb',
      'price': 68000,
      'originalPrice': 129999,
      'battery': 92,
      'score': 90,
      'stock': 2,
      'warranty': '6 Months',
      'image':
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=300&h=300&fit=crop',
      'status': 'available',
      'category': 'Smartphones',
    },
    {
      'name': 'MacBook Pro 14"',
      'brand': 'Apple',
      'storage': '512GB',
      'condition': 'Good',
      'price': 95000,
      'originalPrice': 199900,
      'battery': 85,
      'score': 88,
      'stock': 1,
      'warranty': '3 Months',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300&h=300&fit=crop',
      'status': 'available',
      'category': 'Laptops',
    },
    {
      'name': 'iPad Pro 12.9"',
      'brand': 'Apple',
      'storage': '256GB',
      'condition': 'Fair',
      'price': 45000,
      'originalPrice': 112900,
      'battery': 78,
      'score': 75,
      'stock': 4,
      'warranty': '3 Months',
      'image':
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop',
      'status': 'available',
      'category': 'Tablets',
    },
    {
      'name': 'OnePlus 12',
      'brand': 'OnePlus',
      'storage': '256GB',
      'condition': 'Superb',
      'price': 38000,
      'originalPrice': 64999,
      'battery': 96,
      'score': 94,
      'stock': 6,
      'warranty': '6 Months',
      'image':
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=300&h=300&fit=crop',
      'status': 'available',
      'category': 'Smartphones',
    },
  ];

  List<Map<String, dynamic>> get _filteredDevices {
    return _devices.where((d) {
      final matchesSearch = d['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'All Categories' ||
          d['category'] == _selectedCategory;
      final matchesCondition =
          _selectedCondition == 'All Conditions' ||
          d['condition'] == _selectedCondition;
      return matchesSearch && matchesCategory && matchesCondition;
    }).toList();
  }

  Color _conditionColor(String condition) {
    switch (condition) {
      case 'Superb':
        return const Color(0xFF00C853);
      case 'Good':
        return const Color(0xFF2196F3);
      case 'Fair':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF888888);
    }
  }

  void _showAddEditDialog({Map<String, dynamic>? device}) {
    final nameCtrl = TextEditingController(text: device?['name'] ?? '');
    final priceCtrl = TextEditingController(
      text: device?['price']?.toString() ?? '',
    );
    final origPriceCtrl = TextEditingController(
      text: device?['originalPrice']?.toString() ?? '',
    );
    final batteryCtrl = TextEditingController(
      text: device?['battery']?.toString() ?? '',
    );
    final stockCtrl = TextEditingController(
      text: device?['stock']?.toString() ?? '',
    );
    final imageCtrl = TextEditingController(text: device?['image'] ?? '');
    String selectedCondition = device?['condition'] ?? 'Superb';
    String selectedCat = device?['category'] ?? 'Smartphones';
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
            device == null ? 'Add Device' : 'Edit Device',
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
                  'Device Name',
                  nameCtrl,
                  'e.g. iPhone 15 Pro Max',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 10),
                _dropdown(
                  'Category',
                  selectedCat,
                  ['Smartphones', 'Laptops', 'Tablets', 'Smartwatches'],
                  isDark,
                  textColor,
                  bgColor,
                  borderColor,
                  (v) => setS(() => selectedCat = v!),
                ),
                const SizedBox(height: 10),
                _dropdown(
                  'Condition',
                  selectedCondition,
                  ['Superb', 'Good', 'Fair'],
                  isDark,
                  textColor,
                  bgColor,
                  borderColor,
                  (v) => setS(() => selectedCondition = v!),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        'Sale Price (₹)',
                        priceCtrl,
                        '75000',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        'Original Price (₹)',
                        origPriceCtrl,
                        '159900',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        'Battery %',
                        batteryCtrl,
                        '95',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        'Stock',
                        stockCtrl,
                        '3',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _field(
                  'Image URL',
                  imageCtrl,
                  'https://...',
                  isDark,
                  textColor,
                  borderColor,
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
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    if (device == null) {
                      _devices.add({
                        'name': nameCtrl.text,
                        'brand': 'Apple',
                        'storage': '128GB',
                        'condition': selectedCondition,
                        'price': int.tryParse(priceCtrl.text) ?? 0,
                        'originalPrice': int.tryParse(origPriceCtrl.text) ?? 0,
                        'battery': int.tryParse(batteryCtrl.text) ?? 0,
                        'score': 80,
                        'stock': int.tryParse(stockCtrl.text) ?? 0,
                        'warranty': '3 Months',
                        'image': imageCtrl.text,
                        'status': 'available',
                        'category': selectedCat,
                      });
                    } else {
                      final idx = _devices.indexOf(device);
                      _devices[idx] = {
                        ...device,
                        'name': nameCtrl.text,
                        'condition': selectedCondition,
                        'price':
                            int.tryParse(priceCtrl.text) ?? device['price'],
                        'originalPrice':
                            int.tryParse(origPriceCtrl.text) ??
                            device['originalPrice'],
                        'battery':
                            int.tryParse(batteryCtrl.text) ?? device['battery'],
                        'stock':
                            int.tryParse(stockCtrl.text) ?? device['stock'],
                        'image': imageCtrl.text,
                        'category': selectedCat,
                      };
                    }
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
              child: Text(
                device == null ? 'Add Device' : 'Save Changes',
                style: const TextStyle(fontWeight: FontWeight.w600),
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

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    bool isDark,
    Color textColor,
    Color bgColor,
    Color borderColor,
    ValueChanged<String?> onChanged,
  ) {
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: bgColor,
              style: TextStyle(color: textColor, fontSize: 13),
              items: items
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: onChanged,
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

    final totalStock = _devices.fold<int>(
      0,
      (sum, d) => sum + (d['stock'] as int),
    );
    final avgDiscount = _devices.isEmpty
        ? 0
        : (_devices
                      .map(
                        (d) =>
                            ((d['originalPrice'] - d['price']) /
                            d['originalPrice'] *
                            100),
                      )
                      .reduce((a, b) => a + b) /
                  _devices.length)
              .round();

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
                        'Refurbished Devices',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Manage certified refurbished inventory',
                        style: TextStyle(color: subColor, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showAddEditDialog(),
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
                            'Add Device',
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
            // KPI row
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _kpiCard(
                    '${_devices.length}',
                    'Total Listings',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$totalStock units',
                    'Total Stock',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$avgDiscount%',
                    'Avg Discount',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '${_devices.where((d) => d['status'] == 'available').length}',
                    'Available',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                ],
              ),
            ),
            // Search + filters
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: TextStyle(color: textColor, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search devices...',
                          hintStyle: TextStyle(color: subColor, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.search,
                            color: subColor,
                            size: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _filterDropdown(
                    _selectedCategory,
                    ['All Categories', 'Smartphones', 'Laptops', 'Tablets'],
                    isDark,
                    textColor,
                    borderColor,
                    (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(width: 8),
                  _filterDropdown(
                    _selectedCondition,
                    ['All Conditions', 'Superb', 'Good', 'Fair'],
                    isDark,
                    textColor,
                    borderColor,
                    (v) => setState(() => _selectedCondition = v!),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemCount: _filteredDevices.length,
                itemBuilder: (_, i) {
                  final d = _filteredDevices[i];
                  final discount =
                      (((d['originalPrice'] - d['price']) /
                                  d['originalPrice']) *
                              100)
                          .round();
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                d['image'],
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 130,
                                  color: isDark
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFF0F0F0),
                                  child: Icon(
                                    Icons.devices,
                                    color: subColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _conditionColor(d['condition']),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  d['condition'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF3B30),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '-$discount%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      d['name'],
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF00C853,
                                      ).withAlpha(30),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      d['status'],
                                      style: const TextStyle(
                                        color: Color(0xFF00C853),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${d['brand']} · ${d['storage']}',
                                style: TextStyle(color: subColor, fontSize: 11),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '₹${d['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '₹${d['originalPrice'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                    style: TextStyle(
                                      color: subColor,
                                      fontSize: 10,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _statChip(
                                    '${d['battery']}%',
                                    'Battery',
                                    subColor,
                                    isDark,
                                  ),
                                  const SizedBox(width: 4),
                                  _statChip(
                                    '${d['score']}/100',
                                    'Score',
                                    subColor,
                                    isDark,
                                  ),
                                  const SizedBox(width: 4),
                                  _statChip(
                                    '${d['stock']}',
                                    'Stock',
                                    subColor,
                                    isDark,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                d['warranty'],
                                style: TextStyle(color: subColor, fontSize: 10),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showAddEditDialog(device: d),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF2A2A2A)
                                              : const Color(0xFFF0F0F0),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 12,
                                              color: subColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: subColor,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _devices.remove(d)),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFF3B30,
                                        ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 14,
                                        color: Color(0xFFFF3B30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  Widget _kpiCard(
    String value,
    String label,
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: subColor, fontSize: 9),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String value, String label, Color subColor, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(label, style: TextStyle(color: subColor, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _filterDropdown(
    String value,
    List<String> items,
    bool isDark,
    Color textColor,
    Color borderColor,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          style: TextStyle(color: textColor, fontSize: 11),
          icon: Icon(Icons.keyboard_arrow_down, size: 16, color: textColor),
          items: items
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
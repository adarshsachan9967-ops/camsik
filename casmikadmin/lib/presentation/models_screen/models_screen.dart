import 'package:flutter/material.dart';

class ModelsScreen extends StatefulWidget {
  const ModelsScreen({super.key});

  @override
  State<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedBrand = 'All Brands';

  final List<Map<String, dynamic>> _models = [
    {
      'name': 'iPhone 17 Pro Max',
      'slug': 'iphone-17-pro-max',
      'category': 'Smartphones',
      'brand': 'Apple',
      'basePrice': 134900,
      'storage': '256GB, 512GB, 1TB',
      'image':
          'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'iPhone 17 Pro',
      'slug': 'iphone-17-pro',
      'category': 'Smartphones',
      'brand': 'Apple',
      'basePrice': 119900,
      'storage': '128GB, 256GB, 512GB',
      'image':
          'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'iPhone 16 Pro Max',
      'slug': 'iphone-16-pro-max',
      'category': 'Smartphones',
      'brand': 'Apple',
      'basePrice': 85000,
      'storage': '256GB, 512GB',
      'image':
          'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'iPhone 16 Pro',
      'slug': 'iphone-16-pro',
      'category': 'Smartphones',
      'brand': 'Apple',
      'basePrice': 79000,
      'storage': '128GB, 256GB, 512GB',
      'image':
          'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'Samsung Galaxy S25 Ultra',
      'slug': 'samsung-s25-ultra',
      'category': 'Smartphones',
      'brand': 'Samsung',
      'basePrice': 129999,
      'storage': '256GB, 512GB, 1TB',
      'image':
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'Samsung Galaxy S25+',
      'slug': 'samsung-s25-plus',
      'category': 'Smartphones',
      'brand': 'Samsung',
      'basePrice': 99999,
      'storage': '256GB, 512GB',
      'image':
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'OnePlus 13',
      'slug': 'oneplus-13',
      'category': 'Smartphones',
      'brand': 'OnePlus',
      'basePrice': 69999,
      'storage': '256GB, 512GB',
      'image':
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'Google Pixel 9 Pro',
      'slug': 'pixel-9-pro',
      'category': 'Smartphones',
      'brand': 'Google',
      'basePrice': 109999,
      'storage': '128GB, 256GB',
      'image':
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'MacBook Pro 16"',
      'slug': 'macbook-pro-16',
      'category': 'Laptops',
      'brand': 'Apple',
      'basePrice': 249900,
      'storage': '512GB, 1TB',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=100&h=100&fit=crop',
      'status': 'Active',
    },
    {
      'name': 'Dell XPS 15',
      'slug': 'dell-xps-15',
      'category': 'Laptops',
      'brand': 'Dell',
      'basePrice': 149999,
      'storage': '512GB, 1TB',
      'image':
          'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=100&h=100&fit=crop',
      'status': 'Active',
    },
  ];

  List<String> get _brands {
    final brands = [
      'All Brands',
      ..._models.map((m) => m['brand'] as String).toSet(),
    ];
    return brands;
  }

  List<Map<String, dynamic>> get _filteredModels {
    return _models.where((m) {
      final matchesSearch = m['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesBrand =
          _selectedBrand == 'All Brands' || m['brand'] == _selectedBrand;
      return matchesSearch && matchesBrand;
    }).toList();
  }

  void _showAddEditDialog({Map<String, dynamic>? model}) {
    final nameCtrl = TextEditingController(text: model?['name'] ?? '');
    final priceCtrl = TextEditingController(
      text: model?['basePrice']?.toString() ?? '',
    );
    final storageCtrl = TextEditingController(text: model?['storage'] ?? '');
    final imageCtrl = TextEditingController(text: model?['image'] ?? '');
    String selectedCat = model?['category'] ?? 'Smartphones';
    String selectedBrand = model?['brand'] ?? 'Apple';
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
            model == null ? 'Add Model' : 'Edit Model',
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
                _dialogField(
                  'Model Name',
                  nameCtrl,
                  'e.g. iPhone 17 Pro Max',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 12),
                _dialogDropdown(
                  'Category',
                  selectedCat,
                  ['Smartphones', 'Laptops', 'Tablets', 'Smartwatches'],
                  isDark,
                  textColor,
                  bgColor,
                  borderColor,
                  (v) => setS(() => selectedCat = v!),
                ),
                const SizedBox(height: 12),
                _dialogDropdown(
                  'Brand',
                  selectedBrand,
                  [
                    'Apple',
                    'Samsung',
                    'OnePlus',
                    'Google',
                    'Xiaomi',
                    'Dell',
                    'HP',
                    'Lenovo',
                  ],
                  isDark,
                  textColor,
                  bgColor,
                  borderColor,
                  (v) => setS(() => selectedBrand = v!),
                ),
                const SizedBox(height: 12),
                _dialogField(
                  'Base Price (₹)',
                  priceCtrl,
                  'e.g. 75000',
                  isDark,
                  textColor,
                  borderColor,
                  isNumber: true,
                ),
                const SizedBox(height: 12),
                _dialogField(
                  'Storage Options (comma separated)',
                  storageCtrl,
                  '128GB, 256GB, 512GB',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 12),
                _dialogField(
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
                    if (model == null) {
                      _models.add({
                        'name': nameCtrl.text,
                        'slug': nameCtrl.text.toLowerCase().replaceAll(
                          ' ',
                          '-',
                        ),
                        'category': selectedCat,
                        'brand': selectedBrand,
                        'basePrice': int.tryParse(priceCtrl.text) ?? 0,
                        'storage': storageCtrl.text,
                        'image': imageCtrl.text,
                        'status': 'Active',
                      });
                    } else {
                      final idx = _models.indexOf(model);
                      _models[idx] = {
                        ...model,
                        'name': nameCtrl.text,
                        'category': selectedCat,
                        'brand': selectedBrand,
                        'basePrice':
                            int.tryParse(priceCtrl.text) ?? model['basePrice'],
                        'storage': storageCtrl.text,
                        'image': imageCtrl.text,
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
                model == null ? 'Add Model' : 'Save Changes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogField(
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
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: textColor, fontSize: 14),
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
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF00C853)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dialogDropdown(
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
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: bgColor,
              style: TextStyle(color: textColor, fontSize: 14),
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
                        'Device Models',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${_filteredModels.length} results',
                        style: TextStyle(color: subColor, fontSize: 13),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showAddEditDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
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
                            'Add Model',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search models...',
                          hintStyle: TextStyle(color: subColor, fontSize: 14),
                          prefixIcon: Icon(
                            Icons.search,
                            color: subColor,
                            size: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBrand,
                        dropdownColor: isDark
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        style: TextStyle(color: textColor, fontSize: 13),
                        items: _brands
                            .map(
                              (b) => DropdownMenuItem(value: b, child: Text(b)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedBrand = v!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isDark ? const Color(0xFF111111) : const Color(0xFFF0F0F0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'MODEL',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'BRAND',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'PRICE',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'STORAGE',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      'ACTIONS',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredModels.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: borderColor),
                itemBuilder: (_, i) {
                  final model = _filteredModels[i];
                  return Container(
                    color: cardColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  model['image'],
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 36,
                                    height: 36,
                                    color: isDark
                                        ? const Color(0xFF2A2A2A)
                                        : const Color(0xFFF0F0F0),
                                    child: Icon(
                                      Icons.devices,
                                      color: subColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model['name'],
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      model['slug'],
                                      style: TextStyle(
                                        color: subColor,
                                        fontSize: 10,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            model['brand'],
                            style: TextStyle(color: subColor, fontSize: 12),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₹${(model['basePrice'] as int).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            model['storage'].toString().split(',').first.trim(),
                            style: TextStyle(color: subColor, fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00C853).withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              model['status'],
                              style: const TextStyle(
                                color: Color(0xFF00C853),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showAddEditDialog(model: model),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 16,
                                  color: subColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _models.remove(model));
                                },
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: Color(0xFFFF3B30),
                                ),
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
}
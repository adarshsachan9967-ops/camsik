import 'package:flutter/material.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';

  final List<String> _categories = [
    'All Categories',
    'Smartphones',
    'Laptops',
    'Tablets',
    'Smartwatches',
    'Earbuds',
  ];

  final List<Map<String, dynamic>> _brands = [
    {
      'name': 'Apple',
      'category': 'Smartphones',
      'models': 24,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
      'active': true,
    },
    {
      'name': 'Samsung',
      'category': 'Smartphones',
      'models': 38,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
      'active': true,
    },
    {
      'name': 'OnePlus',
      'category': 'Smartphones',
      'models': 18,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/8/8a/OnePlus_Logo.svg',
      'active': true,
    },
    {
      'name': 'Google',
      'category': 'Smartphones',
      'models': 12,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg',
      'active': true,
    },
    {
      'name': 'Xiaomi',
      'category': 'Smartphones',
      'models': 22,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/2/29/Xiaomi_logo.svg',
      'active': true,
    },
    {
      'name': 'Dell',
      'category': 'Laptops',
      'models': 15,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/8/82/Dell_Logo.png',
      'active': true,
    },
    {
      'name': 'HP',
      'category': 'Laptops',
      'models': 20,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/a/ad/HP_logo_2012.svg',
      'active': true,
    },
    {
      'name': 'Lenovo',
      'category': 'Laptops',
      'models': 17,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/b/b8/Lenovo_logo_2015.svg',
      'active': true,
    },
    {
      'name': 'Apple',
      'category': 'Laptops',
      'models': 8,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
      'active': true,
    },
    {
      'name': 'Noise',
      'category': 'Smartwatches',
      'models': 10,
      'logo':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=100&h=100&fit=crop',
      'active': true,
    },
    {
      'name': 'boAt',
      'category': 'Earbuds',
      'models': 14,
      'logo':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=100&h=100&fit=crop',
      'active': false,
    },
    {
      'name': 'Sony',
      'category': 'Earbuds',
      'models': 9,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/c/ca/Sony_logo.svg',
      'active': true,
    },
    {
      'name': 'Apple',
      'category': 'Tablets',
      'models': 12,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
      'active': true,
    },
    {
      'name': 'Samsung',
      'category': 'Tablets',
      'models': 8,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg',
      'active': true,
    },
    {
      'name': 'OnePlus',
      'category': 'Tablets',
      'models': 4,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/8/8a/OnePlus_Logo.svg',
      'active': true,
    },
    {
      'name': 'Lenovo',
      'category': 'Tablets',
      'models': 6,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/b/b8/Lenovo_logo_2015.svg',
      'active': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredBrands {
    return _brands.where((b) {
      final matchesSearch = b['name'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'All Categories' ||
          b['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showAddEditDialog({Map<String, dynamic>? brand}) {
    final nameCtrl = TextEditingController(text: brand?['name'] ?? '');
    final logoCtrl = TextEditingController(text: brand?['logo'] ?? '');
    String selectedCat = brand?['category'] ?? 'Smartphones';
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
            brand == null ? 'Add New Brand' : 'Edit Brand',
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
                Text(
                  'Brand Name *',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'e.g. Apple',
                    hintStyle: TextStyle(
                      color: isDark
                          ? const Color(0xFF666666)
                          : const Color(0xFF999999),
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
                const SizedBox(height: 14),
                Text(
                  'Category *',
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
                    color: isDark
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCat,
                      isExpanded: true,
                      dropdownColor: bgColor,
                      style: TextStyle(color: textColor, fontSize: 14),
                      items:
                          [
                                'Smartphones',
                                'Laptops',
                                'Tablets',
                                'Smartwatches',
                                'Earbuds',
                              ]
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged: (v) => setS(() => selectedCat = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Logo URL',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: logoCtrl,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'https://...',
                    hintStyle: TextStyle(
                      color: isDark
                          ? const Color(0xFF666666)
                          : const Color(0xFF999999),
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
                    if (brand == null) {
                      _brands.add({
                        'name': nameCtrl.text,
                        'category': selectedCat,
                        'models': 0,
                        'logo': logoCtrl.text,
                        'active': true,
                      });
                    } else {
                      final idx = _brands.indexOf(brand);
                      _brands[idx] = {
                        ...brand,
                        'name': nameCtrl.text,
                        'category': selectedCat,
                        'logo': logoCtrl.text,
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
                brand == null ? 'Add Brand' : 'Save Changes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteBrand(Map<String, dynamic> brand) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        title: const Text(
          'Delete Brand',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text('Are you sure you want to delete "${brand['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _brands.remove(brand));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
            // Header
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
                        'Brands',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${_filteredBrands.length} brands · ${_filteredBrands.where((b) => b['active'] == true).length} active',
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
                            'Add Brand',
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
            // Filters
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
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
                        hintText: 'Search brands...',
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
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final isSelected = _selectedCategory == _categories[i];
                        return GestureDetector(
                          onTap: () => setState(
                            () => _selectedCategory = _categories[i],
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00C853)
                                  : (isDark
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00C853)
                                    : borderColor,
                              ),
                            ),
                            child: Text(
                              _categories[i],
                              style: TextStyle(
                                color: isSelected ? Colors.black : subColor,
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: _filteredBrands.length,
                itemBuilder: (_, i) {
                  final brand = _filteredBrands[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2A2A2A)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  brand['logo'],
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(
                                      brand['name'][0],
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: brand['active']
                                      ? const Color(0xFF00C853)
                                      : const Color(0xFFFF3B30),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: cardColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          brand['name'],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${brand['models']} models',
                          style: TextStyle(color: subColor, fontSize: 10),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _showAddEditDialog(brand: brand),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E1E1E)
                                      : const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 14,
                                  color: subColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => _deleteBrand(brand),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF3B30).withAlpha(30),
                                  borderRadius: BorderRadius.circular(6),
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
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _inventory = [
    {
      'sku': 'IPH17PM-256',
      'name': 'iPhone 17 Pro Max',
      'category': 'Smartphones',
      'brand': 'Apple',
      'storage': '256GB',
      'stock': 12,
      'reserved': 3,
      'reorderLevel': 5,
      'price': 134900,
    },
    {
      'sku': 'IPH17PM-512',
      'name': 'iPhone 17 Pro Max',
      'category': 'Smartphones',
      'brand': 'Apple',
      'storage': '512GB',
      'stock': 8,
      'reserved': 2,
      'reorderLevel': 5,
      'price': 149900,
    },
    {
      'sku': 'IPH16P-128',
      'name': 'iPhone 16 Pro',
      'category': 'Smartphones',
      'brand': 'Apple',
      'storage': '128GB',
      'stock': 3,
      'reserved': 1,
      'reorderLevel': 5,
      'price': 119900,
    },
    {
      'sku': 'SGS25U-256',
      'name': 'Samsung Galaxy S25 Ultra',
      'category': 'Smartphones',
      'brand': 'Samsung',
      'storage': '256GB',
      'stock': 15,
      'reserved': 4,
      'reorderLevel': 5,
      'price': 129999,
    },
    {
      'sku': 'OP13-256',
      'name': 'OnePlus 13',
      'category': 'Smartphones',
      'brand': 'OnePlus',
      'storage': '256GB',
      'stock': 2,
      'reserved': 0,
      'reorderLevel': 5,
      'price': 69999,
    },
    {
      'sku': 'MBP16-512',
      'name': 'MacBook Pro 16"',
      'category': 'Laptops',
      'brand': 'Apple',
      'storage': '512GB',
      'stock': 6,
      'reserved': 1,
      'reorderLevel': 3,
      'price': 249900,
    },
    {
      'sku': 'DXPS15-512',
      'name': 'Dell XPS 15',
      'category': 'Laptops',
      'brand': 'Dell',
      'storage': '512GB',
      'stock': 4,
      'reserved': 0,
      'reorderLevel': 3,
      'price': 149999,
    },
    {
      'sku': 'IPADP-256',
      'name': 'iPad Pro 12.9"',
      'category': 'Tablets',
      'brand': 'Apple',
      'storage': '256GB',
      'stock': 1,
      'reserved': 0,
      'reorderLevel': 3,
      'price': 112900,
    },
    {
      'sku': 'PXL9P-128',
      'name': 'Google Pixel 9 Pro',
      'category': 'Smartphones',
      'brand': 'Google',
      'storage': '128GB',
      'stock': 9,
      'reserved': 2,
      'reorderLevel': 5,
      'price': 109999,
    },
    {
      'sku': 'NOISE-SW1',
      'name': 'Noise ColorFit Pro 5',
      'category': 'Smartwatches',
      'brand': 'Noise',
      'storage': '-',
      'stock': 0,
      'reserved': 0,
      'reorderLevel': 5,
      'price': 4999,
    },
  ];

  List<Map<String, dynamic>> get _filteredInventory {
    return _inventory.where((item) {
      return item['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          item['sku'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          item['brand'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  String _getStatus(Map<String, dynamic> item) {
    final available = (item['stock'] as int) - (item['reserved'] as int);
    if (available <= 0) return 'Out of Stock';
    if (available <= (item['reorderLevel'] as int)) return 'Reorder';
    return 'Good';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Good':
        return const Color(0xFF00C853);
      case 'Reorder':
        return const Color(0xFFFF9800);
      case 'Out of Stock':
        return const Color(0xFFFF3B30);
      default:
        return const Color(0xFF888888);
    }
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

    final totalItems = _inventory.length;
    final totalStock = _inventory.fold<int>(
      0,
      (sum, i) => sum + (i['stock'] as int),
    );
    final lowStockCount = _inventory
        .where((i) => _getStatus(i) == 'Reorder')
        .length;
    final outOfStockCount = _inventory
        .where((i) => _getStatus(i) == 'Out of Stock')
        .length;

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
                  Text(
                    'Inventory',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 16,
                          color: subColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Export',
                          style: TextStyle(color: subColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // KPI cards
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _kpiCard(
                    '$totalItems',
                    'Total SKUs',
                    Icons.inventory_2_outlined,
                    const Color(0xFF2196F3),
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$totalStock',
                    'Total Stock',
                    Icons.warehouse_outlined,
                    const Color(0xFF00C853),
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$lowStockCount',
                    'Low Stock',
                    Icons.warning_amber_outlined,
                    const Color(0xFFFF9800),
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$outOfStockCount',
                    'Out of Stock',
                    Icons.remove_shopping_cart_outlined,
                    const Color(0xFFFF3B30),
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
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
                    hintText: 'Search by name, SKU, brand...',
                    hintStyle: TextStyle(color: subColor, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: subColor, size: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
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
                      'PRODUCT',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      'STOCK',
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
                      'RESERVED',
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
                      'AVAILABLE',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
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
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredInventory.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: borderColor),
                itemBuilder: (_, i) {
                  final item = _filteredInventory[i];
                  final available =
                      (item['stock'] as int) - (item['reserved'] as int);
                  final status = _getStatus(item);
                  final statusColor = _getStatusColor(status);
                  return Container(
                    color: cardColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(
                                    item['sku'],
                                    style: TextStyle(
                                      color: subColor,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF2A2A2A)
                                          : const Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['storage'],
                                      style: TextStyle(
                                        color: subColor,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${item['stock']}',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            '${item['reserved']}',
                            style: TextStyle(
                              color: const Color(0xFFFF9800),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            '$available',
                            style: TextStyle(
                              color: available > 0
                                  ? const Color(0xFF00C853)
                                  : const Color(0xFFFF3B30),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    IconData icon,
    Color accentColor,
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
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
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
}
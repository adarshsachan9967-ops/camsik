import 'package:flutter/material.dart';

class RepairIssuesScreen extends StatefulWidget {
  const RepairIssuesScreen({super.key});

  @override
  State<RepairIssuesScreen> createState() => _RepairIssuesScreenState();
}

class _RepairIssuesScreenState extends State<RepairIssuesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _issues = [
    {
      'name': 'Screen Replacement',
      'desc': 'Cracked or broken display replacement',
      'category': 'Smartphones',
      'minPrice': 2500,
      'maxPrice': 8500,
      'time': '2–4 hours',
      'warranty': '3 Months',
      'bookings': 142,
      'icon': '📱',
      'active': true,
    },
    {
      'name': 'Battery Replacement',
      'desc': 'Original battery replacement for longer life',
      'category': 'Smartphones',
      'minPrice': 1200,
      'maxPrice': 3500,
      'time': '1–2 hours',
      'warranty': '6 Months',
      'bookings': 98,
      'icon': '🔋',
      'active': true,
    },
    {
      'name': 'Charging Port Repair',
      'desc': 'Fix loose or non-functional charging port',
      'category': 'Smartphones',
      'minPrice': 800,
      'maxPrice': 2500,
      'time': '1–3 hours',
      'warranty': '3 Months',
      'bookings': 76,
      'icon': '⚡',
      'active': true,
    },
    {
      'name': 'Camera Repair',
      'desc': 'Front or rear camera module replacement',
      'category': 'Smartphones',
      'minPrice': 1500,
      'maxPrice': 6000,
      'time': '2–4 hours',
      'warranty': '3 Months',
      'bookings': 54,
      'icon': '📷',
      'active': true,
    },
    {
      'name': 'Speaker Repair',
      'desc': 'Earpiece or loudspeaker replacement',
      'category': 'Smartphones',
      'minPrice': 600,
      'maxPrice': 2000,
      'time': '1–2 hours',
      'warranty': '3 Months',
      'bookings': 43,
      'icon': '🔊',
      'active': true,
    },
    {
      'name': 'Screen Replacement',
      'desc': 'Laptop display panel replacement',
      'category': 'Laptops',
      'minPrice': 4000,
      'maxPrice': 18000,
      'time': '3–6 hours',
      'warranty': '6 Months',
      'bookings': 38,
      'icon': '💻',
      'active': true,
    },
    {
      'name': 'Keyboard Replacement',
      'desc': 'Full keyboard or individual key replacement',
      'category': 'Laptops',
      'minPrice': 2000,
      'maxPrice': 8000,
      'time': '2–4 hours',
      'warranty': '3 Months',
      'bookings': 29,
      'icon': '⌨️',
      'active': true,
    },
    {
      'name': 'Battery Replacement',
      'desc': 'Laptop battery replacement for extended life',
      'category': 'Laptops',
      'minPrice': 2500,
      'maxPrice': 7000,
      'time': '1–2 hours',
      'warranty': '6 Months',
      'bookings': 61,
      'icon': '🔋',
      'active': true,
    },
    {
      'name': 'Screen Replacement',
      'desc': 'Tablet display replacement',
      'category': 'Tablets',
      'minPrice': 3000,
      'maxPrice': 12000,
      'time': '3–5 hours',
      'warranty': '3 Months',
      'bookings': 22,
      'icon': '📱',
      'active': true,
    },
    {
      'name': 'Band Replacement',
      'desc': 'Smartwatch strap or band replacement',
      'category': 'Smartwatches',
      'minPrice': 300,
      'maxPrice': 1500,
      'time': '30 mins',
      'warranty': '1 Month',
      'bookings': 87,
      'icon': '⌚',
      'active': true,
    },
    {
      'name': 'Earbud Repair',
      'desc': 'Single or pair earbud repair/replacement',
      'category': 'Earbuds',
      'minPrice': 500,
      'maxPrice': 3000,
      'time': '1–2 hours',
      'warranty': '3 Months',
      'bookings': 34,
      'icon': '🎧',
      'active': false,
    },
  ];

  final List<String> _categories = [
    'All',
    'Smartphones',
    'Laptops',
    'Tablets',
    'Smartwatches',
    'Earbuds',
  ];

  List<Map<String, dynamic>> get _filteredIssues {
    return _issues.where((issue) {
      final matchesSearch =
          issue['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          issue['desc'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesCategory =
          _selectedCategory == 'All' || issue['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showAddEditDialog({Map<String, dynamic>? issue}) {
    final nameCtrl = TextEditingController(text: issue?['name'] ?? '');
    final descCtrl = TextEditingController(text: issue?['desc'] ?? '');
    final minPriceCtrl = TextEditingController(
      text: issue?['minPrice']?.toString() ?? '',
    );
    final maxPriceCtrl = TextEditingController(
      text: issue?['maxPrice']?.toString() ?? '',
    );
    final timeCtrl = TextEditingController(text: issue?['time'] ?? '');
    final warrantyCtrl = TextEditingController(text: issue?['warranty'] ?? '');
    String selectedCat = issue?['category'] ?? 'Smartphones';
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
            issue == null ? 'Add Repair Issue' : 'Edit Repair Issue',
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
                  'Issue Name',
                  nameCtrl,
                  'e.g. Screen Replacement',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 10),
                _field(
                  'Description',
                  descCtrl,
                  'Brief description...',
                  isDark,
                  textColor,
                  borderColor,
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
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
                          value: selectedCat,
                          isExpanded: true,
                          dropdownColor: bgColor,
                          style: TextStyle(color: textColor, fontSize: 13),
                          items:
                              [
                                    'Smartphones',
                                    'Laptops',
                                    'Tablets',
                                    'Smartwatches',
                                    'Earbuds',
                                  ]
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) => setS(() => selectedCat = v!),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        'Min Price (₹)',
                        minPriceCtrl,
                        '800',
                        isDark,
                        textColor,
                        borderColor,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        'Max Price (₹)',
                        maxPriceCtrl,
                        '8500',
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
                        'Time',
                        timeCtrl,
                        '2–4 hours',
                        isDark,
                        textColor,
                        borderColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _field(
                        'Warranty',
                        warrantyCtrl,
                        '3 Months',
                        isDark,
                        textColor,
                        borderColor,
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
                if (nameCtrl.text.isNotEmpty) {
                  setState(() {
                    if (issue == null) {
                      _issues.add({
                        'name': nameCtrl.text,
                        'desc': descCtrl.text,
                        'category': selectedCat,
                        'minPrice': int.tryParse(minPriceCtrl.text) ?? 0,
                        'maxPrice': int.tryParse(maxPriceCtrl.text) ?? 0,
                        'time': timeCtrl.text,
                        'warranty': warrantyCtrl.text,
                        'bookings': 0,
                        'icon': '🔧',
                        'active': true,
                      });
                    } else {
                      final idx = _issues.indexOf(issue);
                      _issues[idx] = {
                        ...issue,
                        'name': nameCtrl.text,
                        'desc': descCtrl.text,
                        'category': selectedCat,
                        'minPrice':
                            int.tryParse(minPriceCtrl.text) ??
                            issue['minPrice'],
                        'maxPrice':
                            int.tryParse(maxPriceCtrl.text) ??
                            issue['maxPrice'],
                        'time': timeCtrl.text,
                        'warranty': warrantyCtrl.text,
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
                issue == null ? 'Add Issue' : 'Save Changes',
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

    final totalBookings = _issues.fold<int>(
      0,
      (sum, i) => sum + (i['bookings'] as int),
    );
    final activeCount = _issues.where((i) => i['active'] == true).length;
    final categoryCount = _issues.map((i) => i['category']).toSet().length;

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
                        'Repair Issues',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${_issues.length} repair services · $activeCount active',
                        style: TextStyle(color: subColor, fontSize: 13),
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
                            'Add Repair Issue',
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
                    '${_issues.length}',
                    'Total Services',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$activeCount',
                    'Active',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    const Color(0xFF00C853),
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$totalBookings',
                    'Total Bookings',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    const Color(0xFFFF9800),
                  ),
                  const SizedBox(width: 8),
                  _kpiCard(
                    '$categoryCount',
                    'Categories',
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    const Color(0xFFFF3B30),
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
                    hintText: 'Search repair issues...',
                    hintStyle: TextStyle(color: subColor, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: subColor, size: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            // Category chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final isSelected = _selectedCategory == _categories[i];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = _categories[i]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00C853)
                            : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
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
            const SizedBox(height: 10),
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isDark ? const Color(0xFF111111) : const Color(0xFFF0F0F0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'ISSUE',
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
                      'CATEGORY',
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
                      'PRICE RANGE',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: Text(
                      'TIME',
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: Text(
                      'WARRANTY',
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
                      'BOOKING',
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
                itemCount: _filteredIssues.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: borderColor),
                itemBuilder: (_, i) {
                  final issue = _filteredIssues[i];
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
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF2A2A2A)
                                      : const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    issue['icon'],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      issue['name'],
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      issue['desc'],
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
                            issue['category'],
                            style: const TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹${issue['minPrice']}',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '₹${issue['maxPrice']}',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            issue['time'],
                            style: TextStyle(color: subColor, fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            issue['warranty'],
                            style: TextStyle(color: subColor, fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Row(
                            children: [
                              Text(
                                '${issue['bookings']}',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _showAddEditDialog(issue: issue),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 14,
                                  color: subColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _issues.remove(issue)),
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 14,
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

  Widget _kpiCard(
    String value,
    String label,
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
    Color accentColor,
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
                color: accentColor,
                fontSize: 18,
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
}
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

class _CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int totalOrders;
  final String totalSpent;
  final String lastActive;
  final String status;
  final String avatarInitials;
  final String avatarColor;

  const _CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastActive,
    required this.status,
    required this.avatarInitials,
    required this.avatarColor,
  });

  factory _CustomerModel.fromMap(Map<String, dynamic> m) => _CustomerModel(
    id: m['id'] as String,
    name: m['name'] as String,
    phone: m['phone'] as String,
    email: m['email'] as String,
    totalOrders: m['totalOrders'] as int,
    totalSpent: m['totalSpent'] as String,
    lastActive: m['lastActive'] as String,
    status: m['status'] as String,
    avatarInitials: m['avatarInitials'] as String,
    avatarColor: m['avatarColor'] as String,
  );
}

class CustomersListWidget extends StatefulWidget {
  final String searchQuery;
  final String statusFilter;

  const CustomersListWidget({
    required this.searchQuery,
    required this.statusFilter,
    super.key,
  });

  @override
  State<CustomersListWidget> createState() => _CustomersListWidgetState();
}

class _CustomersListWidgetState extends State<CustomersListWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production
  int? _expandedIndex;

  static const List<Map<String, dynamic>> _customerMaps = [
    {
      'id': 'CUS-001',
      'name': 'Arjun Mehta',
      'phone': '+91 98765 43210',
      'email': 'arjun.m@gmail.com',
      'totalOrders': 14,
      'totalSpent': '\$2,840',
      'lastActive': '2m ago',
      'status': 'active',
      'avatarInitials': 'AM',
      'avatarColor': '2196F3',
    },
    {
      'id': 'CUS-002',
      'name': 'Priya Sharma',
      'phone': '+91 87654 32109',
      'email': 'priya.s@gmail.com',
      'totalOrders': 8,
      'totalSpent': '\$1,290',
      'lastActive': '1h ago',
      'status': 'active',
      'avatarInitials': 'PS',
      'avatarColor': '9C27B0',
    },
    {
      'id': 'CUS-003',
      'name': 'Mohamed Al-Rashid',
      'phone': '+971 50 234 5678',
      'email': 'mo.rashid@outlook.com',
      'totalOrders': 22,
      'totalSpent': '\$5,640',
      'lastActive': '3h ago',
      'status': 'active',
      'avatarInitials': 'MR',
      'avatarColor': '00BCD4',
    },
    {
      'id': 'CUS-004',
      'name': 'Fatima Zahra',
      'phone': '+212 6 12 34 56 78',
      'email': 'fatima.z@hotmail.com',
      'totalOrders': 5,
      'totalSpent': '\$780',
      'lastActive': '1d ago',
      'status': 'active',
      'avatarInitials': 'FZ',
      'avatarColor': 'FF9800',
    },
    {
      'id': 'CUS-005',
      'name': 'Ravi Krishnan',
      'phone': '+91 76543 21098',
      'email': 'ravi.k@gmail.com',
      'totalOrders': 3,
      'totalSpent': '\$310',
      'lastActive': '2d ago',
      'status': 'blocked',
      'avatarInitials': 'RK',
      'avatarColor': 'FF3B30',
    },
    {
      'id': 'CUS-006',
      'name': 'Amara Diallo',
      'phone': '+221 77 123 4567',
      'email': 'amara.d@gmail.com',
      'totalOrders': 18,
      'totalSpent': '\$3,960',
      'lastActive': '30m ago',
      'status': 'active',
      'avatarInitials': 'AD',
      'avatarColor': '4CAF50',
    },
    {
      'id': 'CUS-007',
      'name': 'Chen Wei',
      'phone': '+86 138 0013 8000',
      'email': 'chen.w@163.com',
      'totalOrders': 7,
      'totalSpent': '\$1,540',
      'lastActive': '5h ago',
      'status': 'active',
      'avatarInitials': 'CW',
      'avatarColor': 'E91E63',
    },
    {
      'id': 'CUS-008',
      'name': 'Kavita Nair',
      'phone': '+91 65432 10987',
      'email': 'kavita.n@yahoo.com',
      'totalOrders': 31,
      'totalSpent': '\$7,200',
      'lastActive': '10m ago',
      'status': 'active',
      'avatarInitials': 'KN',
      'avatarColor': '00C853',
    },
    {
      'id': 'CUS-009',
      'name': 'Omar Hassan',
      'phone': '+20 100 123 4567',
      'email': 'omar.h@gmail.com',
      'totalOrders': 1,
      'totalSpent': '\$145',
      'lastActive': '1w ago',
      'status': 'blocked',
      'avatarInitials': 'OH',
      'avatarColor': 'FF3B30',
    },
  ];

  late List<_CustomerModel> _customers;

  @override
  void initState() {
    super.initState();
    _customers = _customerMaps.map(_CustomerModel.fromMap).toList();
  }

  List<_CustomerModel> get _filtered => _customers.where((c) {
    final searchMatch =
        widget.searchQuery.isEmpty ||
        c.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
        c.phone.contains(widget.searchQuery) ||
        c.email.toLowerCase().contains(widget.searchQuery.toLowerCase());
    final statusMatch =
        widget.statusFilter == 'All' ||
        (widget.statusFilter == 'Active' && c.status == 'active') ||
        (widget.statusFilter == 'Blocked' && c.status == 'blocked');
    return searchMatch && statusMatch;
  }).toList();

  void _toggleBlock(int index) {
    // TODO: Replace with Supabase update
    setState(() {
      final c = _customers[index];
      final newStatus = c.status == 'active' ? 'blocked' : 'active';
      _customers[index] = _CustomerModel(
        id: c.id,
        name: c.name,
        phone: c.phone,
        email: c.email,
        totalOrders: c.totalOrders,
        totalSpent: c.totalSpent,
        lastActive: c.lastActive,
        status: newStatus,
        avatarInitials: c.avatarInitials,
        avatarColor: c.avatarColor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final c = filtered[i];
        final realIndex = _customers.indexOf(c);
        final isExpanded = _expandedIndex == i;
        final isBlocked = c.status == 'blocked';
        final avatarColor = Color(int.parse('FF${c.avatarColor}', radix: 16));

        return GestureDetector(
          onTap: () => setState(() => _expandedIndex = isExpanded ? null : i),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isBlocked
                    ? const Color(0xffff3b3030)
                    : const Color(0xFF2A2A2A),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: avatarColor.withAlpha(38),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            c.avatarInitials,
                            style: TextStyle(
                              color: avatarColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    c.name,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                StatusBadgeWidget(
                                  status: isBlocked
                                      ? BadgeStatus.blocked
                                      : BadgeStatus.active,
                                  fontSize: 9,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              c.phone,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            c.totalSpent,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${c.totalOrders} orders',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isExpanded) ...[
                  Container(height: 1, color: const Color(0xFF1E1E1E)),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'email_outlined',
                              color: AppTheme.textMuted,
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              c.email,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme.textMuted,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Active ${c.lastActive}',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: CustomIconWidget(
                                  iconName: 'receipt_long',
                                  color: AppTheme.casmikGreen,
                                  size: 13,
                                ),
                                label: const Text(
                                  'View Orders',
                                  style: TextStyle(
                                    color: AppTheme.casmikGreen,
                                    fontSize: 12,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  side: const BorderSide(
                                    color: AppTheme.casmikGreenMuted,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _toggleBlock(realIndex),
                                icon: CustomIconWidget(
                                  iconName: isBlocked ? 'lock_open' : 'block',
                                  color: isBlocked
                                      ? AppTheme.casmikGreen
                                      : AppTheme.error,
                                  size: 13,
                                ),
                                label: Text(
                                  isBlocked ? 'Unblock' : 'Block',
                                  style: TextStyle(
                                    color: isBlocked
                                        ? AppTheme.casmikGreen
                                        : AppTheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  side: BorderSide(
                                    color: isBlocked
                                        ? AppTheme.casmikGreenMuted
                                        : const Color(0xffff3b3040),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

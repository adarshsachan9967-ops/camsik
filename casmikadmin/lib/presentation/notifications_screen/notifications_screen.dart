import 'package:flutter/material.dart';
import '../../main.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'type': 'Order',
      'title': 'New sell order received',
      'message': 'Rahul Sharma placed a sell order for iPhone 15 Pro Max',
      'time': '2 min ago',
      'read': false,
      'icon': 'receipt_long',
    },
    {
      'id': 2,
      'type': 'Partner',
      'title': 'New partner application',
      'message': 'TechFix Solutions has applied to become a partner',
      'time': '15 min ago',
      'read': false,
      'icon': 'handshake',
    },
    {
      'id': 3,
      'type': 'Payment',
      'title': 'Payout processed',
      'message': '₹12,500 payout sent to Vikram Logistics',
      'time': '1h ago',
      'read': false,
      'icon': 'account_balance_wallet',
    },
    {
      'id': 4,
      'type': 'Support',
      'title': 'New support ticket',
      'message': 'Customer Priya Nair opened ticket TKT-003',
      'time': '2h ago',
      'read': true,
      'icon': 'support_agent',
    },
    {
      'id': 5,
      'type': 'Order',
      'title': 'Order completed',
      'message': 'Order ORD-2847 has been completed successfully',
      'time': '3h ago',
      'read': true,
      'icon': 'check_circle',
    },
    {
      'id': 6,
      'type': 'System',
      'title': 'System update available',
      'message': 'A new version of the admin panel is available',
      'time': '5h ago',
      'read': true,
      'icon': 'system_update',
    },
    {
      'id': 7,
      'type': 'Partner',
      'title': 'Partner suspended',
      'message': 'Partner QuickFix Mumbai has been suspended',
      'time': '1d ago',
      'read': true,
      'icon': 'block',
    },
    {
      'id': 8,
      'type': 'Payment',
      'title': 'Bank verification request',
      'message': 'New bank account verification request from Amit Singh',
      'time': '1d ago',
      'read': true,
      'icon': 'verified',
    },
  ];

  final List<String> _filters = [
    'All',
    'Order',
    'Partner',
    'Payment',
    'Support',
    'System',
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications.where((n) => n['type'] == _selectedFilter).toList();
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'Order':
        return const Color(0xFF2196F3);
      case 'Partner':
        return const Color(0xFF9C27B0);
      case 'Payment':
        return const Color(0xFF00C853);
      case 'Support':
        return const Color(0xFFFF9800);
      case 'System':
        return const Color(0xFF888888);
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
    final unreadCount = _notifications.where((n) => n['read'] == false).length;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() {
                          for (var n in _notifications) {
                            n['read'] = true;
                          }
                        }),
                        child: Text(
                          'Mark all read',
                          style: TextStyle(
                            color: const Color(0xFF00C853),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Dark/Light mode toggle
                      GestureDetector(
                        onTap: () => themeNotifier.toggle(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            size: 18,
                            color: isDark
                                ? const Color(0xFFFF9800)
                                : const Color(0xFF555555),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final isSelected = _selectedFilter == _filters[i];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilter = _filters[i]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00C853)
                                  : (isDark
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00C853)
                                    : borderColor,
                              ),
                            ),
                            child: Text(
                              _filters[i],
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _filteredNotifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final notif = _filteredNotifications[i];
                  final isUnread = notif['read'] == false;
                  return GestureDetector(
                    onTap: () => setState(() => notif['read'] = true),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUnread
                            ? (isDark
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFF0FFF4))
                            : cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isUnread
                              ? const Color(0xFF00C853).withAlpha(80)
                              : borderColor,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _typeColor(notif['type']).withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.notifications_outlined,
                                size: 20,
                                color: _typeColor(notif['type']),
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
                                        notif['title'],
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 13,
                                          fontWeight: isUnread
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isUnread)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF00C853),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  notif['message'],
                                  style: TextStyle(
                                    color: subColor,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _typeColor(
                                          notif['type'],
                                        ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        notif['type'],
                                        style: TextStyle(
                                          color: _typeColor(notif['type']),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      notif['time'],
                                      style: TextStyle(
                                        color: subColor,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
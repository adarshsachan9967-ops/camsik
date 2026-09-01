import 'package:flutter/material.dart';

class DeliveryAgentsScreen extends StatefulWidget {
  const DeliveryAgentsScreen({super.key});

  @override
  State<DeliveryAgentsScreen> createState() => _DeliveryAgentsScreenState();
}

class _DeliveryAgentsScreenState extends State<DeliveryAgentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _activeAgents = [
    {
      'name': 'Ravi Kumar',
      'phone': '+91 98765 43210',
      'city': 'Mumbai',
      'orders': 142,
      'rating': 4.8,
      'status': 'On Duty',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Bike',
    },
    {
      'name': 'Suresh Patel',
      'phone': '+91 87654 32109',
      'city': 'Delhi',
      'orders': 98,
      'rating': 4.6,
      'status': 'Available',
      'avatar':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Scooter',
    },
    {
      'name': 'Amit Singh',
      'phone': '+91 76543 21098',
      'city': 'Bangalore',
      'orders': 215,
      'rating': 4.9,
      'status': 'On Duty',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Bike',
    },
    {
      'name': 'Priya Sharma',
      'phone': '+91 65432 10987',
      'city': 'Chennai',
      'orders': 67,
      'rating': 4.5,
      'status': 'Available',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Scooter',
    },
    {
      'name': 'Deepak Verma',
      'phone': '+91 54321 09876',
      'city': 'Hyderabad',
      'orders': 189,
      'rating': 4.7,
      'status': 'Off Duty',
      'avatar':
          'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Bike',
    },
  ];

  final List<Map<String, dynamic>> _pendingAgents = [
    {
      'name': 'Kiran Reddy',
      'phone': '+91 43210 98765',
      'city': 'Pune',
      'appliedDate': '22 Aug 2026',
      'docs': ['Aadhaar', 'License', 'Vehicle RC'],
      'avatar':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Bike',
    },
    {
      'name': 'Meera Nair',
      'phone': '+91 32109 87654',
      'city': 'Kochi',
      'appliedDate': '23 Aug 2026',
      'docs': ['Aadhaar', 'License'],
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Scooter',
    },
    {
      'name': 'Arjun Mehta',
      'phone': '+91 21098 76543',
      'city': 'Ahmedabad',
      'appliedDate': '24 Aug 2026',
      'docs': ['Aadhaar', 'License', 'Vehicle RC', 'Insurance'],
      'avatar':
          'https://images.unsplash.com/photo-1463453091185-61582044d556?w=100&h=100&fit=crop&crop=face',
      'vehicle': 'Bike',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'On Duty':
        return const Color(0xFF00C853);
      case 'Available':
        return const Color(0xFF2196F3);
      case 'Off Duty':
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

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111111) : Colors.white,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Agents',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF00C853),
                    unselectedLabelColor: subColor,
                    indicatorColor: const Color(0xFF00C853),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: 'Active (${_activeAgents.length})'),
                      Tab(text: 'Pending (${_pendingAgents.length})'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Active agents
                  ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _activeAgents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final agent = _activeAgents[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.network(
                                    agent['avatar'],
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 48,
                                      height: 48,
                                      color: isDark
                                          ? const Color(0xFF2A2A2A)
                                          : const Color(0xFFF0F0F0),
                                      child: Center(
                                        child: Text(
                                          agent['name'][0],
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _statusColor(agent['status']),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: cardColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        agent['name'],
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _statusColor(
                                            agent['status'],
                                          ).withAlpha(30),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          agent['status'],
                                          style: TextStyle(
                                            color: _statusColor(
                                              agent['status'],
                                            ),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${agent['city']} · ${agent['vehicle']}',
                                    style: TextStyle(
                                      color: subColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: const Color(0xFFFF9800),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${agent['rating']}',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        color: subColor,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${agent['orders']} orders',
                                        style: TextStyle(
                                          color: subColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF00C853,
                                      ).withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.call_outlined,
                                      size: 16,
                                      color: Color(0xFF00C853),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        backgroundColor: isDark
                                            ? const Color(0xFF1E1E1E)
                                            : Colors.white,
                                        title: Text(
                                          'Suspend Agent',
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        content: Text(
                                          'Suspend ${agent['name']}?',
                                          style: TextStyle(color: subColor),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(
                                                () =>
                                                    _activeAgents.remove(agent),
                                              );
                                              Navigator.pop(ctx);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFFF3B30,
                                              ),
                                            ),
                                            child: const Text(
                                              'Suspend',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFF3B30,
                                      ).withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.block_outlined,
                                      size: 16,
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
                  // Pending agents
                  ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _pendingAgents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final agent = _pendingAgents[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.network(
                                    agent['avatar'],
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 48,
                                      height: 48,
                                      color: isDark
                                          ? const Color(0xFF2A2A2A)
                                          : const Color(0xFFF0F0F0),
                                      child: Center(
                                        child: Text(
                                          agent['name'][0],
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        agent['name'],
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${agent['city']} · ${agent['vehicle']}',
                                        style: TextStyle(
                                          color: subColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Applied: ${agent['appliedDate']}',
                                        style: TextStyle(
                                          color: subColor,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFF9800,
                                    ).withAlpha(30),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Pending',
                                    style: TextStyle(
                                      color: Color(0xFFFF9800),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Documents:',
                              style: TextStyle(color: subColor, fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: (agent['docs'] as List)
                                  .map<Widget>(
                                    (doc) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF00C853,
                                        ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_outline,
                                            size: 12,
                                            color: Color(0xFF00C853),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            doc,
                                            style: const TextStyle(
                                              color: Color(0xFF00C853),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _pendingAgents.remove(agent);
                                        _activeAgents.add({
                                          ...agent,
                                          'orders': 0,
                                          'rating': 0.0,
                                          'status': 'Available',
                                        });
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00C853),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Approve',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _pendingAgents.remove(agent),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFF3B30,
                                        ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFFF3B30),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Reject',
                                          style: TextStyle(
                                            color: Color(0xFFFF3B30),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
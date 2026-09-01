import 'package:flutter/material.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  String _selectedStatus = 'All';
  final Map<String, TextEditingController> _replyControllers = {};
  final Map<String, bool> _expandedTickets = {};

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT-001',
      'subject': 'Order not picked up yet',
      'user': 'Rahul Sharma',
      'userType': 'Customer',
      'status': 'Open',
      'priority': 'High',
      'time': '2h ago',
      'message':
          'My sell order was scheduled for pickup 2 days ago but no one came. Order ID: ORD-2847',
      'replies': [],
    },
    {
      'id': 'TKT-002',
      'subject': 'Payment not received for completed order',
      'user': 'Vikram Logistics',
      'userType': 'Partner',
      'status': 'In Progress',
      'priority': 'High',
      'time': '5h ago',
      'message':
          'Order ORD-2801 was completed 3 days ago but payment is still pending in my wallet.',
      'replies': [
        {
          'from': 'Admin',
          'text': 'We are looking into this. Please allow 24 hours.',
          'time': '4h ago',
        },
      ],
    },
    {
      'id': 'TKT-003',
      'subject': 'App crashing on login',
      'user': 'Priya Nair',
      'userType': 'Customer',
      'status': 'Open',
      'priority': 'Medium',
      'time': '1d ago',
      'message':
          'The app keeps crashing when I try to login with Google. Using Android 14.',
      'replies': [],
    },
    {
      'id': 'TKT-004',
      'subject': 'Wrong device condition assessed',
      'user': 'Arjun Mehta',
      'userType': 'Customer',
      'status': 'Resolved',
      'priority': 'Low',
      'time': '2d ago',
      'message':
          'The agent assessed my iPhone as Fair condition but it is in Good condition.',
      'replies': [
        {
          'from': 'Admin',
          'text': 'We have re-evaluated and updated the price accordingly.',
          'time': '1d ago',
        },
      ],
    },
    {
      'id': 'TKT-005',
      'subject': 'Delivery route not optimized',
      'user': 'Ravi Kumar',
      'userType': 'Delivery Agent',
      'status': 'Open',
      'priority': 'Low',
      'time': '3h ago',
      'message':
          'The app is assigning me orders that are very far from each other. Please fix the routing.',
      'replies': [],
    },
  ];

  final List<String> _statuses = ['All', 'Open', 'In Progress', 'Resolved'];

  List<Map<String, dynamic>> get _filteredTickets {
    if (_selectedStatus == 'All') return _tickets;
    return _tickets.where((t) => t['status'] == _selectedStatus).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Open':
        return const Color(0xFFFF3B30);
      case 'In Progress':
        return const Color(0xFFFF9800);
      case 'Resolved':
        return const Color(0xFF00C853);
      default:
        return const Color(0xFF888888);
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFFF3B30);
      case 'Medium':
        return const Color(0xFFFF9800);
      case 'Low':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF888888);
    }
  }

  Color _userTypeColor(String type) {
    switch (type) {
      case 'Customer':
        return const Color(0xFF2196F3);
      case 'Partner':
        return const Color(0xFF9C27B0);
      case 'Delivery Agent':
        return const Color(0xFFFF9800);
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
                        'Support Tickets',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
                          '${_tickets.where((t) => t['status'] == 'Open').length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
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
                      itemCount: _statuses.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final isSelected = _selectedStatus == _statuses[i];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedStatus = _statuses[i]),
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
                              _statuses[i],
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
                itemCount: _filteredTickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final ticket = _filteredTickets[i];
                  final isExpanded = _expandedTickets[ticket['id']] ?? false;
                  _replyControllers.putIfAbsent(
                    ticket['id'],
                    () => TextEditingController(),
                  );

                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                            () => _expandedTickets[ticket['id']] = !isExpanded,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      ticket['id'],
                                      style: TextStyle(
                                        color: subColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _userTypeColor(
                                          ticket['userType'],
                                        ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        ticket['userType'],
                                        style: TextStyle(
                                          color: _userTypeColor(
                                            ticket['userType'],
                                          ),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _priorityColor(
                                          ticket['priority'],
                                        ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        ticket['priority'],
                                        style: TextStyle(
                                          color: _priorityColor(
                                            ticket['priority'],
                                          ),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(
                                          ticket['status'],
                                        ).withAlpha(30),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        ticket['status'],
                                        style: TextStyle(
                                          color: _statusColor(ticket['status']),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  ticket['subject'],
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      ticket['user'],
                                      style: TextStyle(
                                        color: subColor,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '·',
                                      style: TextStyle(color: subColor),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      ticket['time'],
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
                        ),
                        if (isExpanded) ...[
                          Divider(height: 1, color: borderColor),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1E1E1E)
                                        : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    ticket['message'],
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...(ticket['replies'] as List).map<Widget>(
                                  (reply) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF00C853,
                                            ).withAlpha(30),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'A',
                                              style: TextStyle(
                                                color: Color(0xFF00C853),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF00C853,
                                              ).withAlpha(20),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Admin',
                                                      style: TextStyle(
                                                        color: const Color(
                                                          0xFF00C853,
                                                        ),
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      reply['time'],
                                                      style: TextStyle(
                                                        color: subColor,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  reply['text'],
                                                  style: TextStyle(
                                                    color: textColor,
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
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller:
                                            _replyControllers[ticket['id']],
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 13,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Type a reply...',
                                          hintStyle: TextStyle(
                                            color: subColor,
                                            fontSize: 13,
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? const Color(0xFF1E1E1E)
                                              : const Color(0xFFF5F5F5),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: borderColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: borderColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF00C853),
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        final ctrl =
                                            _replyControllers[ticket['id']]!;
                                        if (ctrl.text.isNotEmpty) {
                                          setState(() {
                                            (ticket['replies'] as List).add({
                                              'from': 'Admin',
                                              'text': ctrl.text,
                                              'time': 'Just now',
                                            });
                                            ticket['status'] = 'In Progress';
                                            ctrl.clear();
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00C853),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.send,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (ticket['status'] != 'Resolved')
                                      GestureDetector(
                                        onTap: () => setState(
                                          () => ticket['status'] = 'Resolved',
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF00C853,
                                            ).withAlpha(30),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            'Mark Resolved',
                                            style: TextStyle(
                                              color: Color(0xFF00C853),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    if (ticket['status'] == 'Open')
                                      GestureDetector(
                                        onTap: () => setState(
                                          () =>
                                              ticket['status'] = 'In Progress',
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFFFF9800,
                                            ).withAlpha(30),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            'In Progress',
                                            style: TextStyle(
                                              color: Color(0xFFFF9800),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
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
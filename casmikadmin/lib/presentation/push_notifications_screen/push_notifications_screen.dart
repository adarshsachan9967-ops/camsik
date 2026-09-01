import 'package:flutter/material.dart';

class PushNotificationsScreen extends StatefulWidget {
  const PushNotificationsScreen({super.key});

  @override
  State<PushNotificationsScreen> createState() =>
      _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends State<PushNotificationsScreen> {
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  String _selectedAudience = 'All Users';
  bool _isSending = false;
  bool _sentSuccess = false;

  final List<String> _audiences = [
    'All Users',
    'Partners',
    'Delivery Agents',
    'Customers',
    'Custom Search',
  ];

  final List<Map<String, dynamic>> _sentHistory = [
    {
      'title': 'Diwali Offer!',
      'message': 'Get 25% off on all devices this Diwali!',
      'audience': 'All Users',
      'sent': '24 Aug 2026',
      'delivered': 4521,
      'opened': 1823,
    },
    {
      'title': 'New Feature: Live Tracking',
      'message': 'Track your order in real-time with our new feature',
      'audience': 'Customers',
      'sent': '20 Aug 2026',
      'delivered': 2341,
      'opened': 987,
    },
    {
      'title': 'Payout Update',
      'message': 'Your weekly payout has been processed',
      'audience': 'Partners',
      'sent': '18 Aug 2026',
      'delivered': 48,
      'opened': 45,
    },
  ];

  void _sendNotification() async {
    if (_titleCtrl.text.isEmpty || _messageCtrl.text.isEmpty) return;
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isSending = false;
      _sentSuccess = true;
      _sentHistory.insert(0, {
        'title': _titleCtrl.text,
        'message': _messageCtrl.text,
        'audience': _selectedAudience,
        'sent': 'Just now',
        'delivered': 0,
        'opened': 0,
      });
      _titleCtrl.clear();
      _messageCtrl.clear();
    });
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _sentSuccess = false);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Push Notifications',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Compose and send push notifications',
                style: TextStyle(color: subColor, fontSize: 13),
              ),
              const SizedBox(height: 16),
              // Compose card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compose Notification',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Audience',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _audiences.map((a) {
                        final isSelected = _selectedAudience == a;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedAudience = a),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00C853)
                                  : (isDark
                                        ? const Color(0xFF1E1E1E)
                                        : const Color(0xFFF5F5F5)),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00C853)
                                    : borderColor,
                              ),
                            ),
                            child: Text(
                              a,
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
                      }).toList(),
                    ),
                    if (_selectedAudience == 'Custom Search') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _searchCtrl,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search users by name or phone...',
                          hintStyle: TextStyle(color: subColor, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.search,
                            color: subColor,
                            size: 18,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF1E1E1E)
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
                            borderSide: const BorderSide(
                              color: Color(0xFF00C853),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Text(
                      'Notification Title *',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _titleCtrl,
                      style: TextStyle(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'e.g. Special Offer!',
                        hintStyle: TextStyle(color: subColor, fontSize: 13),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1E1E1E)
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
                          borderSide: const BorderSide(
                            color: Color(0xFF00C853),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Message *',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _messageCtrl,
                      maxLines: 4,
                      style: TextStyle(color: textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Write your notification message...',
                        hintStyle: TextStyle(color: subColor, fontSize: 13),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1E1E1E)
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
                          borderSide: const BorderSide(
                            color: Color(0xFF00C853),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_sentSuccess)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C853).withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00C853)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Color(0xFF00C853),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Notification sent successfully!',
                              style: TextStyle(
                                color: Color(0xFF00C853),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onTap: _isSending ? null : _sendNotification,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _isSending
                              ? const Color(0xFF00C853).withAlpha(150)
                              : const Color(0xFF00C853),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isSending) ...[
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ] else ...[
                              const Icon(
                                Icons.send,
                                color: Colors.black,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              _isSending ? 'Sending...' : 'Send Notification',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sent History',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              ..._sentHistory.map(
                (notif) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                          Expanded(
                            child: Text(
                              notif['title'],
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00C853).withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notif['audience'],
                              style: const TextStyle(
                                color: Color(0xFF00C853),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['message'],
                        style: TextStyle(color: subColor, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: subColor),
                          const SizedBox(width: 4),
                          Text(
                            notif['sent'],
                            style: TextStyle(color: subColor, fontSize: 11),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.send_outlined, size: 12, color: subColor),
                          const SizedBox(width: 4),
                          Text(
                            '${notif['delivered']} delivered',
                            style: TextStyle(color: subColor, fontSize: 11),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.open_in_new,
                            size: 12,
                            color: const Color(0xFF00C853),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${notif['opened']} opened',
                            style: const TextStyle(
                              color: Color(0xFF00C853),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
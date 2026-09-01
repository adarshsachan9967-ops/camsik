import 'package:flutter/material.dart';

class PendingActionsWidget extends StatelessWidget {
  const PendingActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.assignment_turned_in,
        iconColor: const Color(0xFF00C853),
        iconBg: const Color(0xFFE8FFF0),
        title: '3 New Assignments',
        subtitle: 'Accept or reject before 6:00 PM',
        tag: 'Urgent',
        tagColor: const Color(0xFFEF4444),
        tagBg: const Color(0xFFFEF2F2),
      ),
      _ActionItem(
        icon: Icons.search,
        iconColor: const Color(0xFF3B82F6),
        iconBg: const Color(0xFFEFF6FF),
        title: '2 Pending Inspections',
        subtitle: 'Devices awaiting quality check',
        tag: 'Action needed',
        tagColor: const Color(0xFF3B82F6),
        tagBg: const Color(0xFFEFF6FF),
      ),
      _ActionItem(
        icon: Icons.local_shipping,
        iconColor: const Color(0xFFF59E0B),
        iconBg: const Color(0xFFFFFBEB),
        title: '1 Pickup Overdue',
        subtitle: '#CSM-4815 · Scheduled 9:00 AM',
        tag: 'Overdue',
        tagColor: const Color(0xFFF59E0B),
        tagBg: const Color(0xFFFFFBEB),
      ),
      _ActionItem(
        icon: Icons.payments,
        iconColor: const Color(0xFF8B5CF6),
        iconBg: const Color(0xFFF5F3FF),
        title: 'Payout Request Ready',
        subtitle: '₹18,500 eligible for withdrawal',
        tag: 'Available',
        tagColor: const Color(0xFF8B5CF6),
        tagBg: const Color(0xFFF5F3FF),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Pending Actions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${actions.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: actions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _ActionCard(item: actions[i]),
        ),
      ],
    );
  }
}

class _ActionItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final Color tagBg;

  const _ActionItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
  });
}

class _ActionCard extends StatelessWidget {
  final _ActionItem item;
  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: item.tagBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: item.tagColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

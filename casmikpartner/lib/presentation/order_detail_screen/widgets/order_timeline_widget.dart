import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OrderTimelineWidget extends StatelessWidget {
  final String status;
  const OrderTimelineWidget({required this.status, super.key});

  static const List<Map<String, dynamic>> _allSteps = [
    {
      'label': 'Order Assigned',
      'status': 'New',
      'icon': Icons.assignment_outlined,
    },
    {
      'label': 'Accepted by Partner',
      'status': 'Accepted',
      'icon': Icons.check_circle_outline_rounded,
    },
    {
      'label': 'Pickup Scheduled',
      'status': 'Pickup',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'label': 'Device Inspection',
      'status': 'Inspection',
      'icon': Icons.fact_check_outlined,
    },
    {
      'label': 'Completed',
      'status': 'Completed',
      'icon': Icons.verified_outlined,
    },
  ];

  int _statusIndex(String s) {
    const order = ['New', 'Accepted', 'Pickup', 'Inspection', 'Completed'];
    final i = order.indexOf(s);
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _statusIndex(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.timeline_rounded,
                  size: 15,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Order Timeline',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._allSteps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isDone = i <= currentIndex;
            final isActive = i == currentIndex;
            final isLast = i == _allSteps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppTheme.primary
                            : const Color(0xFFEEEEEE),
                        shape: BoxShape.circle,
                        border: isActive
                            ? Border.all(color: AppTheme.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: isDone && !isActive
                            ? const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              )
                            : Icon(
                                step['icon'] as IconData,
                                size: 13,
                                color: isActive
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                              ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 28,
                        color: i < currentIndex
                            ? AppTheme.primary
                            : const Color(0xFFEEEEEE),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 4),
                    child: Text(
                      step['label'],
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isDone
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

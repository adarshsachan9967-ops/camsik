import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardPendingActionsWidget extends StatelessWidget {
  const DashboardPendingActionsWidget({super.key});

  static const List<Map<String, dynamic>> _actions = [
    {
      'title': 'Accept New Order',
      'subtitle': 'ORD-2847 · Samsung Galaxy A54',
      'icon': Icons.assignment_turned_in_outlined,
      'color': Color(0xFF1565C0),
      'action': 'Accept',
      'orderId': 'ORD-2847',
    },
    {
      'title': 'Schedule Pickup',
      'subtitle': 'ORD-2841 · iPhone 13 · Accepted',
      'icon': Icons.local_shipping_outlined,
      'color': Color(0xFFE65100),
      'action': 'Schedule',
      'orderId': 'ORD-2841',
    },
    {
      'title': 'Submit Inspection',
      'subtitle': 'ORD-2835 · OnePlus 11 · Pickup Done',
      'icon': Icons.fact_check_outlined,
      'color': Color(0xFF00695C),
      'action': 'Inspect',
      'orderId': 'ORD-2835',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pending Actions',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_actions.length} items',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._actions.asMap().entries.map((entry) {
            final i = entry.key;
            final action = entry.value;
            final color = action['color'] as Color;
            return Column(
              children: [
                if (i > 0) Divider(height: 1, color: const Color(0xFFF5F5F5)),
                InkWell(
                  onTap: () {
                    if (action['action'] == 'Inspect') {
                      context.push(
                        '/device-inspection-screen',
                        extra: action['orderId'],
                      );
                    } else {
                      context.push(
                        '/order-detail-screen',
                        extra: action['orderId'],
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: color.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            size: 18,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                action['title'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                action['subtitle'],
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            action['action'],
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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

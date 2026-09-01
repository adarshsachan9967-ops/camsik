import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class DashboardRecentOrdersWidget extends StatelessWidget {
  const DashboardRecentOrdersWidget({super.key});

  static final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-2847',
      'customer': 'Priya Sharma',
      'device': 'Samsung Galaxy A54 5G',
      'amount': '₹14,200',
      'status': 'New',
      'time': '10 min ago',
    },
    {
      'id': 'ORD-2845',
      'customer': 'Arjun Mehta',
      'device': 'iPhone 13 128GB',
      'amount': '₹32,500',
      'status': 'Pickup',
      'time': '1 hr ago',
    },
    {
      'id': 'ORD-2842',
      'customer': 'Fatima Khan',
      'device': 'OnePlus Nord CE 3',
      'amount': '₹11,800',
      'status': 'Inspection',
      'time': '2 hrs ago',
    },
    {
      'id': 'ORD-2839',
      'customer': 'Ravi Nair',
      'device': 'Xiaomi 13 Pro',
      'amount': '₹28,000',
      'status': 'Completed',
      'time': '5 hrs ago',
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
                  'Recent Orders',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/orders-screen'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                  ),
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._orders.asMap().entries.map((entry) {
            final i = entry.key;
            final order = entry.value;
            return Column(
              children: [
                if (i > 0) Divider(height: 1, color: const Color(0xFFF5F5F5)),
                InkWell(
                  onTap: () =>
                      context.push('/order-detail-screen', extra: order['id']),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.smartphone_outlined,
                            size: 20,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    order['id'],
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  StatusBadgeWidget(status: order['status']),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${order['customer']} · ${order['device']}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              order['amount'],
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              order['time'],
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

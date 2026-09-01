import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../widgets/empty_state_widget.dart';

class OrdersTabContentWidget extends StatefulWidget {
  final String status;
  const OrdersTabContentWidget({required this.status, super.key});

  @override
  State<OrdersTabContentWidget> createState() => _OrdersTabContentWidgetState();
}

class _OrdersTabContentWidgetState extends State<OrdersTabContentWidget>
    with AutomaticKeepAliveClientMixin {
  // TODO: Replace with [Riverpod/Bloc] for production

  static final List<Map<String, dynamic>> _allOrders = [
    {
      'id': 'ORD-2847',
      'customer': 'Priya Sharma',
      'phone': '+91 98765 43210',
      'device': 'Samsung Galaxy A54 5G 128GB',
      'brand': 'Samsung',
      'amount': 14200,
      'status': 'New',
      'pickupDate': '26 Aug 2026',
      'city': 'Mumbai',
      'pin': '400050',
      'agent': 'Unassigned',
    },
    {
      'id': 'ORD-2846',
      'customer': 'Vikram Singh',
      'phone': '+91 87654 32109',
      'device': 'Realme GT 5 Pro 256GB',
      'brand': 'Realme',
      'amount': 22500,
      'status': 'New',
      'pickupDate': '26 Aug 2026',
      'city': 'Thane',
      'pin': '400601',
      'agent': 'Unassigned',
    },
    {
      'id': 'ORD-2845',
      'customer': 'Arjun Mehta',
      'phone': '+91 76543 21098',
      'device': 'iPhone 13 128GB',
      'brand': 'Apple',
      'amount': 32500,
      'status': 'Pickup',
      'pickupDate': '25 Aug 2026',
      'city': 'Andheri',
      'pin': '400069',
      'agent': 'Suresh Patil',
    },
    {
      'id': 'ORD-2844',
      'customer': 'Neha Joshi',
      'phone': '+91 65432 10987',
      'device': 'Vivo V29 Pro 256GB',
      'brand': 'Vivo',
      'amount': 18900,
      'status': 'Accepted',
      'pickupDate': '27 Aug 2026',
      'city': 'Borivali',
      'pin': '400066',
      'agent': 'Rahul Desai',
    },
    {
      'id': 'ORD-2843',
      'customer': 'Mohammed Iqbal',
      'phone': '+91 54321 09876',
      'device': 'Redmi Note 13 Pro+ 256GB',
      'brand': 'Xiaomi',
      'amount': 16400,
      'status': 'Pending',
      'pickupDate': '28 Aug 2026',
      'city': 'Kurla',
      'pin': '400070',
      'agent': 'Unassigned',
    },
    {
      'id': 'ORD-2842',
      'customer': 'Fatima Khan',
      'phone': '+91 43210 98765',
      'device': 'OnePlus Nord CE 3 128GB',
      'brand': 'OnePlus',
      'amount': 11800,
      'status': 'Inspection',
      'pickupDate': '24 Aug 2026',
      'city': 'Bandra',
      'pin': '400050',
      'agent': 'Suresh Patil',
    },
    {
      'id': 'ORD-2841',
      'customer': 'Deepak Kulkarni',
      'phone': '+91 32109 87654',
      'device': 'iPhone 12 64GB',
      'brand': 'Apple',
      'amount': 24600,
      'status': 'Accepted',
      'pickupDate': '27 Aug 2026',
      'city': 'Dadar',
      'pin': '400014',
      'agent': 'Rahul Desai',
    },
    {
      'id': 'ORD-2839',
      'customer': 'Ravi Nair',
      'phone': '+91 21098 76543',
      'device': 'Xiaomi 13 Pro 256GB',
      'brand': 'Xiaomi',
      'amount': 28000,
      'status': 'Completed',
      'pickupDate': '23 Aug 2026',
      'city': 'Malad',
      'pin': '400064',
      'agent': 'Suresh Patil',
    },
    {
      'id': 'ORD-2837',
      'customer': 'Sunita Rao',
      'phone': '+91 10987 65432',
      'device': 'Samsung Galaxy S23 256GB',
      'brand': 'Samsung',
      'amount': 38500,
      'status': 'Completed',
      'pickupDate': '22 Aug 2026',
      'city': 'Goregaon',
      'pin': '400063',
      'agent': 'Rahul Desai',
    },
    {
      'id': 'ORD-2835',
      'customer': 'Anil Sharma',
      'phone': '+91 99887 66554',
      'device': 'OnePlus 11 256GB',
      'brand': 'OnePlus',
      'amount': 26200,
      'status': 'Inspection',
      'pickupDate': '24 Aug 2026',
      'city': 'Kandivali',
      'pin': '400067',
      'agent': 'Suresh Patil',
    },
    {
      'id': 'ORD-2830',
      'customer': 'Geeta Pillai',
      'phone': '+91 88776 55443',
      'device': 'Motorola Edge 40 Pro',
      'brand': 'Motorola',
      'amount': 19800,
      'status': 'Cancelled',
      'pickupDate': '20 Aug 2026',
      'city': 'Chembur',
      'pin': '400071',
      'agent': 'Unassigned',
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders => _allOrders
      .where(
        (o) =>
            o['status'].toString().toLowerCase() == widget.status.toLowerCase(),
      )
      .toList();

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {});
  }

  String _actionLabel(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return 'Review';
      case 'accepted':
        return 'Pickup';
      case 'pickup':
        return 'Inspect';
      case 'inspection':
        return 'Continue';
      default:
        return 'View';
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: 'No ${widget.status} Orders',
        subtitle: 'Orders with ${widget.status} status will appear here.',
      );
    }

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final order = orders[i];
          return _OrderCard(
            order: order,
            actionLabel: _actionLabel(order['status']),
            onTap: () =>
                context.push('/order-detail-screen', extra: order['id']),
            onAction: () {
              if (order['status'] == 'Inspection' ||
                  order['status'] == 'Pickup') {
                context.push('/device-inspection-screen', extra: order['id']);
              } else {
                context.push('/order-detail-screen', extra: order['id']);
              }
            },
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String actionLabel;
  final VoidCallback onTap;
  final VoidCallback onAction;

  const _OrderCard({
    required this.order,
    required this.actionLabel,
    required this.onTap,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
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
                Text(
                  order['id'],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadgeWidget(status: order['status']),
                const Spacer(),
                Text(
                  '₹${(order['amount'] as int).toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 13,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  order['customer'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.smartphone_outlined,
                  size: 13,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order['device'],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Pickup: ${order['pickupDate']}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.location_on_outlined,
                  size: 12,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${order['city']} · ${order['pin']}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onAction,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      actionLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

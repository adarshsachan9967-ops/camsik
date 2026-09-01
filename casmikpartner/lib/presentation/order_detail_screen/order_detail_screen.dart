import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../widgets/status_badge_widget.dart';
import './widgets/order_action_buttons_widget.dart';
import './widgets/order_info_card_widget.dart';
import './widgets/order_timeline_widget.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({required this.orderId, super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  static final Map<String, Map<String, dynamic>> _orderData = {
    'ORD-2847': {
      'id': 'ORD-2847',
      'status': 'New',
      'customer': 'Priya Sharma',
      'phone': '+91 98765 43210',
      'address': '14B, Linking Road, Bandra West',
      'city': 'Mumbai',
      'pin': '400050',
      'brand': 'Samsung',
      'model': 'Galaxy A54 5G',
      'storage': '128GB',
      'color': 'Awesome Graphite',
      'condition': 'Good',
      'amount': '₹14,200',
      'pickupDate': '26 Aug 2026',
      'agent': 'Unassigned',
      'createdAt': '25 Aug 2026, 09:14 AM',
    },
    'ORD-2845': {
      'id': 'ORD-2845',
      'status': 'Pickup',
      'customer': 'Arjun Mehta',
      'phone': '+91 76543 21098',
      'address': '7, Versova Road, Andheri West',
      'city': 'Andheri',
      'pin': '400069',
      'brand': 'Apple',
      'model': 'iPhone 13',
      'storage': '128GB',
      'color': 'Midnight',
      'condition': 'Excellent',
      'amount': '₹32,500',
      'pickupDate': '25 Aug 2026',
      'agent': 'Suresh Patil',
      'createdAt': '24 Aug 2026, 03:45 PM',
    },
    'ORD-2841': {
      'id': 'ORD-2841',
      'status': 'Accepted',
      'customer': 'Deepak Kulkarni',
      'phone': '+91 32109 87654',
      'address': '22, Gokhale Road, Dadar West',
      'city': 'Dadar',
      'pin': '400014',
      'brand': 'Apple',
      'model': 'iPhone 12',
      'storage': '64GB',
      'color': 'Blue',
      'condition': 'Good',
      'amount': '₹24,600',
      'pickupDate': '27 Aug 2026',
      'agent': 'Rahul Desai',
      'createdAt': '24 Aug 2026, 11:20 AM',
    },
    'ORD-2835': {
      'id': 'ORD-2835',
      'status': 'Inspection',
      'customer': 'Anil Sharma',
      'phone': '+91 99887 66554',
      'address': '5, S.V. Road, Kandivali West',
      'city': 'Kandivali',
      'pin': '400067',
      'brand': 'OnePlus',
      'model': '11 5G',
      'storage': '256GB',
      'color': 'Titan Black',
      'condition': 'Good',
      'amount': '₹26,200',
      'pickupDate': '24 Aug 2026',
      'agent': 'Suresh Patil',
      'createdAt': '23 Aug 2026, 02:10 PM',
    },
  };

  Map<String, dynamic> get _order =>
      _orderData[widget.orderId] ??
      {
        'id': widget.orderId,
        'status': 'New',
        'customer': 'Customer',
        'phone': '-',
        'address': '-',
        'city': '-',
        'pin': '-',
        'brand': '-',
        'model': '-',
        'storage': '-',
        'color': '-',
        'condition': '-',
        'amount': '₹0',
        'pickupDate': '-',
        'agent': '-',
        'createdAt': '-',
      };

  bool _accepting = false;
  bool _rejecting = false;

  Future<void> _acceptOrder() async {
    setState(() => _accepting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _accepting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${widget.orderId} accepted!'),
          backgroundColor: AppTheme.success,
        ),
      );
      context.pop();
    }
  }

  Future<void> _rejectOrder() async {
    setState(() => _rejecting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _rejecting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${widget.orderId} rejected.'),
          backgroundColor: AppTheme.error,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    final status = order['status'] as String;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order['id'],
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            StatusBadgeWidget(status: status),
          ],
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppTheme.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    OrderInfoCardWidget(
                      title: 'Customer Info',
                      icon: Icons.person_outline_rounded,
                      iconColor: const Color(0xFF1565C0),
                      rows: [
                        InfoRow('Name', order['customer']),
                        InfoRow('Phone', order['phone']),
                        InfoRow('Address', order['address']),
                        InfoRow('City', '${order['city']} · ${order['pin']}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OrderInfoCardWidget(
                      title: 'Device Info',
                      icon: Icons.smartphone_outlined,
                      iconColor: const Color(0xFF6A1B9A),
                      rows: [
                        InfoRow('Brand', order['brand']),
                        InfoRow('Model', order['model']),
                        InfoRow('Storage', order['storage']),
                        InfoRow('Color', order['color']),
                        InfoRow('Condition', order['condition']),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OrderInfoCardWidget(
                      title: 'Order Info',
                      icon: Icons.receipt_long_outlined,
                      iconColor: AppTheme.primary,
                      rows: [
                        InfoRow(
                          'Quoted Amount',
                          order['amount'],
                          isHighlight: true,
                        ),
                        InfoRow('Pickup Date', order['pickupDate']),
                        InfoRow('Assigned Agent', order['agent']),
                        InfoRow('Created At', order['createdAt']),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OrderTimelineWidget(status: status),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            OrderActionButtonsWidget(
              status: status,
              orderId: order['id'],
              accepting: _accepting,
              rejecting: _rejecting,
              onAccept: _acceptOrder,
              onReject: _rejectOrder,
              onStartInspection: () =>
                  context.push('/device-inspection-screen', extra: order['id']),
            ),
          ],
        ),
      ),
    );
  }
}

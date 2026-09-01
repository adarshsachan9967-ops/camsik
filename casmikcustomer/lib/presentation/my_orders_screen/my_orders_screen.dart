import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/order_card_widget.dart';
import './widgets/order_tracking_timeline_widget.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  late TabController _tabController;
  Map<String, dynamic>? _expandedOrder;

  final List<Map<String, dynamic>> _orderMaps = [
    {
      'id': 'ORD-2024-001',
      'type': 'Sell',
      'device': 'iPhone 13 (128GB)',
      'brand': 'Apple',
      'status': 'Quality Check',
      'statusStep': 4,
      'price': '₹26,500',
      'date': '24 Aug 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1c95f6d14-1775058099616.png',
      'semanticLabel': 'Apple iPhone 13 in blue color being sold',
      'agentName': 'Rahul Verma',
      'agentPhone': '+91 98234 56789',
      'address': '12, Koramangala 5th Block, Bangalore 560095',
      'isActive': true,
    },
    {
      'id': 'ORD-2024-002',
      'type': 'Buy',
      'device': 'Samsung Galaxy S23',
      'brand': 'Samsung',
      'status': 'Out for Delivery',
      'statusStep': 7,
      'price': '₹34,499',
      'date': '23 Aug 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_122e5667e-1772368533819.png',
      'semanticLabel': 'Samsung Galaxy S23 in phantom black being purchased',
      'agentName': 'Priya Singh',
      'agentPhone': '+91 97654 32109',
      'address': '45, Bandra West, Mumbai 400050',
      'isActive': true,
    },
    {
      'id': 'ORD-2024-003',
      'type': 'Repair',
      'device': 'OnePlus 11 (Screen)',
      'brand': 'OnePlus',
      'status': 'Repair In Progress',
      'statusStep': 3,
      'price': '₹2,999',
      'date': '22 Aug 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1afe6c34d-1774965717912.png',
      'semanticLabel': 'OnePlus 11 smartphone being repaired',
      'agentName': 'Vikram Nair',
      'agentPhone': '+91 96543 21098',
      'address': '8, Anna Nagar, Chennai 600040',
      'isActive': true,
    },
    {
      'id': 'ORD-2024-004',
      'type': 'Sell',
      'device': 'Redmi Note 12 Pro',
      'brand': 'Xiaomi',
      'status': 'Completed',
      'statusStep': 9,
      'price': '₹12,800',
      'date': '18 Aug 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1c02d7c81-1772655888448.png',
      'semanticLabel': 'Xiaomi Redmi Note 12 Pro sold successfully',
      'agentName': 'Ananya Sharma',
      'agentPhone': '+91 95432 10987',
      'address': '22, Sector 18, Noida 201301',
      'isActive': false,
    },
    {
      'id': 'ORD-2024-005',
      'type': 'Exchange',
      'device': 'iPhone 12 → iPhone 14',
      'brand': 'Apple',
      'status': 'Completed',
      'statusStep': 9,
      'price': '₹18,000',
      'date': '15 Aug 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1defeb64d-1774141910900.png',
      'semanticLabel': 'iPhone 12 exchanged for iPhone 14',
      'agentName': 'Kavitha Menon',
      'agentPhone': '+91 94321 09876',
      'address': '33, Jubilee Hills, Hyderabad 500033',
      'isActive': false,
    },
    {
      'id': 'ORD-2024-006',
      'type': 'Buy',
      'device': 'OnePlus 11',
      'brand': 'OnePlus',
      'status': 'Cancelled',
      'statusStep': 0,
      'price': '₹29,999',
      'date': '10 Aug 2026',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_151319317-1764767387361.png',
      'semanticLabel': 'OnePlus 11 order cancelled',
      'agentName': '',
      'agentPhone': '',
      'address': '5, MG Road, Pune 411001',
      'isActive': false,
    },
  ];

  List<Map<String, dynamic>> get _activeOrders =>
      _orderMaps.where((o) => o['isActive'] as bool).toList();

  List<Map<String, dynamic>> get _completedOrders => _orderMaps
      .where((o) => !(o['isActive'] as bool) && o['status'] != 'Cancelled')
      .toList();

  List<Map<String, dynamic>> get _cancelledOrders =>
      _orderMaps.where((o) => o['status'] == 'Cancelled').toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            Container(
              color: AppTheme.surfaceLight,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primary,
                    unselectedLabelColor: AppTheme.textSecondary,
                    indicatorColor: AppTheme.primary,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    tabs: [
                      Tab(text: 'Active (${_activeOrders.length})'),
                      Tab(text: 'Completed (${_completedOrders.length})'),
                      Tab(text: 'Cancelled (${_cancelledOrders.length})'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(_activeOrders, showTracking: true),
                  _buildOrderList(_completedOrders),
                  _buildOrderList(_cancelledOrders, isCancelled: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
    List<Map<String, dynamic>> orders, {
    bool showTracking = false,
    bool isCancelled = false,
  }) {
    if (orders.isEmpty) {
      return EmptyStateWidget(
        iconName: 'orders',
        title: isCancelled ? 'No cancelled orders' : 'No orders yet',
        subtitle: isCancelled
            ? 'All your cancelled orders will appear here'
            : 'Start by selling or buying a device',
        ctaLabel: isCancelled ? null : 'Explore Devices',
        onCta: isCancelled ? null : () {},
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isExpanded = _expandedOrder?['id'] == order['id'];

        return Column(
          children: [
            OrderCardWidget(
              order: order,
              isExpanded: isExpanded,
              onTap: () {
                setState(() {
                  _expandedOrder = isExpanded ? null : order;
                });
              },
            ),
            if (isExpanded && showTracking) ...[
              const SizedBox(height: 8),
              OrderTrackingTimelineWidget(
                currentStep: order['statusStep'] as int,
                orderType: order['type'] as String,
                agentName: order['agentName'] as String,
                agentPhone: order['agentPhone'] as String,
              ),
            ],
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/admin_models.dart';
import '../../services/api_service.dart';
import 'widgets/metric_pill.dart';
import 'widgets/recent_order_tile.dart';
import 'widgets/summary_card.dart';

class AdminOverviewScreen extends StatefulWidget {
  final AdminUser user;
  final VoidCallback onNavigateToOrders;

  const AdminOverviewScreen({
    super.key,
    required this.user,
    required this.onNavigateToOrders,
  });

  @override
  State<AdminOverviewScreen> createState() => _AdminOverviewScreenState();
}

class _AdminOverviewScreenState extends State<AdminOverviewScreen> {
  bool _isLoading = true;
  AdminOverviewStats? _stats;
  List<AdminOrder> _recentOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOverview();
  }

  Future<void> _loadOverview() async {
    setState(() {
      _isLoading = true;
    });

    final overviewData = await ApiService.fetchOverview();
    if (overviewData != null) {
      final rawStats = overviewData['stats'] as Map<String, dynamic>? ?? {};
      final rawRecent = overviewData['recentOrders'] as List? ?? [];
      setState(() {
        _stats = AdminOverviewStats.fromJson(rawStats);
        _recentOrders = rawRecent
            .map((e) => AdminOrder.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } else {
      // Fallback: fetch orders count directly
      final orders = await ApiService.fetchOrders();
      final partners = await ApiService.fetchPartners();
      final agents = await ApiService.fetchDeliveryAgents();

      int pending = 0;
      int completed = 0;
      double rev = 0.0;
      for (final o in orders) {
        if (o.status == 'completed') completed++;
        if (o.status == 'pending' || o.status == 'assigned') pending++;
        rev += o.finalPrice;
      }

      setState(() {
        _stats = AdminOverviewStats(
          totalOrders: orders.length,
          totalRevenue: rev,
          pendingOrders: pending,
          activeOrders: orders.length - completed,
          completedOrders: completed,
          cancelledOrders: 0,
          totalPartners: partners.length,
          activePartners: partners.where((p) => p.status == 'active').length,
          totalDeliveryAgents: agents.length,
          activeDeliveryAgents: agents
              .where((a) => a.dutyStatus == 'online')
              .length,
          totalModels: 48,
          totalBrands: 12,
        );
        _recentOrders = orders.take(5).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CAMSIK Central Hub',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Live Ecosystem Overview',
              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOverview,
            tooltip: 'Sync Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
            )
          : RefreshIndicator(
              onRefresh: _loadOverview,
              color: const Color(0xFF7C3AED),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome & Live Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'API Gateway: Online & Synchronized',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.user.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Metric Banner: Total Platform GMV
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withAlpha(70),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL PLATFORM VOLUME',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              Icon(Icons.trending_up, color: Colors.white, size: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${(_stats?.totalRevenue ?? 0).toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              MetricPill(
                                label: 'Total Orders',
                                value: '${_stats?.totalOrders ?? 0}',
                              ),
                              const SizedBox(width: 10),
                              MetricPill(
                                label: 'Completed',
                                value: '${_stats?.completedOrders ?? 0}',
                              ),
                              const SizedBox(width: 10),
                              MetricPill(
                                label: 'Active Hubs',
                                value: '${_stats?.activePartners ?? 0}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Key Metric Grid
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Pending Tasks',
                            value: '${_stats?.pendingOrders ?? 0}',
                            subtitle: 'Requires Dispatch/QA',
                            icon: Icons.pending_actions,
                            color: const Color(0xFFF59E0B),
                            onTap: widget.onNavigateToOrders,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SummaryCard(
                            title: 'Active Riders',
                            value:
                                '${_stats?.activeDeliveryAgents ?? 0}/${_stats?.totalDeliveryAgents ?? 0}',
                            subtitle: 'On Field Right Now',
                            icon: Icons.two_wheeler,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Partner Stores',
                            value: '${_stats?.totalPartners ?? 0}',
                            subtitle:
                                '${_stats?.activePartners ?? 0} Verified Active',
                            icon: Icons.storefront,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SummaryCard(
                            title: 'Catalog Models',
                            value: '${_stats?.totalModels ?? 0}',
                            subtitle:
                                '${_stats?.totalBrands ?? 0} Active Brands',
                            icon: Icons.devices,
                            color: const Color(0xFF9333EA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent Activity Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Live Pipeline Orders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        TextButton(
                          onPressed: widget.onNavigateToOrders,
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: Color(0xFF7C3AED),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (_recentOrders.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'No active pipeline orders found',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recentOrders.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (ctx, idx) {
                          final o = _recentOrders[idx];
                          return RecentOrderTile(order: o);
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

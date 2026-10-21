import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/order_extensions.dart';
import '../../core/services/session_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/partner_models.dart';
import '../customers/partner_customers_screen.dart';
import '../orders/widgets/order_detail_sheet.dart';
import '../reports/partner_reports_screen.dart';
import '../riders/partner_riders_screen.dart';
import 'data/models/dashboard_stats_model.dart';
import 'data/repositories/dashboard_repository.dart';

class PartnerDashboardScreen extends StatefulWidget {
  final List<PartnerOrder> orders;
  final PartnerUser? user;
  final bool loading;
  final Future<void> Function() onRefresh;
  final Function(int) onNavigate;

  const PartnerDashboardScreen({
    super.key,
    required this.orders,
    this.user,
    required this.loading,
    required this.onRefresh,
    required this.onNavigate,
  });

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  final DashboardRepository _dashboardRepo = DashboardRepositoryImpl();
  DashboardStatsModel? _stats;
  bool _fetchingStats = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final activeUser = widget.user ?? SessionService.currentUser;
    final partnerId = activeUser?.id.isNotEmpty == true ? activeUser!.id : 'partner-001';
    setState(() => _fetchingStats = true);
    final data = await _dashboardRepo.fetchDashboardStats(partnerId);
    if (mounted) {
      setState(() {
        _stats = data;
        _fetchingStats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.loading || _fetchingStats) && widget.orders.isEmpty && _stats == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final activeUser = widget.user ?? SessionService.currentUser;
    final commissionRate = _stats?.commissionRate ?? (activeUser?.commission ?? 5.0);

    final calculatedVolume = widget.orders.fold<double>(0.0, (sum, o) => sum + o.finalPrice);
    final totalVolume = (_stats?.storeTradeVolume != null && _stats!.storeTradeVolume > 0)
        ? _stats!.storeTradeVolume
        : calculatedVolume;

    final completedOrders = widget.orders.filterCompleted();
    final completedCount = _stats?.completedOrdersCount ?? completedOrders.length;
    final totalUnitsCount = _stats?.totalOrdersCount ?? widget.orders.length;
    final pendingCount = _stats?.activePipelineCount ?? (widget.orders.length - completedOrders.length);

    final commissionEarned = (_stats?.totalCommissionEarned != null && _stats!.totalCommissionEarned > 0)
        ? _stats!.totalCommissionEarned
        : ((totalVolume * commissionRate) / 100);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await Future.wait([
          widget.onRefresh(),
          _loadStats(),
        ]);
      },
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Store Volume & Financial Overview Card
          Container(
            padding: EdgeInsets.all(5.w > 22 ? 22 : 5.w),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF334155)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.monetization_on_outlined,
                            color: Color(0xFF60A5FA),
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'STORE TRADE VOLUME',
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF065F46).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF059669)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up_rounded,
                              color: Color(0xFF34D399), size: 14),
                          SizedBox(width: 1.w),
                          Text(
                            _stats?.momGrowth ?? '+14.2% MoM',
                            style: TextStyle(
                              color: const Color(0xFF34D399),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  CurrencyFormatter.format(totalVolume),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  '$completedCount Orders Liquidated • $totalUnitsCount Total Registered',
                  style: TextStyle(
                    color: const Color(0xFF34D399),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),

                // Financial Breakdown Sub-cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B132B).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Pipeline',
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Text(
                                  '$pendingCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 1.5.w),
                                Text(
                                  'units',
                                  style: TextStyle(
                                    color: const Color(0xFF64748B),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 2.5.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B132B).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Commission (${commissionRate.toStringAsFixed(1)}%)',
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              CurrencyFormatter.format(commissionEarned),
                              style: TextStyle(
                                color: const Color(0xFF60A5FA),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Quick Action Shortcuts
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => widget.onNavigate(2),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.5.w,
                      vertical: 1.6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '45-Point QA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: InkWell(
                  onTap: () => widget.onNavigate(3),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.5.w,
                      vertical: 1.6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.successGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.flash_on_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Spot Payout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.5.h),

          // Header: Active Queue & Store Tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Active Queue & Tasks',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => widget.onNavigate(1),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View All (${widget.orders.length}) →',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),

          if (widget.orders.isEmpty)
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 40,
                      color: const Color(0xFF94A3B8).withValues(alpha: 0.6),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'No active orders in store queue right now.',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...widget.orders.take(5).map((order) => _buildOrderTile(context, order)),

          SizedBox(height: 2.5.h),

          // Store Operations Hub (Fleet, Customers, Analytics)
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Store Operations Hub',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),

          // 3 Feature Cards
          _buildOperationTile(
            context: context,
            title: 'Delivery Fleet & Riders',
            subtitle: 'Onboard, assign & track real-time agent dispatch',
            badge: 'LIVE FLEET',
            badgeColor: const Color(0xFF0D9488),
            icon: Icons.delivery_dining_rounded,
            iconBg: const Color(0xFF0D9488).withValues(alpha: 0.12),
            iconColor: const Color(0xFF0D9488),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PartnerRidersScreen()),
            ),
          ),
          SizedBox(height: 1.2.h),
          _buildOperationTile(
            context: context,
            title: 'Customer Directory',
            subtitle: 'Client portfolio, repeat device sellers & tier classification',
            badge: 'PORTFOLIO',
            badgeColor: const Color(0xFF6366F1),
            icon: Icons.people_alt_rounded,
            iconBg: const Color(0xFF6366F1).withValues(alpha: 0.12),
            iconColor: const Color(0xFF6366F1),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PartnerCustomersScreen(orders: widget.orders),
              ),
            ),
          ),
          SizedBox(height: 1.2.h),
          _buildOperationTile(
            context: context,
            title: 'Performance & Audit Reports',
            subtitle: 'Trade metrics, commission yield breakdown & channel analytics',
            badge: 'METRICS',
            badgeColor: const Color(0xFFF59E0B),
            icon: Icons.insights_rounded,
            iconBg: const Color(0xFFF59E0B).withValues(alpha: 0.12),
            iconColor: const Color(0xFFF59E0B),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PartnerReportsScreen(orders: widget.orders),
              ),
            ),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildOperationTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(3.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 12.w > 48 ? 48 : 12.w,
                height: 12.w > 48 ? 48 : 12.w,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.3.h,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTile(BuildContext context, PartnerOrder order) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => OrderDetailSheet(
                order: order,
                onOrderUpdated: widget.onRefresh,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(3.5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Device Type Icon Container
                Container(
                  width: 12.w > 48 ? 48 : 12.w,
                  height: 12.w > 48 ? 48 : 12.w,
                  decoration: BoxDecoration(
                    color: order.typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.devices_rounded,
                    color: order.typeColor,
                    size: 22,
                  ),
                ),
                SizedBox(width: 3.w),

                // Order and Device Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.deviceName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        'Cust: ${order.customerName} • ${order.orderNumber}',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Valuation: ${CurrencyFormatter.format(order.finalPrice)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.5.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: order.statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: order.statusColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    order.statusDisplay,
                    style: TextStyle(
                      color: order.statusColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

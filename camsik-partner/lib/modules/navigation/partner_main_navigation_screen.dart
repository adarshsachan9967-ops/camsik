import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import '../../models/partner_models.dart';
import '../dashboard/partner_dashboard_screen.dart';
import '../inspection/partner_inspection_screen.dart';
import '../orders/bloc/orders_cubit.dart';
import '../orders/bloc/orders_state.dart';
import '../orders/partner_orders_screen.dart';
import '../payouts/partner_payouts_screen.dart';
import '../profile/partner_profile_screen.dart';
import 'bloc/navigation_cubit.dart';

class PartnerMainNavigationScreen extends StatelessWidget {
  const PartnerMainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit(0)),
        BlocProvider<OrdersCubit>(create: (_) => OrdersCubit()..loadOrders()),
      ],
      child: const _MainNavigationContent(),
    );
  }
}

class _MainNavigationContent extends StatelessWidget {
  const _MainNavigationContent();

  @override
  Widget build(BuildContext context) {
    final user = SessionService.currentUser;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 4.w,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CAMSIK PARTNER',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16.sp,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    user?.storeName ?? 'Tech Store Hub',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            tooltip: 'Refresh Data',
            onPressed: () => context.read<OrdersCubit>().loadOrders(),
          ),
          Container(
            margin: EdgeInsets.only(right: 3.5.w),
            padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.5.w),
                Text(
                  user?.city ?? 'Live',
                  style: TextStyle(
                    color: const Color(0xFFE2E8F0),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, ordersState) {
              final orders = ordersState is OrdersLoaded
                  ? ordersState.orders
                  : <PartnerOrder>[];
              final loading = ordersState is OrdersLoading;

              return IndexedStack(
                index: currentIndex,
                children: [
                  PartnerDashboardScreen(
                    orders: orders,
                    user: user,
                    loading: loading,
                    onRefresh: () => context.read<OrdersCubit>().loadOrders(),
                    onNavigate: (idx) =>
                        context.read<NavigationCubit>().setTab(idx),
                  ),
                  PartnerOrdersScreen(
                    onRefresh: () => context.read<OrdersCubit>().loadOrders(),
                  ),
                  PartnerInspectionScreen(
                    orders: orders,
                    onOrderUpdated: () =>
                        context.read<OrdersCubit>().loadOrders(),
                  ),
                  PartnerPayoutsScreen(
                    orders: orders,
                    user: user,
                    onRefresh: () => context.read<OrdersCubit>().loadOrders(),
                  ),
                  PartnerProfileScreen(user: user),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (idx) =>
                context.read<NavigationCubit>().setTab(idx),
            indicatorColor: AppColors.primary.withValues(alpha: 0.15),
            height: 65,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(
                  Icons.dashboard_rounded,
                  color: AppColors.primary,
                ),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(
                  Icons.shopping_bag_rounded,
                  color: AppColors.primary,
                ),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(Icons.fact_check_outlined),
                selectedIcon: Icon(
                  Icons.fact_check_rounded,
                  color: AppColors.primary,
                ),
                label: 'Inspection',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                ),
                label: 'Payouts',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primary,
                ),
                label: 'Store KYC',
              ),
            ],
          );
        },
      ),
    );
  }
}

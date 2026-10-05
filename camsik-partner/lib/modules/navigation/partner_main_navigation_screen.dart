import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        BlocProvider<NavigationCubit>(
          create: (_) => NavigationCubit(0),
        ),
        BlocProvider<OrdersCubit>(
          create: (_) => OrdersCubit()..loadOrders(),
        ),
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.storefront, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CAMSIK PARTNER',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    user?.storeName ?? 'Tech Store Hub',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Refresh Data',
            onPressed: () => context.read<OrdersCubit>().loadOrders(),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, color: Color(0xFFD97706), size: 13),
                const SizedBox(width: 4),
                Text(
                  user?.city ?? 'Active',
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 10,
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
            indicatorColor: AppColors.primary.withValues(alpha: 0.18),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon:
                    Icon(Icons.shopping_bag, color: AppColors.primary),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(Icons.fact_check_outlined),
                selectedIcon:
                    Icon(Icons.fact_check, color: AppColors.primary),
                label: 'Inspection',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon:
                    Icon(Icons.account_balance_wallet, color: AppColors.primary),
                label: 'Payouts',
              ),
              NavigationDestination(
                icon: Icon(Icons.store_outlined),
                selectedIcon: Icon(Icons.store, color: AppColors.primary),
                label: 'Store KYC',
              ),
            ],
          );
        },
      ),
    );
  }
}

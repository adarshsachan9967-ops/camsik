import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import '../../models/admin_models.dart';
import '../fleet/admin_fleet_screen.dart';
import '../fleet/bloc/fleet_cubit.dart';
import '../orders/admin_orders_screen.dart';
import '../orders/bloc/orders_cubit.dart';
import '../overview/admin_overview_screen.dart';
import '../overview/bloc/overview_cubit.dart';
import '../partners/admin_partners_screen.dart';
import '../partners/bloc/partners_cubit.dart';
import '../profile/admin_profile_screen.dart';
import '../profile/bloc/profile_cubit.dart';
import 'bloc/navigation_cubit.dart';

class AdminMainShell extends StatelessWidget {
  final AdminUser? user;

  const AdminMainShell({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => OverviewCubit()..loadOverview()),
        BlocProvider(create: (_) => OrdersCubit()..loadOrders()),
        BlocProvider(create: (_) => PartnersCubit()..loadPartners()),
        BlocProvider(create: (_) => FleetCubit()..loadAgents()),
        BlocProvider(create: (_) => ProfileCubit()..loadProfile()),
      ],
      child: _AdminMainShellView(user: user),
    );
  }
}

class _AdminMainShellView extends StatelessWidget {
  final AdminUser? user;

  const _AdminMainShellView({this.user});

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Central Ecosystem Hub';
      case 1:
        return 'Orders Command Center';
      case 2:
        return 'Partner Stores Network';
      case 3:
        return 'Field Fleet Logistics';
      case 4:
        return 'Admin System & Controls';
      default:
        return 'Camsik Admin Suite';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationCubit>().state;
    final adminUser = user ?? SessionService.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTitle(currentIndex),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              adminUser?.name ?? 'Super Administrator',
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20, color: Colors.white),
            onPressed: () {
              context.read<OverviewCubit>().loadOverview();
              context.read<OrdersCubit>().loadOrders();
              context.read<PartnersCubit>().loadPartners();
              context.read<FleetCubit>().loadAgents();
              context.read<ProfileCubit>().loadProfile();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          const AdminOverviewScreen(),
          const AdminOrdersScreen(),
          const AdminPartnersScreen(),
          const AdminFleetScreen(),
          AdminProfileScreen(user: adminUser),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (idx) => context.read<NavigationCubit>().setTab(idx),
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: AppColors.primary),
            label: 'Partners',
          ),
          NavigationDestination(
            icon: Icon(Icons.two_wheeler_outlined),
            selectedIcon: Icon(Icons.two_wheeler, color: AppColors.primary),
            label: 'Fleet',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings, color: AppColors.primary),
            label: 'System',
          ),
        ],
      ),
    );
  }
}

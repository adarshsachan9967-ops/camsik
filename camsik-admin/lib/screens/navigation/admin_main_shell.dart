import 'package:flutter/material.dart';
import '../../models/admin_models.dart';
import '../fleet/admin_fleet_screen.dart';
import '../orders/admin_orders_screen.dart';
import '../overview/admin_overview_screen.dart';
import '../partners/admin_partners_screen.dart';
import '../profile/admin_profile_screen.dart';

class AdminMainShell extends StatefulWidget {
  final AdminUser user;

  const AdminMainShell({super.key, required this.user});

  @override
  State<AdminMainShell> createState() => _AdminMainShellState();
}

class _AdminMainShellState extends State<AdminMainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      AdminOverviewScreen(
        user: widget.user,
        onNavigateToOrders: () => setState(() => _currentIndex = 1),
      ),
      const AdminOrdersScreen(),
      const AdminPartnersScreen(),
      const AdminFleetScreen(),
      AdminProfileScreen(user: widget.user),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: const Color(0xFF7C3AED).withAlpha(40),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF7C3AED)),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long, color: Color(0xFF7C3AED)),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: Color(0xFF7C3AED)),
            label: 'Partners',
          ),
          NavigationDestination(
            icon: Icon(Icons.two_wheeler_outlined),
            selectedIcon: Icon(Icons.two_wheeler, color: Color(0xFF7C3AED)),
            label: 'Fleet',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon:
                Icon(Icons.admin_panel_settings, color: Color(0xFF7C3AED)),
            label: 'System',
          ),
        ],
      ),
    );
  }
}

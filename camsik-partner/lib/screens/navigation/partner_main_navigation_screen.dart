import 'package:flutter/material.dart';
import '../../models/partner_models.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../dashboard/partner_dashboard_screen.dart';
import '../inspection/partner_inspection_screen.dart';
import '../orders/partner_orders_screen.dart';
import '../payouts/partner_payouts_screen.dart';
import '../profile/partner_profile_screen.dart';

class PartnerMainNavigationScreen extends StatefulWidget {
  const PartnerMainNavigationScreen({super.key});

  @override
  State<PartnerMainNavigationScreen> createState() =>
      _PartnerMainNavigationScreenState();
}

class _PartnerMainNavigationScreenState
    extends State<PartnerMainNavigationScreen> {
  int _currentIndex = 0;
  List<PartnerOrder> _liveOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final user = SessionService.currentUser;
    final orders = await ApiService.fetchOrders(partnerId: user?.id);
    if (mounted) {
      setState(() {
        _liveOrders = orders;
        _loading = false;
      });
    }
  }

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
                color: const Color(0xFF2563EB),
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
                    style:
                        const TextStyle(fontSize: 11, color: Colors.white70),
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
            onPressed: _loadData,
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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PartnerDashboardScreen(
            orders: _liveOrders,
            loading: _loading,
            onRefresh: _loadData,
            onNavigate: (idx) => setState(() => _currentIndex = idx),
          ),
          PartnerOrdersScreen(
            orders: _liveOrders,
            loading: _loading,
            onRefresh: _loadData,
          ),
          PartnerInspectionScreen(
            orders: _liveOrders,
            onOrderUpdated: _loadData,
          ),
          PartnerPayoutsScreen(
            orders: _liveOrders,
            user: user,
            onRefresh: _loadData,
          ),
          PartnerProfileScreen(user: user),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: const Color(0xFF2563EB).withValues(alpha: 0.18),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF2563EB)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF2563EB)),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check, color: Color(0xFF2563EB)),
            label: 'Inspection',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon:
                Icon(Icons.account_balance_wallet, color: Color(0xFF2563EB)),
            label: 'Payouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store, color: Color(0xFF2563EB)),
            label: 'Store KYC',
          ),
        ],
      ),
    );
  }
}

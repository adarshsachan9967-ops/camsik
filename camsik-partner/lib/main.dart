import 'dart:async';
import 'package:flutter/material.dart';
import 'models/partner_models.dart';
import 'services/api_service.dart';
import 'services/session_service.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SessionService.init();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
    runApp(const CamsikPartnerApp());
  }, (error, stack) {
    debugPrint('Global Camsik Partner Error: $error');
  });
}

class CamsikPartnerApp extends StatelessWidget {
  const CamsikPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik Partner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: SessionService.isLoggedIn
          ? const PartnerMainNavigationScreen()
          : const PartnerLoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 1. PARTNER AUTH LOGIN SCREEN
// ─────────────────────────────────────────────────────────────
class PartnerLoginScreen extends StatefulWidget {
  const PartnerLoginScreen({super.key});

  @override
  State<PartnerLoginScreen> createState() => _PartnerLoginScreenState();
}

class _PartnerLoginScreenState extends State<PartnerLoginScreen> {
  final _identifierController = TextEditingController(text: 'partner@camsik.com');
  final _passwordController = TextEditingController(text: 'partner123');
  bool _loading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter both phone/email and password');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final res = await ApiService.login(identifier, password);

    if (!mounted) return;

    if (res['success'] == true && res['partner'] is PartnerUser) {
      await SessionService.saveSession(res['partner'] as PartnerUser);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PartnerMainNavigationScreen()),
      );
    } else {
      setState(() {
        _loading = false;
        _errorMessage = res['message'] ?? 'Login failed. Please verify credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Icon(Icons.storefront, color: Colors.white, size: 32),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CAMSIK PARTNER',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Authorized Merchant & Hub Portal',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                  const SizedBox(height: 32),

                  if (_errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Phone / Email field
                  const Text('Registered Phone or Email', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _identifierController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      prefixIcon: const Icon(Icons.mail_outline, color: Colors.white54, size: 18),
                      hintText: 'e.g. partner@camsik.com or 9876543210',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Password field
                  const Text('Password', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white54, size: 18),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                    ),
                    onPressed: _loading ? null : _handleLogin,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Sign In to Partner Hub', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 20),

                  // Demo hints
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Authorized Partner Demo Account:', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('• Email: partner@camsik.com / phone: 9876543210', style: TextStyle(color: Colors.white38, fontSize: 11)),
                        Text('• Pass: any password (auto-connects to live backend)', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 2. MAIN NAVIGATION SHELL
// ─────────────────────────────────────────────────────────────
class PartnerMainNavigationScreen extends StatefulWidget {
  const PartnerMainNavigationScreen({super.key});

  @override
  State<PartnerMainNavigationScreen> createState() => _PartnerMainNavigationScreenState();
}

class _PartnerMainNavigationScreenState extends State<PartnerMainNavigationScreen> {
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
              decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.storefront, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CAMSIK PARTNER', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.1)),
                  Text(user?.storeName ?? 'Tech Store Hub', style: const TextStyle(fontSize: 11, color: Colors.white70), overflow: TextOverflow.ellipsis),
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
            decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.verified, color: Color(0xFFD97706), size: 13),
                const SizedBox(width: 4),
                Text(user?.city ?? 'Active', style: const TextStyle(color: Color(0xFF92400E), fontSize: 10, fontWeight: FontWeight.bold)),
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
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: Color(0xFF2563EB)), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF2563EB)), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check, color: Color(0xFF2563EB)), label: 'Inspection'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF2563EB)), label: 'Payouts'),
          NavigationDestination(icon: Icon(Icons.store_outlined), selectedIcon: Icon(Icons.store, color: Color(0xFF2563EB)), label: 'Store KYC'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 3. TAB 0: PARTNER DASHBOARD SCREEN
// ─────────────────────────────────────────────────────────────
class PartnerDashboardScreen extends StatelessWidget {
  final List<PartnerOrder> orders;
  final bool loading;
  final Future<void> Function() onRefresh;
  final Function(int) onNavigate;

  const PartnerDashboardScreen({
    super.key,
    required this.orders,
    required this.loading,
    required this.onRefresh,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    if (loading && orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalVolume = orders.fold<double>(0.0, (sum, o) => sum + o.finalPrice);
    final completedCount = orders.filterCompleted().length;
    final commissionEarned = totalVolume * 0.05; // 5% commission tier

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Store Volume & Financial Overview Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('STORE TRADE VOLUME', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                    Icon(Icons.trending_up, color: Color(0xFF10B981), size: 18),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${totalVolume.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completedCount Orders Processed • ${orders.length} Total Registered',
                  style: const TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Active Orders', style: TextStyle(color: Colors.white60, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('${orders.length - completedCount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Commission (5%)', style: TextStyle(color: Colors.white60, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('₹${commissionEarned.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Action Shortcuts
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('45-Point QA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () => onNavigate(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.flash_on, size: 18),
                  label: const Text('Spot Payout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () => onNavigate(3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Queue & Store Tasks', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              TextButton(
                onPressed: () => onNavigate(1),
                child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (orders.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
              child: const Center(
                child: Text('No active orders in store queue right now.', style: TextStyle(color: Colors.black45, fontSize: 12)),
              ),
            )
          else
            ...orders.take(4).map((order) => _buildOrderTile(context, order)),
        ],
      ),
    );
  }

  Widget _buildOrderTile(BuildContext context, PartnerOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: order.typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.devices, color: order.typeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.deviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('Cust: ${order.customerName} • ${order.orderNumber}', style: const TextStyle(color: Colors.black54, fontSize: 11)),
                const SizedBox(height: 4),
                Text('Valuation: ₹${order.finalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: order.statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Text(order.statusDisplay, style: TextStyle(color: order.statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4. TAB 1: PARTNER ORDERS (LIST + SEARCH + FILTER)
// ─────────────────────────────────────────────────────────────
class PartnerOrdersScreen extends StatefulWidget {
  final List<PartnerOrder> orders;
  final bool loading;
  final Future<void> Function() onRefresh;

  const PartnerOrdersScreen({
    super.key,
    required this.orders,
    required this.loading,
    required this.onRefresh,
  });

  @override
  State<PartnerOrdersScreen> createState() => _PartnerOrdersScreenState();
}

class _PartnerOrdersScreenState extends State<PartnerOrdersScreen> {
  String _selectedStatus = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  List<PartnerOrder> get _filteredOrders {
    return widget.orders.where((o) {
      final matchesStatus = _selectedStatus == 'all' || o.status == _selectedStatus;
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          o.orderNumber.toLowerCase().contains(q) ||
          o.customerName.toLowerCase().contains(q) ||
          o.deviceName.toLowerCase().contains(q);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search by Order ID, Device or Customer...',
                    hintStyle: const TextStyle(fontSize: 12, color: Colors.black45),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('all', 'All Orders (${widget.orders.length})'),
                      _buildChip('assigned', 'Assigned'),
                      _buildChip('inspection', 'In QA'),
                      _buildChip('completed', 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: widget.loading && widget.orders.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.black.withValues(alpha: 0.2)),
                            const SizedBox(height: 12),
                            const Text('No orders match your filter criteria.', style: TextStyle(color: Colors.black45, fontSize: 13)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, idx) {
                          final order = _filteredOrders[idx];
                          return _buildOrderCard(order);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
        selected: isSelected,
        selectedColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        onSelected: (_) => setState(() => _selectedStatus = status),
      ),
    );
  }

  Widget _buildOrderCard(PartnerOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showOrderDetailModal(order),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2563EB))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: order.statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(order.statusDisplay, style: TextStyle(color: order.statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(order.deviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.black45),
                    const SizedBox(width: 4),
                    Text(order.customerName, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.black45),
                    const SizedBox(width: 4),
                    Text(order.city, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Slot: ${order.pickupDate}', style: const TextStyle(color: Colors.black45, fontSize: 11)),
                    Text('₹${order.finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF0F172A))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderDetailModal(PartnerOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF2563EB))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: order.statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                      child: Text(order.statusDisplay, style: TextStyle(color: order.statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Device Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(order.deviceName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                if (order.deviceStorage.isNotEmpty) Text('Storage: ${order.deviceStorage}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 16),

                const Text('Customer & Pickup Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 6),
                Text('${order.customerName} (${order.customerPhone})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('${order.customerAddress}, ${order.city} - ${order.pinCode}', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Online Quoted Price', style: TextStyle(fontSize: 11, color: Colors.black45)),
                          Text('₹${order.quotedPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Current Final Valuation', style: TextStyle(fontSize: 11, color: Colors.black45)),
                          Text('₹${order.finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Status Updates
                if (order.status != 'completed') ...[
                  const Text('Update Order Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (order.status == 'assigned')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                          onPressed: () async {
                            Navigator.pop(ctx);
                            await ApiService.updateOrder(orderId: order.id, status: 'accepted');
                            widget.onRefresh();
                          },
                          child: const Text('Accept Store Task'),
                        ),
                      if (order.status == 'accepted')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
                          onPressed: () async {
                            Navigator.pop(ctx);
                            await ApiService.updateOrder(orderId: order.id, status: 'inspection');
                            widget.onRefresh();
                          },
                          child: const Text('Mark Under QA Inspection'),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await ApiService.updateOrder(orderId: order.id, status: 'completed');
                          widget.onRefresh();
                        },
                        child: const Text('Complete & Disburse'),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 5. TAB 2: PARTNER 45-POINT PHYSICAL QA INSPECTION
// ─────────────────────────────────────────────────────────────
class PartnerInspectionScreen extends StatefulWidget {
  final List<PartnerOrder> orders;
  final Future<void> Function() onOrderUpdated;

  const PartnerInspectionScreen({
    super.key,
    required this.orders,
    required this.onOrderUpdated,
  });

  @override
  State<PartnerInspectionScreen> createState() => _PartnerInspectionScreenState();
}

class _PartnerInspectionScreenState extends State<PartnerInspectionScreen> {
  PartnerOrder? _selectedOrder;
  bool _screenOriginal = true;
  bool _touchPerfect = true;
  bool _batteryHealthy = true;
  bool _cameraClean = true;
  bool _shutterLow = true;
  bool _motherboardClean = true;
  final double _customDeduction = 0.0;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.orders.isNotEmpty) {
      _selectedOrder = widget.orders.first;
    }
  }

  double _calculateAdjustedPrice() {
    if (_selectedOrder == null) return 0.0;
    double price = _selectedOrder!.quotedPrice;
    if (!_screenOriginal) price -= 4500;
    if (!_touchPerfect) price -= 2500;
    if (!_batteryHealthy) price -= 2000;
    if (!_cameraClean) price -= 3000;
    if (!_shutterLow) price -= 2000;
    if (!_motherboardClean) price -= 5000;
    price -= _customDeduction;
    return price < 1000 ? 1000 : price;
  }

  int _calculateScore() {
    int score = 100;
    if (!_screenOriginal) score -= 20;
    if (!_touchPerfect) score -= 15;
    if (!_batteryHealthy) score -= 15;
    if (!_cameraClean) score -= 15;
    if (!_shutterLow) score -= 10;
    if (!_motherboardClean) score -= 25;
    return score < 20 ? 20 : score;
  }

  Future<void> _submitQA() async {
    if (_selectedOrder == null) return;
    setState(() => _submitting = true);

    final finalVal = _calculateAdjustedPrice();
    final score = _calculateScore();

    final ok = await ApiService.updateOrder(
      orderId: _selectedOrder!.id,
      status: 'inspection_completed',
      finalPrice: finalVal,
      inspectionScore: score,
      notes: '45-Point QA Score: $score/100. Certified by Hub Technician.',
    );

    if (mounted) {
      setState(() => _submitting = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text('QA Completed! Score: $score/100 • New Price: ₹${finalVal.toStringAsFixed(0)}'),
          ),
        );
        widget.onOrderUpdated();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.redAccent, content: Text('Failed to update inspection report on server')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return const Center(child: Text('No orders ready for QA inspection.'));
    }

    final finalPrice = _calculateAdjustedPrice();
    final score = _calculateScore();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Select Order Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.08))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PartnerOrder>(
              value: _selectedOrder ?? widget.orders.first,
              isExpanded: true,
              items: widget.orders.map((o) {
                return DropdownMenuItem(
                  value: o,
                  child: Text('${o.orderNumber} - ${o.deviceName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedOrder = val);
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Live Valuation Summary Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('45-POINT QA SCORE', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('$score / 100', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('FINAL RE-VALUATION', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('₹${finalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF34D399), fontSize: 24, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text('Hardware Diagnostic Checklist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),

        _buildCheckTile('Original OEM Display / Glass', 'No lines, spots, or third-party replacement', _screenOriginal, (v) => setState(() => _screenOriginal = v)),
        _buildCheckTile('Touchscreen & Multi-Touch Response', 'Zero touch ghosting or dead zones', _touchPerfect, (v) => setState(() => _touchPerfect = v)),
        _buildCheckTile('Battery Health (> 85% / Cycle Count)', 'Holds peak operational performance', _batteryHealthy, (v) => setState(() => _batteryHealthy = v)),
        _buildCheckTile('Camera Optics / Sensor Glass', 'Zero fungus, scratches, or sensor dust', _cameraClean, (v) => setState(() => _cameraClean = v)),
        _buildCheckTile('Shutter Actuations (< 50k count)', 'Mechanical shutter within safe lifecycle', _shutterLow, (v) => setState(() => _shutterLow = v)),
        _buildCheckTile('Motherboard, IC & Wi-Fi / Bluetooth', 'No liquid intrusion or motherboard repair history', _motherboardClean, (v) => setState(() => _motherboardClean = v)),

        const SizedBox(height: 20),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _submitting ? null : _submitQA,
          child: _submitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text('Submit Certified QA Report (₹${finalPrice.toStringAsFixed(0)})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildCheckTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
      child: SwitchListTile(
        activeTrackColor: const Color(0xFF10B981),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 11)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 6. TAB 3: PARTNER PAYOUTS & SPOT DISBURSEMENT
// ─────────────────────────────────────────────────────────────
class PartnerPayoutsScreen extends StatelessWidget {
  final List<PartnerOrder> orders;
  final PartnerUser? user;
  final Future<void> Function() onRefresh;

  const PartnerPayoutsScreen({
    super.key,
    required this.orders,
    required this.user,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final completedOrders = orders.filterCompleted();
    final floatBalance = user?.availableBalance ?? 250000.0;
    final totalDisbursed = completedOrders.fold<double>(0.0, (s, o) => s + o.finalPrice);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('STORE FLOAT & WALLET', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('₹${floatBalance.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('Total Disbursed: ₹${totalDisbursed.toStringAsFixed(0)} • Instant IMPS', style: const TextStyle(color: Color(0xFF60A5FA), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Disbursed Payout History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),

          if (completedOrders.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
              child: const Center(
                child: Text('No completed payouts recorded yet.', style: TextStyle(color: Colors.black45, fontSize: 12)),
              ),
            )
          else
            ...completedOrders.map((o) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${o.finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF10B981))),
                          const SizedBox(height: 2),
                          Text('${o.orderNumber} • ${o.customerName}', style: const TextStyle(color: Colors.black54, fontSize: 11)),
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                          SizedBox(width: 4),
                          Text('IMPS Paid', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 7. TAB 4: STORE KYC & PARTNER PROFILE
// ─────────────────────────────────────────────────────────────
class PartnerProfileScreen extends StatelessWidget {
  final PartnerUser? user;
  const PartnerProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront, size: 36, color: Color(0xFF2563EB)),
              ),
              const SizedBox(height: 12),
              Text(user?.storeName ?? 'Tech Store Hub', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              Text(user?.name ?? 'Partner Owner', style: const TextStyle(color: Colors.black54, fontSize: 13)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(10)),
                child: const Text('Verified Camsik Partner Hub', style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildInfoCard('Contact & Location', [
          _buildInfoRow('Phone', user?.phone ?? '+91 98765 43210'),
          _buildInfoRow('Email', user?.email ?? 'partner@camsik.com'),
          _buildInfoRow('City & State', '${user?.city ?? "Mumbai"}, ${user?.state ?? "Maharashtra"}'),
        ]),

        const SizedBox(height: 14),

        _buildInfoCard('Operating Parameters', [
          _buildInfoRow('Commission Rate', '${user?.commission ?? 5.0}% per unit liquidated'),
          _buildInfoRow('Operating Pin Codes', user?.pinCodes.isNotEmpty == true ? user!.pinCodes.join(', ') : '400001, 400050, 401107'),
        ]),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFEE2E2),
            foregroundColor: const Color(0xFFDC2626),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text('Sign Out from Partner App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          onPressed: () async {
            await SessionService.clearSession();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const PartnerLoginScreen()),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black45)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}

extension OrderFilters on List<PartnerOrder> {
  List<PartnerOrder> filterCompleted() {
    return where((o) => o.status == 'completed' || o.status == 'paid').toList();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'models/admin_models.dart';
import 'services/api_service.dart';
import 'services/session_service.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('CamsikAdmin Error: ${details.exception}');
    };
    runApp(const CamsikAdminApp());
  }, (error, stack) {
    debugPrint('CamsikAdmin Uncaught: $error\n$stack');
  });
}

class CamsikAdminApp extends StatelessWidget {
  const CamsikAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAMSIK Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED), // Premium Purple
          primary: const Color(0xFF7C3AED),
          secondary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A), // Dark Luxury Slate
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AdminAuthCheckScreen(),
    );
  }
}

class AdminAuthCheckScreen extends StatefulWidget {
  const AdminAuthCheckScreen({super.key});

  @override
  State<AdminAuthCheckScreen> createState() => _AdminAuthCheckScreenState();
}

class _AdminAuthCheckScreenState extends State<AdminAuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (!mounted) return;
    if (loggedIn) {
      final user = await SessionService.getUser();
      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminMainShell(user: user)),
        );
        return;
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
      ),
    );
  }
}

// ==========================================
// 1. ADMIN LOGIN SCREEN
// ==========================================
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController(text: 'admin@camsik.com');
  final _passwordController = TextEditingController(text: 'Casmik@9967');
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter both admin email and password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final adminUser = await ApiService.login(email, password);

    if (!mounted) return;

    if (adminUser != null) {
      await SessionService.saveUser(adminUser);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminMainShell(user: adminUser)),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid admin credentials or unauthorized account';
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
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Header
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withAlpha(35),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF7C3AED).withAlpha(80), width: 2),
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded, size: 52, color: Color(0xFFC4B5FD)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CAMSIK ADMIN',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Central Command & Control Center',
                  style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 36),

                // Card container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF334155)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(80),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.redAccent.withAlpha(80)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Text(
                        'Admin Email / ID',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF64748B), size: 20),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          hintText: 'admin@camsik.com',
                          hintStyle: const TextStyle(color: Color(0xFF475569)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Master Password',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B), size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF64748B),
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0F172A),
                          hintText: '••••••••',
                          hintStyle: const TextStyle(color: Color(0xFF475569)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Sign In to Super Admin',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Secured by CAMSIK Enterprise Auth • Role-based Access Control',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. ADMIN MAIN NAVIGATION SHELL
// ==========================================
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
      AdminOverviewScreen(user: widget.user, onNavigateToOrders: () => setState(() => _currentIndex = 1)),
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
            selectedIcon: Icon(Icons.admin_panel_settings, color: Color(0xFF7C3AED)),
            label: 'System',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. TAB 1: ADMIN OVERVIEW / ANALYTICS
// ==========================================
class AdminOverviewScreen extends StatefulWidget {
  final AdminUser user;
  final VoidCallback onNavigateToOrders;

  const AdminOverviewScreen({super.key, required this.user, required this.onNavigateToOrders});

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
        _recentOrders = rawRecent.map((e) => AdminOrder.fromJson(e as Map<String, dynamic>)).toList();
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
          activeDeliveryAgents: agents.where((a) => a.dutyStatus == 'online').length,
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
            Text('CAMSIK Central Hub', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Live Ecosystem Overview', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
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
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const Spacer(),
                          Text(
                            widget.user.name,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
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
                                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.1),
                              ),
                              Icon(Icons.trending_up, color: Colors.white, size: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${(_stats?.totalRevenue ?? 0).toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _MetricPill(label: 'Total Orders', value: '${_stats?.totalOrders ?? 0}'),
                              const SizedBox(width: 10),
                              _MetricPill(label: 'Completed', value: '${_stats?.completedOrders ?? 0}'),
                              const SizedBox(width: 10),
                              _MetricPill(label: 'Active Hubs', value: '${_stats?.activePartners ?? 0}'),
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
                          child: _SummaryCard(
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
                          child: _SummaryCard(
                            title: 'Active Riders',
                            value: '${_stats?.activeDeliveryAgents ?? 0}/${_stats?.totalDeliveryAgents ?? 0}',
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
                          child: _SummaryCard(
                            title: 'Partner Stores',
                            value: '${_stats?.totalPartners ?? 0}',
                            subtitle: '${_stats?.activePartners ?? 0} Verified Active',
                            icon: Icons.storefront,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title: 'Catalog Models',
                            value: '${_stats?.totalModels ?? 0}',
                            subtitle: '${_stats?.totalBrands ?? 0} Active Brands',
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        TextButton(
                          onPressed: widget.onNavigateToOrders,
                          child: const Text('View All', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
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
                          child: Text('No active pipeline orders found', style: TextStyle(color: Color(0xFF94A3B8))),
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
                          return _RecentOrderTile(order: o);
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetricPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  final AdminOrder order;

  const _RecentOrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.phone_android, color: Color(0xFF7C3AED), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order.id,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.type.toUpperCase(),
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${order.customerName} • ${order.deviceModel}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${order.finalPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 2),
              _StatusBadge(status: order.status),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 4. TAB 2: ORDER COMMAND CENTER
// ==========================================
class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  bool _isLoading = true;
  List<AdminOrder> _allOrders = [];
  List<AdminPartner> _partners = [];
  List<AdminDeliveryAgent> _agents = [];

  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedType = 'all';

  final _searchController = TextEditingController();

  final List<String> _statuses = [
    'all',
    'pending',
    'assigned',
    'out_for_pickup',
    'picked_up',
    'inspection_in_progress',
    'completed',
    'cancelled',
  ];

  final List<String> _types = [
    'all',
    'sell',
    'buy',
    'repair',
    'exchange',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final orders = await ApiService.fetchOrders(
      search: _searchQuery,
      status: _selectedStatus,
      type: _selectedType,
    );
    final partners = await ApiService.fetchPartners();
    final agents = await ApiService.fetchDeliveryAgents();

    if (!mounted) return;
    setState(() {
      _allOrders = orders;
      _partners = partners;
      _agents = agents;
      _isLoading = false;
    });
  }

  void _showOrderDetailSheet(AdminOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AdminOrderDetailModal(
        order: order,
        partners: _partners,
        agents: _agents,
        onOrderUpdated: () {
          Navigator.pop(ctx);
          _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Command Center', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                    _loadData();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Order ID, Customer, Phone, Device...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                              _loadData();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statuses.map((s) {
                      final isSelected = _selectedStatus == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(s == 'all' ? 'All Status' : s.replaceAll('_', ' ').toUpperCase()),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF7C3AED),
                          backgroundColor: const Color(0xFFF1F5F9),
                          showCheckmark: false,
                          onSelected: (_) {
                            setState(() => _selectedStatus = s);
                            _loadData();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 4),
                // Type Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _types.map((t) {
                      final isSelected = _selectedType == t;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(t == 'all' ? 'All Types' : t.toUpperCase()),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF64748B),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF7C3AED).withAlpha(35),
                          backgroundColor: Colors.transparent,
                          onSelected: (_) {
                            setState(() => _selectedType = t);
                            _loadData();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Order Card List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
                : _allOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2_outlined, size: 54, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 12),
                            const Text(
                              'No matching orders found',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try clearing filters or search term',
                              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _selectedStatus = 'all';
                                  _selectedType = 'all';
                                });
                                _loadData();
                              },
                              child: const Text('Reset All Filters'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        color: const Color(0xFF7C3AED),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _allOrders.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (ctx, idx) {
                            final o = _allOrders[idx];
                            return _AdminOrderCard(
                              order: o,
                              onTap: () => _showOrderDetailSheet(o),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final AdminOrder order;
  final VoidCallback onTap;

  const _AdminOrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Order ID, Type badge, Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        order.id,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          order.type.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹${order.finalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),

              // Device & Customer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.phone_iphone, color: Color(0xFF64748B), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.deviceModel,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        if (order.deviceVariant.isNotEmpty)
                          Text(
                            order.deviceVariant,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.person_outline, color: Color(0xFF64748B), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${order.customerName} (${order.customerPhone})',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Assignments: Partner Hub & Rider
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.storefront, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              order.assignedPartnerName,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.two_wheeler, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              order.assignedRiderName,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Bottom status & Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatusBadge(status: order.status),
                  Row(
                    children: const [
                      Text(
                        'Manage Order',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
                      ),
                      Icon(Icons.chevron_right, size: 16, color: Color(0xFF7C3AED)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. ORDER DETAIL BOTTOM SHEET
// ==========================================
class _AdminOrderDetailModal extends StatefulWidget {
  final AdminOrder order;
  final List<AdminPartner> partners;
  final List<AdminDeliveryAgent> agents;
  final VoidCallback onOrderUpdated;

  const _AdminOrderDetailModal({
    required this.order,
    required this.partners,
    required this.agents,
    required this.onOrderUpdated,
  });

  @override
  State<_AdminOrderDetailModal> createState() => _AdminOrderDetailModalState();
}

class _AdminOrderDetailModalState extends State<_AdminOrderDetailModal> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);
    final ok = await ApiService.updateOrder(
      orderId: widget.order.id,
      status: newStatus,
      notes: 'Status updated by Super Admin',
    );
    if (!mounted) return;
    setState(() => _isUpdating = false);
    if (ok) {
      widget.onOrderUpdated();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status on server')),
      );
    }
  }

  void _showAssignPartnerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Assign Partner Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: widget.partners.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, idx) {
              final p = widget.partners[idx];
              return ListTile(
                title: Text(p.storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${p.ownerName} • ${p.city}', style: const TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  Navigator.pop(ctx);
                  setState(() => _isUpdating = true);
                  await ApiService.updateOrder(
                    orderId: widget.order.id,
                    assignedPartnerId: p.id,
                    assignedPartnerName: p.storeName,
                  );
                  if (mounted) {
                    setState(() => _isUpdating = false);
                    widget.onOrderUpdated();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAssignRiderDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Assign Delivery Rider', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: widget.agents.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, idx) {
              final a = widget.agents[idx];
              return ListTile(
                title: Text(a.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${a.zone} • ${a.vehicleType} (${a.dutyStatus})', style: const TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  Navigator.pop(ctx);
                  setState(() => _isUpdating = true);
                  await ApiService.updateOrder(
                    orderId: widget.order.id,
                    assignedRiderId: a.id,
                    assignedRiderName: a.name,
                  );
                  if (mounted) {
                    setState(() => _isUpdating = false);
                    widget.onOrderUpdated();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                    Text('Type: ${o.type.toUpperCase()}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
                _StatusBadge(status: o.status),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer & Location
                  _DetailSection(
                    title: 'Customer Information',
                    children: [
                      _DetailRow(label: 'Name', value: o.customerName),
                      _DetailRow(label: 'Phone', value: o.customerPhone),
                      _DetailRow(label: 'Address', value: '${o.pickupAddress}, ${o.pickupCity}'),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Device Valuation
                  _DetailSection(
                    title: 'Device & Financial Valuation',
                    children: [
                      _DetailRow(label: 'Device', value: o.deviceModel),
                      if (o.deviceVariant.isNotEmpty) _DetailRow(label: 'Variant', value: o.deviceVariant),
                      _DetailRow(label: 'Final Payout', value: '₹${o.finalPrice.toStringAsFixed(0)}'),
                      _DetailRow(label: 'Payment Status', value: o.paymentStatus.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Assignment Control
                  _DetailSection(
                    title: 'Hub & Delivery Allocation',
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Assigned Hub:', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              Text(o.assignedPartnerName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: _showAssignPartnerDialog,
                            style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                            child: const Text('Reassign Hub'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Assigned Rider:', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              Text(o.assignedRiderName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: _showAssignRiderDialog,
                            style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                            child: const Text('Reassign Rider'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Status Transitions
                  const Text(
                    'Override Order Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ActionButton(
                        label: 'Assign Hub/Rider',
                        color: const Color(0xFF2563EB),
                        onPressed: () => _updateStatus('assigned'),
                      ),
                      _ActionButton(
                        label: 'Out for Pickup',
                        color: const Color(0xFF7C3AED),
                        onPressed: () => _updateStatus('out_for_pickup'),
                      ),
                      _ActionButton(
                        label: 'Inspection In Progress',
                        color: const Color(0xFFF59E0B),
                        onPressed: () => _updateStatus('inspection_in_progress'),
                      ),
                      _ActionButton(
                        label: 'Mark Completed',
                        color: const Color(0xFF059669),
                        onPressed: () => _updateStatus('completed'),
                      ),
                      _ActionButton(
                        label: 'Cancel Order',
                        color: Colors.redAccent,
                        onPressed: () => _updateStatus('cancelled'),
                      ),
                    ],
                  ),
                  if (_isUpdating) ...[
                    const SizedBox(height: 20),
                    const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(25),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

// ==========================================
// 6. TAB 3: PARTNERS MANAGEMENT
// ==========================================
class AdminPartnersScreen extends StatefulWidget {
  const AdminPartnersScreen({super.key});

  @override
  State<AdminPartnersScreen> createState() => _AdminPartnersScreenState();
}

class _AdminPartnersScreenState extends State<AdminPartnersScreen> {
  bool _isLoading = true;
  List<AdminPartner> _partners = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    setState(() => _isLoading = true);
    final list = await ApiService.fetchPartners();
    if (!mounted) return;
    setState(() {
      _partners = list;
      _isLoading = false;
    });
  }

  Future<void> _togglePartnerStatus(AdminPartner partner) async {
    final newStatus = partner.status == 'active' ? 'suspended' : 'active';
    final ok = await ApiService.updatePartnerStatus(partnerId: partner.id, status: newStatus);
    if (!mounted) return;
    if (ok) {
      _loadPartners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: newStatus == 'active' ? const Color(0xFF059669) : Colors.redAccent,
          content: Text('${partner.storeName} status updated to ${newStatus.toUpperCase()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _partners.where((p) {
      final q = _searchQuery.toLowerCase();
      return p.storeName.toLowerCase().contains(q) ||
          p.ownerName.toLowerCase().contains(q) ||
          p.city.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Network', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPartners),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search Store Name, Owner, City...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
                : RefreshIndicator(
                    onRefresh: _loadPartners,
                    color: const Color(0xFF7C3AED),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (ctx, idx) {
                        final p = filtered[idx];
                        final isActive = p.status == 'active';
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF7C3AED).withAlpha(20),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.store, color: Color(0xFF7C3AED), size: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.storeName,
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                            ),
                                            Text(
                                              '${p.ownerName} • ${p.city}',
                                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isActive ? const Color(0xFF10B981).withAlpha(25) : Colors.redAccent.withAlpha(25),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        p.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isActive ? const Color(0xFF059669) : Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20, color: Color(0xFFF1F5F9)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Rating: ⭐ ${p.rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                    Text('Commission: ${p.commissionRate.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                    Text('Total QA: ${p.totalOrders}', style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isActive ? Colors.redAccent : const Color(0xFF059669),
                                        side: BorderSide(color: isActive ? Colors.redAccent : const Color(0xFF059669)),
                                      ),
                                      icon: Icon(isActive ? Icons.block : Icons.check_circle, size: 16),
                                      label: Text(isActive ? 'Suspend Hub' : 'Activate Hub'),
                                      onPressed: () => _togglePartnerStatus(p),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 7. TAB 4: DELIVERY FLEET MANAGEMENT
// ==========================================
class AdminFleetScreen extends StatefulWidget {
  const AdminFleetScreen({super.key});

  @override
  State<AdminFleetScreen> createState() => _AdminFleetScreenState();
}

class _AdminFleetScreenState extends State<AdminFleetScreen> {
  bool _isLoading = true;
  List<AdminDeliveryAgent> _agents = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    setState(() => _isLoading = true);
    final list = await ApiService.fetchDeliveryAgents();
    if (!mounted) return;
    setState(() {
      _agents = list;
      _isLoading = false;
    });
  }

  Future<void> _toggleDuty(AdminDeliveryAgent agent) async {
    final newDuty = agent.dutyStatus == 'online' ? 'offline' : 'online';
    final ok = await ApiService.updateAgentDutyStatus(agentId: agent.id, dutyStatus: newDuty);
    if (!mounted) return;
    if (ok) {
      _loadAgents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _agents.where((a) {
      final q = _searchQuery.toLowerCase();
      return a.name.toLowerCase().contains(q) ||
          a.zone.toLowerCase().contains(q) ||
          a.phone.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Fleet Logistics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAgents),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search Rider Name, Phone, Zone...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
                : RefreshIndicator(
                    onRefresh: _loadAgents,
                    color: const Color(0xFF7C3AED),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (ctx, idx) {
                        final a = filtered[idx];
                        final isOnline = a.dutyStatus == 'online';
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2563EB).withAlpha(20),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.two_wheeler, color: Color(0xFF2563EB), size: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              a.name,
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                            ),
                                            Text(
                                              '${a.phone} • ${a.zone}',
                                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isOnline ? const Color(0xFF10B981).withAlpha(25) : Colors.grey.withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        a.dutyStatus.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isOnline ? const Color(0xFF059669) : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20, color: Color(0xFFF1F5F9)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Vehicle: ${a.vehicleType}', style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                    Text('Rating: ⭐ ${a.rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                    Text('Active Tasks: ${a.activeOrders}', style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isOnline ? Colors.orange[800] : const Color(0xFF059669),
                                      ),
                                      icon: Icon(isOnline ? Icons.bedtime_outlined : Icons.wb_sunny_outlined, size: 16),
                                      label: Text(isOnline ? 'Set Offline' : 'Set Online'),
                                      onPressed: () => _toggleDuty(a),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 8. TAB 5: ADMIN PROFILE & SYSTEM CONTROLS
// ==========================================
class AdminProfileScreen extends StatelessWidget {
  final AdminUser user;

  const AdminProfileScreen({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out Super Admin?'),
        content: const Text('You will need master credentials to re-enter the administrative dashboard.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SessionService.clearSession();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin System & Controls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Admin Identity Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF7C3AED).withAlpha(30),
                    child: const Icon(Icons.security, size: 32, color: Color(0xFF7C3AED)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Server & System Information
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cloud_sync, color: Color(0xFF7C3AED)),
                    title: const Text('Backend API Gateway', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('https://casmik-one.vercel.app', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security, color: Color(0xFF2563EB)),
                    title: const Text('RBAC Security Protocol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Full Superadmin Read/Write Access', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.verified_user, color: Color(0xFF2563EB), size: 20),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone_android, color: Color(0xFF059669)),
                    title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('CAMSIK Admin v2.4.0 (Build 36)', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withAlpha(20),
                  foregroundColor: Colors.redAccent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out Super Admin Session', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Status Badge Component
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'completed':
        bg = const Color(0xFF10B981).withAlpha(25);
        fg = const Color(0xFF059669);
        break;
      case 'out_for_pickup':
      case 'assigned':
        bg = const Color(0xFF2563EB).withAlpha(25);
        fg = const Color(0xFF2563EB);
        break;
      case 'inspection_in_progress':
        bg = const Color(0xFFF59E0B).withAlpha(25);
        fg = const Color(0xFFD97706);
        break;
      case 'cancelled':
        bg = Colors.redAccent.withAlpha(25);
        fg = Colors.redAccent;
        break;
      default:
        bg = const Color(0xFF64748B).withAlpha(25);
        fg = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

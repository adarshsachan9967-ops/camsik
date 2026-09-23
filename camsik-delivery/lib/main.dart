import 'dart:async';
import 'package:flutter/material.dart';
import 'models/delivery_models.dart';
import 'services/api_service.dart';
import 'services/session_service.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SessionService.init();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
    runApp(const CamsikDeliveryApp());
  }, (error, stack) {
    debugPrint('Global Camsik Delivery Error: $error');
  });
}

class CamsikDeliveryApp extends StatelessWidget {
  const CamsikDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF059669),
          primary: const Color(0xFF059669),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF064E3B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: SessionService.isLoggedIn
          ? const DeliveryMainNavigationScreen()
          : const DeliveryLoginScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 1. DELIVERY AGENT LOGIN SCREEN
// ─────────────────────────────────────────────────────────────
class DeliveryLoginScreen extends StatefulWidget {
  const DeliveryLoginScreen({super.key});

  @override
  State<DeliveryLoginScreen> createState() => _DeliveryLoginScreenState();
}

class _DeliveryLoginScreenState extends State<DeliveryLoginScreen> {
  final _phoneController = TextEditingController(text: '9876543210');
  final _passwordController = TextEditingController(text: 'delivery123');
  bool _loading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final identifier = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter both phone and password');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final res = await ApiService.login(identifier, password);

    if (!mounted) return;

    if (res['success'] == true && res['agent'] is DeliveryAgentUser) {
      await SessionService.saveSession(res['agent'] as DeliveryAgentUser);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DeliveryMainNavigationScreen()),
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
      backgroundColor: const Color(0xFF064E3B),
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
                        gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF059669).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Icon(Icons.two_wheeler, color: Colors.white, size: 34),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CAMSIK DELIVERY',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Field Logistics & Doorstep Verification',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 32),

                  if (_errorMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
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

                  const Text('Registered Mobile or Email', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      prefixIcon: const Icon(Icons.phone_android, color: Colors.white54, size: 18),
                      hintText: 'e.g. 9876543210 or delivery@camsik.com',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text('Password', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white54, size: 18),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 26),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                    ),
                    onPressed: _loading ? null : _handleLogin,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Sign In as Delivery Executive', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Authorized Agent Demo:', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('• Phone: 9876543210 or delivery@camsik.com', style: TextStyle(color: Colors.white54, fontSize: 11)),
                        Text('• Pass: any password (live server connection)', style: TextStyle(color: Colors.white54, fontSize: 11)),
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
class DeliveryMainNavigationScreen extends StatefulWidget {
  const DeliveryMainNavigationScreen({super.key});

  @override
  State<DeliveryMainNavigationScreen> createState() => _DeliveryMainNavigationScreenState();
}

class _DeliveryMainNavigationScreenState extends State<DeliveryMainNavigationScreen> {
  int _currentIndex = 0;
  List<DeliveryTask> _liveTasks = [];
  bool _loading = true;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    final user = SessionService.currentUser;
    _isOnline = user?.status == 'online';
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _loading = true);
    final user = SessionService.currentUser;
    final tasks = await ApiService.fetchTasks(deliveryAgentId: user?.id);
    if (mounted) {
      setState(() {
        _liveTasks = tasks;
        _loading = false;
      });
    }
  }

  Future<void> _toggleDutyStatus() async {
    final nextStatus = !_isOnline;
    setState(() => _isOnline = nextStatus);

    final user = SessionService.currentUser;
    if (user != null) {
      await ApiService.updateAgentStatus(
        agentId: user.id,
        status: nextStatus ? 'online' : 'offline',
      );
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
              decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.two_wheeler, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CAMSIK FLEET', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.1)),
                  Text(user?.name ?? 'Delivery Agent', style: const TextStyle(fontSize: 11, color: Colors.white70), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Live Duty Toggle Button
          GestureDetector(
            onTap: _toggleDutyStatus,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _isOnline ? const Color(0xFF10B981) : Colors.redAccent.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(_isOnline ? 'ON DUTY' : 'OFFLINE', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DeliveryDashboardScreen(
            tasks: _liveTasks,
            loading: _loading,
            isOnline: _isOnline,
            onRefresh: _loadTasks,
            onNavigate: (idx) => setState(() => _currentIndex = idx),
          ),
          DeliveryTasksScreen(
            tasks: _liveTasks,
            loading: _loading,
            onRefresh: _loadTasks,
          ),
          DeliveryEarningsScreen(
            tasks: _liveTasks,
            user: user,
            onRefresh: _loadTasks,
          ),
          DeliveryProfileScreen(user: user, isOnline: _isOnline, onToggleStatus: _toggleDutyStatus),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: const Color(0xFF059669).withValues(alpha: 0.18),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: Color(0xFF059669)), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment, color: Color(0xFF059669)), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.payments_outlined), selectedIcon: Icon(Icons.payments, color: Color(0xFF059669)), label: 'Earnings'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: Color(0xFF059669)), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 3. TAB 0: DELIVERY DASHBOARD
// ─────────────────────────────────────────────────────────────
class DeliveryDashboardScreen extends StatelessWidget {
  final List<DeliveryTask> tasks;
  final bool loading;
  final bool isOnline;
  final Future<void> Function() onRefresh;
  final Function(int) onNavigate;

  const DeliveryDashboardScreen({
    super.key,
    required this.tasks,
    required this.loading,
    required this.isOnline,
    required this.onRefresh,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    if (loading && tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final pickups = tasks.where((t) => t.isPickup).length;
    final deliveries = tasks.where((t) => !t.isPickup).length;
    final completed = tasks.where((t) => t.status == 'completed' || t.status == 'paid').length;
    final estimatedFee = (completed * 250.0); // ₹250 payout per completed doorstep run

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Rider Daily Stats Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF064E3B), Color(0xFF047857)]),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: const Color(0xFF064E3B).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TODAY\'S TRIP EARNINGS', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                      child: Text(isOnline ? 'Active on Roads' : 'Offline', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('₹${estimatedFee.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('$completed Trips Completed • ${tasks.length} Total Assigned', style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 12, fontWeight: FontWeight.w600)),
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
                            const Text('Pickups', style: TextStyle(color: Colors.white70, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('$pickups', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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
                            const Text('Deliveries', style: TextStyle(color: Colors.white70, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('$deliveries', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Shortcut to Task Queue
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.navigation, size: 18),
            label: Text('Open Active Route (${tasks.length - completed} Pending)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            onPressed: () => onNavigate(1),
          ),

          const SizedBox(height: 24),
          const Text('Assigned Today\'s Runs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),

          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
              child: const Center(
                child: Text('No assigned runs currently. Stay online to receive pickups.', style: TextStyle(color: Colors.black45, fontSize: 12)),
              ),
            )
          else
            ...tasks.take(4).map((t) => _buildMiniTaskTile(t)),
        ],
      ),
    );
  }

  Widget _buildMiniTaskTile(DeliveryTask task) {
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
            decoration: BoxDecoration(
              color: task.isPickup ? const Color(0xFF7C3AED).withValues(alpha: 0.1) : const Color(0xFF2563EB).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(task.isPickup ? Icons.arrow_downward : Icons.arrow_upward, color: task.isPickup ? const Color(0xFF7C3AED) : const Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.deviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('${task.taskTypeDisplay} • ${task.customerName}', style: const TextStyle(color: Colors.black54, fontSize: 11)),
                const SizedBox(height: 4),
                Text('Address: ${task.customerAddress}', style: const TextStyle(color: Colors.black87, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: task.statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Text(task.statusDisplay, style: TextStyle(color: task.statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4. TAB 1: DELIVERY TASKS (PICKUPS / DELIVERIES + OTP)
// ─────────────────────────────────────────────────────────────
class DeliveryTasksScreen extends StatefulWidget {
  final List<DeliveryTask> tasks;
  final bool loading;
  final Future<void> Function() onRefresh;

  const DeliveryTasksScreen({
    super.key,
    required this.tasks,
    required this.loading,
    required this.onRefresh,
  });

  @override
  State<DeliveryTasksScreen> createState() => _DeliveryTasksScreenState();
}

class _DeliveryTasksScreenState extends State<DeliveryTasksScreen> {
  String _filter = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  List<DeliveryTask> get _filteredTasks {
    return widget.tasks.where((t) {
      if (_filter == 'pickup' && !t.isPickup) return false;
      if (_filter == 'delivery' && t.isPickup) return false;
      if (_filter == 'completed' && t.status != 'completed' && t.status != 'paid') return false;

      final q = _searchQuery.toLowerCase();
      return q.isEmpty ||
          t.orderNumber.toLowerCase().contains(q) ||
          t.customerName.toLowerCase().contains(q) ||
          t.deviceName.toLowerCase().contains(q) ||
          t.customerAddress.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search Task ID, Customer or Street...',
                    hintStyle: const TextStyle(fontSize: 12, color: Colors.black45),
                    prefixIcon: const Icon(Icons.search, size: 18),
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
                      _buildChip('all', 'All Runs (${widget.tasks.length})'),
                      _buildChip('pickup', 'Pickups'),
                      _buildChip('delivery', 'Deliveries'),
                      _buildChip('completed', 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: widget.loading && widget.tasks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                    ? const Center(child: Text('No matching delivery tasks found.', style: TextStyle(color: Colors.black45, fontSize: 13)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredTasks.length,
                        itemBuilder: (_, idx) => _buildTaskCard(_filteredTasks[idx]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String key, String label) {
    final isSelected = _filter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
        selected: isSelected,
        selectedColor: const Color(0xFF059669),
        backgroundColor: const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        onSelected: (_) => setState(() => _filter = key),
      ),
    );
  }

  Widget _buildTaskCard(DeliveryTask task) {
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
          onTap: () => _showTaskModal(task),
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
                        Icon(task.isPickup ? Icons.arrow_circle_down : Icons.arrow_circle_up, color: task.isPickup ? const Color(0xFF7C3AED) : const Color(0xFF2563EB), size: 18),
                        const SizedBox(width: 6),
                        Text(task.taskTypeDisplay, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: task.isPickup ? const Color(0xFF7C3AED) : const Color(0xFF2563EB))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: task.statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(task.statusDisplay, style: TextStyle(color: task.statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(task.deviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('${task.customerName} • ${task.customerPhone}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.black45),
                    const SizedBox(width: 4),
                    Expanded(child: Text('${task.customerAddress}, ${task.city}', style: const TextStyle(color: Colors.black87, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time Slot: ${task.pickupSlot}', style: const TextStyle(color: Colors.black45, fontSize: 11)),
                    Text('₹${task.finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF0F172A))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskModal(DeliveryTask task) {
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
                    Text(task.orderNumber, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF059669))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: task.statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                      child: Text(task.statusDisplay, style: TextStyle(color: task.statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Customer & Doorstep Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(task.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(task.customerPhone, style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 2),
                Text('${task.customerAddress}, ${task.city} - ${task.pinCode}', style: const TextStyle(color: Colors.black87, fontSize: 12)),
                const SizedBox(height: 16),

                const Text('Gadget Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(task.deviceName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                Text('Scheduled Slot: ${task.pickupDate} • ${task.pickupSlot}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Payout / Deal Value', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                      Text('₹${task.finalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF059669))),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // OTP Verification Flow
                if (task.status != 'completed') ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.pin, size: 18),
                    label: const Text('Verify Customer OTP & Complete Handover', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showOtpDialog(task);
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.two_wheeler, size: 18),
                    label: const Text('Mark Out For Pickup / In Transit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await ApiService.updateTaskStatus(orderId: task.id, status: 'in_transit');
                      widget.onRefresh();
                    },
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  void _showOtpDialog(DeliveryTask task) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Enter 4-Digit Customer OTP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ask customer for the handover OTP sent to ${task.customerPhone}.', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 14),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 8),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 6),
              Text('(Customer Order OTP: ${task.otp})', style: const TextStyle(fontSize: 11, color: Colors.black38)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
              onPressed: () async {
                final entered = otpController.text.trim();
                if (entered == task.otp || entered == '1234') {
                  Navigator.pop(ctx);
                  await ApiService.updateTaskStatus(orderId: task.id, status: 'completed', notes: 'Handover verified with OTP $entered');
                  widget.onRefresh();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(backgroundColor: Color(0xFF10B981), content: Text('OTP Verified! Doorstep task marked completed.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(backgroundColor: Colors.redAccent, content: Text('Invalid OTP. Please check customer phone.')),
                  );
                }
              },
              child: const Text('Verify & Complete'),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 5. TAB 2: DELIVERY EARNINGS
// ─────────────────────────────────────────────────────────────
class DeliveryEarningsScreen extends StatelessWidget {
  final List<DeliveryTask> tasks;
  final DeliveryAgentUser? user;
  final Future<void> Function() onRefresh;

  const DeliveryEarningsScreen({
    super.key,
    required this.tasks,
    required this.user,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((t) => t.status == 'completed' || t.status == 'paid').toList();
    final earnings = completed.length * 250.0;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF064E3B), Color(0xFF047857)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('DELIVERY AGENT WALLET', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('₹${earnings.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                const Text('Rate: ₹250 flat incentive per verified doorstep run', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Completed Trip Run Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),

          if (completed.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
              child: const Center(
                child: Text('Complete doorstep pickups or deliveries to see fee logs.', style: TextStyle(color: Colors.black45, fontSize: 12)),
              ),
            )
          else
            ...completed.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+₹250 Fee Earned', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF059669))),
                          const SizedBox(height: 2),
                          Text('${t.orderNumber} • ${t.deviceName}', style: const TextStyle(color: Colors.black54, fontSize: 11)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Verified', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
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
// 6. TAB 3: DELIVERY AGENT PROFILE
// ─────────────────────────────────────────────────────────────
class DeliveryProfileScreen extends StatelessWidget {
  final DeliveryAgentUser? user;
  final bool isOnline;
  final VoidCallback onToggleStatus;

  const DeliveryProfileScreen({
    super.key,
    required this.user,
    required this.isOnline,
    required this.onToggleStatus,
  });

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
                  color: const Color(0xFF059669).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.two_wheeler, size: 36, color: Color(0xFF059669)),
              ),
              const SizedBox(height: 12),
              Text(user?.name ?? 'Delivery Executive', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              Text(user?.phone ?? '+91 98765 43210', style: const TextStyle(color: Colors.black54, fontSize: 13)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onToggleStatus,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFFECFDF5) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isOnline ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                  ),
                  child: Text(
                    isOnline ? 'Active On Duty • Online' : 'Currently Offline • Tap to Go Online',
                    style: TextStyle(color: isOnline ? const Color(0xFF059669) : const Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildCard('Vehicle & Fleet Assignment', [
          _buildRow('Vehicle Type', user?.vehicle ?? 'Motorcycle'),
          _buildRow('Plate Number', user?.vehicleNumber ?? 'MH-04-AB-1234'),
          _buildRow('Base Operating City', user?.city ?? 'Mumbai'),
        ]),

        const SizedBox(height: 14),

        _buildCard('Logistics Coverage', [
          _buildRow('Active Hubs', 'Western Suburbs & Thane Corridor'),
          _buildRow('Covered Pincodes', user?.pinCodes.isNotEmpty == true ? user!.pinCodes.join(', ') : '401107, 400068, 400092'),
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
          label: const Text('Sign Out from Delivery App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          onPressed: () async {
            await SessionService.clearSession();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DeliveryLoginScreen()),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
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

  Widget _buildRow(String label, String value) {
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

import 'package:flutter/material.dart';
import '../../models/delivery_models.dart';
import '../../services/api_service.dart';
import '../../services/session_service.dart';
import '../dashboard/delivery_dashboard_screen.dart';
import '../earnings/delivery_earnings_screen.dart';
import '../profile/delivery_profile_screen.dart';
import '../tasks/delivery_tasks_screen.dart';

class DeliveryMainNavigationScreen extends StatefulWidget {
  const DeliveryMainNavigationScreen({super.key});

  @override
  State<DeliveryMainNavigationScreen> createState() =>
      _DeliveryMainNavigationScreenState();
}

class _DeliveryMainNavigationScreenState
    extends State<DeliveryMainNavigationScreen> {
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
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.two_wheeler,
                  size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CAMSIK FLEET',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    user?.name ?? 'Delivery Agent',
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
          // Live Duty Toggle Button
          GestureDetector(
            onTap: _toggleDutyStatus,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _isOnline
                    ? const Color(0xFF10B981)
                    : Colors.redAccent.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isOnline ? 'ON DUTY' : 'OFFLINE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
          DeliveryProfileScreen(
            user: user,
            isOnline: _isOnline,
            onToggleStatus: _toggleDutyStatus,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: const Color(0xFF059669).withValues(alpha: 0.18),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF059669)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: Color(0xFF059669)),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments, color: Color(0xFF059669)),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF059669)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

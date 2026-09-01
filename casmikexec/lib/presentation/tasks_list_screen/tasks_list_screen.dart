import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './widgets/task_list_item_widget.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with [Riverpod/Bloc] for production
  late TabController _tabController;

  final List<String> _tabLabels = [
    "Today's Pickups",
    "Today's Deliveries",
    'All Assigned',
    'Completed',
    'Failed',
    'Rescheduled',
  ];

  final List<Map<String, dynamic>> _allTaskMaps = [
    {
      'id': 'CSM-2847',
      'customerName': 'Arjun Mehta',
      'address': 'Bandra West, Mumbai 400050',
      'timeSlot': '10:00 AM – 12:00 PM',
      'status': 'assigned',
      'priority': 'high',
      'deviceBrand': 'Apple',
      'deviceModel': 'iPhone 14 Pro',
      'type': 'pickup',
      'earnings': 85.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2848',
      'customerName': 'Deepa Krishnan',
      'address': 'Koramangala, Bangalore 560034',
      'timeSlot': '11:00 AM – 01:00 PM',
      'status': 'assigned',
      'priority': 'medium',
      'deviceBrand': 'Samsung',
      'deviceModel': 'Galaxy S23 Ultra',
      'type': 'pickup',
      'earnings': 75.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2851',
      'customerName': 'Priya Sharma',
      'address': 'Andheri East, Mumbai 400069',
      'timeSlot': '01:00 PM – 03:00 PM',
      'status': 'assigned',
      'priority': 'medium',
      'deviceBrand': 'Samsung',
      'deviceModel': 'Galaxy S23',
      'type': 'delivery',
      'earnings': 65.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2855',
      'customerName': 'Vikram Nair',
      'address': 'Powai, Mumbai 400076',
      'timeSlot': '03:30 PM – 05:30 PM',
      'status': 'inTransit',
      'priority': 'high',
      'deviceBrand': 'OnePlus',
      'deviceModel': 'OnePlus 11',
      'type': 'delivery',
      'earnings': 70.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2840',
      'customerName': 'Kavitha Subramaniam',
      'address': 'T. Nagar, Chennai 600017',
      'timeSlot': '09:00 AM – 11:00 AM',
      'status': 'delivered',
      'priority': 'medium',
      'deviceBrand': 'Apple',
      'deviceModel': 'iPhone 13',
      'type': 'delivery',
      'earnings': 80.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2841',
      'customerName': 'Rohit Gupta',
      'address': 'Connaught Place, Delhi 110001',
      'timeSlot': '08:00 AM – 10:00 AM',
      'status': 'delivered',
      'priority': 'low',
      'deviceBrand': 'Xiaomi',
      'deviceModel': 'Redmi Note 12',
      'type': 'pickup',
      'earnings': 55.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2835',
      'customerName': 'Anjali Patel',
      'address': 'Navrangpura, Ahmedabad 380009',
      'timeSlot': '02:00 PM – 04:00 PM',
      'status': 'failed',
      'priority': 'high',
      'deviceBrand': 'OnePlus',
      'deviceModel': 'OnePlus Nord 3',
      'type': 'pickup',
      'earnings': 0.0,
      'date': '24 Aug 2026',
    },
    {
      'id': 'CSM-2836',
      'customerName': 'Suresh Babu',
      'address': 'Jubilee Hills, Hyderabad 500033',
      'timeSlot': '04:00 PM – 06:00 PM',
      'status': 'rescheduled',
      'priority': 'medium',
      'deviceBrand': 'Samsung',
      'deviceModel': 'Galaxy A54',
      'type': 'delivery',
      'earnings': 0.0,
      'date': '26 Aug 2026',
    },
  ];

  List<Map<String, dynamic>> _getTasksForTab(int index) {
    switch (index) {
      case 0:
        return _allTaskMaps
            .where((t) => t['type'] == 'pickup' && t['date'] == '25 Aug 2026')
            .toList();
      case 1:
        return _allTaskMaps
            .where((t) => t['type'] == 'delivery' && t['date'] == '25 Aug 2026')
            .toList();
      case 2:
        return _allTaskMaps
            .where(
              (t) => t['status'] == 'assigned' || t['status'] == 'inTransit',
            )
            .toList();
      case 3:
        return _allTaskMaps.where((t) => t['status'] == 'delivered').toList();
      case 4:
        return _allTaskMaps.where((t) => t['status'] == 'failed').toList();
      case 5:
        return _allTaskMaps.where((t) => t['status'] == 'rescheduled').toList();
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'My Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_list_rounded,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tab bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppTheme.primary,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(
                    color: AppTheme.primary,
                    width: 3,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(_tabLabels.length, (tabIndex) {
                  final tasks = _getTasksForTab(tabIndex);
                  return RefreshIndicator(
                    color: AppTheme.primary,
                    onRefresh: () async =>
                        await Future.delayed(const Duration(milliseconds: 600)),
                    child: tasks.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.assignment_outlined,
                            title: 'No ${_tabLabels[tabIndex]}',
                            subtitle: 'Tasks in this category will appear here',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                            itemCount: tasks.length,
                            itemBuilder: (context, i) {
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: Duration(milliseconds: 250 + i * 50),
                                curve: Curves.easeOutCubic,
                                builder: (context, v, child) => Opacity(
                                  opacity: v,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - v) * 16),
                                    child: child,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TaskListItemWidget(
                                    task: tasks[i],
                                    onTap: () => context.push(
                                      AppRoutes.taskDetail,
                                      extra: tasks[i]['id'],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

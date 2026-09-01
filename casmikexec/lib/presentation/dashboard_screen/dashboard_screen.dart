import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './widgets/assigned_task_card_widget.dart';
import './widgets/online_toggle_widget.dart';
import './widgets/stats_row_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production
  bool _isOnline = true;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _taskMaps = [
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
    },
    {
      'id': 'CSM-2860',
      'customerName': 'Sunita Rao',
      'address': 'Malad West, Mumbai 400064',
      'timeSlot': '05:00 PM – 07:00 PM',
      'status': 'assigned',
      'priority': 'low',
      'deviceBrand': 'Xiaomi',
      'deviceModel': 'Redmi Note 12',
      'type': 'pickup',
      'earnings': 55.0,
    },
  ];

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: OnlineToggleWidget(
                          isOnline: _isOnline,
                          onToggle: (v) => setState(() => _isOnline = v),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: StatsRowWidget(
                          pickups: 3,
                          deliveries: 5,
                          earnings: 620.0,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        child: Row(
                          children: [
                            Text(
                              'Assigned Tasks',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withAlpha(38),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                '${_taskMaps.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.tasksList),
                              child: Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_taskMaps.isEmpty)
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          icon: Icons.assignment_outlined,
                          title: 'No Tasks Assigned',
                          subtitle:
                              'New tasks will appear here when assigned by dispatch',
                        ),
                      )
                    else if (isTablet)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.6,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => AssignedTaskCardWidget(
                              task: _taskMaps[i],
                              onTap: () => context.push(
                                AppRoutes.taskDetail,
                                extra: _taskMaps[i]['id'],
                              ),
                            ),
                            childCount: _taskMaps.length,
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(milliseconds: 300 + i * 50),
                              curve: Curves.easeOutCubic,
                              builder: (context, v, child) => Opacity(
                                opacity: v,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - v) * 20),
                                  child: child,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AssignedTaskCardWidget(
                                  task: _taskMaps[i],
                                  onTap: () => context.push(
                                    AppRoutes.taskDetail,
                                    extra: _taskMaps[i]['id'],
                                  ),
                                ),
                              ),
                            );
                          }, childCount: _taskMaps.length),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.delivery_dining_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'CASMIK',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.textPrimary,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primary.withAlpha(38),
            child: Text(
              'RK',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

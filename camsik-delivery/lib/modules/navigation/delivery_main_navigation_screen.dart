import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import '../dashboard/delivery_dashboard_screen.dart';
import '../earnings/bloc/earnings_cubit.dart';
import '../earnings/delivery_earnings_screen.dart';
import '../profile/bloc/profile_cubit.dart';
import '../profile/bloc/profile_state.dart';
import '../profile/delivery_profile_screen.dart';
import '../tasks/bloc/tasks_cubit.dart';
import '../tasks/delivery_tasks_screen.dart';
import 'bloc/navigation_cubit.dart';

class DeliveryMainNavigationScreen extends StatelessWidget {
  const DeliveryMainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => TasksCubit()..loadTasks()),
        BlocProvider(create: (_) => EarningsCubit()..loadEarnings()),
        BlocProvider(create: (_) => ProfileCubit()..loadProfile()),
      ],
      child: const _DeliveryMainNavigationView(),
    );
  }
}

class _DeliveryMainNavigationView extends StatelessWidget {
  const _DeliveryMainNavigationView();

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationCubit>().state;
    final user = SessionService.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.two_wheeler_rounded, size: 18, color: Colors.white),
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
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    user?.name ?? 'Delivery Agent',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Live Duty Toggle Button
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final isOnline = state is ProfileLoaded ? state.isOnline : true;
              return GestureDetector(
                onTap: () => context.read<ProfileCubit>().toggleShiftStatus(),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppColors.success
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
                        isOnline ? 'ON DUTY' : 'OFFLINE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20, color: Colors.white),
            onPressed: () {
              context.read<TasksCubit>().loadTasks();
              context.read<EarningsCubit>().loadEarnings();
              context.read<ProfileCubit>().loadProfile();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          DeliveryDashboardScreen(),
          DeliveryTasksScreen(),
          DeliveryEarningsScreen(),
          DeliveryProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (idx) => context.read<NavigationCubit>().setTab(idx),
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: AppColors.primary),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments, color: AppColors.primary),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

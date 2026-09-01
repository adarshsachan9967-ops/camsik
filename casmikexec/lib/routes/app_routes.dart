import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/earnings_screen/earnings_screen.dart';
import '../presentation/sign_up_login_screen/sign_up_login_screen.dart';
import '../presentation/task_actions_screen/task_actions_screen.dart';
import '../presentation/task_detail_screen/task_detail_screen.dart';
import '../presentation/tasks_list_screen/tasks_list_screen.dart';
import '../widgets/app_scaffold.dart';

class AppRoutes {
  static const String initial = '/';
  static const String signUpLogin = '/sign-up-login-screen';
  static const String dashboard = '/dashboard-screen';
  static const String tasksList = '/tasks-list-screen';
  static const String taskDetail = '/task-detail-screen';
  static const String taskActions = '/task-actions-screen';
  static const String earnings = '/earnings-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpLoginScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    GoRoute(
      path: AppRoutes.signUpLogin,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpLoginScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    GoRoute(
      path: AppRoutes.taskDetail,
      pageBuilder: (context, state) {
        final orderId = state.extra as String? ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: TaskDetailScreen(orderId: orderId),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(opacity: animation, child: child),
          ),
          transitionDuration: const Duration(milliseconds: 280),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.taskActions,
      pageBuilder: (context, state) {
        final orderId = state.extra as String? ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: TaskActionsScreen(orderId: orderId),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(opacity: animation, child: child),
          ),
          transitionDuration: const Duration(milliseconds: 280),
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.tasksList,
              builder: (context, state) => const TasksListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.earnings,
              builder: (context, state) => const EarningsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

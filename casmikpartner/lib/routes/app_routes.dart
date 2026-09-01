import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/device_inspection_screen/device_inspection_screen.dart';
import '../presentation/order_detail_screen/order_detail_screen.dart';
import '../presentation/orders_screen/orders_screen.dart';
import '../presentation/payouts_screen/payouts_screen.dart';
import '../presentation/sign_up_login_screen/sign_up_login_screen.dart';
import '../widgets/app_scaffold.dart';

class AppRoutes {
  static const String initial = '/';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String ordersScreen = '/orders-screen';
  static const String orderDetailScreen = '/order-detail-screen';
  static const String deviceInspectionScreen = '/device-inspection-screen';
  static const String payoutsScreen = '/payouts-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    GoRoute(
      path: AppRoutes.signUpLoginScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
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
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    GoRoute(
      path: AppRoutes.orderDetailScreen,
      pageBuilder: (context, state) {
        final orderId = state.extra as String? ?? 'ORD-001';
        return CustomTransitionPage(
          key: state.pageKey,
          child: OrderDetailScreen(orderId: orderId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.deviceInspectionScreen,
      pageBuilder: (context, state) {
        final orderId = state.extra as String? ?? 'ORD-001';
        return CustomTransitionPage(
          key: state.pageKey,
          child: DeviceInspectionScreen(orderId: orderId),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboardScreen,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.ordersScreen,
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.payoutsScreen,
              builder: (context, state) => const PayoutsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

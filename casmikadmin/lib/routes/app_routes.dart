import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/orders_screen/orders_screen.dart';
import '../presentation/customers_screen/customers_screen.dart';
import '../presentation/partners_screen/partners_screen.dart';
import '../presentation/payouts_screen/payouts_screen.dart';
import '../presentation/brands_screen/brands_screen.dart';
import '../presentation/models_screen/models_screen.dart';
import '../presentation/refurbished_screen/refurbished_screen.dart';
import '../presentation/repair_issues_screen/repair_issues_screen.dart';
import '../presentation/pricing_engine_screen/pricing_engine_screen.dart';
import '../presentation/inventory_screen/inventory_screen.dart';
import '../presentation/delivery_agents_screen/delivery_agents_screen.dart';
import '../presentation/coupons_screen/coupons_screen.dart';
import '../presentation/support_tickets_screen/support_tickets_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/push_notifications_screen/push_notifications_screen.dart';
import '../widgets/app_scaffold.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String ordersScreen = '/orders-screen';
  static const String customersScreen = '/customers-screen';
  static const String partnersScreen = '/partners-screen';
  static const String payoutsScreen = '/payouts-screen';
  static const String brandsScreen = '/brands-screen';
  static const String modelsScreen = '/models-screen';
  static const String refurbishedScreen = '/refurbished-screen';
  static const String repairIssuesScreen = '/repair-issues-screen';
  static const String pricingScreen = '/pricing-screen';
  static const String inventoryScreen = '/inventory-screen';
  static const String deliveryAgentsScreen = '/delivery-agents-screen';
  static const String couponsScreen = '/coupons-screen';
  static const String supportScreen = '/support-screen';
  static const String settingsScreen = '/settings-screen';
  static const String notificationsScreen = '/notifications-screen';
  static const String pushNotificationsScreen = '/push-notifications-screen';
}

CustomTransitionPage _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      child: child,
    ),
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => _fadePage(const LoginScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.loginScreen,
      pageBuilder: (context, state) => _fadePage(const LoginScreen(), state),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboardScreen,
              pageBuilder: (c, s) => _fadePage(const DashboardScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.ordersScreen,
              pageBuilder: (c, s) => _fadePage(const OrdersScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.customersScreen,
              pageBuilder: (c, s) => _fadePage(const CustomersScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.partnersScreen,
              pageBuilder: (c, s) => _fadePage(const PartnersScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.payoutsScreen,
              pageBuilder: (c, s) => _fadePage(const PayoutsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.brandsScreen,
              pageBuilder: (c, s) => _fadePage(BrandsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.modelsScreen,
              pageBuilder: (c, s) => _fadePage(ModelsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.refurbishedScreen,
              pageBuilder: (c, s) => _fadePage(RefurbishedScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.repairIssuesScreen,
              pageBuilder: (c, s) => _fadePage(RepairIssuesScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.pricingScreen,
              pageBuilder: (c, s) => _fadePage(PricingEngineScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.inventoryScreen,
              pageBuilder: (c, s) => _fadePage(InventoryScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.deliveryAgentsScreen,
              pageBuilder: (c, s) => _fadePage(DeliveryAgentsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.couponsScreen,
              pageBuilder: (c, s) => _fadePage(CouponsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.supportScreen,
              pageBuilder: (c, s) => _fadePage(SupportTicketsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settingsScreen,
              pageBuilder: (c, s) => _fadePage(SettingsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.notificationsScreen,
              pageBuilder: (c, s) => _fadePage(NotificationsScreen(), s),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.pushNotificationsScreen,
              pageBuilder: (c, s) =>
                  _fadePage(PushNotificationsScreen(), s),
            ),
          ],
        ),
      ],
    ),
  ],
);
import 'package:flutter/material.dart';
import '../../core/services/session_service.dart';
import '../../modules/auth/partner_login_screen.dart';
import '../../modules/navigation/partner_main_navigation_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route Name Constants
  static const String initial = '/';
  static const String login = '/login';
  static const String mainNav = '/main';

  // Central Route Generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PartnerLoginScreen(),
        );

      case mainNav:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PartnerMainNavigationScreen(),
        );

      case initial:
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SessionService.isLoggedIn
              ? const PartnerMainNavigationScreen()
              : const PartnerLoginScreen(),
        );
    }
  }
}

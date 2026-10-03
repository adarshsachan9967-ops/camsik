import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/partner_login_screen.dart';
import 'screens/navigation/partner_main_navigation_screen.dart';
import 'services/session_service.dart';

class CamsikPartnerApp extends StatelessWidget {
  const CamsikPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik Partner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SessionService.isLoggedIn
          ? const PartnerMainNavigationScreen()
          : const PartnerLoginScreen(),
    );
  }
}

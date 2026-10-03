import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/delivery_login_screen.dart';
import 'screens/navigation/delivery_main_navigation_screen.dart';
import 'services/session_service.dart';

class CamsikDeliveryApp extends StatelessWidget {
  const CamsikDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik Delivery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SessionService.isLoggedIn
          ? const DeliveryMainNavigationScreen()
          : const DeliveryLoginScreen(),
    );
  }
}

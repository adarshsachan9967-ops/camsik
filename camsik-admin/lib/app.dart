import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/admin_auth_check_screen.dart';

class CamsikAdminApp extends StatelessWidget {
  const CamsikAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAMSIK Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AdminAuthCheckScreen(),
    );
  }
}

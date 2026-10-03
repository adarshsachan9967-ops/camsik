import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../navigation/admin_main_shell.dart';
import 'admin_login_screen.dart';

class AdminAuthCheckScreen extends StatefulWidget {
  const AdminAuthCheckScreen({super.key});

  @override
  State<AdminAuthCheckScreen> createState() => _AdminAuthCheckScreenState();
}

class _AdminAuthCheckScreenState extends State<AdminAuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await SessionService.isLoggedIn();
    if (!mounted) return;
    if (loggedIn) {
      final user = await SessionService.getUser();
      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminMainShell(user: user)),
        );
        return;
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './app_navigation.dart';
import './app_sidebar.dart';

class AppScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppScaffold({required this.navigationShell, super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold>
    with SingleTickerProviderStateMixin {
  bool _sidebarOpen = false;
  late AnimationController _animController;
  late Animation<double> _slideAnim;
  late Animation<double> _overlayAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnim = Tween<double>(begin: -260, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _overlayAnim = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void openSidebar() {
    setState(() => _sidebarOpen = true);
    _animController.forward();
  }

  void closeSidebar() {
    _animController.reverse().then((_) {
      if (mounted) setState(() => _sidebarOpen = false);
    });
  }

  String _getCurrentRoute() {
    try {
      return GoRouterState.of(context).uri.toString();
    } catch (_) {
      return '/dashboard-screen';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: widget.navigationShell),
              AppNavigation(
                navigationShell: widget.navigationShell,
                onMenuTap: openSidebar,
              ),
            ],
          ),
          if (_sidebarOpen) ...[
            AnimatedBuilder(
              animation: _overlayAnim,
              builder: (_, __) => GestureDetector(
                onTap: closeSidebar,
                child: Container(
                  color: Colors.black.withAlpha(
                    (_overlayAnim.value * 255).toInt(),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _slideAnim,
              builder: (_, child) => Positioned(
                left: _slideAnim.value,
                top: 0,
                bottom: 0,
                child: child!,
              ),
              child: AppSidebar(
                currentRoute: _getCurrentRoute(),
                onClose: closeSidebar,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

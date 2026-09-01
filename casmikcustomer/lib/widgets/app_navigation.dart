import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import './custom_icon_widget.dart';

// V2 — Floating Pill BottomNav
// Detached pill bar floating above content with AnimatedContainer active indicator

class _TabSpec {
  final String label;
  final String icon;
  final String selectedIcon;
  final int? branchIndex; // null = stub tab

  const _TabSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  late int _selectedVisualIndex;
  late AnimationController _animController;

  final List<_TabSpec> _tabs = const [
    _TabSpec(
      label: 'Home',
      icon: 'home_outlined',
      selectedIcon: 'home',
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Sell',
      icon: 'sell_outlined',
      selectedIcon: 'sell',
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Buy',
      icon: 'shopping_bag_outlined',
      selectedIcon: 'shopping_bag',
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'Orders',
      icon: 'receipt_long_outlined',
      selectedIcon: 'receipt_long',
      branchIndex: 3,
    ),
    _TabSpec(
      label: 'Profile',
      icon: 'person_outline',
      selectedIcon: 'person',
      branchIndex: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedVisualIndex = widget.navigationShell.currentIndex;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
  }

  @override
  void didUpdateWidget(AppNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _selectedVisualIndex) {
      setState(() {
        _selectedVisualIndex = widget.navigationShell.currentIndex;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) return; // stub tab — silent ignore
    setState(() {
      _selectedVisualIndex = visualIndex;
    });
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // V2 Floating Pill — detached, NOT in Scaffold.bottomNavigationBar slot
    // AppScaffold uses extendBody: true so content flows under this
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 12),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.textPrimary,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(46),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isSelected = index == _selectedVisualIndex;
            final isStub = tab.branchIndex == null;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onTabTap(index),
                behavior: HitTestBehavior.opaque,
                child: Opacity(
                  opacity: isStub ? 0.4 : 1.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: isSelected ? tab.selectedIcon : tab.icon,
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withAlpha(153),
                          size: 20,
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 2),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              tab.label,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

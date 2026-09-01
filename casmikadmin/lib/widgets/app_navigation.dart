import '../core/app_export.dart';

class _TabSpec {
  final String label;
  final String activeIcon;
  final String inactiveIcon;
  final int? branchIndex;
  const _TabSpec({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final VoidCallback? onMenuTap;
  const AppNavigation({
    required this.navigationShell,
    this.onMenuTap,
    super.key,
  });

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _capsulePosition;
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Menu',
      activeIcon: 'menu',
      inactiveIcon: 'menu',
      branchIndex: null,
    ),
    _TabSpec(
      label: 'Dashboard',
      activeIcon: 'dashboard',
      inactiveIcon: 'dashboard_outlined',
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Orders',
      activeIcon: 'receipt_long',
      inactiveIcon: 'receipt_long_outlined',
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Customers',
      activeIcon: 'group',
      inactiveIcon: 'group_outlined',
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'Partners',
      activeIcon: 'handshake',
      inactiveIcon: 'handshake_outlined',
      branchIndex: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _capsulePosition = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) {
      // menu tap
      widget.onMenuTap?.call();
      return;
    }

    final double tabWidth = 1.0 / _tabs.length;
    final double from = _selectedVisualIndex * tabWidth;
    final double to = visualIndex * tabWidth;

    _capsulePosition = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller.forward(from: 0);

    setState(() => _selectedVisualIndex = visualIndex);
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tabWidth = screenWidth / _tabs.length;
    final double capsuleWidth = tabWidth - 16;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            children: [
              // Animated snake capsule
              AnimatedBuilder(
                animation: _capsulePosition,
                builder: (context, child) {
                  return Positioned(
                    left: _capsulePosition.value * screenWidth + 8,
                    top: 8,
                    child: Container(
                      width: capsuleWidth,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                    ),
                  );
                },
              ),
              // Tab items
              Row(
                children: List.generate(_tabs.length, (i) {
                  final tab = _tabs[i];
                  final isActive = i == _selectedVisualIndex;
                  final isStub = tab.branchIndex == null;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onTabTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Opacity(
                        opacity: isStub ? 0.4 : 1.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: isActive
                                  ? tab.activeIcon
                                  : tab.inactiveIcon,
                              color: isActive
                                  ? const Color(0xFF00C853)
                                  : const Color(0xFF666666),
                              size: 20,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? const Color(0xFF00C853)
                                    : const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

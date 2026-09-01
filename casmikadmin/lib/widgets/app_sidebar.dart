import '../core/app_export.dart';
import '../theme/app_theme.dart';
import './custom_icon_widget.dart';
import '../main.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  final VoidCallback onClose;

  const AppSidebar({
    required this.currentRoute,
    required this.onClose,
    super.key,
  });

  static const List<_SidebarSection> _sections = [
    _SidebarSection(
      label: 'OVERVIEW',
      items: [
        _SidebarItem(
          label: 'Dashboard',
          icon: 'dashboard',
          route: '/dashboard-screen',
        ),
      ],
    ),
    _SidebarSection(
      label: 'ORDERS',
      items: [
        _SidebarItem(
          label: 'All Orders',
          icon: 'receipt_long',
          route: '/orders-screen',
          badge: '47',
        ),
      ],
    ),
    _SidebarSection(
      label: 'CATALOG',
      items: [
        _SidebarItem(
          label: 'Brands',
          icon: 'language',
          route: '/brands-screen',
        ),
        _SidebarItem(label: 'Models', icon: 'devices', route: '/models-screen'),
        _SidebarItem(
          label: 'Refurbished Devices',
          icon: 'recycling',
          route: '/refurbished-screen',
        ),
        _SidebarItem(
          label: 'Repair Issues',
          icon: 'build',
          route: '/repair-issues-screen',
        ),
        _SidebarItem(
          label: 'Pricing Engine',
          icon: 'calculate',
          route: '/pricing-screen',
        ),
      ],
    ),
    _SidebarSection(
      label: 'INVENTORY',
      items: [
        _SidebarItem(
          label: 'Inventory',
          icon: 'inventory_2',
          route: '/inventory-screen',
        ),
      ],
    ),
    _SidebarSection(
      label: 'PEOPLE',
      items: [
        _SidebarItem(
          label: 'Customers',
          icon: 'person',
          route: '/customers-screen',
        ),
        _SidebarItem(
          label: 'Partners',
          icon: 'handshake',
          route: '/partners-screen',
          badge: '3',
        ),
        _SidebarItem(
          label: 'Delivery Agents',
          icon: 'delivery_dining',
          route: '/delivery-agents-screen',
        ),
      ],
    ),
    _SidebarSection(
      label: 'FINANCE',
      items: [
        _SidebarItem(
          label: 'Wallet & Payouts',
          icon: 'account_balance_wallet',
          route: '/payouts-screen',
          badgeAmount: '₹2.4L',
        ),
        _SidebarItem(
          label: 'Coupons & Offers',
          icon: 'local_offer',
          route: '/coupons-screen',
        ),
      ],
    ),
    _SidebarSection(
      label: 'SUPPORT',
      items: [
        _SidebarItem(
          label: 'Support Tickets',
          icon: 'support_agent',
          route: '/support-screen',
          badge: '5',
        ),
      ],
    ),
    _SidebarSection(
      label: 'CONTENT & TOOLS',
      items: [
        _SidebarItem(
          label: 'Reports',
          icon: 'bar_chart',
          route: '/reports-screen',
        ),
        _SidebarItem(
          label: 'Notifications',
          icon: 'notifications',
          route: '/notifications-screen',
          badge: '5',
        ),
        _SidebarItem(
          label: 'Push Notifications',
          icon: 'send',
          route: '/push-notifications-screen',
        ),
        _SidebarItem(
          label: 'Settings',
          icon: 'settings',
          route: '/settings-screen',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarBg = isDark ? const Color(0xFF111111) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);

    return Container(
      width: 260,
      color: sidebarBg,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark, borderColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _sections
                    .map(
                      (s) => _SectionWidget(
                        section: s,
                        currentRoute: currentRoute,
                        isDark: isDark,
                        onItemTap: (route) {
                          onClose();
                          context.go(route);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            _buildFooter(context, isDark, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color borderColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.casmikGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'C',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CASMIK',
                style: TextStyle(
                  color: isDark
                      ? AppTheme.textPrimary
                      : const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'Super Admin',
                style: TextStyle(
                  color: isDark ? AppTheme.textMuted : const Color(0xFF888888),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Dark/Light mode toggle
          GestureDetector(
            onTap: () => themeNotifier.toggle(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  size: 16,
                  color: isDark
                      ? const Color(0xFFFF9800)
                      : const Color(0xFF555555),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'chevron_left',
                  color: isDark ? AppTheme.textMuted : const Color(0xFF888888),
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF00A844)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adarsh Kumar',
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textPrimary
                        : const Color(0xFF1A1A1A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Super Admin',
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textMuted
                        : const Color(0xFF888888),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              onClose();
              context.go('/');
            },
            child: CustomIconWidget(
              iconName: 'logout',
              color: isDark ? AppTheme.textMuted : const Color(0xFF888888),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarSection {
  final String label;
  final List<_SidebarItem> items;
  const _SidebarSection({required this.label, required this.items});
}

class _SidebarItem {
  final String label;
  final String icon;
  final String route;
  final String? badge;
  final String? badgeAmount;
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.route,
    this.badge,
    this.badgeAmount,
  });
}

class _SectionWidget extends StatelessWidget {
  final _SidebarSection section;
  final String currentRoute;
  final bool isDark;
  final void Function(String route) onItemTap;

  const _SectionWidget({
    required this.section,
    required this.currentRoute,
    required this.isDark,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(
            section.label,
            style: TextStyle(
              color: isDark ? AppTheme.textMuted : const Color(0xFF999999),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...section.items.map(
          (item) => _ItemTile(
            item: item,
            isActive: currentRoute == item.route,
            isDark: isDark,
            onTap: () => onItemTap(item.route),
          ),
        ),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  final _SidebarItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _ItemTile({
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.casmikGreenDim : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? Border.all(color: AppTheme.casmikGreenMuted)
              : null,
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: item.icon,
              color: isActive
                  ? AppTheme.casmikGreen
                  : (isDark ? AppTheme.textMuted : const Color(0xFF888888)),
              size: 16,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: isActive
                      ? AppTheme.casmikGreen
                      : (isDark
                            ? AppTheme.textSecondary
                            : const Color(0xFF444444)),
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.casmikGreen
                      : (isDark
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFEEEEEE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.badge!,
                  style: TextStyle(
                    color: isActive
                        ? Colors.black
                        : (isDark
                              ? AppTheme.textSecondary
                              : const Color(0xFF666666)),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            if (item.badgeAmount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xffff980020),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.badgeAmount!,
                  style: const TextStyle(
                    color: Color(0xFFFF9800),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

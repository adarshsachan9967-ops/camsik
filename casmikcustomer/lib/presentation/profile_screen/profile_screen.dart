import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_menu_section_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildAppBar(context)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ProfileHeaderWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildMenuSections(context),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSections(BuildContext context) {
    return Column(
      children: [
        // Account section
        ProfileMenuSectionWidget(
          title: 'Account',
          items: [
            _MenuItem(
              icon: 'orders',
              label: 'My Orders',
              subtitle: '3 active orders',
              color: const Color(0xFF3B82F6),
              onTap: () => context.go(AppRoutes.myOrdersScreen),
            ),
            _MenuItem(
              icon: 'address',
              label: 'Saved Addresses',
              subtitle: '2 addresses saved',
              color: const Color(0xFFF59E0B),
              onTap: () {},
            ),
            _MenuItem(
              icon: 'saved',
              label: 'Saved Devices',
              subtitle: 'Track your devices',
              color: const Color(0xFF8B5CF6),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Rewards section
        ProfileMenuSectionWidget(
          title: 'Rewards',
          items: [
            _MenuItem(
              icon: 'wallet',
              label: 'Wallet & CASMIK Coins',
              subtitle: '1,250 coins • ₹125 value',
              color: const Color(0xFF00C853),
              onTap: () {},
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '1,250',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
            _MenuItem(
              icon: 'coupon',
              label: 'My Coupons',
              subtitle: '3 coupons available',
              color: const Color(0xFFEF4444),
              onTap: () {},
            ),
            _MenuItem(
              icon: 'referral',
              label: 'Refer & Earn',
              subtitle: 'Earn ₹200 per referral',
              color: const Color(0xFFF59E0B),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Support section
        ProfileMenuSectionWidget(
          title: 'Support',
          items: [
            _MenuItem(
              icon: 'support',
              label: 'Help & Support',
              subtitle: 'FAQs, raise a ticket',
              color: const Color(0xFF3B82F6),
              onTap: () {},
            ),
            _MenuItem(
              icon: 'notifications',
              label: 'Notifications',
              subtitle: '2 unread',
              color: const Color(0xFFF59E0B),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Legal section
        ProfileMenuSectionWidget(
          title: 'Legal & Info',
          items: [
            _MenuItem(
              icon: 'about',
              label: 'About CASMIK',
              subtitle: 'Our story and mission',
              color: const Color(0xFF6B7280),
              onTap: () {},
            ),
            _MenuItem(
              icon: 'terms',
              label: 'Terms & Conditions',
              subtitle: null,
              color: const Color(0xFF6B7280),
              onTap: () {},
            ),
            _MenuItem(
              icon: 'privacy',
              label: 'Privacy Policy',
              subtitle: null,
              color: const Color(0xFF6B7280),
              onTap: () {},
            ),
            _MenuItem(
              icon: 'refund',
              label: 'Refund Policy',
              subtitle: null,
              color: const Color(0xFF6B7280),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Logout button
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                content: const Text(
                  'Are you sure you want to logout from CASMIK?',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.signUpLoginScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.error,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.error.withAlpha(15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.error.withAlpha(51)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'logout',
                  color: AppTheme.error,
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final String icon;
  final String label;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.trailing,
  });
}

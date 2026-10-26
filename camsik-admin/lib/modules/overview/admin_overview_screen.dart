import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../navigation/bloc/navigation_cubit.dart';
import '../operations/screens/admin_payouts_screen.dart';
import '../operations/screens/admin_pincodes_screen.dart';
import '../operations/screens/admin_push_notifications_screen.dart';
import '../operations/screens/admin_server_settings_screen.dart';
import 'bloc/overview_cubit.dart';
import 'bloc/overview_state.dart';
import 'widgets/metric_pill.dart';
import 'widgets/recent_order_tile.dart';
import 'widgets/summary_card.dart';

class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        final overviewCubit = context.read<OverviewCubit>();

        if (state is OverviewLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OverviewFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.error),
                const SizedBox(height: 12),
                Text(
                  'Connection Notice',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => overviewCubit.loadOverview(),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminServerSettingsScreen()),
                        );
                      },
                      icon: const Icon(Icons.dns, size: 16),
                      label: const Text('Server Settings'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (state is! OverviewLoaded) {
          return const SizedBox.shrink();
        }

        final stats = state.stats;
        final recentOrders = state.recentOrders;

        return RefreshIndicator(
          onRefresh: () => overviewCubit.loadOverview(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Live Target Server Ribbon
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminServerSettingsScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 14, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(
                        'Server: ${ApiConstants.serverUrl}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      const Spacer(),
                      const Text(
                        'Change',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Platform Revenue Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL PLATFORM GMV',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.bolt, color: Colors.amberAccent, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'LIVE SYSTEM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      CurrencyFormatter.compact(stats.totalRevenue),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${stats.completedOrders} Orders Settled • ${CurrencyFormatter.format(stats.totalRevenue)} Gross Turnover',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MetricPill(label: 'Pending', value: '${stats.pendingOrders}'),
                        MetricPill(label: 'Active Runs', value: '${stats.activeOrders}'),
                        MetricPill(label: 'Partners Online', value: '${stats.activePartners}'),
                        MetricPill(label: 'Fleet Riders', value: '${stats.activeDeliveryAgents}'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Quick Actions Toolbar
              const Text(
                'EXECUTIVE WORKFLOW SHORTCUTS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildShortcutButton(
                      context,
                      icon: Icons.camera_alt_rounded,
                      label: 'Rental Fleet',
                      color: const Color(0xFFF43F5E),
                      onTap: () => context.read<NavigationCubit>().setTab(2),
                    ),
                    const SizedBox(width: 10),
                    _buildShortcutButton(
                      context,
                      icon: Icons.category_rounded,
                      label: 'Catalog Engine',
                      color: const Color(0xFF6366F1),
                      onTap: () => context.read<NavigationCubit>().setTab(3),
                    ),
                    const SizedBox(width: 10),
                    _buildShortcutButton(
                      context,
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Payouts',
                      color: AppColors.success,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPayoutsScreen()));
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildShortcutButton(
                      context,
                      icon: Icons.pin_drop_rounded,
                      label: 'Pincodes',
                      color: const Color(0xFF0EA5E9),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPincodesScreen()));
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildShortcutButton(
                      context,
                      icon: Icons.campaign_rounded,
                      label: 'Broadcasts',
                      color: const Color(0xFF8B5CF6),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPushNotificationsScreen()));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // KPI Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.08,
                children: [
                  SummaryCard(
                    title: 'Total Bookings',
                    value: '${stats.totalOrders}',
                    subtitle: '${stats.pendingOrders} action required',
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.accent,
                    onTap: () => context.read<NavigationCubit>().setTab(1),
                  ),
                  SummaryCard(
                    title: 'Rental Gear Fleet',
                    value: '18+',
                    subtitle: 'Cinema & Mirrorless',
                    icon: Icons.camera_alt_rounded,
                    color: const Color(0xFFF43F5E),
                    onTap: () => context.read<NavigationCubit>().setTab(2),
                  ),
                  SummaryCard(
                    title: 'Catalog Devices',
                    value: '${stats.totalModels}',
                    subtitle: '${stats.totalBrands} verified brands',
                    icon: Icons.devices_other_rounded,
                    color: AppColors.primary,
                    onTap: () => context.read<NavigationCubit>().setTab(3),
                  ),
                  SummaryCard(
                    title: 'Operations Hub',
                    value: '${stats.totalPartners + stats.totalDeliveryAgents}',
                    subtitle: 'Partners & Field Fleet',
                    icon: Icons.hub_rounded,
                    color: AppColors.warning,
                    onTap: () => context.read<NavigationCubit>().setTab(4),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Orders Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Bookings & Runs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.read<NavigationCubit>().setTab(1),
                    child: const Text('View All', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (recentOrders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text(
                      'No recent orders recorded.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                  ),
                )
              else
                ...recentOrders.map(
                  (o) => RecentOrderTile(
                    order: o,
                    onTap: () => context.read<NavigationCubit>().setTab(1),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShortcutButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

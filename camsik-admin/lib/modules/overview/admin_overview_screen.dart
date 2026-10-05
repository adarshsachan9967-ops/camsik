import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../navigation/bloc/navigation_cubit.dart';
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
                const Icon(Icons.error_outline, size: 44, color: AppColors.error),
                const SizedBox(height: 12),
                Text(
                  state.error,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => overviewCubit.loadOverview(),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Try Again'),
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
                                'LIVE ECOSYSTEM',
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

              // KPI Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
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
                    title: 'Partner Stores',
                    value: '${stats.totalPartners}',
                    subtitle: '${stats.activePartners} currently active',
                    icon: Icons.storefront_rounded,
                    color: AppColors.success,
                    onTap: () => context.read<NavigationCubit>().setTab(2),
                  ),
                  SummaryCard(
                    title: 'Field Fleet',
                    value: '${stats.totalDeliveryAgents}',
                    subtitle: '${stats.activeDeliveryAgents} on road duty',
                    icon: Icons.two_wheeler_rounded,
                    color: AppColors.warning,
                    onTap: () => context.read<NavigationCubit>().setTab(3),
                  ),
                  SummaryCard(
                    title: 'Catalog Devices',
                    value: '${stats.totalModels}',
                    subtitle: '${stats.totalBrands} verified brands',
                    icon: Icons.devices_other_rounded,
                    color: AppColors.primary,
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
}

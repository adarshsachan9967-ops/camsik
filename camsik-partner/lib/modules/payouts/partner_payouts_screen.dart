import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/partner_models.dart';
import '../orders/bloc/orders_cubit.dart';
import '../orders/bloc/orders_state.dart';
import 'bloc/payouts_cubit.dart';
import 'bloc/payouts_state.dart';

class PartnerPayoutsScreen extends StatelessWidget {
  final List<PartnerOrder>? orders;
  final PartnerUser? user;
  final Future<void> Function()? onRefresh;

  const PartnerPayoutsScreen({
    super.key,
    this.orders,
    this.user,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) {
        final cubit = PayoutsCubit();
        if (orders != null) {
          cubit.loadPayouts(existingOrders: orders);
        } else {
          final ordersState = ctx.read<OrdersCubit?>()?.state;
          if (ordersState is OrdersLoaded) {
            cubit.loadPayouts(existingOrders: ordersState.orders);
          } else {
            cubit.loadPayouts();
          }
        }
        return cubit;
      },
      child: _PayoutsView(onRefresh: onRefresh),
    );
  }
}

class _PayoutsView extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const _PayoutsView({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayoutsCubit, PayoutsState>(
      builder: (context, state) {
        if (state is PayoutsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is PayoutsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 12),
                Text(
                  state.error,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<PayoutsCubit>().loadPayouts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is PayoutsLoaded) {
          final completedOrders = state.completedOrders;

          return RefreshIndicator(
            onRefresh: () async {
              final cubit = context.read<PayoutsCubit>();
              if (onRefresh != null) {
                await onRefresh!();
              }
              await cubit.loadPayouts();
            },

            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Float & Wallet Balance Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'STORE FLOAT & WALLET',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          Icon(Icons.account_balance_wallet, color: Colors.white70, size: 18),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CurrencyFormatter.format(state.floatBalance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Total Disbursed: ${CurrencyFormatter.format(state.totalDisbursed)} • Instant IMPS',
                        style: const TextStyle(
                          color: Color(0xFF60A5FA),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Disbursed Payout History',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Automated IMPS',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (completedOrders.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.history_outlined, size: 40, color: AppColors.textSecondary),
                          SizedBox(height: 8),
                          Text(
                            'No completed payouts recorded yet.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...completedOrders.map(
                    (o) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CurrencyFormatter.format(o.finalPrice),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${o.orderNumber} • ${o.customerName}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, color: AppColors.success, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'IMPS Paid',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

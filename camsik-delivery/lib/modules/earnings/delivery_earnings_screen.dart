import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import 'bloc/earnings_cubit.dart';
import 'bloc/earnings_state.dart';

class DeliveryEarningsScreen extends StatelessWidget {
  const DeliveryEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      builder: (context, state) {
        final earningsCubit = context.read<EarningsCubit>();
        final isLoading = state is EarningsLoading;
        final isLoaded = state is EarningsLoaded;
        final completed = isLoaded ? state.completedTasks : const [];
        final totalEarnings = isLoaded ? state.totalEarnings : 0.0;

        return RefreshIndicator(
          onRefresh: () => earningsCubit.loadEarnings(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DELIVERY AGENT WALLET',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormatter.format(totalEarnings),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rate: ₹250 flat incentive per verified doorstep run',
                      style: TextStyle(color: Color(0xFFFCD34D), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Completed Trip Run Logs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 10),
              if (isLoading && completed.isEmpty)
                const Center(child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ))
              else if (completed.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: const Center(
                    child: Text(
                      'Complete doorstep pickups or deliveries to see fee logs.',
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                  ),
                )
              else
                ...completed.map(
                  (t) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '+${CurrencyFormatter.format(250)} Fee Earned',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${t.orderNumber} • ${t.deviceName}',
                              style: const TextStyle(color: Colors.black54, fontSize: 11),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Verified',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

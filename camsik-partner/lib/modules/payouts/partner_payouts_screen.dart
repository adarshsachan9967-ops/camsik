import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
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
      child: _PayoutsView(onRefresh: onRefresh, user: user),
    );
  }
}

class _PayoutsView extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final PartnerUser? user;

  const _PayoutsView({this.onRefresh, this.user});

  void _showWithdrawModal(
    BuildContext context,
    PayoutsLoaded state,
    double balance,
  ) {
    final bankName = state.wallet?.bankName ?? user?.bankName ?? 'HDFC Bank';
    final accNum = state.wallet?.accountNumber ?? user?.accountNumber ?? '•••• 4892';
    final ifsc = state.wallet?.ifscCode ?? user?.ifscCode ?? 'HDFC0001234';
    final isVerified = state.wallet?.isVerified ?? user?.isBankVerified ?? true;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Request Float Withdrawal',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 0.6.h),
              Text(
                'Available Float Balance: ${CurrencyFormatter.format(balance)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.5.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_rounded,
                        color: AppColors.primary, size: 22),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$bankName $accNum',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'IFSC: $ifsc • ${isVerified ? "Verified Merchant Account" : "Registered Account"}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.5.h),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await context.read<PayoutsCubit>().requestWithdrawal(
                          balance,
                          bankName: bankName,
                          accountNumber: accNum,
                          ifscCode: ifsc,
                        );
                  },
                  child: Text(
                    'Confirm Transfer to Bank',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayoutsCubit, PayoutsState>(
      listener: (context, state) {
        if (state is PayoutsLoaded) {
          if (state.actionMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Text(
                  state.actionMessage!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else if (state.actionError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Text(
                  state.actionError!,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        if (state is PayoutsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is PayoutsFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 44,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    state.error,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => context.read<PayoutsCubit>().loadPayouts(),
                    child: Text(
                      'Retry',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PayoutsLoaded) {
          final completedOrders = state.completedOrders;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              final cubit = context.read<PayoutsCubit>();
              if (onRefresh != null) {
                await onRefresh!();
              }
              await cubit.loadPayouts();
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              children: [
                // Store Float & Wallet Card
                Container(
                  padding: EdgeInsets.all(5.w > 22 ? 22 : 5.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFF334155)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Color(0xFF60A5FA),
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'STORE FLOAT & WALLET',
                                style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _showWithdrawModal(
                              context,
                              state,
                              state.floatBalance,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.primary,
                                ),
                              ),
                              child: Text(
                                'Withdraw Float',
                                style: TextStyle(
                                  color: const Color(0xFF93C5FD),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      Text(
                        CurrencyFormatter.format(state.floatBalance),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 0.6.h),
                      Text(
                        'Total Disbursed: ${CurrencyFormatter.format(state.totalDisbursed)} • Instant 24x7 IMPS',
                        style: TextStyle(
                          color: const Color(0xFF34D399),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.5.h),

                // Financial Overview Mini-grid
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3.5.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Disbursed Units',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 0.4.h),
                            Text(
                              '${completedOrders.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3.5.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settlement SLA',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 0.4.h),
                            Text(
                              '< 30 Seconds',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: const Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.5.h),

                // Header: Disbursed History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Disbursed Payout History',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Live Bank UTR',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),

                if (completedOrders.isEmpty)
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.history_rounded,
                            size: 40,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'No completed payouts recorded yet.',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...completedOrders.map((o) => _buildPayoutTile(context, o)),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPayoutTile(BuildContext context, PartnerOrder o) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CurrencyFormatter.format(o.finalPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16.sp,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    '${o.orderNumber} • ${o.customerName}',
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 2.5.w,
              vertical: 0.5.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  'IMPS Paid',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

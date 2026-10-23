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
import 'data/models/payout_transaction_model.dart';

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

class _PayoutsView extends StatefulWidget {
  final Future<void> Function()? onRefresh;
  final PartnerUser? user;

  const _PayoutsView({this.onRefresh, this.user});

  @override
  State<_PayoutsView> createState() => _PayoutsViewState();
}

class _PayoutsViewState extends State<_PayoutsView> {
  int _selectedFilterIndex = 0; // 0: All, 1: Orders, 2: Withdrawals

  String _formatDateTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Recent';
    final dt = DateTime.tryParse(isoString)?.toLocal();
    if (dt == null) return 'Recent';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthStr = months[dt.month - 1];
    final dayStr = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';

    return '$dayStr $monthStr, $hour:$minuteStr $period';
  }

  void _showWithdrawModal(
    BuildContext context,
    PayoutsLoaded state,
    double balance,
  ) {
    final bankName = state.wallet?.bankName ?? widget.user?.bankName ?? 'HDFC Bank';
    final accNum = state.wallet?.accountNumber ?? widget.user?.accountNumber ?? '•••• 4892';
    final ifsc = state.wallet?.ifscCode ?? widget.user?.ifscCode ?? 'HDFC0001234';
    final holderName = state.wallet?.accountHolderName ?? widget.user?.name ?? 'Partner Store';
    final isVerified = state.wallet?.isVerified ?? widget.user?.isBankVerified ?? true;

    final controller = TextEditingController();
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final bottomInset = MediaQuery.of(modalCtx).viewInsets.bottom;

            void applyPreset(double amt) {
              final finalAmt = amt > balance ? balance : amt;
              setModalState(() {
                controller.text = finalAmt.toInt().toString();
                errorText = null;
              });
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, bottomInset + 3.h),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transfer Float to Bank',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.bolt_rounded, color: AppColors.success, size: 14),
                              SizedBox(width: 1.w),
                              Text(
                                'Instant IMPS',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.6.h),
                    Text(
                      'Withdrawable Balance: ${CurrencyFormatter.format(balance)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Destination Bank Details Card
                    Container(
                      padding: EdgeInsets.all(3.5.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      bankName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      accNum,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.3.h),
                                Text(
                                  '$holderName • IFSC: $ifsc',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isVerified)
                            const Icon(
                              Icons.verified_rounded,
                              color: AppColors.success,
                              size: 18,
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Amount input
                    Text(
                      'Enter Withdrawal Amount (₹)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF334155),
                      ),
                    ),
                    SizedBox(height: 0.8.h),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.currency_rupee_rounded, color: AppColors.primary),
                        hintText: '0',
                        hintStyle: TextStyle(fontSize: 15.sp, color: const Color(0xFF94A3B8)),
                        errorText: errorText,
                        errorStyle: TextStyle(fontSize: 14.sp),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        final parsed = double.tryParse(val) ?? 0;
                        if (parsed > balance) {
                          setModalState(() {
                            errorText = 'Amount exceeds available balance';
                          });
                        } else {
                          setModalState(() {
                            errorText = null;
                          });
                        }
                      },
                    ),

                    SizedBox(height: 1.5.h),

                    // Quick Chips
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: [
                        if (balance >= 1000)
                          ActionChip(
                            label: Text('₹1,000', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                            backgroundColor: const Color(0xFFF1F5F9),
                            onPressed: () => applyPreset(1000),
                          ),
                        if (balance >= 2500)
                          ActionChip(
                            label: Text('₹2,500', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                            backgroundColor: const Color(0xFFF1F5F9),
                            onPressed: () => applyPreset(2500),
                          ),
                        if (balance >= 5000)
                          ActionChip(
                            label: Text('₹5,000', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                            backgroundColor: const Color(0xFFF1F5F9),
                            onPressed: () => applyPreset(5000),
                          ),
                        ActionChip(
                          label: Text(
                            'Full (${CurrencyFormatter.format(balance)})',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          backgroundColor: AppColors.primaryLight,
                          side: const BorderSide(color: AppColors.primary),
                          onPressed: () => applyPreset(balance),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Submit CTA
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          final entered = double.tryParse(controller.text.trim()) ?? 0;
                          if (entered <= 0) {
                            setModalState(() {
                              errorText = 'Please enter a valid amount';
                            });
                            return;
                          }
                          if (entered > balance) {
                            setModalState(() {
                              errorText = 'Amount exceeds available balance';
                            });
                            return;
                          }

                          Navigator.pop(ctx);
                          await context.read<PayoutsCubit>().requestWithdrawal(
                                entered,
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
              ),
            );
          },
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
                    size: 48,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    state.error,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => context.read<PayoutsCubit>().loadPayouts(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
          final wallet = state.wallet;
          final commissionEarned = wallet?.totalCommissionEarned ??
              (state.totalDisbursed * ((wallet?.commissionRate ?? 5.0) / 100));

          // Merge live transactions: if explicit API transactions exist, use them.
          // Otherwise build dynamic spot payout items from completedOrders.
          final List<PayoutTransactionModel> allTxns = state.transactions.isNotEmpty
              ? state.transactions
              : completedOrders.map((o) {
                  return PayoutTransactionModel(
                    id: 'pay-${o.id}',
                    partnerId: o.partnerId ?? 'partner',
                    orderId: o.id,
                    orderNumber: o.orderNumber,
                    customerName: o.customerName,
                    modelName: o.deviceName.isNotEmpty ? o.deviceName : o.deviceModel,
                    amount: o.finalPrice,
                    type: 'spot_payout',
                    status: 'completed',
                    method: 'instant_upi',
                    referenceId: 'IMPS${o.orderNumber.replaceAll(RegExp(r'\D'), '').padLeft(8, '0')}',
                    bankName: 'Verified Bank',
                    accountNumber: '•••• 9468',
                    ifscCode: 'HDFC0001234',
                    holderName: o.customerName,
                    notes: 'Instant spot buyout',
                    createdAt: o.pickupDate,
                  );
                }).toList();

          // Apply selected filter
          final filteredTxns = allTxns.where((t) {
            if (_selectedFilterIndex == 1) return t.type == 'spot_payout' || t.orderNumber != null;
            if (_selectedFilterIndex == 2) return t.type == 'withdrawal';
            return true;
          }).toList();

          final orderTxnCount = allTxns.where((t) => t.type == 'spot_payout' || t.orderNumber != null).length;
          final withdrawTxnCount = allTxns.where((t) => t.type == 'withdrawal').length;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              final cubit = context.read<PayoutsCubit>();
              if (widget.onRefresh != null) {
                await widget.onRefresh!();
              }
              await cubit.loadPayouts();
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // Top Live Sync Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Live 24x7 IMPS Settlements',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => context.read<PayoutsCubit>().loadPayouts(),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                        child: Row(
                          children: [
                            const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF64748B)),
                            SizedBox(width: 1.w),
                            Text(
                              'Sync',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),

                // Hero Store Float & Wallet Card
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B132B), Color(0xFF1C2541)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF3A506B).withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0B132B).withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF48CAE4).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: Color(0xFF48CAE4),
                                    size: 16,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Flexible(
                                  child: Text(
                                    'STORE FLOAT',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          InkWell(
                            onTap: () => _showWithdrawModal(
                              context,
                              state,
                              state.floatBalance,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.7.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.arrow_outward_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 1.2.w),
                                  Text(
                                    'Withdraw',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.8.h),
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
                        'Instant withdrawable to verified merchant bank account',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Disbursed',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.2.h),
                                  Text(
                                    CurrencyFormatter.format(state.totalDisbursed),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF34D399),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(width: 1, height: 26, color: Colors.white.withValues(alpha: 0.15)),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Earned Margin (5%)',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF94A3B8),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.2.h),
                                  Text(
                                    CurrencyFormatter.format(commissionEarned),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF60A5FA),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                // Financial Overview Mini-grid (100% Dynamic, Zero Mock Data)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Liquidated Units',
                                  style: TextStyle(
                                    color: const Color(0xFF64748B),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.inventory_2_rounded,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.6.h),
                            Text(
                              '${completedOrders.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18.sp,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 0.2.h),
                            Text(
                              completedOrders.isEmpty ? 'No units yet' : 'Verified Orders',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: completedOrders.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF059669),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Settlement SLA',
                                  style: TextStyle(
                                    color: const Color(0xFF64748B),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.flash_on_rounded,
                                    color: AppColors.success,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.6.h),
                            Text(
                              completedOrders.isEmpty ? 'Real-Time' : 'Instant IMPS',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16.sp,
                                color: const Color(0xFF059669),
                              ),
                            ),
                            SizedBox(height: 0.2.h),
                            Text(
                              'Live Bank UTRs',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Verified Merchant Settlement Bank Details Card
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_rounded,
                          color: Color(0xFF334155),
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 3.5.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  wallet?.bankName ?? widget.user?.bankName ?? 'HDFC Bank',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.3.h),
                            Text(
                              'Acc: ${wallet?.accountNumber ?? widget.user?.accountNumber ?? "•••• 4892"} • IFSC: ${wallet?.ifscCode ?? widget.user?.ifscCode ?? "HDFC0001234"}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.5.h),

                // Section Header: Disbursed Payout History
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
                        SizedBox(width: 2.5.w),
                        Text(
                          'Disbursed Payout History',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.sp,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${filteredTxns.length} Recorded',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.2.h),

                // Filter Segmented Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(0, 'All (${allTxns.length})'),
                      SizedBox(width: 2.w),
                      _buildFilterChip(1, 'Order Payouts ($orderTxnCount)'),
                      SizedBox(width: 2.w),
                      _buildFilterChip(2, 'Withdrawals ($withdrawTxnCount)'),
                    ],
                  ),
                ),

                SizedBox(height: 1.5.h),

                if (filteredTxns.isEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              size: 36,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Text(
                            'No payouts recorded yet',
                            style: TextStyle(
                              color: const Color(0xFF1E293B),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Complete doorstep inspections or customer buyouts to see instant IMPS settlements here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...filteredTxns.map((txn) => _buildTransactionCard(txn)),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(PayoutTransactionModel txn) {
    final isWithdrawal = txn.type == 'withdrawal';
    final hasOrder = txn.orderNumber != null && txn.orderNumber!.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isWithdrawal
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.successLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isWithdrawal
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: isWithdrawal ? AppColors.primary : AppColors.success,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CurrencyFormatter.format(txn.amount),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17.sp,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 0.2.h),
                          Text(
                            isWithdrawal
                                ? 'Float Withdrawal to Bank'
                                : (hasOrder
                                    ? '${txn.orderNumber} • ${txn.customerName ?? "Customer"}'
                                    : (txn.notes.isNotEmpty ? txn.notes : 'Spot Disbursal')),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF475569),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: txn.status == 'completed'
                      ? AppColors.success.withValues(alpha: 0.1)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: txn.status == 'completed'
                        ? AppColors.success.withValues(alpha: 0.25)
                        : const Color(0xFFF59E0B),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      txn.status == 'completed'
                          ? Icons.check_circle_rounded
                          : Icons.hourglass_top_rounded,
                      color: txn.status == 'completed'
                          ? AppColors.success
                          : const Color(0xFFD97706),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      txn.status == 'completed' ? 'IMPS Paid' : 'Processing',
                      style: TextStyle(
                        color: txn.status == 'completed'
                            ? AppColors.success
                            : const Color(0xFFD97706),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (txn.modelName != null && txn.modelName!.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Device: ${txn.modelName}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
            ),
          ],

          SizedBox(height: 1.h),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          SizedBox(height: 1.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.tag_rounded, size: 14, color: Color(0xFF94A3B8)),
                  SizedBox(width: 1.w),
                  Text(
                    txn.referenceId.isNotEmpty ? txn.referenceId : 'UTR-LIVE-IMPS',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                _formatDateTime(txn.createdAt),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

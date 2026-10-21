import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/partner_models.dart';
import '../orders/bloc/orders_cubit.dart';
import '../orders/bloc/orders_state.dart';
import 'bloc/inspection_cubit.dart';
import 'bloc/inspection_state.dart';

class PartnerInspectionScreen extends StatelessWidget {
  final List<PartnerOrder>? orders;
  final Future<void> Function()? onOrderUpdated;

  const PartnerInspectionScreen({
    super.key,
    this.orders,
    this.onOrderUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (orders != null) {
      return _buildInspectionBody(context, orders!);
    }

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, ordersState) {
        if (ordersState is OrdersLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final liveOrders =
            ordersState is OrdersLoaded ? ordersState.orders : <PartnerOrder>[];
        return _buildInspectionBody(context, liveOrders);
      },
    );
  }

  Widget _buildInspectionBody(
    BuildContext context,
    List<PartnerOrder> availableOrders,
  ) {
    final pendingOrders =
        availableOrders.where((o) => o.status != 'completed').toList();
    final inspectionOrders =
        pendingOrders.isNotEmpty ? pendingOrders : availableOrders;

    if (inspectionOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  size: 44,
                  color: Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'No orders ready for QA inspection',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 0.8.h),
              Text(
                'Assigned doorstep and hub intake devices will appear here.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => InspectionCubit(initialOrder: inspectionOrders.first),
      child: _InspectionForm(
        orders: inspectionOrders,
        onOrderUpdated: () async {
          if (onOrderUpdated != null) {
            await onOrderUpdated!();
          } else {
            context.read<OrdersCubit>().loadOrders();
          }
        },
      ),
    );
  }
}

class _InspectionForm extends StatefulWidget {
  final List<PartnerOrder> orders;
  final Future<void> Function() onOrderUpdated;

  const _InspectionForm({
    required this.orders,
    required this.onOrderUpdated,
  });

  @override
  State<_InspectionForm> createState() => _InspectionFormState();
}

class _InspectionFormState extends State<_InspectionForm> {
  final TextEditingController _imeiController = TextEditingController();

  @override
  void dispose() {
    _imeiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InspectionCubit, InspectionState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Text(
                state.successMessage!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
            ),
          );
          if (state.successMessage!.contains('QA Completed')) {
            widget.onOrderUpdated();
          }
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Text(
                state.errorMessage!,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<InspectionCubit>();
        final selected = state.selectedOrder ?? widget.orders.first;
        final finalPrice = state.adjustedPrice;
        final score = state.inspectionScore;

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          children: [
            // Select Order Dropdown Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PartnerOrder>(
                  value: widget.orders.any((o) => o.id == selected.id)
                      ? widget.orders.firstWhere((o) => o.id == selected.id)
                      : widget.orders.first,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),
                  items: widget.orders.map((o) {
                    return DropdownMenuItem(
                      value: o,
                      child: Text(
                        '${o.orderNumber} - ${o.deviceName}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      cubit.selectOrder(val);
                      _imeiController.clear();
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Live Valuation & 45-Point QA Score Card
            Container(
              padding: EdgeInsets.all(4.5.w),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF334155)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '45-POINT QA SCORE',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$score',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '/100',
                                style: TextStyle(
                                  color: const Color(0xFF64748B),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'FINAL RE-VALUATION',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            CurrencyFormatter.format(finalPrice),
                            style: TextStyle(
                              color: const Color(0xFF34D399),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // Progress Bar for Quality Score
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        score >= 80
                            ? const Color(0xFF10B981)
                            : (score >= 50
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFFEF4444)),
                      ),
                    ),
                  ),

                  SizedBox(height: 1.2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Device Grade: ${score >= 90 ? "Grade A+ (Pristine)" : score >= 75 ? "Grade A (Minor wear)" : "Grade B (Fair)"}',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Initial: ${CurrencyFormatter.format(selected.quotedPrice)}',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // GSMA IMEI Verification Card
            _buildImeiCard(context, state, cubit),

            SizedBox(height: 2.5.h),

            // Header for Diagnostics Checklist
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Hardware Diagnostic Checklist',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.2.h),

            _buildCheckTile(
              'Original OEM Display / Glass',
              'No lines, dead pixels, or third-party replacement',
              Icons.screen_lock_portrait_rounded,
              state.screenOriginal,
              (v) => cubit.toggleScreenOriginal(v),
            ),
            _buildCheckTile(
              'Touchscreen & Multi-Touch Response',
              'Zero touch ghosting, complete edge-to-edge response',
              Icons.touch_app_rounded,
              state.touchPerfect,
              (v) => cubit.toggleTouchPerfect(v),
            ),
            _buildCheckTile(
              'Battery Health (> 85% / Cycle Count)',
              'Holds peak power voltage under stress test',
              Icons.battery_charging_full_rounded,
              state.batteryHealthy,
              (v) => cubit.toggleBatteryHealthy(v),
            ),
            _buildCheckTile(
              'Camera Optics / Sensor Glass',
              'Zero lens fungus, sensor spots, or scratch haze',
              Icons.camera_alt_rounded,
              state.cameraClean,
              (v) => cubit.toggleCameraClean(v),
            ),
            _buildCheckTile(
              'Shutter Actuations (< 50k count)',
              'Mechanical shutter motor within safe lifespan',
              Icons.shutter_speed_rounded,
              state.shutterLow,
              (v) => cubit.toggleShutterLow(v),
            ),
            _buildCheckTile(
              'Motherboard & Wi-Fi / Bluetooth',
              'No water damage indicator trigger or trace repairs',
              Icons.memory_rounded,
              state.motherboardClean,
              (v) => cubit.toggleMotherboardClean(v),
            ),

            SizedBox(height: 2.5.h),

            // Submit Button
            Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.successGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: state.isSubmitting ? null : () => cubit.submitQA(),
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified_rounded, size: 20),
                          SizedBox(width: 2.w),
                          Text(
                            'Submit Certified QA (${CurrencyFormatter.format(finalPrice)})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        );
      },
    );
  }

  Widget _buildImeiCard(
    BuildContext context,
    InspectionState state,
    InspectionCubit cubit,
  ) {
    final report = state.verificationReport;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                  const Icon(
                    Icons.security_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'GSMA & Device IMEI Diagnostic',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 0.4.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Official GSMA',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _imeiController,
                  keyboardType: TextInputType.number,
                  maxLength: 15,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Enter 15-digit IMEI number',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.5.w,
                      vertical: 1.2.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.5.w),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.4.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: state.isVerifyingImei
                    ? null
                    : () => cubit.verifyDeviceImei(_imeiController.text),
                child: state.isVerifyingImei
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Verify',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5.sp,
                        ),
                      ),
              ),
            ],
          ),
          if (report != null) ...[
            SizedBox(height: 1.2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: report.blacklisted
                    ? AppColors.errorLight
                    : AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: report.blacklisted
                      ? AppColors.error.withValues(alpha: 0.3)
                      : AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    report.blacklisted
                        ? Icons.warning_amber_rounded
                        : Icons.verified_rounded,
                    size: 18,
                    color: report.blacklisted
                        ? AppColors.error
                        : AppColors.success,
                  ),
                  SizedBox(width: 2.5.w),
                  Expanded(
                    child: Text(
                      'GSMA: ${report.status} • Model: ${report.brand} ${report.model}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: report.blacklisted
                            ? AppColors.error
                            : AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? AppColors.success.withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: SwitchListTile(
        activeTrackColor: AppColors.success,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: value
                ? AppColors.success.withValues(alpha: 0.1)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: value ? AppColors.success : const Color(0xFF64748B),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 14.sp,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

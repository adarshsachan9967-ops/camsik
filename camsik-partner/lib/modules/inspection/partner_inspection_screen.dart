import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

        final liveOrders = ordersState is OrdersLoaded ? ordersState.orders : <PartnerOrder>[];
        return _buildInspectionBody(context, liveOrders);
      },
    );
  }

  Widget _buildInspectionBody(BuildContext context, List<PartnerOrder> availableOrders) {
    final pendingOrders = availableOrders.where((o) => o.status != 'completed').toList();
    final inspectionOrders = pendingOrders.isNotEmpty ? pendingOrders : availableOrders;

    if (inspectionOrders.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fact_check_outlined, size: 54, color: AppColors.textSecondary),
              SizedBox(height: 12),
              Text(
                'No orders ready for QA inspection',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Assigned doorstep and hub intake devices will appear here.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
              content: Text(state.successMessage!),
            ),
          );
          if (state.successMessage!.contains('QA Completed')) {
            widget.onOrderUpdated();
          }
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(state.errorMessage!),
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
          padding: const EdgeInsets.all(16),
          children: [
            // Select Order Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PartnerOrder>(
                  value: widget.orders.any((o) => o.id == selected.id)
                      ? widget.orders.firstWhere((o) => o.id == selected.id)
                      : widget.orders.first,
                  isExpanded: true,
                  items: widget.orders.map((o) {
                    return DropdownMenuItem(
                      value: o,
                      child: Text(
                        '${o.orderNumber} - ${o.deviceName}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
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

            const SizedBox(height: 16),

            // Live Valuation Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '45-POINT QA SCORE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$score / 100',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'FINAL RE-VALUATION',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(finalPrice),
                        style: const TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // GSMA IMEI Verification Card
            _buildImeiCard(context, state, cubit),

            const SizedBox(height: 20),
            const Text(
              'Hardware Diagnostic Checklist',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            _buildCheckTile(
              'Original OEM Display / Glass',
              'No lines, spots, or third-party replacement',
              state.screenOriginal,
              (v) => cubit.toggleScreenOriginal(v),
            ),
            _buildCheckTile(
              'Touchscreen & Multi-Touch Response',
              'Zero touch ghosting or dead zones',
              state.touchPerfect,
              (v) => cubit.toggleTouchPerfect(v),
            ),
            _buildCheckTile(
              'Battery Health (> 85% / Cycle Count)',
              'Holds peak operational performance',
              state.batteryHealthy,
              (v) => cubit.toggleBatteryHealthy(v),
            ),
            _buildCheckTile(
              'Camera Optics / Sensor Glass',
              'Zero fungus, scratches, or sensor dust',
              state.cameraClean,
              (v) => cubit.toggleCameraClean(v),
            ),
            _buildCheckTile(
              'Shutter Actuations (< 50k count)',
              'Mechanical shutter within safe lifecycle',
              state.shutterLow,
              (v) => cubit.toggleShutterLow(v),
            ),
            _buildCheckTile(
              'Motherboard, IC & Wi-Fi / Bluetooth',
              'No liquid intrusion or motherboard repair history',
              state.motherboardClean,
              (v) => cubit.toggleMotherboardClean(v),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: state.isSubmitting ? null : () => cubit.submitQA(),
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Submit Certified QA Report (${CurrencyFormatter.format(finalPrice)})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImeiCard(BuildContext context, InspectionState state, InspectionCubit cubit) {
    final report = state.verificationReport;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live GSMA & IMEI Diagnostic',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(Icons.security, size: 16, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _imeiController,
                  keyboardType: TextInputType.number,
                  maxLength: 15,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Enter 15-digit IMEI number',
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: state.isVerifyingImei
                    ? null
                    : () => cubit.verifyDeviceImei(_imeiController.text),
                child: state.isVerifyingImei
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          if (report != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: report.blacklisted
                    ? AppColors.errorLight
                    : AppColors.successLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    report.blacklisted ? Icons.warning_amber : Icons.verified,
                    size: 16,
                    color: report.blacklisted ? AppColors.error : AppColors.success,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'GSMA: ${report.status} • Brand & Model Verified: ${report.brand} ${report.model}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: report.blacklisted ? AppColors.error : AppColors.success,
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
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: SwitchListTile(
        activeTrackColor: AppColors.success,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

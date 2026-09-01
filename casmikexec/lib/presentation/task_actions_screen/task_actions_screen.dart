import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import './widgets/action_step_indicator_widget.dart';
import './widgets/device_condition_widget.dart';
import './widgets/otp_input_widget.dart';
import './widgets/proof_of_delivery_widget.dart';

class TaskActionsScreen extends StatefulWidget {
  final String orderId;
  const TaskActionsScreen({super.key, required this.orderId});

  @override
  State<TaskActionsScreen> createState() => _TaskActionsScreenState();
}

class _TaskActionsScreenState extends State<TaskActionsScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production
  int _currentStep = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Start Trip',
      'subtitle': 'Begin navigation to pickup location',
      'icon': Icons.directions_bike_rounded,
      'actionLabel': 'Start Trip Now',
    },
    {
      'title': 'Mark Arrived',
      'subtitle': 'Confirm you have reached the location',
      'icon': Icons.location_on_rounded,
      'actionLabel': 'I Have Arrived',
    },
    {
      'title': 'OTP Verification',
      'subtitle': 'Enter the OTP shared by the customer',
      'icon': Icons.lock_open_rounded,
      'actionLabel': 'Verify OTP',
    },
    {
      'title': 'Pickup Confirmed',
      'subtitle': 'Capture device condition and photos',
      'icon': Icons.check_circle_outline_rounded,
      'actionLabel': 'Confirm Pickup',
    },
    {
      'title': 'In Transit',
      'subtitle': 'Navigate to delivery destination',
      'icon': Icons.local_shipping_rounded,
      'actionLabel': 'Start Delivery',
    },
    {
      'title': 'Delivered',
      'subtitle': 'Submit proof of delivery',
      'icon': Icons.task_alt_rounded,
      'actionLabel': 'Complete Delivery',
    },
  ];

  String _otpValue = '';
  bool _showDeviceCondition = false;
  bool _showProofOfDelivery = false;

  void _handleAction() async {
    if (_currentStep == 2 && _otpValue.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete 6-digit OTP')),
      );
      return;
    }

    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);

    if (_currentStep == 3) {
      setState(() => _showDeviceCondition = true);
      return;
    }

    if (_currentStep == 5) {
      setState(() => _showProofOfDelivery = true);
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _showDeviceCondition = false;
        _showProofOfDelivery = false;
      });
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final step = _steps[_currentStep];
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirm: ${step['title']}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          step['subtitle'] as String,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // AppBar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.orderId,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Task Actions',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withAlpha(204),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'Step ${_currentStep + 1}/${_steps.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActionStepIndicatorWidget(
                      steps: _steps,
                      currentStep: _currentStep,
                    ),
                    const SizedBox(height: 20),
                    // Current step card
                    _buildCurrentStepCard(),
                    const SizedBox(height: 16),
                    // OTP input for step 2
                    if (_currentStep == 2)
                      OtpInputWidget(
                        onOtpChanged: (otp) => setState(() => _otpValue = otp),
                      ),
                    // Device condition for step 3
                    if (_currentStep == 3 && _showDeviceCondition) ...[
                      const SizedBox(height: 16),
                      DeviceConditionWidget(
                        onSubmit: () {
                          setState(() {
                            _showDeviceCondition = false;
                            _currentStep = 4;
                          });
                        },
                      ),
                    ],
                    // Proof of delivery for step 5
                    if (_currentStep == 5 && _showProofOfDelivery) ...[
                      const SizedBox(height: 16),
                      ProofOfDeliveryWidget(
                        onSubmit: () {
                          context.pop();
                        },
                      ),
                    ],
                    // Failed pickup option
                    if (_currentStep <= 2) ...[
                      const SizedBox(height: 16),
                      _buildFailedPickupButton(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: (_showDeviceCondition || _showProofOfDelivery)
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleAction,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(_steps[_currentStep]['actionLabel'] as String),
                ),
              ),
            ),
    );
  }

  Widget _buildCurrentStepCard() {
    final step = _steps[_currentStep];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withAlpha(20),
            AppTheme.primary.withAlpha(8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withAlpha(64)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              step['icon'] as IconData,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Step',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step['title'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step['subtitle'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedPickupButton() {
    return GestureDetector(
      onTap: () => _showFailedPickupSheet(),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.error.withAlpha(13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.error.withAlpha(51)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: AppTheme.error, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Report Failed Pickup',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.error,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.error,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _showFailedPickupSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FailedPickupSheet(),
    );
  }
}

class _FailedPickupSheet extends StatefulWidget {
  @override
  State<_FailedPickupSheet> createState() => _FailedPickupSheetState();
}

class _FailedPickupSheetState extends State<_FailedPickupSheet> {
  String? _selectedReason;
  final _notesCtrl = TextEditingController();
  DateTime? _rescheduleDate;

  final _reasons = [
    'Customer Not Available',
    'Address Not Found',
    'Customer Refused',
    'Device Not Ready',
    'Other',
  ];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Report Failed Pickup',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select reason and optionally reschedule',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reason',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ..._reasons.map(
              (r) => GestureDetector(
                onTap: () => setState(() => _selectedReason = r),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedReason == r
                        ? AppTheme.error.withAlpha(20)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedReason == r
                          ? AppTheme.error.withAlpha(102)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedReason == r
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 18,
                        color: _selectedReason == r
                            ? AppTheme.error
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        r,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _selectedReason == r
                              ? AppTheme.error
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional Notes (optional)',
                hintText: 'Describe what happened...',
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 14)),
                );
                if (picked != null) setState(() => _rescheduleDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _rescheduleDate != null
                          ? 'Reschedule: ${_rescheduleDate!.day}/${_rescheduleDate!.month}/${_rescheduleDate!.year}'
                          : 'Select Reschedule Date (optional)',
                      style: TextStyle(
                        fontSize: 13,
                        color: _rescheduleDate != null
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedReason == null
                    ? null
                    : () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                  disabledBackgroundColor: AppTheme.textMuted,
                ),
                child: const Text('Submit Failed Report'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PendingApprovalWidget extends StatefulWidget {
  final VoidCallback onContactSupport;

  const PendingApprovalWidget({super.key, required this.onContactSupport});

  @override
  State<PendingApprovalWidget> createState() => _PendingApprovalWidgetState();
}

class _PendingApprovalWidgetState extends State<PendingApprovalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ScaleTransition(
          scale: _pulse,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppTheme.warning.withAlpha(31),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              size: 48,
              color: AppTheme.warning,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Application Under Review',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Your documents are being verified by our team. This usually takes 24–48 hours. You\'ll receive an SMS once approved.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _statusRow('Personal Info', true),
              const SizedBox(height: 8),
              _statusRow('Vehicle Details', true),
              const SizedBox(height: 8),
              _statusRow('Document Verification', false),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: widget.onContactSupport,
          icon: const Icon(Icons.headset_mic_outlined),
          label: const Text('Contact Support'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: BorderSide(color: AppTheme.primary),
            foregroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusRow(String label, bool done) {
    return Row(
      children: [
        Icon(
          done
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 20,
          color: done ? AppTheme.primary : AppTheme.warning,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: done ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          done ? 'Completed' : 'In Review',
          style: TextStyle(
            fontSize: 12,
            color: done ? AppTheme.primary : AppTheme.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

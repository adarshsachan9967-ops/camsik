import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case 'out_for_pickup':
      case 'assigned':
      case 'in_progress':
        bg = AppColors.accentLight;
        fg = AppColors.accent;
        break;
      case 'inspection_in_progress':
      case 'pending':
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;
      case 'cancelled':
      case 'rejected':
        bg = AppColors.errorLight;
        fg = AppColors.error;
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

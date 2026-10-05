import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class PartnerStatusBadge extends StatelessWidget {
  final String status;

  const PartnerStatusBadge({super.key, required this.status});

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'inspection_completed':
        return AppColors.success;
      case 'pickup_scheduled':
      case 'in_progress':
      case 'scheduled':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.error;
      case 'pending':
      default:
        return AppColors.warning;
    }
  }

  String _formatStatus() {
    return status.replaceAll('_', ' ').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _formatStatus(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

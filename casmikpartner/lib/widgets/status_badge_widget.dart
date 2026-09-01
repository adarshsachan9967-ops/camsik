import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String status;
  final double? fontSize;

  const StatusBadgeWidget({required this.status, this.fontSize, super.key});

  Color _bgColor() {
    switch (status.toLowerCase()) {
      case 'new':
      case 'new assignment':
        return AppTheme.statusNew.withAlpha(31);
      case 'pending':
        return AppTheme.statusPending.withAlpha(31);
      case 'accepted':
        return AppTheme.statusAccepted.withAlpha(31);
      case 'pickup':
        return AppTheme.statusPickup.withAlpha(31);
      case 'inspection':
        return AppTheme.statusInspection.withAlpha(31);
      case 'completed':
        return AppTheme.statusCompleted.withAlpha(31);
      case 'cancelled':
        return AppTheme.statusCancelled.withAlpha(31);
      case 'paid':
        return AppTheme.success.withAlpha(31);
      case 'processing':
        return AppTheme.warning.withAlpha(31);
      case 'verified':
        return AppTheme.success.withAlpha(31);
      case 'rejected':
        return AppTheme.error.withAlpha(31);
      default:
        return Colors.grey.withAlpha(31);
    }
  }

  Color _textColor() {
    switch (status.toLowerCase()) {
      case 'new':
      case 'new assignment':
        return AppTheme.statusNew;
      case 'pending':
        return AppTheme.statusPending;
      case 'accepted':
        return AppTheme.statusAccepted;
      case 'pickup':
        return AppTheme.statusPickup;
      case 'inspection':
        return AppTheme.statusInspection;
      case 'completed':
        return AppTheme.statusCompleted;
      case 'cancelled':
        return AppTheme.statusCancelled;
      case 'paid':
        return AppTheme.success;
      case 'processing':
        return AppTheme.warning;
      case 'verified':
        return AppTheme.success;
      case 'rejected':
        return AppTheme.error;
      default:
        return Colors.grey[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: fontSize ?? 11,
          fontWeight: FontWeight.w600,
          color: _textColor(),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

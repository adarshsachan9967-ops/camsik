import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TaskStatus {
  assigned,
  startTrip,
  arrived,
  pickupConfirmed,
  inTransit,
  delivered,
  failed,
  rescheduled,
  pending,
}

enum PriorityLevel { high, medium, low }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 11,
  });

  factory StatusBadgeWidget.fromStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.assigned:
        return StatusBadgeWidget(
          label: 'Assigned',
          backgroundColor: AppTheme.statusAssigned.withAlpha(38),
          textColor: AppTheme.statusAssigned,
        );
      case TaskStatus.startTrip:
        return StatusBadgeWidget(
          label: 'Start Trip',
          backgroundColor: AppTheme.primary.withAlpha(38),
          textColor: AppTheme.primary,
        );
      case TaskStatus.arrived:
        return StatusBadgeWidget(
          label: 'Arrived',
          backgroundColor: AppTheme.primary.withAlpha(38),
          textColor: AppTheme.primaryDark,
        );
      case TaskStatus.pickupConfirmed:
        return StatusBadgeWidget(
          label: 'Pickup Confirmed',
          backgroundColor: AppTheme.primary.withAlpha(38),
          textColor: AppTheme.primaryDark,
        );
      case TaskStatus.inTransit:
        return StatusBadgeWidget(
          label: 'In Transit',
          backgroundColor: AppTheme.statusInTransit.withAlpha(38),
          textColor: AppTheme.statusInTransit,
        );
      case TaskStatus.delivered:
        return StatusBadgeWidget(
          label: 'Delivered',
          backgroundColor: AppTheme.statusCompleted.withAlpha(38),
          textColor: AppTheme.statusCompleted,
        );
      case TaskStatus.failed:
        return StatusBadgeWidget(
          label: 'Failed',
          backgroundColor: AppTheme.statusFailed.withAlpha(38),
          textColor: AppTheme.statusFailed,
        );
      case TaskStatus.rescheduled:
        return StatusBadgeWidget(
          label: 'Rescheduled',
          backgroundColor: AppTheme.statusRescheduled.withAlpha(38),
          textColor: AppTheme.statusRescheduled,
        );
      case TaskStatus.pending:
        return StatusBadgeWidget(
          label: 'Pending',
          backgroundColor: AppTheme.textMuted.withAlpha(51),
          textColor: AppTheme.textSecondary,
        );
    }
  }

  factory StatusBadgeWidget.fromPriority(PriorityLevel priority) {
    switch (priority) {
      case PriorityLevel.high:
        return StatusBadgeWidget(
          label: 'High',
          backgroundColor: AppTheme.priorityHigh.withAlpha(38),
          textColor: AppTheme.priorityHigh,
        );
      case PriorityLevel.medium:
        return StatusBadgeWidget(
          label: 'Medium',
          backgroundColor: AppTheme.priorityMedium.withAlpha(38),
          textColor: AppTheme.priorityMedium,
        );
      case PriorityLevel.low:
        return StatusBadgeWidget(
          label: 'Low',
          backgroundColor: AppTheme.priorityLow.withAlpha(38),
          textColor: AppTheme.priorityLow,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

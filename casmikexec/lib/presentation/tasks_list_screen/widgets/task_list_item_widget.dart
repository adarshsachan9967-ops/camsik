import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../../../routes/app_routes.dart';

class TaskListItemWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onTap;

  const TaskListItemWidget({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = task['status'] as String;
    final priority = task['priority'] as String;
    final type = task['type'] as String;

    final priorityLevel = priority == 'high'
        ? PriorityLevel.high
        : priority == 'medium'
        ? PriorityLevel.medium
        : PriorityLevel.low;

    final taskStatus = status == 'assigned'
        ? TaskStatus.assigned
        : status == 'inTransit'
        ? TaskStatus.inTransit
        : status == 'delivered'
        ? TaskStatus.delivered
        : status == 'failed'
        ? TaskStatus.failed
        : TaskStatus.rescheduled;

    final priorityColor = priority == 'high'
        ? AppTheme.priorityHigh
        : priority == 'medium'
        ? AppTheme.priorityMedium
        : AppTheme.priorityLow;

    return Dismissible(
      key: Key(task['id'] as String),
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.navigation_rounded, color: AppTheme.primary),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.error.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.close_rounded, color: AppTheme.error),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          context.push(AppRoutes.taskActions, extra: task['id']);
          return false;
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: priorityColor, width: 3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task['id'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: type == 'pickup'
                            ? AppTheme.statusAssigned.withAlpha(26)
                            : AppTheme.statusCompleted.withAlpha(26),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        type == 'pickup' ? '↑ Pickup' : '↓ Delivery',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: type == 'pickup'
                              ? AppTheme.statusAssigned
                              : AppTheme.statusCompleted,
                        ),
                      ),
                    ),
                    const Spacer(),
                    StatusBadgeWidget.fromStatus(taskStatus),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['customerName'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${task['deviceBrand']} ${task['deviceModel']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  task['address'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusBadgeWidget.fromPriority(priorityLevel),
                        const SizedBox(height: 8),
                        Text(
                          (task['earnings'] as double) > 0
                              ? '₹${(task['earnings'] as double).toStringAsFixed(0)}'
                              : '—',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: (task['earnings'] as double) > 0
                                ? AppTheme.primary
                                : AppTheme.textMuted,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task['timeSlot'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      task['date'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

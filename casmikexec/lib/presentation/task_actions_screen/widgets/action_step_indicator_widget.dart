import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ActionStepIndicatorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> steps;
  final int currentStep;

  const ActionStepIndicatorWidget({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Task Progress',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(steps.length, (i) {
              final isDone = i < currentStep;
              final isActive = i == currentStep;
              final isLast = i == steps.length - 1;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isActive ? 28 : 22,
                            height: isActive ? 28 : 22,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppTheme.primary
                                  : isActive
                                  ? AppTheme.primary
                                  : AppTheme.surfaceLight,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDone || isActive
                                    ? AppTheme.primary
                                    : AppTheme.textMuted,
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isActive
                                            ? Colors.white
                                            : AppTheme.textMuted,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (steps[i]['title'] as String).split(' ').first,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: isActive
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isDone || isActive
                                  ? AppTheme.primary
                                  : AppTheme.textMuted,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: i < currentStep
                                ? AppTheme.primary
                                : AppTheme.textMuted.withAlpha(77),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

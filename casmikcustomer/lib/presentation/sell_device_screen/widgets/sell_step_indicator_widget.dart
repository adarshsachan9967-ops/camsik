import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SellStepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const SellStepIndicatorWidget({
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector line
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  color: isCompleted ? AppTheme.primary : AppTheme.borderLight,
                ),
              );
            } else {
              // Step circle
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              final isCurrent = stepIndex == currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isCurrent ? 28 : 24,
                height: isCurrent ? 28 : 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.primary
                      : isCurrent
                      ? AppTheme.primary
                      : AppTheme.borderLight,
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(
                          color: AppTheme.primary.withAlpha(77),
                          width: 3,
                        )
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 14,
                        )
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isCurrent
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (i) {
            final isCurrent = i == currentStep;
            return Text(
              labels[i],
              style: TextStyle(
                fontSize: 9,
                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                color: isCurrent ? AppTheme.primary : AppTheme.textMuted,
              ),
            );
          }),
        ),
      ],
    );
  }
}

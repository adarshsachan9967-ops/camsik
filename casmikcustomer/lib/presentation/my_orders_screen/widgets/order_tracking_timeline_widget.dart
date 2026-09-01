import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class OrderTrackingTimelineWidget extends StatelessWidget {
  final int currentStep;
  final String orderType;
  final String agentName;
  final String agentPhone;

  const OrderTrackingTimelineWidget({
    required this.currentStep,
    required this.orderType,
    required this.agentName,
    required this.agentPhone,
    super.key,
  });

  List<Map<String, String>> _getSteps() {
    if (orderType == 'Sell' || orderType == 'Exchange') {
      return [
        {'label': 'Pickup Scheduled', 'icon': 'calendar'},
        {'label': 'Agent Assigned', 'icon': 'person'},
        {'label': 'Agent En Route', 'icon': 'truck'},
        {'label': 'Device Picked Up', 'icon': 'check_circle'},
        {'label': 'Quality Check', 'icon': 'verified'},
        {'label': 'Price Confirmed', 'icon': 'tick'},
        {'label': 'Payment Initiated', 'icon': 'wallet'},
        {'label': 'Payment Processing', 'icon': 'timer'},
        {'label': 'Payment Sent', 'icon': 'check_circle'},
        {'label': 'Completed', 'icon': 'star'},
      ];
    } else if (orderType == 'Buy') {
      return [
        {'label': 'Order Placed', 'icon': 'cart_filled'},
        {'label': 'Payment Confirmed', 'icon': 'check_circle'},
        {'label': 'Quality Check', 'icon': 'verified'},
        {'label': 'Packed', 'icon': 'orders'},
        {'label': 'Handed to Courier', 'icon': 'truck'},
        {'label': 'In Transit', 'icon': 'truck'},
        {'label': 'Out for Delivery', 'icon': 'location'},
        {'label': 'Delivered', 'icon': 'check_circle'},
        {'label': 'Completed', 'icon': 'star'},
      ];
    } else {
      // Repair
      return [
        {'label': 'Repair Scheduled', 'icon': 'calendar'},
        {'label': 'Device Picked Up', 'icon': 'truck'},
        {'label': 'Diagnosis', 'icon': 'search'},
        {'label': 'Repair In Progress', 'icon': 'speed'},
        {'label': 'Quality Check', 'icon': 'verified'},
        {'label': 'Ready for Delivery', 'icon': 'check_circle'},
        {'label': 'Out for Delivery', 'icon': 'truck'},
        {'label': 'Delivered', 'icon': 'star'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Tracking',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          if (agentName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withAlpha(38),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.primary,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agentName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'CASMIK Agent',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Timeline steps
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isCompleted = i < currentStep;
            final isCurrent = i == currentStep;
            final isLast = i == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator column
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.primary
                            : isCurrent
                            ? AppTheme.primary.withAlpha(38)
                            : AppTheme.borderLight,
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(color: AppTheme.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 14,
                              )
                            : CustomIconWidget(
                                iconName: step['icon']!,
                                color: isCurrent
                                    ? AppTheme.primary
                                    : AppTheme.textMuted,
                                size: 14,
                              ),
                      ),
                    ),
                    if (!isLast)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 2,
                        height: 32,
                        color: isCompleted
                            ? AppTheme.primary
                            : AppTheme.borderLight,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 4),
                    child: Text(
                      step['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isCurrent
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isCompleted || isCurrent
                            ? AppTheme.textPrimary
                            : AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

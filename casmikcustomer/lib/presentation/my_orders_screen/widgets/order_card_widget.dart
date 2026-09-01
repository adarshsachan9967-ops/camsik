import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

// OrderCard anatomy: type badge + device image + device name + status + price + action
// Swipeable action (V4 ListItem) for quick cancel/support
class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isExpanded;
  final VoidCallback onTap;

  const OrderCardWidget({
    required this.order,
    required this.isExpanded,
    required this.onTap,
    super.key,
  });

  Color _typeColor(String type) {
    switch (type) {
      case 'Sell':
        return AppTheme.primary;
      case 'Buy':
        return AppTheme.info;
      case 'Exchange':
        return AppTheme.warning;
      case 'Repair':
        return AppTheme.error;
      default:
        return AppTheme.textSecondary;
    }
  }

  BadgeStyle _statusBadgeStyle(String status) {
    if (status == 'Completed') return BadgeStyle.success;
    if (status == 'Cancelled') return BadgeStyle.error;
    return BadgeStyle.info;
  }

  @override
  Widget build(BuildContext context) {
    final type = order['type'] as String;
    final status = order['status'] as String;
    final typeColor = _typeColor(type);

    return Dismissible(
      key: Key(order['id'] as String),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'support',
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(height: 4),
            const Text(
              'Support',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async => false,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isExpanded ? typeColor : AppTheme.borderLight,
              width: isExpanded ? 1.5 : 1,
            ),
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
            child: Row(
              children: [
                // Device image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(
                    imageUrl: order['imageUrl'] as String,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    semanticLabel: order['semanticLabel'] as String,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withAlpha(31),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: typeColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            order['date'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order['device'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          StatusBadgeWidget(
                            label: status,
                            style: _statusBadgeStyle(status),
                            fontSize: 10,
                          ),
                          const Spacer(),
                          Text(
                            order['price'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CustomIconWidget(
                  iconName: isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

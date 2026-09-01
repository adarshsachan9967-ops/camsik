import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ProfileMenuSectionWidget extends StatelessWidget {
  final String title;
  final List<dynamic> items;

  const ProfileMenuSectionWidget({
    required this.title,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              // Extract properties dynamically
              final String icon = item.icon as String;
              final String label = item.label as String;
              final String? subtitle = item.subtitle as String?;
              final Color color = item.color as Color;
              final VoidCallback onTap = item.onTap as VoidCallback;
              final Widget? trailing = item.trailing as Widget?;

              return Column(
                children: [
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(16) : Radius.zero,
                      bottom: isLast ? const Radius.circular(16) : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          // Icon container — gradient accent card style (Family D)
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withAlpha(26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: icon,
                                color: color,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                if (subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          trailing ??
                              CustomIconWidget(
                                iconName: 'chevron_right',
                                color: AppTheme.textMuted,
                                size: 18,
                              ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: 70, color: AppTheme.borderLight),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

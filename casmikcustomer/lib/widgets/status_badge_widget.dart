import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BadgeStyle { success, warning, error, info, neutral }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final BadgeStyle style;
  final double fontSize;

  const StatusBadgeWidget({
    required this.label,
    this.style = BadgeStyle.neutral,
    this.fontSize = 11,
    super.key,
  });

  Color _bgColor() {
    switch (style) {
      case BadgeStyle.success:
        return AppTheme.primary.withAlpha(31);
      case BadgeStyle.warning:
        return AppTheme.warning.withAlpha(31);
      case BadgeStyle.error:
        return AppTheme.error.withAlpha(31);
      case BadgeStyle.info:
        return AppTheme.info.withAlpha(31);
      case BadgeStyle.neutral:
        return AppTheme.backgroundLight;
    }
  }

  Color _textColor() {
    switch (style) {
      case BadgeStyle.success:
        return AppTheme.primary;
      case BadgeStyle.warning:
        return AppTheme.warning;
      case BadgeStyle.error:
        return AppTheme.error;
      case BadgeStyle.info:
        return AppTheme.info;
      case BadgeStyle.neutral:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: _textColor(),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class ConditionBadgeWidget extends StatelessWidget {
  final String condition; // 'Fair', 'Good', 'Superb'

  const ConditionBadgeWidget({required this.condition, super.key});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    switch (condition.toLowerCase()) {
      case 'fair':
        bg = AppTheme.conditionFair.withAlpha(31);
        text = AppTheme.conditionFair;
        break;
      case 'good':
        bg = AppTheme.conditionGood.withAlpha(31);
        text = AppTheme.conditionGood;
        break;
      case 'superb':
        bg = AppTheme.conditionSuperb.withAlpha(31);
        text = AppTheme.conditionSuperb;
        break;
      default:
        bg = AppTheme.backgroundLight;
        text = AppTheme.textSecondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        condition,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: text,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

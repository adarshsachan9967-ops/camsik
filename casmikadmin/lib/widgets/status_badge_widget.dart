import 'package:flutter/material.dart';

enum BadgeStatus {
  active,
  pending,
  completed,
  cancelled,
  suspended,
  blocked,
  approved,
  rejected,
  processing,
  inTransit,
}

class StatusBadgeWidget extends StatelessWidget {
  final BadgeStatus status;
  final String? customLabel;
  final double fontSize;

  const StatusBadgeWidget({
    required this.status,
    this.customLabel,
    this.fontSize = 11,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Text(
        customLabel ?? config.label,
        style: TextStyle(
          color: config.textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  _BadgeConfig _getConfig(BadgeStatus s) {
    switch (s) {
      case BadgeStatus.active:
        return _BadgeConfig(
          'Active',
          const Color(0xFF00C853),
          const Color(0xff00c85330),
          const Color(0xff00c85350),
        );
      case BadgeStatus.pending:
        return _BadgeConfig(
          'Pending',
          const Color(0xFFFF9800),
          const Color(0xffff980020),
          const Color(0xffff980040),
        );
      case BadgeStatus.completed:
        return _BadgeConfig(
          'Completed',
          const Color(0xFF2196F3),
          const Color(0xff2196f320),
          const Color(0xff2196f340),
        );
      case BadgeStatus.cancelled:
        return _BadgeConfig(
          'Cancelled',
          const Color(0xFFFF3B30),
          const Color(0xffff3b3020),
          const Color(0xffff3b3040),
        );
      case BadgeStatus.suspended:
        return _BadgeConfig(
          'Suspended',
          const Color(0xFFFF9800),
          const Color(0xffff980020),
          const Color(0xffff980040),
        );
      case BadgeStatus.blocked:
        return _BadgeConfig(
          'Blocked',
          const Color(0xFFFF3B30),
          const Color(0xffff3b3020),
          const Color(0xffff3b3040),
        );
      case BadgeStatus.approved:
        return _BadgeConfig(
          'Approved',
          const Color(0xFF00C853),
          const Color(0xff00c85320),
          const Color(0xff00c85340),
        );
      case BadgeStatus.rejected:
        return _BadgeConfig(
          'Rejected',
          const Color(0xFFFF3B30),
          const Color(0xffff3b3020),
          const Color(0xffff3b3040),
        );
      case BadgeStatus.processing:
        return _BadgeConfig(
          'Processing',
          const Color(0xFF9C27B0),
          const Color(0xff9c27b020),
          const Color(0xff9c27b040),
        );
      case BadgeStatus.inTransit:
        return _BadgeConfig(
          'In Transit',
          const Color(0xFF2196F3),
          const Color(0xff2196f320),
          const Color(0xff2196f340),
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  const _BadgeConfig(
    this.label,
    this.textColor,
    this.bgColor,
    this.borderColor,
  );
}

import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'completed':
        bg = const Color(0xFF10B981).withAlpha(25);
        fg = const Color(0xFF059669);
        break;
      case 'out_for_pickup':
      case 'assigned':
        bg = const Color(0xFF2563EB).withAlpha(25);
        fg = const Color(0xFF2563EB);
        break;
      case 'inspection_in_progress':
        bg = const Color(0xFFF59E0B).withAlpha(25);
        fg = const Color(0xFFD97706);
        break;
      case 'cancelled':
        bg = Colors.redAccent.withAlpha(25);
        fg = Colors.redAccent;
        break;
      default:
        bg = const Color(0xFF64748B).withAlpha(25);
        fg = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

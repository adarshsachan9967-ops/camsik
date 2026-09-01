import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class InfoRow {
  final String label;
  final String value;
  final bool isHighlight;
  InfoRow(this.label, this.value, {this.isHighlight = false});
}

class OrderInfoCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<InfoRow> rows;

  const OrderInfoCardWidget({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.rows,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 15, color: iconColor),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: const Color(0xFFF5F5F5)),
          ...rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            return Column(
              children: [
                if (i > 0) Divider(height: 1, color: const Color(0xFFF5F5F5)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          row.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row.value,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: row.isHighlight
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: row.isHighlight
                                ? AppTheme.primary
                                : AppTheme.textPrimary,
                            fontFeatures: row.isHighlight
                                ? const [FontFeature.tabularFigures()]
                                : null,
                          ),
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class InspectionImeiWidget extends StatelessWidget {
  final TextEditingController imeiCtrl;
  final TextEditingController serialCtrl;

  const InspectionImeiWidget({
    required this.imeiCtrl,
    required this.serialCtrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.info.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.perm_device_info_outlined,
                  size: 15,
                  color: AppTheme.info,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Device Identifiers',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FieldLabel('IMEI Number *'),
          const SizedBox(height: 6),
          TextFormField(
            controller: imeiCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: const InputDecoration(
              hintText: '15-digit IMEI number',
              prefixIcon: Icon(Icons.dialpad_rounded, size: 18),
              helperText: 'Dial *#06# on the device to find IMEI',
            ),
          ),
          const SizedBox(height: 12),
          _FieldLabel('Serial Number'),
          const SizedBox(height: 6),
          TextFormField(
            controller: serialCtrl,
            decoration: const InputDecoration(
              hintText: 'Device serial number',
              prefixIcon: Icon(Icons.tag_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class InspectionChecklistWidget extends StatelessWidget {
  final Map<String, String?> checklistState;
  final Function(String key, String value) onUpdate;

  const InspectionChecklistWidget({
    required this.checklistState,
    required this.onUpdate,
    super.key,
  });

  static const Map<String, IconData> _icons = {
    'Display': Icons.tv_outlined,
    'Touch Screen': Icons.touch_app_outlined,
    'Front Camera': Icons.camera_front_outlined,
    'Rear Camera': Icons.camera_rear_outlined,
    'Speaker': Icons.volume_up_outlined,
    'Microphone': Icons.mic_outlined,
    'Power Button': Icons.power_settings_new_rounded,
    'Volume Buttons': Icons.volume_down_outlined,
    'Charging Port': Icons.charging_station_outlined,
    'Face ID / Fingerprint': Icons.fingerprint_rounded,
    'Battery Health': Icons.battery_full_rounded,
    'Physical Condition': Icons.smartphone_outlined,
  };

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
                    color: AppTheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    size: 15,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '12-Point Inspection Checklist',
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
          ...checklistState.entries.toList().asMap().entries.map((mapEntry) {
            final i = mapEntry.key;
            final entry = mapEntry.value;
            final key = entry.key;
            final value = entry.value;
            final isLast = i == checklistState.length - 1;

            return Column(
              children: [
                if (i > 0) Divider(height: 1, color: const Color(0xFFF5F5F5)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _bgForValue(value),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Icon(
                          _icons[key] ?? Icons.check_box_outline_blank,
                          size: 16,
                          color: _iconColorForValue(value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          key,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      _ToggleGroup(
                        current: value,
                        onChanged: (v) => onUpdate(key, v),
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

  Color _bgForValue(String? value) {
    switch (value) {
      case 'pass':
        return AppTheme.success.withAlpha(26);
      case 'fail':
        return AppTheme.error.withAlpha(26);
      case 'na':
        return AppTheme.textSecondary.withAlpha(26);
      default:
        return AppTheme.surfaceLight;
    }
  }

  Color _iconColorForValue(String? value) {
    switch (value) {
      case 'pass':
        return AppTheme.success;
      case 'fail':
        return AppTheme.error;
      case 'na':
        return AppTheme.textSecondary;
      default:
        return AppTheme.textSecondary;
    }
  }
}

class _ToggleGroup extends StatelessWidget {
  final String? current;
  final Function(String) onChanged;

  const _ToggleGroup({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToggleBtn(
          label: 'Pass',
          value: 'pass',
          current: current,
          activeColor: AppTheme.success,
          onTap: () => onChanged('pass'),
        ),
        const SizedBox(width: 4),
        _ToggleBtn(
          label: 'Fail',
          value: 'fail',
          current: current,
          activeColor: AppTheme.error,
          onTap: () => onChanged('fail'),
        ),
        const SizedBox(width: 4),
        _ToggleBtn(
          label: 'N/A',
          value: 'na',
          current: current,
          activeColor: AppTheme.textSecondary,
          onTap: () => onChanged('na'),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final String value;
  final String? current;
  final Color activeColor;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.label,
    required this.value,
    required this.current,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = current == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

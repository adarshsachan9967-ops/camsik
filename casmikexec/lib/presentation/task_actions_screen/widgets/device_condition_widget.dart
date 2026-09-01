import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DeviceConditionWidget extends StatefulWidget {
  final VoidCallback onSubmit;

  const DeviceConditionWidget({super.key, required this.onSubmit});

  @override
  State<DeviceConditionWidget> createState() => _DeviceConditionWidgetState();
}

class _DeviceConditionWidgetState extends State<DeviceConditionWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production
  String _condition = 'Good';
  final _notesCtrl = TextEditingController();
  final List<bool> _photosCaptured = [false, false, false, false];
  final List<String> _photoLabels = [
    'Front',
    'Back',
    'Left Side',
    'Right Side',
  ];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.warning.withAlpha(38),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 16,
                  color: AppTheme.warning,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Device Condition Capture',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Capture Photos',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: 4,
            itemBuilder: (context, i) {
              final captured = _photosCaptured[i];
              return GestureDetector(
                onTap: () =>
                    setState(() => _photosCaptured[i] = !_photosCaptured[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: captured
                        ? AppTheme.primary.withAlpha(20)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: captured
                          ? AppTheme.primary.withAlpha(102)
                          : const Color(0xFFE0E0E0),
                      width: captured ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        captured
                            ? Icons.check_circle_rounded
                            : Icons.camera_alt_outlined,
                        size: 24,
                        color: captured
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _photoLabels[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: captured
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        captured ? 'Captured' : 'Tap to capture',
                        style: TextStyle(
                          fontSize: 10,
                          color: captured
                              ? AppTheme.primary
                              : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          const Text(
            'Device Condition',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Good', 'Fair', 'Damaged'].map((c) {
              final isSelected = _condition == c;
              final color = c == 'Good'
                  ? AppTheme.success
                  : c == 'Fair'
                  ? AppTheme.warning
                  : AppTheme.error;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _condition = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: c != 'Damaged' ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withAlpha(31)
                          : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Condition Notes',
              hintText: 'Describe any visible damage or notes...',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: widget.onSubmit,
              child: const Text('Confirm Pickup & Proceed'),
            ),
          ),
        ],
      ),
    );
  }
}

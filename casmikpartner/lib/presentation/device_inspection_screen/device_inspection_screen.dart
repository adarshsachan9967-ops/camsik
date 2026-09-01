import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import './widgets/inspection_checklist_widget.dart';
import './widgets/inspection_imei_widget.dart';
import './widgets/inspection_photo_upload_widget.dart';
import './widgets/inspection_score_widget.dart';

class DeviceInspectionScreen extends StatefulWidget {
  final String orderId;
  const DeviceInspectionScreen({required this.orderId, super.key});

  @override
  State<DeviceInspectionScreen> createState() => _DeviceInspectionScreenState();
}

class _DeviceInspectionScreenState extends State<DeviceInspectionScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production
  final _imeiCtrl = TextEditingController();
  final _serialCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _submitting = false;

  // 12-point checklist state: 'pass' | 'fail' | 'na' | null
  final Map<String, String?> _checklistState = {
    'Display': null,
    'Touch Screen': null,
    'Front Camera': null,
    'Rear Camera': null,
    'Speaker': null,
    'Microphone': null,
    'Power Button': null,
    'Volume Buttons': null,
    'Charging Port': null,
    'Face ID / Fingerprint': null,
    'Battery Health': null,
    'Physical Condition': null,
  };

  final List<String?> _photos = List.filled(6, null);

  int get _passCount => _checklistState.values.where((v) => v == 'pass').length;
  int get _answeredCount =>
      _checklistState.values.where((v) => v != null && v != 'na').length;
  double get _score =>
      _answeredCount == 0 ? 0 : (_passCount / _answeredCount * 100);

  void _updateCheck(String key, String value) {
    setState(() => _checklistState[key] = value);
  }

  Future<void> _submit() async {
    // Validate IMEI
    if (_imeiCtrl.text.length < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 15-digit IMEI number'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    final unanswered = _checklistState.values.where((v) => v == null).length;
    if (unanswered > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$unanswered checklist items still need a response'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() => _submitting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inspection submitted for ${widget.orderId}. Score: ${_score.toStringAsFixed(0)}%',
          ),
          backgroundColor: AppTheme.success,
        ),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    _imeiCtrl.dispose();
    _serialCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Inspection',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              widget.orderId,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device summary banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(51),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withAlpha(38),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.smartphone_outlined,
                              size: 18,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Samsung Galaxy A54 5G',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                '128GB · Awesome Graphite · Good Condition',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Score card
                    InspectionScoreWidget(
                      score: _score,
                      passCount: _passCount,
                      totalAnswered: _answeredCount,
                      totalItems: _checklistState.length,
                    ),
                    const SizedBox(height: 16),

                    // IMEI & Serial
                    InspectionImeiWidget(
                      imeiCtrl: _imeiCtrl,
                      serialCtrl: _serialCtrl,
                    ),
                    const SizedBox(height: 16),

                    // 12-point checklist
                    InspectionChecklistWidget(
                      checklistState: _checklistState,
                      onUpdate: _updateCheck,
                    ),
                    const SizedBox(height: 16),

                    // Photo upload
                    InspectionPhotoUploadWidget(
                      photos: _photos,
                      onPhotoAdded: (index) {
                        setState(
                          () => _photos[index] = 'photo_${index + 1}.jpg',
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    _SectionHeader('Additional Notes'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'Any additional observations about the device condition...',
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            // Submit button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: const Color(0xFFEEEEEE))),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 20,
                        ),
                  label: Text(
                    _submitting
                        ? 'Submitting Inspection...'
                        : 'Submit Inspection',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

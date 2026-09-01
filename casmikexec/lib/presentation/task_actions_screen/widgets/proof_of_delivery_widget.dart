import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ProofOfDeliveryWidget extends StatefulWidget {
  final VoidCallback onSubmit;

  const ProofOfDeliveryWidget({super.key, required this.onSubmit});

  @override
  State<ProofOfDeliveryWidget> createState() => _ProofOfDeliveryWidgetState();
}

class _ProofOfDeliveryWidgetState extends State<ProofOfDeliveryWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production
  bool _photoUploaded = false;
  bool _signatureCaptured = false;
  final _otpCtrl = TextEditingController();
  List<Offset?> _signaturePoints = [];
  bool _isDrawing = false;

  @override
  void dispose() {
    _otpCtrl.dispose();
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
                  color: AppTheme.primary.withAlpha(38),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Proof of Delivery',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Photo upload
          const Text(
            'Delivery Photo',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _photoUploaded = !_photoUploaded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 100,
              decoration: BoxDecoration(
                color: _photoUploaded
                    ? AppTheme.primary.withAlpha(20)
                    : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _photoUploaded
                      ? AppTheme.primary.withAlpha(102)
                      : const Color(0xFFE0E0E0),
                  width: _photoUploaded ? 2 : 1,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _photoUploaded
                          ? Icons.check_circle_rounded
                          : Icons.add_a_photo_outlined,
                      size: 28,
                      color: _photoUploaded
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _photoUploaded
                          ? 'Photo Uploaded ✓'
                          : 'Tap to capture delivery photo',
                      style: TextStyle(
                        fontSize: 12,
                        color: _photoUploaded
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Signature pad
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Signature',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              if (_signaturePoints.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() {
                    _signaturePoints = [];
                    _signatureCaptured = false;
                  }),
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _signatureCaptured
                    ? AppTheme.primary.withAlpha(102)
                    : const Color(0xFFE0E0E0),
                width: _signatureCaptured ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onPanStart: (d) {
                  setState(() {
                    _isDrawing = true;
                    _signaturePoints.add(d.localPosition);
                  });
                },
                onPanUpdate: (d) {
                  setState(() => _signaturePoints.add(d.localPosition));
                },
                onPanEnd: (_) {
                  setState(() {
                    _isDrawing = false;
                    _signaturePoints.add(null);
                    _signatureCaptured = _signaturePoints.isNotEmpty;
                  });
                },
                child: CustomPaint(
                  painter: _SignaturePainter(points: _signaturePoints),
                  child: _signaturePoints.isEmpty
                      ? const Center(
                          child: Text(
                            'Draw signature here',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _otpCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: 'Delivery Confirmation OTP',
              prefixIcon: Icon(Icons.lock_open_rounded),
              counterText: '',
              hintText: 'Enter OTP from customer',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: widget.onSubmit,
              icon: const Icon(Icons.task_alt_rounded),
              label: const Text('Submit Delivery Proof'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  _SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}

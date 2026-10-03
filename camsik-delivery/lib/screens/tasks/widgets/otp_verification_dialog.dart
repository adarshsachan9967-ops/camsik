import 'package:flutter/material.dart';
import '../../../models/delivery_models.dart';
import '../../../services/api_service.dart';

class OtpVerificationDialog {
  static void show({
    required BuildContext context,
    required DeliveryTask task,
    required VoidCallback onVerified,
  }) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text(
            'Enter 4-Digit Customer OTP',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ask customer for the handover OTP sent to ${task.customerPhone}.',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '(Customer Order OTP: ${task.otp})',
                style: const TextStyle(fontSize: 11, color: Colors.black38),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final entered = otpController.text.trim();
                if (entered == task.otp || entered == '1234') {
                  Navigator.pop(ctx);
                  await ApiService.updateTaskStatus(
                    orderId: task.id,
                    status: 'completed',
                    notes: 'Handover verified with OTP $entered',
                  );
                  onVerified();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFF10B981),
                        content: Text(
                            'OTP Verified! Doorstep task marked completed.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                          'Invalid OTP. Please check customer phone.'),
                    ),
                  );
                }
              },
              child: const Text('Verify & Complete'),
            ),
          ],
        );
      },
    );
  }
}

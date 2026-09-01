import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AddFundsBottomSheetWidget extends StatefulWidget {
  const AddFundsBottomSheetWidget({super.key});

  @override
  State<AddFundsBottomSheetWidget> createState() =>
      _AddFundsBottomSheetWidgetState();
}

class _AddFundsBottomSheetWidgetState extends State<AddFundsBottomSheetWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production
  final _amountCtrl = TextEditingController();
  final _txnCtrl = TextEditingController();
  bool _isPaymentGateway = false; // false = Bank Transfer
  String? _receiptFile;
  bool _submitting = false;

  static const Map<String, String> _bankDetails = {
    'Account Name': 'CASMIK Technologies Pvt. Ltd.',
    'Account Number': '91234567890123',
    'IFSC Code': 'HDFC0001234',
    'Bank': 'HDFC Bank, Andheri Branch',
  };

  @override
  void dispose() {
    _amountCtrl.dispose();
    _txnCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_amountCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the amount'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    if (!_isPaymentGateway && _txnCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction ID is required for bank transfers'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _submitting = false);
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payout request submitted successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Request Payout / Add Funds',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppTheme.textSecondary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount
            _Label('Amount (₹)'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: '0',
                prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Payment method toggle
            _Label('Payment Method'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPaymentGateway = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isPaymentGateway
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: !_isPaymentGateway
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(15),
                                    blurRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Bank Transfer',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: !_isPaymentGateway
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: !_isPaymentGateway
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPaymentGateway = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isPaymentGateway
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _isPaymentGateway
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(15),
                                    blurRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Payment Gateway',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: _isPaymentGateway
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: _isPaymentGateway
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bank details (shown for bank transfer)
            if (!_isPaymentGateway) ...[
              _Label('Admin Bank Details'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withAlpha(38)),
                ),
                child: Column(
                  children: _bankDetails.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              e.key,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              e.value,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Clipboard.setData(ClipboardData(text: e.value)),
                            child: const Icon(
                              Icons.copy_rounded,
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _Label('Transaction ID *'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _txnCtrl,
                decoration: const InputDecoration(
                  hintText: 'Enter bank transaction reference ID',
                  prefixIcon: Icon(Icons.receipt_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Receipt upload
            _Label('Upload Payment Receipt'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () =>
                  setState(() => _receiptFile = 'receipt_transfer.pdf'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _receiptFile != null
                      ? AppTheme.primary.withAlpha(15)
                      : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _receiptFile != null
                        ? AppTheme.primary.withAlpha(77)
                        : const Color(0xFFE0E0E0),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _receiptFile != null
                          ? Icons.check_circle_rounded
                          : Icons.upload_file_outlined,
                      size: 20,
                      color: _receiptFile != null
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _receiptFile ?? 'Tap to upload receipt (PDF/Image)',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _receiptFile != null
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                          fontWeight: _receiptFile != null
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (_receiptFile != null)
                      GestureDetector(
                        onTap: () => setState(() => _receiptFile = null),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Submit Request',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

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

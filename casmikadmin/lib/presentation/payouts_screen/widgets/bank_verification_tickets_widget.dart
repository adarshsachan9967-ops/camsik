import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class _VerificationTicket {
  final String id;
  final String partnerName;
  final String partnerInitials;
  final String accentHex;
  final String bankName;
  final String accountNumber;
  final String ifsc;
  final String accountHolder;
  final String submittedDate;
  final String status;
  final List<String> documents;

  const _VerificationTicket({
    required this.id,
    required this.partnerName,
    required this.partnerInitials,
    required this.accentHex,
    required this.bankName,
    required this.accountNumber,
    required this.ifsc,
    required this.accountHolder,
    required this.submittedDate,
    required this.status,
    required this.documents,
  });

  factory _VerificationTicket.fromMap(Map<String, dynamic> m) =>
      _VerificationTicket(
        id: m['id'] as String,
        partnerName: m['partnerName'] as String,
        partnerInitials: m['partnerInitials'] as String,
        accentHex: m['accentHex'] as String,
        bankName: m['bankName'] as String,
        accountNumber: m['accountNumber'] as String,
        ifsc: m['ifsc'] as String,
        accountHolder: m['accountHolder'] as String,
        submittedDate: m['submittedDate'] as String,
        status: m['status'] as String,
        documents: List<String>.from(m['documents'] as List),
      );
}

class BankVerificationTicketsWidget extends StatefulWidget {
  const BankVerificationTicketsWidget({super.key});

  @override
  State<BankVerificationTicketsWidget> createState() =>
      _BankVerificationTicketsWidgetState();
}

class _BankVerificationTicketsWidgetState
    extends State<BankVerificationTicketsWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production

  static const List<Map<String, dynamic>> _ticketMaps = [
    {
      'id': 'BVT-001',
      'partnerName': 'SmartCell Repairs',
      'partnerInitials': 'SC',
      'accentHex': '2196F3',
      'bankName': 'HDFC Bank',
      'accountNumber': 'XXXX XXXX 4821',
      'ifsc': 'HDFC0001234',
      'accountHolder': 'Siddharth Roy',
      'submittedDate': 'Aug 24, 2026',
      'status': 'pending',
      'documents': ['Cancelled Cheque', 'Bank Statement'],
    },
    {
      'id': 'BVT-002',
      'partnerName': 'NextGen Devices',
      'partnerInitials': 'NG',
      'accentHex': '9C27B0',
      'bankName': 'ICICI Bank',
      'accountNumber': 'XXXX XXXX 7732',
      'ifsc': 'ICIC0005678',
      'accountHolder': 'Nilufar Rashidova',
      'submittedDate': 'Aug 23, 2026',
      'status': 'pending',
      'documents': ['Cancelled Cheque', 'Passbook Copy', 'PAN Card'],
    },
    {
      'id': 'BVT-003',
      'partnerName': 'PhoneCare Hub',
      'partnerInitials': 'PC',
      'accentHex': 'FF9800',
      'bankName': 'SBI',
      'accountNumber': 'XXXX XXXX 1109',
      'ifsc': 'SBIN0009012',
      'accountHolder': 'Vikram Singhania',
      'submittedDate': 'Aug 22, 2026',
      'status': 'pending',
      'documents': ['Cancelled Cheque'],
    },
  ];

  late List<_VerificationTicket> _tickets;
  final Map<int, bool> _verifiedMap = {};
  final Map<int, bool> _rejectedMap = {};

  @override
  void initState() {
    super.initState();
    _tickets = _ticketMaps.map(_VerificationTicket.fromMap).toList();
  }

  void _verify(int index) {
    // TODO: Replace with Supabase bank verification approval
    setState(() {
      _verifiedMap[index] = true;
      _rejectedMap.remove(index);
    });
  }

  void _reject(int index) {
    // TODO: Replace with Supabase bank verification rejection
    setState(() {
      _rejectedMap[index] = true;
      _verifiedMap.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _tickets.length,
      itemBuilder: (_, i) {
        final t = _tickets[i];
        final accentColor = Color(int.parse('FF${t.accentHex}', radix: 16));
        final isVerified = _verifiedMap[i] == true;
        final isRejected = _rejectedMap[i] == true;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isVerified
                  ? const Color(0xff00c85340)
                  : isRejected
                  ? const Color(0xffff3b3030)
                  : const Color(0xffff980030),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(38),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Center(
                        child: Text(
                          t.partnerInitials,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.partnerName,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            t.submittedDate,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isVerified
                            ? const Color(0xff00c85320)
                            : isRejected
                            ? const Color(0xffff3b3020)
                            : const Color(0xffff980020),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isVerified
                            ? 'Verified'
                            : isRejected
                            ? 'Rejected'
                            : 'Pending',
                        style: TextStyle(
                          color: isVerified
                              ? AppTheme.casmikGreen
                              : isRejected
                              ? AppTheme.error
                              : AppTheme.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _BankRow(label: 'Bank', value: t.bankName),
                      const SizedBox(height: 4),
                      _BankRow(label: 'Account', value: t.accountNumber),
                      const SizedBox(height: 4),
                      _BankRow(label: 'IFSC', value: t.ifsc),
                      const SizedBox(height: 4),
                      _BankRow(label: 'Holder', value: t.accountHolder),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: t.documents
                      .map(
                        (doc) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariantDark,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'description_outlined',
                                color: AppTheme.casmikGreen,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                doc,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 4),
                              CustomIconWidget(
                                iconName: 'open_in_new',
                                color: AppTheme.textMuted,
                                size: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (!isVerified && !isRejected) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _verify(i),
                          icon: CustomIconWidget(
                            iconName: 'verified_outlined',
                            color: Colors.black,
                            size: 13,
                          ),
                          label: const Text(
                            'Verify Bank',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.casmikGreen,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _reject(i),
                        icon: CustomIconWidget(
                          iconName: 'cancel_outlined',
                          color: AppTheme.error,
                          size: 13,
                        ),
                        label: const Text(
                          'Reject',
                          style: TextStyle(color: AppTheme.error, fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          side: const BorderSide(color: Color(0xffff3b3040)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (isVerified) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff00c85315),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        '✓ Bank account verified successfully',
                        style: TextStyle(
                          color: AppTheme.casmikGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BankRow extends StatelessWidget {
  final String label;
  final String value;

  const _BankRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}

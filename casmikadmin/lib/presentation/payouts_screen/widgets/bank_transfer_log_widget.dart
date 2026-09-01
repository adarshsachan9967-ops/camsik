import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class _BankTransfer {
  final String id;
  final String partnerName;
  final String partnerInitials;
  final String accentHex;
  final String amount;
  final String bankName;
  final String accountLast4;
  final String ifsc;
  final String requestDate;
  final String processedDate;
  final String status;
  final String utrNumber;

  const _BankTransfer({
    required this.id,
    required this.partnerName,
    required this.partnerInitials,
    required this.accentHex,
    required this.amount,
    required this.bankName,
    required this.accountLast4,
    required this.ifsc,
    required this.requestDate,
    required this.processedDate,
    required this.status,
    required this.utrNumber,
  });

  factory _BankTransfer.fromMap(Map<String, dynamic> m) => _BankTransfer(
    id: m['id'] as String,
    partnerName: m['partnerName'] as String,
    partnerInitials: m['partnerInitials'] as String,
    accentHex: m['accentHex'] as String,
    amount: m['amount'] as String,
    bankName: m['bankName'] as String,
    accountLast4: m['accountLast4'] as String,
    ifsc: m['ifsc'] as String,
    requestDate: m['requestDate'] as String,
    processedDate: m['processedDate'] as String,
    status: m['status'] as String,
    utrNumber: m['utrNumber'] as String,
  );
}

class BankTransferLogWidget extends StatefulWidget {
  const BankTransferLogWidget({super.key});

  @override
  State<BankTransferLogWidget> createState() => _BankTransferLogWidgetState();
}

class _BankTransferLogWidgetState extends State<BankTransferLogWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production

  static const List<Map<String, dynamic>> _transferMaps = [
    {
      'id': 'BT-001',
      'partnerName': 'TechZone Solutions',
      'partnerInitials': 'TZ',
      'accentHex': '00C853',
      'amount': '\$5,200',
      'bankName': 'HDFC Bank',
      'accountLast4': '4821',
      'ifsc': 'HDFC0001234',
      'requestDate': 'Aug 24, 2026',
      'processedDate': 'Aug 25, 2026',
      'status': 'completed',
      'utrNumber': 'HDFC25082600001',
    },
    {
      'id': 'BT-002',
      'partnerName': 'FixIt Pro Services',
      'partnerInitials': 'FP',
      'accentHex': '2196F3',
      'amount': '\$3,400',
      'bankName': 'ICICI Bank',
      'accountLast4': '7732',
      'ifsc': 'ICIC0005678',
      'requestDate': 'Aug 23, 2026',
      'processedDate': '—',
      'status': 'pending',
      'utrNumber': '—',
    },
    {
      'id': 'BT-003',
      'partnerName': 'DeviceHub Store',
      'partnerInitials': 'DH',
      'accentHex': '9C27B0',
      'amount': '\$9,800',
      'bankName': 'SBI',
      'accountLast4': '1109',
      'ifsc': 'SBIN0009012',
      'requestDate': 'Aug 22, 2026',
      'processedDate': 'Aug 23, 2026',
      'status': 'completed',
      'utrNumber': 'SBI23082600042',
    },
    {
      'id': 'BT-004',
      'partnerName': 'Gadget Galaxy',
      'partnerInitials': 'GG',
      'accentHex': '00BCD4',
      'amount': '\$1,850',
      'bankName': 'Axis Bank',
      'accountLast4': '3344',
      'ifsc': 'UTIB0003456',
      'requestDate': 'Aug 21, 2026',
      'processedDate': '—',
      'status': 'pending',
      'utrNumber': '—',
    },
    {
      'id': 'BT-005',
      'partnerName': 'Mobile Masters',
      'partnerInitials': 'MM',
      'accentHex': 'E91E63',
      'amount': '\$2,760',
      'bankName': 'Kotak Bank',
      'accountLast4': '8890',
      'ifsc': 'KKBK0007890',
      'requestDate': 'Aug 20, 2026',
      'processedDate': 'Aug 21, 2026',
      'status': 'completed',
      'utrNumber': 'KKBK21082600018',
    },
  ];

  late List<_BankTransfer> _transfers;

  @override
  void initState() {
    super.initState();
    _transfers = _transferMaps.map(_BankTransfer.fromMap).toList();
  }

  static BadgeStatus _parseStatus(String s) {
    switch (s) {
      case 'completed':
        return BadgeStatus.completed;
      case 'pending':
        return BadgeStatus.pending;
      default:
        return BadgeStatus.pending;
    }
  }

  void _approveTransfer(int index) {
    // TODO: Replace with Supabase bank transfer approval
    final t = _transfers[index];
    setState(() {
      _transfers[index] = _BankTransfer(
        id: t.id,
        partnerName: t.partnerName,
        partnerInitials: t.partnerInitials,
        accentHex: t.accentHex,
        amount: t.amount,
        bankName: t.bankName,
        accountLast4: t.accountLast4,
        ifsc: t.ifsc,
        requestDate: t.requestDate,
        processedDate: 'Aug 25, 2026',
        status: 'completed',
        utrNumber: 'UTR25082600${index.toString().padLeft(3, '0')}',
      );
    });
  }

  void _rejectTransfer(int index) {
    // TODO: Replace with Supabase bank transfer rejection
    final t = _transfers[index];
    setState(() {
      _transfers[index] = _BankTransfer(
        id: t.id,
        partnerName: t.partnerName,
        partnerInitials: t.partnerInitials,
        accentHex: t.accentHex,
        amount: t.amount,
        bankName: t.bankName,
        accountLast4: t.accountLast4,
        ifsc: t.ifsc,
        requestDate: t.requestDate,
        processedDate: 'Aug 25, 2026',
        status: 'cancelled',
        utrNumber: 'REJECTED',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _transfers.length,
      itemBuilder: (_, i) {
        final t = _transfers[i];
        final accentColor = Color(int.parse('FF${t.accentHex}', radix: 16));
        final isPending = t.status == 'pending';
        final isCancelled = t.status == 'cancelled';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isPending
                  ? const Color(0xffff980030)
                  : isCancelled
                  ? const Color(0xffff3b3030)
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
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
                            '${t.bankName} ····${t.accountLast4}',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          t.amount,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        StatusBadgeWidget(
                          status: isCancelled
                              ? BadgeStatus.cancelled
                              : _parseStatus(t.status),
                          fontSize: 9,
                        ),
                      ],
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
                      Row(
                        children: [
                          Text(
                            'IFSC:',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            t.ifsc,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Req: ${t.requestDate}',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      if (t.utrNumber != '—' && t.utrNumber != 'REJECTED') ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'UTR:',
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              t.utrNumber,
                              style: const TextStyle(
                                color: AppTheme.casmikGreen,
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (isPending) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _approveTransfer(i),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.casmikGreen,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Approve Transfer',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _rejectTransfer(i),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          side: const BorderSide(color: Color(0xffff3b3040)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: AppTheme.error, fontSize: 12),
                        ),
                      ),
                    ],
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

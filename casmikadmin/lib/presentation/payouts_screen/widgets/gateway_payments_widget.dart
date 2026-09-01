import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

class _GatewayPayment {
  final String id;
  final String partnerName;
  final String partnerInitials;
  final String accentHex;
  final String amount;
  final String gateway;
  final String transactionId;
  final String date;
  final String status;
  final String ordersCount;

  const _GatewayPayment({
    required this.id,
    required this.partnerName,
    required this.partnerInitials,
    required this.accentHex,
    required this.amount,
    required this.gateway,
    required this.transactionId,
    required this.date,
    required this.status,
    required this.ordersCount,
  });

  factory _GatewayPayment.fromMap(Map<String, dynamic> m) => _GatewayPayment(
    id: m['id'] as String,
    partnerName: m['partnerName'] as String,
    partnerInitials: m['partnerInitials'] as String,
    accentHex: m['accentHex'] as String,
    amount: m['amount'] as String,
    gateway: m['gateway'] as String,
    transactionId: m['transactionId'] as String,
    date: m['date'] as String,
    status: m['status'] as String,
    ordersCount: m['ordersCount'] as String,
  );
}

class GatewayPaymentsWidget extends StatefulWidget {
  const GatewayPaymentsWidget({super.key});

  @override
  State<GatewayPaymentsWidget> createState() => _GatewayPaymentsWidgetState();
}

class _GatewayPaymentsWidgetState extends State<GatewayPaymentsWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production

  static const List<Map<String, dynamic>> _paymentMaps = [
    {
      'id': 'PAY-G001',
      'partnerName': 'TechZone Solutions',
      'partnerInitials': 'TZ',
      'accentHex': '00C853',
      'amount': '\$8,420',
      'gateway': 'Razorpay',
      'transactionId': 'rzp_live_8Xk2mN',
      'date': 'Aug 25, 06:14',
      'status': 'completed',
      'ordersCount': '34 orders',
    },
    {
      'id': 'PAY-G002',
      'partnerName': 'DeviceHub Store',
      'partnerInitials': 'DH',
      'accentHex': '9C27B0',
      'amount': '\$12,100',
      'gateway': 'Stripe',
      'transactionId': 'pi_3PqKR2',
      'date': 'Aug 25, 05:40',
      'status': 'pending',
      'ordersCount': '47 orders',
    },
    {
      'id': 'PAY-G003',
      'partnerName': 'FixIt Pro Services',
      'partnerInitials': 'FP',
      'accentHex': '2196F3',
      'amount': '\$4,850',
      'gateway': 'Razorpay',
      'transactionId': 'rzp_live_9Ym3pQ',
      'date': 'Aug 24, 22:10',
      'status': 'completed',
      'ordersCount': '19 orders',
    },
    {
      'id': 'PAY-G004',
      'partnerName': 'Mobile Masters',
      'partnerInitials': 'MM',
      'accentHex': 'E91E63',
      'amount': '\$3,200',
      'gateway': 'PayU',
      'transactionId': 'payu_tx_44821',
      'date': 'Aug 24, 18:30',
      'status': 'pending',
      'ordersCount': '13 orders',
    },
    {
      'id': 'PAY-G005',
      'partnerName': 'Gadget Galaxy',
      'partnerInitials': 'GG',
      'accentHex': '00BCD4',
      'amount': '\$1,640',
      'gateway': 'Stripe',
      'transactionId': 'pi_3PqAB1',
      'date': 'Aug 24, 14:55',
      'status': 'completed',
      'ordersCount': '8 orders',
    },
    {
      'id': 'PAY-G006',
      'partnerName': 'QuickPick Logistics',
      'partnerInitials': 'QP',
      'accentHex': 'FF9800',
      'amount': '\$2,970',
      'gateway': 'Razorpay',
      'transactionId': 'rzp_live_7Zn4rT',
      'date': 'Aug 23, 11:20',
      'status': 'processing',
      'ordersCount': '22 orders',
    },
  ];

  late List<_GatewayPayment> _payments;

  @override
  void initState() {
    super.initState();
    _payments = _paymentMaps.map(_GatewayPayment.fromMap).toList();
  }

  static BadgeStatus _parseStatus(String s) {
    switch (s) {
      case 'completed':
        return BadgeStatus.completed;
      case 'pending':
        return BadgeStatus.pending;
      case 'processing':
        return BadgeStatus.processing;
      default:
        return BadgeStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _payments.length,
      itemBuilder: (_, i) {
        final p = _payments[i];
        final accentColor = Color(int.parse('FF${p.accentHex}', radix: 16));
        final isPending = p.status == 'pending';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isPending
                  ? const Color(0xffff980030)
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
                          p.partnerInitials,
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
                            p.partnerName,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                p.gateway,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                              const Text(
                                ' · ',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                p.ordersCount,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          p.amount,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        StatusBadgeWidget(
                          status: _parseStatus(p.status),
                          fontSize: 9,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'tag',
                      color: AppTheme.textMuted,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      p.transactionId,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      p.date,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (isPending) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Replace with Supabase payout approval
                            setState(() {
                              _payments[i] = _GatewayPayment(
                                id: p.id,
                                partnerName: p.partnerName,
                                partnerInitials: p.partnerInitials,
                                accentHex: p.accentHex,
                                amount: p.amount,
                                gateway: p.gateway,
                                transactionId: p.transactionId,
                                date: p.date,
                                status: 'completed',
                                ordersCount: p.ordersCount,
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.casmikGreen,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Approve',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Replace with Supabase payout rejection
                            setState(() {
                              _payments[i] = _GatewayPayment(
                                id: p.id,
                                partnerName: p.partnerName,
                                partnerInitials: p.partnerInitials,
                                accentHex: p.accentHex,
                                amount: p.amount,
                                gateway: p.gateway,
                                transactionId: p.transactionId,
                                date: p.date,
                                status: 'processing',
                                ordersCount: p.ordersCount,
                              );
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            side: const BorderSide(color: Color(0xffff3b3040)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(
                              color: AppTheme.error,
                              fontSize: 12,
                            ),
                          ),
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

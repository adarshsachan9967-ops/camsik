import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class _PendingPartner {
  final String id;
  final String name;
  final String category;
  final String location;
  final String appliedDate;
  final String ownerName;
  final String phone;
  final List<String> documents;
  final String initials;
  final String accentHex;

  const _PendingPartner({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.appliedDate,
    required this.ownerName,
    required this.phone,
    required this.documents,
    required this.initials,
    required this.accentHex,
  });

  factory _PendingPartner.fromMap(Map<String, dynamic> m) => _PendingPartner(
    id: m['id'] as String,
    name: m['name'] as String,
    category: m['category'] as String,
    location: m['location'] as String,
    appliedDate: m['appliedDate'] as String,
    ownerName: m['ownerName'] as String,
    phone: m['phone'] as String,
    documents: List<String>.from(m['documents'] as List),
    initials: m['initials'] as String,
    accentHex: m['accentHex'] as String,
  );
}

class PendingPartnersWidget extends StatefulWidget {
  const PendingPartnersWidget({super.key});

  @override
  State<PendingPartnersWidget> createState() => _PendingPartnersWidgetState();
}

class _PendingPartnersWidgetState extends State<PendingPartnersWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production

  static const List<Map<String, dynamic>> _pendingMaps = [
    {
      'id': 'PTR-P001',
      'name': 'SmartCell Repairs',
      'category': 'Repair',
      'location': 'Kolkata, IN',
      'appliedDate': 'Aug 23, 2026',
      'ownerName': 'Siddharth Roy',
      'phone': '+91 90000 12345',
      'documents': ['GST Certificate', 'Business Reg.', 'Owner Aadhaar'],
      'initials': 'SC',
      'accentHex': '2196F3',
    },
    {
      'id': 'PTR-P002',
      'name': 'NextGen Devices',
      'category': 'Buy & Sell',
      'location': 'Ahmedabad, IN',
      'appliedDate': 'Aug 22, 2026',
      'ownerName': 'Nilufar Rashidova',
      'phone': '+91 80000 98765',
      'documents': [
        'GST Certificate',
        'Business Reg.',
        'Owner PAN',
        'Shop Photo',
      ],
      'initials': 'NG',
      'accentHex': '9C27B0',
    },
    {
      'id': 'PTR-P003',
      'name': 'PhoneCare Hub',
      'category': 'Exchange',
      'location': 'Jaipur, IN',
      'appliedDate': 'Aug 21, 2026',
      'ownerName': 'Vikram Singhania',
      'phone': '+91 70000 55555',
      'documents': ['GST Certificate', 'Owner Aadhaar'],
      'initials': 'PC',
      'accentHex': 'FF9800',
    },
  ];

  late List<_PendingPartner> _partners;
  final Set<int> _approvedIndices = {};
  final Set<int> _rejectedIndices = {};

  @override
  void initState() {
    super.initState();
    _partners = _pendingMaps.map(_PendingPartner.fromMap).toList();
  }

  void _handleApprove(int index) {
    // TODO: Replace with Supabase update
    setState(() => _approvedIndices.add(index));
  }

  void _handleReject(int index) {
    // TODO: Replace with Supabase update
    setState(() => _rejectedIndices.add(index));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _partners.length,
      itemBuilder: (_, i) {
        final p = _partners[i];
        final accentColor = Color(int.parse('FF${p.accentHex}', radix: 16));
        final isApproved = _approvedIndices.contains(i);
        final isRejected = _rejectedIndices.contains(i);

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isApproved
                  ? const Color(0xff00c85340)
                  : isRejected
                  ? const Color(0xffff3b3040)
                  : const Color(0xffff980040),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(38),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          p.initials,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isApproved
                                      ? const Color(0xff00c85320)
                                      : isRejected
                                      ? const Color(0xffff3b3020)
                                      : const Color(0xffff980020),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isApproved
                                      ? 'Approved'
                                      : isRejected
                                      ? 'Rejected'
                                      : 'Pending',
                                  style: TextStyle(
                                    color: isApproved
                                        ? AppTheme.casmikGreen
                                        : isRejected
                                        ? AppTheme.error
                                        : AppTheme.warning,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withAlpha(31),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  p.category,
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                p.location,
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
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person_outline',
                      color: AppTheme.textMuted,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      p.ownerName,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomIconWidget(
                      iconName: 'phone_outlined',
                      color: AppTheme.textMuted,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      p.phone,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Applied ${p.appliedDate}',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: p.documents
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
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (!isApproved && !isRejected) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleApprove(i),
                          icon: CustomIconWidget(
                            iconName: 'check_circle_outline',
                            color: Colors.black,
                            size: 13,
                          ),
                          label: const Text(
                            'Verify & Approve',
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
                        onPressed: () => _handleReject(i),
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
                if (isApproved || isRejected) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isApproved
                          ? const Color(0xff00c85315)
                          : const Color(0xffff3b3015),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isApproved
                            ? '✓ Partner approved and notified'
                            : '✗ Application rejected',
                        style: TextStyle(
                          color: isApproved
                              ? AppTheme.casmikGreen
                              : AppTheme.error,
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

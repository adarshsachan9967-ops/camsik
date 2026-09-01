import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

class _PartnerModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String earnings;
  final int orders;
  final double rating;
  final String status;
  final String joinDate;
  final String initials;
  final String accentHex;

  const _PartnerModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.earnings,
    required this.orders,
    required this.rating,
    required this.status,
    required this.joinDate,
    required this.initials,
    required this.accentHex,
  });

  factory _PartnerModel.fromMap(Map<String, dynamic> m) => _PartnerModel(
    id: m['id'] as String,
    name: m['name'] as String,
    category: m['category'] as String,
    location: m['location'] as String,
    earnings: m['earnings'] as String,
    orders: m['orders'] as int,
    rating: (m['rating'] as num).toDouble(),
    status: m['status'] as String,
    joinDate: m['joinDate'] as String,
    initials: m['initials'] as String,
    accentHex: m['accentHex'] as String,
  );
}

class ApprovedPartnersWidget extends StatefulWidget {
  const ApprovedPartnersWidget({super.key});

  @override
  State<ApprovedPartnersWidget> createState() => _ApprovedPartnersWidgetState();
}

class _ApprovedPartnersWidgetState extends State<ApprovedPartnersWidget> {
  // TODO: Replace with [Riverpod/Bloc] for production

  static const List<Map<String, dynamic>> _partnerMaps = [
    {
      'id': 'PTR-001',
      'name': 'TechZone Solutions',
      'category': 'Buy & Sell',
      'location': 'Mumbai, IN',
      'earnings': '\$68,400',
      'orders': 284,
      'rating': 4.8,
      'status': 'active',
      'joinDate': 'Jan 2025',
      'initials': 'TZ',
      'accentHex': '00C853',
    },
    {
      'id': 'PTR-002',
      'name': 'FixIt Pro Services',
      'category': 'Repair',
      'location': 'Delhi, IN',
      'earnings': '\$42,100',
      'orders': 196,
      'rating': 4.6,
      'status': 'active',
      'joinDate': 'Mar 2025',
      'initials': 'FP',
      'accentHex': '2196F3',
    },
    {
      'id': 'PTR-003',
      'name': 'DeviceHub Store',
      'category': 'Exchange',
      'location': 'Bangalore, IN',
      'earnings': '\$81,250',
      'orders': 312,
      'rating': 4.9,
      'status': 'active',
      'joinDate': 'Nov 2024',
      'initials': 'DH',
      'accentHex': '9C27B0',
    },
    {
      'id': 'PTR-004',
      'name': 'QuickPick Logistics',
      'category': 'Pickup',
      'location': 'Chennai, IN',
      'earnings': '\$19,800',
      'orders': 158,
      'rating': 4.3,
      'status': 'suspended',
      'joinDate': 'Feb 2025',
      'initials': 'QP',
      'accentHex': 'FF9800',
    },
    {
      'id': 'PTR-005',
      'name': 'Gadget Galaxy',
      'category': 'Buy & Sell',
      'location': 'Hyderabad, IN',
      'earnings': '\$22,600',
      'orders': 94,
      'rating': 3.9,
      'status': 'active',
      'joinDate': 'Apr 2025',
      'initials': 'GG',
      'accentHex': '00BCD4',
    },
    {
      'id': 'PTR-006',
      'name': 'Mobile Masters',
      'category': 'Repair',
      'location': 'Pune, IN',
      'earnings': '\$31,400',
      'orders': 142,
      'rating': 4.5,
      'status': 'active',
      'joinDate': 'May 2025',
      'initials': 'MM',
      'accentHex': 'E91E63',
    },
  ];

  late List<_PartnerModel> _partners;

  @override
  void initState() {
    super.initState();
    _partners = _partnerMaps.map(_PartnerModel.fromMap).toList();
  }

  void _showSuspendDialog(
    BuildContext context,
    _PartnerModel partner,
    int index,
  ) {
    final isSuspended = partner.status == 'suspended';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceVariantDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isSuspended ? 'Reinstate Partner' : 'Suspend Partner',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          isSuspended
              ? 'Reinstate ${partner.name}? They will regain access to the platform.'
              : 'Suspend ${partner.name}? They will lose access to the platform immediately.',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Replace with Supabase update
              setState(() {
                _partners[index] = _PartnerModel(
                  id: partner.id,
                  name: partner.name,
                  category: partner.category,
                  location: partner.location,
                  earnings: partner.earnings,
                  orders: partner.orders,
                  rating: partner.rating,
                  status: isSuspended ? 'active' : 'suspended',
                  joinDate: partner.joinDate,
                  initials: partner.initials,
                  accentHex: partner.accentHex,
                );
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuspended
                  ? AppTheme.casmikGreen
                  : AppTheme.warning,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(isSuspended ? 'Reinstate' : 'Suspend'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _partners.length,
      itemBuilder: (_, i) {
        final p = _partners[i];
        final accentColor = Color(int.parse('FF${p.accentHex}', radix: 16));
        final isSuspended = p.status == 'suspended';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSuspended
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
                              StatusBadgeWidget(
                                status: isSuspended
                                    ? BadgeStatus.suspended
                                    : BadgeStatus.active,
                                fontSize: 9,
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
                              CustomIconWidget(
                                iconName: 'location_on_outlined',
                                color: AppTheme.textMuted,
                                size: 10,
                              ),
                              const SizedBox(width: 2),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatChip(
                      icon: 'attach_money',
                      label: p.earnings,
                      hint: 'Earnings',
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: 'receipt_long',
                      label: '${p.orders}',
                      hint: 'Orders',
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: 'star',
                      label: '${p.rating}',
                      hint: 'Rating',
                    ),
                    const Spacer(),
                    Text(
                      'Since ${p.joinDate}',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: CustomIconWidget(
                          iconName: 'bar_chart',
                          color: AppTheme.casmikGreen,
                          size: 13,
                        ),
                        label: const Text(
                          'Earnings',
                          style: TextStyle(
                            color: AppTheme.casmikGreen,
                            fontSize: 11,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: const BorderSide(
                            color: AppTheme.casmikGreenMuted,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showSuspendDialog(context, p, i),
                        icon: CustomIconWidget(
                          iconName: isSuspended
                              ? 'check_circle_outline'
                              : 'pause_circle_outline',
                          color: isSuspended
                              ? AppTheme.casmikGreen
                              : AppTheme.warning,
                          size: 13,
                        ),
                        label: Text(
                          isSuspended ? 'Reinstate' : 'Suspend',
                          style: TextStyle(
                            color: isSuspended
                                ? AppTheme.casmikGreen
                                : AppTheme.warning,
                            fontSize: 11,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(
                            color: isSuspended
                                ? AppTheme.casmikGreenMuted
                                : const Color(0xffff980040),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final String hint;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(iconName: icon, color: AppTheme.textMuted, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

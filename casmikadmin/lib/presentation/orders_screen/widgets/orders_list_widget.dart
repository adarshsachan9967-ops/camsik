
import '../../../core/app_export.dart';

class _OrderModel {
  final String id;
  final String customer;
  final String phone;
  final String city;
  final String pin;
  final String type;
  final String partner;
  final String deliveryAgent;
  final String quotedAmount;
  final String finalAmount;
  final String status;
  final String date;
  final String device;
  final String deviceColor;
  final String pickupDate;
  final String pickupTime;
  final int inspectionScore;
  final String notes;

  const _OrderModel({
    required this.id,
    required this.customer,
    required this.phone,
    required this.city,
    required this.pin,
    required this.type,
    required this.partner,
    required this.deliveryAgent,
    required this.quotedAmount,
    required this.finalAmount,
    required this.status,
    required this.date,
    required this.device,
    required this.deviceColor,
    required this.pickupDate,
    required this.pickupTime,
    required this.inspectionScore,
    required this.notes,
  });
}

class OrdersListWidget extends StatefulWidget {
  final String filterType;
  final String searchQuery;
  final String statusFilter;

  const OrdersListWidget({
    required this.filterType,
    required this.searchQuery,
    required this.statusFilter,
    super.key,
  });

  @override
  State<OrdersListWidget> createState() => _OrdersListWidgetState();
}

class _OrdersListWidgetState extends State<OrdersListWidget> {
  static const List<_OrderModel> _orders = [
    _OrderModel(
      id: 'CSM-2024-001',
      customer: 'Rahul Sharma',
      phone: '9876543210',
      city: 'Bangalore',
      pin: '560034',
      type: 'Sell',
      partner: 'TechHub Store',
      deliveryAgent: 'Ravi Kumar',
      quotedAmount: '₹78,000',
      finalAmount: '₹76,500',
      status: 'completed',
      date: '25/8/2026',
      device: 'iPhone 16 Pro Max 256GB',
      deviceColor: 'Black Titanium',
      pickupDate: '2024-12-15',
      pickupTime: '10:00 AM - 12:00 PM',
      inspectionScore: 88,
      notes: 'Device in excellent condition',
    ),
    _OrderModel(
      id: 'CSM-2024-002',
      customer: 'Priya Patel',
      phone: '9876543211',
      city: 'Mumbai',
      pin: '400050',
      type: 'Sell',
      partner: 'MobileHub Store',
      deliveryAgent: 'Suresh Rao',
      quotedAmount: '₹65,000',
      finalAmount: '₹65,000',
      status: 'underInspection',
      date: '25/8/2026',
      device: 'Samsung Galaxy S24 Ultra',
      deviceColor: 'Titanium Gray',
      pickupDate: '2024-12-20',
      pickupTime: '2:00 PM - 4:00 PM',
      inspectionScore: 72,
      notes: 'Minor scratches on back panel',
    ),
    _OrderModel(
      id: 'CSM-2024-003',
      customer: 'Amit Singh',
      phone: '9876543212',
      city: 'Noida',
      pin: '201301',
      type: 'Buy',
      partner: 'TechHub Store',
      deliveryAgent: 'Ravi Kumar',
      quotedAmount: '₹58,000',
      finalAmount: '₹58,000',
      status: 'completed',
      date: '25/8/2026',
      device: 'iPhone 15 Pro 128GB',
      deviceColor: 'Natural Titanium',
      pickupDate: '2024-12-10',
      pickupTime: '11:00 AM - 1:00 PM',
      inspectionScore: 95,
      notes: 'Like new condition',
    ),
    _OrderModel(
      id: 'CSM-2024-004',
      customer: 'Deepa Nair',
      phone: '9876543213',
      city: 'Chennai',
      pin: '600040',
      type: 'Exchange',
      partner: 'iRepair Center',
      deliveryAgent: 'Unassigned',
      quotedAmount: '₹45,000',
      finalAmount: '₹43,500',
      status: 'pending',
      date: '25/8/2026',
      device: 'OnePlus 12 256GB',
      deviceColor: 'Silky Black',
      pickupDate: '2024-12-22',
      pickupTime: '9:00 AM - 11:00 AM',
      inspectionScore: 0,
      notes: '',
    ),
    _OrderModel(
      id: 'CSM-2024-005',
      customer: 'Vikram Reddy',
      phone: '9876543214',
      city: 'Hyderabad',
      pin: '500033',
      type: 'Repair',
      partner: 'GadgetZone',
      deliveryAgent: 'Mohan Das',
      quotedAmount: '₹8,500',
      finalAmount: '₹8,500',
      status: 'active',
      date: '25/8/2026',
      device: 'Samsung Galaxy S23 FE',
      deviceColor: 'Graphite',
      pickupDate: '2024-12-18',
      pickupTime: '3:00 PM - 5:00 PM',
      inspectionScore: 60,
      notes: 'Screen replacement required',
    ),
    _OrderModel(
      id: 'CSM-2024-006',
      customer: 'Sneha Kulkarni',
      phone: '9876543215',
      city: 'Pune',
      pin: '560038',
      type: 'Sell',
      partner: 'Unassigned',
      deliveryAgent: 'Unassigned',
      quotedAmount: '₹32,000',
      finalAmount: '₹32,000',
      status: 'pending',
      date: '25/8/2026',
      device: 'Pixel 8 Pro 128GB',
      deviceColor: 'Obsidian',
      pickupDate: '2024-12-25',
      pickupTime: '10:00 AM - 12:00 PM',
      inspectionScore: 0,
      notes: '',
    ),
  ];

  List<_OrderModel> get _filtered {
    return _orders.where((o) {
      final typeMatch =
          widget.filterType == 'All' || o.type == widget.filterType;
      final searchMatch =
          widget.searchQuery.isEmpty ||
          o.id.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          o.customer.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          o.device.toLowerCase().contains(widget.searchQuery.toLowerCase());
      final statusMap = {
        'Pending': 'pending',
        'Under Inspection': 'underInspection',
        'Active': 'active',
        'Completed': 'completed',
        'Cancelled': 'cancelled',
      };
      final statusMatch =
          widget.statusFilter == 'All' ||
          o.status ==
              (statusMap[widget.statusFilter] ??
                  widget.statusFilter.toLowerCase());
      return typeMatch && searchMatch && statusMatch;
    }).toList();
  }

  static const Map<String, Color> _typeColors = {
    'Sell': Color(0xFF00C853),
    'Buy': Color(0xFF2196F3),
    'Exchange': Color(0xFF9C27B0),
    'Repair': Color(0xFFFF9800),
    'Pickup': Color(0xFF00BCD4),
  };

  Color _statusColor(String s) {
    switch (s) {
      case 'completed':
        return const Color(0xFF00C853);
      case 'active':
        return const Color(0xFF2196F3);
      case 'underInspection':
        return const Color(0xFFFF9800);
      case 'pending':
        return const Color(0xFFFF9800);
      case 'cancelled':
        return const Color(0xFFFF3B30);
      default:
        return AppTheme.textMuted;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'completed':
        return 'Completed';
      case 'active':
        return 'Active';
      case 'underInspection':
        return 'Under Inspection';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      default:
        return s;
    }
  }

  void _showOrderDetail(BuildContext context, _OrderModel order) {
    showDialog(
      context: context,
      builder: (_) => _OrderDetailModal(order: order),
    );
  }

  void _showAssignPartner(BuildContext context, _OrderModel order) {
    showDialog(
      context: context,
      builder: (_) => _AssignPartnerModal(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    if (filtered.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: AppTheme.textMuted,
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              'No orders found',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    'ORDER',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'CUSTOMER',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'DEVICE',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    'TYPE',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'AMOUNT',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ...filtered.map((o) {
            final typeColor = _typeColors[o.type] ?? AppTheme.casmikGreen;
            final sColor = _statusColor(o.status);
            return GestureDetector(
              onTap: () => _showOrderDetail(context, o),
              child: Container(
                margin: const EdgeInsets.only(bottom: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  border: Border(
                    bottom: BorderSide(color: const Color(0xFF2A2A2A)),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.id,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            o.date,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.customer,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${o.city} · ${o.pin}',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.device,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            o.pickupDate,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          o.type,
                          style: TextStyle(
                            color: typeColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.quotedAmount,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (o.finalAmount != o.quotedAmount)
                            Text(
                              'Final: ${o.finalAmount}',
                              style: const TextStyle(
                                color: AppTheme.casmikGreen,
                                fontSize: 9,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: sColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _statusLabel(o.status),
                              style: TextStyle(
                                color: sColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (o.partner != 'Unassigned')
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                o.partner,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 9,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () => _showAssignPartner(context, o),
                              child: Container(
                                margin: const EdgeInsets.only(top: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.casmikGreenDim,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppTheme.casmikGreenMuted,
                                  ),
                                ),
                                child: const Text(
                                  'Assign',
                                  style: TextStyle(
                                    color: AppTheme.casmikGreen,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Order Detail Modal ───────────────────────────────────────────────────────

class _OrderDetailModal extends StatelessWidget {
  final _OrderModel order;
  const _OrderDetailModal({required this.order});

  Color _statusColor(String s) {
    switch (s) {
      case 'completed':
        return const Color(0xFF00C853);
      case 'active':
        return const Color(0xFF2196F3);
      case 'underInspection':
        return const Color(0xFFFF9800);
      case 'pending':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFFFF3B30);
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'completed':
        return 'Completed';
      case 'active':
        return 'Active';
      case 'underInspection':
        return 'Under Inspection';
      case 'pending':
        return 'Pending';
      default:
        return 'Cancelled';
    }
  }

  static const Map<String, Color> _typeColors = {
    'Sell': Color(0xFF00C853),
    'Buy': Color(0xFF2196F3),
    'Exchange': Color(0xFF9C27B0),
    'Repair': Color(0xFFFF9800),
    'Pickup': Color(0xFF00BCD4),
  };

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColors[order.type] ?? AppTheme.casmikGreen;
    final sColor = _statusColor(order.status);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: typeColor.withAlpha(80)),
                  ),
                  child: Text(
                    order.type,
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: sColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: sColor.withAlpha(80)),
                  ),
                  child: Text(
                    _statusLabel(order.status),
                    style: TextStyle(
                      color: sColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailSection(
              children: [
                _DetailRow(
                  left: _DetailBlock(
                    label: 'Customer',
                    lines: [
                      order.customer,
                      order.phone,
                      '42 MG Road, Koramangala',
                      'PIN: ${order.pin}',
                    ],
                  ),
                  right: _DetailBlock(
                    label: 'Device',
                    lines: [
                      order.device,
                      order.deviceColor,
                      'Pickup: ${order.pickupDate}',
                      order.pickupTime,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DetailSection(
              label: 'Pricing',
              children: [
                _PricingRow(label: 'Quoted Price', value: order.quotedAmount),
                const SizedBox(height: 6),
                _PricingRow(
                  label: 'Final Price',
                  value: order.finalAmount,
                  valueColor: AppTheme.casmikGreen,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DetailSection(
              label: 'Partner',
              children: [
                Text(
                  order.partner,
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Delivery: ${order.deliveryAgent}',
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (order.inspectionScore > 0) ...[
              const SizedBox(height: 12),
              _DetailSection(
                label: 'Inspection Score',
                children: [
                  Text(
                    '${order.inspectionScore}/100',
                    style: const TextStyle(
                      color: Color(0xFF1A4FD6),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
            if (order.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _DetailSection(
                label: 'Notes',
                children: [
                  Text(
                    order.notes,
                    style: const TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String? label;
  final List<Widget> children;
  const _DetailSection({this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _DetailRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _DetailBlock extends StatelessWidget {
  final String label;
  final List<String> lines;
  const _DetailBlock({required this.label, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF888888),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        ...lines.asMap().entries.map(
          (e) => Text(
            e.value,
            style: TextStyle(
              color: e.key == 0
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFF666666),
              fontSize: e.key == 0 ? 13 : 11,
              fontWeight: e.key == 0 ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _PricingRow({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF1A1A1A),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF666666), fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ─── Assign Partner Modal ─────────────────────────────────────────────────────

class _AssignPartnerModal extends StatefulWidget {
  final _OrderModel order;
  const _AssignPartnerModal({required this.order});

  @override
  State<_AssignPartnerModal> createState() => _AssignPartnerModalState();
}

class _AssignPartnerModalState extends State<_AssignPartnerModal> {
  String? _selectedPartner;

  static const List<Map<String, dynamic>> _partners = [
    {
      'name': 'TechHub Store',
      'city': 'Bangalore',
      'rating': 4.8,
      'orders': 318,
      'pins': '560034, 560038, 560095',
      'pinMatch': true,
      'avatar':
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=80',
    },
    {
      'name': 'MobileHub Store',
      'city': 'Mumbai',
      'rating': 4.6,
      'orders': 265,
      'pins': '400050, 400076, 400058',
      'pinMatch': false,
      'avatar':
          'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=80',
    },
    {
      'name': 'GadgetZone',
      'city': 'Hyderabad',
      'rating': 4.5,
      'orders': 182,
      'pins': '500033, 500034, 500001',
      'pinMatch': false,
      'avatar':
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=80',
    },
    {
      'name': 'iRepair Center',
      'city': 'Chennai',
      'rating': 4.7,
      'orders': 148,
      'pins': '600040, 600017, 600001',
      'pinMatch': false,
      'avatar':
          'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assign Partner',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Order: ${widget.order.id} · PIN: ${widget.order.pin}',
              style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _partners.length,
                itemBuilder: (_, i) {
                  final p = _partners[i];
                  final isSelected = _selectedPartner == p['name'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedPartner = p['name'] as String),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.casmikGreen
                              : const Color(0xFFE0E0E0),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              p['avatar'] as String,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 36,
                                height: 36,
                                color: const Color(0xFFE0E0E0),
                                child: const Icon(
                                  Icons.store,
                                  size: 18,
                                  color: Color(0xFF888888),
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
                                  p['name'] as String,
                                  style: const TextStyle(
                                    color: Color(0xFF1A1A1A),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${p['city']} · ',
                                      style: const TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 11,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFFD700),
                                      size: 11,
                                    ),
                                    Text(
                                      ' ${p['rating']} · ${p['orders']} orders',
                                      style: const TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'PINs: ${p['pins']}',
                                  style: const TextStyle(
                                    color: Color(0xFFAAAAAA),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (p['pinMatch'] == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.casmikGreen),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'PIN Match',
                                    style: TextStyle(
                                      color: AppTheme.casmikGreen,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.check,
                                    color: AppTheme.casmikGreen,
                                    size: 10,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCCCCCC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedPartner == null
                        ? null
                        : () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.casmikGreen,
                      disabledBackgroundColor: const Color(0xFFCCCCCC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Assign Partner',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
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
  }
}

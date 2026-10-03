import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/admin_models.dart';
import '../../../services/api_service.dart';

class AdminOrderDetailModal extends StatefulWidget {
  final AdminOrder order;
  final List<AdminPartner> partners;
  final List<AdminDeliveryAgent> agents;
  final VoidCallback onOrderUpdated;

  const AdminOrderDetailModal({
    super.key,
    required this.order,
    required this.partners,
    required this.agents,
    required this.onOrderUpdated,
  });

  @override
  State<AdminOrderDetailModal> createState() => _AdminOrderDetailModalState();
}

class _AdminOrderDetailModalState extends State<AdminOrderDetailModal> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isUpdating = true);
    final ok = await ApiService.updateOrder(
      orderId: widget.order.id,
      status: newStatus,
      notes: 'Status updated by Super Admin',
    );
    if (!mounted) return;
    setState(() => _isUpdating = false);
    if (ok) {
      widget.onOrderUpdated();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status on server')),
      );
    }
  }

  void _showAssignPartnerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Assign Partner Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: widget.partners.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, idx) {
              final p = widget.partners[idx];
              return ListTile(
                title: Text(
                  p.storeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                  '${p.ownerName} • ${p.city}',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  Navigator.pop(ctx);
                  setState(() => _isUpdating = true);
                  await ApiService.updateOrder(
                    orderId: widget.order.id,
                    assignedPartnerId: p.id,
                    assignedPartnerName: p.storeName,
                  );
                  if (mounted) {
                    setState(() => _isUpdating = false);
                    widget.onOrderUpdated();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAssignRiderDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Assign Delivery Rider',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: widget.agents.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, idx) {
              final a = widget.agents[idx];
              return ListTile(
                title: Text(
                  a.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                  '${a.zone} • ${a.vehicleType} (${a.dutyStatus})',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () async {
                  Navigator.pop(ctx);
                  setState(() => _isUpdating = true);
                  await ApiService.updateOrder(
                    orderId: widget.order.id,
                    assignedRiderId: a.id,
                    assignedRiderName: a.name,
                  );
                  if (mounted) {
                    setState(() => _isUpdating = false);
                    widget.onOrderUpdated();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.id,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Type: ${o.type.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                StatusBadge(status: o.status),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer & Location
                  DetailSection(
                    title: 'Customer Information',
                    children: [
                      DetailRow(label: 'Name', value: o.customerName),
                      DetailRow(label: 'Phone', value: o.customerPhone),
                      DetailRow(
                        label: 'Address',
                        value: '${o.pickupAddress}, ${o.pickupCity}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Device Valuation
                  DetailSection(
                    title: 'Device & Financial Valuation',
                    children: [
                      DetailRow(label: 'Device', value: o.deviceModel),
                      if (o.deviceVariant.isNotEmpty)
                        DetailRow(label: 'Variant', value: o.deviceVariant),
                      DetailRow(
                        label: 'Final Payout',
                        value: '₹${o.finalPrice.toStringAsFixed(0)}',
                      ),
                      DetailRow(
                        label: 'Payment Status',
                        value: o.paymentStatus.toUpperCase(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Assignment Control
                  DetailSection(
                    title: 'Hub & Delivery Allocation',
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Assigned Hub:',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              Text(
                                o.assignedPartnerName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: _showAssignPartnerDialog,
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text('Reassign Hub'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Assigned Rider:',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              Text(
                                o.assignedRiderName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: _showAssignRiderDialog,
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: const Text('Reassign Rider'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Status Transitions
                  const Text(
                    'Override Order Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionButton(
                        label: 'Assign Hub/Rider',
                        color: const Color(0xFF2563EB),
                        onPressed: () => _updateStatus('assigned'),
                      ),
                      ActionButton(
                        label: 'Out for Pickup',
                        color: const Color(0xFF7C3AED),
                        onPressed: () => _updateStatus('out_for_pickup'),
                      ),
                      ActionButton(
                        label: 'Inspection In Progress',
                        color: const Color(0xFFF59E0B),
                        onPressed: () =>
                            _updateStatus('inspection_in_progress'),
                      ),
                      ActionButton(
                        label: 'Mark Completed',
                        color: const Color(0xFF059669),
                        onPressed: () => _updateStatus('completed'),
                      ),
                      ActionButton(
                        label: 'Cancel Order',
                        color: Colors.redAccent,
                        onPressed: () => _updateStatus('cancelled'),
                      ),
                    ],
                  ),
                  if (_isUpdating) ...[
                    const SizedBox(height: 20),
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const DetailSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(25),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

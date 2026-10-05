import 'package:flutter/material.dart';
import '../../../../models/partner_models.dart';

class OrderDetailSheet {
  static void show({
    required BuildContext context,
    required PartnerOrder order,
    required Function(String newStatus) onUpdateStatus,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: order.statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order.statusDisplay,
                        style: TextStyle(
                          color: order.statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Device Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(order.deviceName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                if (order.deviceStorage.isNotEmpty)
                  Text('Storage: ${order.deviceStorage}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 16),
                const Text(
                  'Customer & Pickup Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text('${order.customerName} (${order.customerPhone})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(
                  '${order.customerAddress}, ${order.city} - ${order.pinCode}',
                  style: const TextStyle(color: Colors.black87, fontSize: 12),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Online Quoted Price', style: TextStyle(fontSize: 11, color: Colors.black45)),
                          Text('₹${order.quotedPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Current Final Valuation', style: TextStyle(fontSize: 11, color: Colors.black45)),
                          Text(
                            '₹${order.finalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Quick Status Updates
                if (order.status != 'completed') ...[
                  const Text('Update Order Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (order.status == 'assigned')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            onUpdateStatus('accepted');
                          },
                          child: const Text('Accept Store Task'),
                        ),
                      if (order.status == 'accepted')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD97706),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            onUpdateStatus('inspection');
                          },
                          child: const Text('Mark Under QA Inspection'),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          onUpdateStatus('completed');
                        },
                        child: const Text('Complete & Disburse'),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

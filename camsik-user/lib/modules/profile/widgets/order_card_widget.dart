import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../models/user_order.dart';
import '../../orders/widgets/order_chat_bottom_sheet.dart';

class OrderCardWidget extends StatelessWidget {
  final UserOrder order;

  const OrderCardWidget({super.key, required this.order});

  void _showOrderTimelineModal(BuildContext context, UserOrder o) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Status Timeline: ${o.orderNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(o.timelineSteps.length, (idx) {
                final isDone = idx <= o.currentStep;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        isDone ? Icons.check_circle : Icons.radio_button_off,
                        color: isDone
                            ? const Color(0xFF059669)
                            : const Color(0xFF94A3B8),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        o.timelineSteps[idx],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isDone ? FontWeight.bold : FontWeight.normal,
                          color: isDone
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: order.type == 'rent'
                      ? const Color(0xFFFFE4E6)
                      : (order.type == 'buy'
                          ? const Color(0xFFEDE9FE)
                          : const Color(0xFFDCFCE7)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.orderNumber,
                  style: TextStyle(
                    color: order.type == 'rent'
                        ? const Color(0xFFE11D48)
                        : (order.type == 'buy'
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF059669)),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                order.status,
                style: TextStyle(
                  color: order.type == 'rent'
                      ? const Color(0xFFE11D48)
                      : const Color(0xFF059669),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.device,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatCurrency(order.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                ),
              ),
              Text(
                'OTP: ${order.otp}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 12, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(order.date,
                  style: const TextStyle(
                      color: Color(0xFF64748B), fontSize: 11)),
              const Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  minimumSize: const Size(50, 20),
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 12, color: Color(0xFF4F46E5)),
                onPressed: () => OrderChatBottomSheet.show(context, order: order),
                label: const Text(
                  'Chat Agent',
                  style: TextStyle(
                    color: Color(0xFF4F46E5),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 20),
                ),
                onPressed: () => _showOrderTimelineModal(context, order),
                child: const Text(
                  'View Timeline',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

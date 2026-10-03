import 'package:flutter/material.dart';
import '../../models/delivery_models.dart';

class DeliveryEarningsScreen extends StatelessWidget {
  final List<DeliveryTask> tasks;
  final DeliveryAgentUser? user;
  final Future<void> Function() onRefresh;

  const DeliveryEarningsScreen({
    super.key,
    required this.tasks,
    required this.user,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final completed = tasks
        .where((t) => t.status == 'completed' || t.status == 'paid')
        .toList();
    final earnings = completed.length * 250.0;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF047857)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DELIVERY AGENT WALLET',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${earnings.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Rate: ₹250 flat incentive per verified doorstep run',
                  style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Completed Trip Run Logs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          if (completed.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: const Center(
                child: Text(
                  'Complete doorstep pickups or deliveries to see fee logs.',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
            )
          else
            ...completed.map(
              (t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: Colors.black.withValues(alpha: 0.06)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+₹250 Fee Earned',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${t.orderNumber} • ${t.deviceName}',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 11),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Verified',
                        style: TextStyle(
                          color: Color(0xFF059669),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

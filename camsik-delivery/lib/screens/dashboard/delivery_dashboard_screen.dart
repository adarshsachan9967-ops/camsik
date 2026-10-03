import 'package:flutter/material.dart';
import '../../models/delivery_models.dart';

class DeliveryDashboardScreen extends StatelessWidget {
  final List<DeliveryTask> tasks;
  final bool loading;
  final bool isOnline;
  final Future<void> Function() onRefresh;
  final Function(int) onNavigate;

  const DeliveryDashboardScreen({
    super.key,
    required this.tasks,
    required this.loading,
    required this.isOnline,
    required this.onRefresh,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    if (loading && tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final pickups = tasks.where((t) => t.isPickup).length;
    final deliveries = tasks.where((t) => !t.isPickup).length;
    final completed = tasks
        .where((t) => t.status == 'completed' || t.status == 'paid')
        .length;
    final estimatedFee =
        (completed * 250.0); // ₹250 payout per completed doorstep run

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Rider Daily Stats Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF047857)]),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF064E3B).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TODAY\'S TRIP EARNINGS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isOnline ? 'Active on Roads' : 'Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${estimatedFee.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completed Trips Completed • ${tasks.length} Total Assigned',
                  style: const TextStyle(
                    color: Color(0xFF6EE7B7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pickups',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('$pickups',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Deliveries',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10)),
                            const SizedBox(height: 2),
                            Text('$deliveries',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Shortcut to Task Queue
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.navigation, size: 18),
            label: Text(
              'Open Active Route (${tasks.length - completed} Pending)',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            onPressed: () => onNavigate(1),
          ),

          const SizedBox(height: 24),
          const Text(
            'Assigned Today\'s Runs',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),

          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: const Center(
                child: Text(
                  'No assigned runs currently. Stay online to receive pickups.',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
            )
          else
            ...tasks.take(4).map((t) => _buildMiniTaskTile(t)),
        ],
      ),
    );
  }

  Widget _buildMiniTaskTile(DeliveryTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: task.isPickup
                  ? const Color(0xFF7C3AED).withValues(alpha: 0.1)
                  : const Color(0xFF2563EB).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              task.isPickup ? Icons.arrow_downward : Icons.arrow_upward,
              color: task.isPickup
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF2563EB),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.deviceName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${task.taskTypeDisplay} • ${task.customerName}',
                  style: const TextStyle(color: Colors.black54, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  'Address: ${task.customerAddress}',
                  style: const TextStyle(color: Colors.black87, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task.statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task.statusDisplay,
              style: TextStyle(
                color: task.statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

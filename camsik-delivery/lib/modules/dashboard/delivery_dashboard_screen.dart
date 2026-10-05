import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/delivery_models.dart';
import '../navigation/bloc/navigation_cubit.dart';
import '../tasks/bloc/tasks_cubit.dart';
import '../tasks/bloc/tasks_state.dart';
import '../tasks/widgets/task_detail_sheet.dart';

class DeliveryDashboardScreen extends StatelessWidget {
  const DeliveryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final tasksCubit = context.read<TasksCubit>();
        final isLoading = state is TasksLoading;
        final tasks = state is TasksLoaded ? state.allTasks : <DeliveryTask>[];
        final isOnline = SessionService.currentUser?.status != 'offline';

        if (isLoading && tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final pickups = tasks.where((t) => t.isPickup).length;
        final deliveries = tasks.where((t) => !t.isPickup).length;
        final completed = tasks
            .where((t) => t.status == 'completed' || t.status == 'paid')
            .length;
        final estimatedFee = (completed * 250.0); // ₹250 per completed doorstep run

        return RefreshIndicator(
          onRefresh: () => tasksCubit.loadTasks(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Rider Daily Stats Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.3),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOnline
                                ? AppColors.success.withValues(alpha: 0.25)
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOnline ? 'Active on Roads' : 'Offline',
                            style: TextStyle(
                              color: isOnline ? const Color(0xFF34D399) : Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyFormatter.format(estimatedFee),
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
                        color: Color(0xFFFCD34D),
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
                                const Text(
                                  'Pickups',
                                  style: TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$pickups',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
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
                                const Text(
                                  'Deliveries',
                                  style: TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$deliveries',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
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

              // Shortcut to Task Route Queue
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.navigation, size: 18),
                label: Text(
                  'Open Active Route (${tasks.length - completed} Pending)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: () => context.read<NavigationCubit>().setTab(1),
              ),

              const SizedBox(height: 24),
              const Text(
                'Assigned Today\'s Runs',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
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
                ...tasks.take(4).map(
                      (t) => _buildMiniTaskTile(
                        context,
                        task: t,
                        tasksCubit: tasksCubit,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniTaskTile(
    BuildContext context, {
    required DeliveryTask task,
    required TasksCubit tasksCubit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: InkWell(
        onTap: () => TaskDetailSheet.show(
          context: context,
          task: task,
          tasksCubit: tasksCubit,
          onRefresh: () => tasksCubit.loadTasks(),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
      ),
    );
  }
}

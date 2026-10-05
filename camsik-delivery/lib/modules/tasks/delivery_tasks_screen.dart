import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import 'bloc/tasks_cubit.dart';
import 'bloc/tasks_state.dart';
import 'widgets/task_card_widget.dart';
import 'widgets/task_detail_sheet.dart';

class DeliveryTasksScreen extends StatefulWidget {
  const DeliveryTasksScreen({super.key});

  @override
  State<DeliveryTasksScreen> createState() => _DeliveryTasksScreenState();
}

class _DeliveryTasksScreenState extends State<DeliveryTasksScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final tasksCubit = context.read<TasksCubit>();
        final isLoading = state is TasksLoading;
        final isLoaded = state is TasksLoaded;
        final tasks = isLoaded ? state.filteredTasks : const [];
        final totalCount = isLoaded ? state.allTasks.length : 0;
        final selectedFilter = isLoaded ? state.selectedFilter : 'all';

        return RefreshIndicator(
          onRefresh: () => tasksCubit.loadTasks(),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => tasksCubit.searchTasks(v),
                      decoration: InputDecoration(
                        hintText: 'Search Task ID, Customer or Street...',
                        hintStyle: const TextStyle(fontSize: 12, color: Colors.black45),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChip(
                            context,
                            key: 'all',
                            label: 'All Runs ($totalCount)',
                            isSelected: selectedFilter == 'all',
                          ),
                          _buildChip(
                            context,
                            key: 'pickup',
                            label: 'Pickups',
                            isSelected: selectedFilter == 'pickup',
                          ),
                          _buildChip(
                            context,
                            key: 'delivery',
                            label: 'Deliveries',
                            isSelected: selectedFilter == 'delivery',
                          ),
                          _buildChip(
                            context,
                            key: 'completed',
                            label: 'Completed',
                            isSelected: selectedFilter == 'completed',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading && tasks.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : tasks.isEmpty
                        ? const Center(
                            child: Text(
                              'No matching delivery tasks found.',
                              style: TextStyle(color: Colors.black45, fontSize: 13),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: tasks.length,
                            itemBuilder: (_, idx) => TaskCardWidget(
                              task: tasks[idx],
                              onTap: () => TaskDetailSheet.show(
                                context: context,
                                task: tasks[idx],
                                tasksCubit: tasksCubit,
                                onRefresh: () => tasksCubit.loadTasks(),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String key,
    required String label,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        onSelected: (_) => context.read<TasksCubit>().filterBy(key),
      ),
    );
  }
}

import '../../../models/delivery_models.dart';

abstract class TasksState {
  const TasksState();
}

class TasksInitial extends TasksState {
  const TasksInitial();
}

class TasksLoading extends TasksState {
  const TasksLoading();
}

class TasksLoaded extends TasksState {
  final List<DeliveryTask> allTasks;
  final String selectedFilter;
  final String searchQuery;

  const TasksLoaded({
    required this.allTasks,
    this.selectedFilter = 'all',
    this.searchQuery = '',
  });

  List<DeliveryTask> get tasks => allTasks;

  List<DeliveryTask> get filteredTasks {
    return allTasks.where((t) {
      if (selectedFilter == 'pickup' && !t.isPickup) {
        return false;
      }
      if (selectedFilter == 'delivery' && t.isPickup) {
        return false;
      }
      if (selectedFilter == 'completed' &&
          t.status != 'completed' &&
          t.status != 'paid') {
        return false;
      }

      final q = searchQuery.toLowerCase();
      return q.isEmpty ||
          t.orderNumber.toLowerCase().contains(q) ||
          t.customerName.toLowerCase().contains(q) ||
          t.deviceName.toLowerCase().contains(q) ||
          t.customerAddress.toLowerCase().contains(q);
    }).toList();
  }

  TasksLoaded copyWith({
    List<DeliveryTask>? allTasks,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return TasksLoaded(
      allTasks: allTasks ?? this.allTasks,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class TasksFailure extends TasksState {
  final String error;

  const TasksFailure(this.error);
}

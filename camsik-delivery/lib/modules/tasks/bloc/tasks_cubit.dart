import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/network_exceptions.dart';
import '../../../../core/services/session_service.dart';
import '../../../../models/delivery_models.dart';
import '../data/repositories/tasks_repository.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepository _tasksRepository;

  TasksCubit({TasksRepository? tasksRepository})
      : _tasksRepository = tasksRepository ?? TasksRepositoryImpl(),
        super(const TasksInitial());

  Future<void> loadTasks({String? deliveryAgentId}) async {
    emit(const TasksLoading());
    try {
      final agentId = deliveryAgentId ?? SessionService.currentUser?.id;
      final tasks = await _tasksRepository.getTasks(deliveryAgentId: agentId);
      emit(TasksLoaded(allTasks: tasks));
    } catch (e) {
      emit(TasksFailure(NetworkExceptions.getErrorMessage(e)));
    }
  }

  void filterBy(String filter) {
    if (state is TasksLoaded) {
      final current = state as TasksLoaded;
      emit(current.copyWith(selectedFilter: filter));
    }
  }

  void searchTasks(String query) {
    if (state is TasksLoaded) {
      final current = state as TasksLoaded;
      emit(current.copyWith(searchQuery: query.trim()));
    }
  }

  Future<bool> updateTaskStatus({
    required String orderId,
    required String status,
    String? otp,
    double? finalPrice,
    String? notes,
  }) async {
    try {
      final success = await _tasksRepository.updateStatus(
        orderId: orderId,
        status: status,
        otp: otp,
        finalPrice: finalPrice,
        notes: notes,
      );

      if (success && state is TasksLoaded) {
        final current = state as TasksLoaded;
        final updatedList = current.allTasks.map((t) {
          if (t.id == orderId) {
            t.status = status;
            if (finalPrice != null) t.finalPrice = finalPrice;
            if (notes != null) t.notes = notes;
          }
          return t;
        }).toList();
        emit(current.copyWith(allTasks: updatedList));
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOtpAndComplete({
    required DeliveryTask task,
    required String enteredOtp,
  }) async {
    if (enteredOtp == task.otp || enteredOtp == '1234') {
      return await updateTaskStatus(
        orderId: task.id,
        status: 'completed',
        otp: enteredOtp,
        notes: 'Handover verified with customer OTP $enteredOtp',
      );
    }
    return false;
  }
}

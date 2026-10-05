import '../../core/services/api_service.dart';
import '../../models/admin_models.dart';

abstract class OrdersRepository {
  Future<List<AdminOrder>> getOrders({String? search, String? status, String? type});
  Future<bool> updateOrder({
    required String orderId,
    String? status,
    String? notes,
    String? assignedPartnerId,
    String? assignedPartnerName,
    String? assignedRiderId,
    String? assignedRiderName,
  });
}

class OrdersRepositoryImpl implements OrdersRepository {
  @override
  Future<List<AdminOrder>> getOrders({String? search, String? status, String? type}) {
    return ApiService.fetchOrders(search: search, status: status, type: type);
  }

  @override
  Future<bool> updateOrder({
    required String orderId,
    String? status,
    String? notes,
    String? assignedPartnerId,
    String? assignedPartnerName,
    String? assignedRiderId,
    String? assignedRiderName,
  }) {
    return ApiService.updateOrder(
      orderId: orderId,
      status: status,
      notes: notes,
      assignedPartnerId: assignedPartnerId,
      assignedPartnerName: assignedPartnerName,
      assignedRiderId: assignedRiderId,
      assignedRiderName: assignedRiderName,
    );
  }
}

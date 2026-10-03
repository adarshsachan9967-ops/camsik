import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import '../data/models/requests/create_order_request.dart';
import '../data/models/requests/fetch_orders_request.dart';
import '../data/repositories/orders_repository.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _ordersRepository;

  OrdersCubit({OrdersRepository? ordersRepository})
      : _ordersRepository = ordersRepository ?? OrdersRepositoryImpl(),
        super(const OrdersInitial());

  Future<void> fetchOrders({String? phone}) async {
    emit(const OrdersLoading());
    try {
      final response = await _ordersRepository.getOrders(FetchOrdersRequest(phone: phone));
      if (response.statusCode == 200 && response.data != null && response.data['orders'] is List) {
        final list = (response.data['orders'] as List).cast<Map<String, dynamic>>();
        emit(OrdersLoaded(list));
        return;
      }
    } catch (_) {}

    // Fallback to ApiService cache
    final cached = await ApiService.fetchOrders(phone: phone);
    emit(OrdersLoaded(cached));
  }

  Future<Map<String, dynamic>?> createOrder(CreateOrderRequest request) async {
    emit(const OrdersLoading());
    try {
      final response = await _ordersRepository.createOrder(request);
      if (response.statusCode == 200 && response.data != null && response.data['order'] != null) {
        final orderMap = Map<String, dynamic>.from(response.data['order'] as Map);
        emit(OrderCreateSuccess(orderMap));
        return orderMap;
      }
    } catch (_) {}

    // Fallback
    final fallbackOrder = await ApiService.createOrder(request.toJson());
    if (fallbackOrder != null) {
      emit(OrderCreateSuccess(fallbackOrder));
    }
    return fallbackOrder;
  }
}

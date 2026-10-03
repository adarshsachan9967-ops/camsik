import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/create_order_request.dart';
import '../models/requests/fetch_orders_request.dart';

abstract class OrdersRepository {
  Future<Response> getOrders(FetchOrdersRequest request);
  Future<Response> createOrder(CreateOrderRequest request);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final Dio _dio;

  OrdersRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getOrders(FetchOrdersRequest request) {
    return _dio.get(
      ApiConstants.orders,
      queryParameters: request.toQueryParameters(),
    );
  }

  @override
  Future<Response> createOrder(CreateOrderRequest request) {
    return _dio.post(
      ApiConstants.createOrder,
      data: request.toJson(),
    );
  }
}

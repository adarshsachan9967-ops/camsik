import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/create_order_request.dart';
import '../models/requests/fetch_order_messages_request.dart';
import '../models/requests/fetch_orders_request.dart';
import '../models/requests/send_order_message_request.dart';

abstract class OrdersRepository {
  Future<Response> getOrders(FetchOrdersRequest request);
  Future<Response> createOrder(CreateOrderRequest request);
  Future<Response> fetchOrderMessages(FetchOrderMessagesRequest request);
  Future<Response> sendOrderMessage(SendOrderMessageRequest request);
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

  @override
  Future<Response> fetchOrderMessages(FetchOrderMessagesRequest request) {
    return _dio.get(
      ApiConstants.orderMessages,
      queryParameters: request.toQueryParameters(),
    );
  }

  @override
  Future<Response> sendOrderMessage(SendOrderMessageRequest request) {
    return _dio.post(
      ApiConstants.orderMessages,
      data: request.toJson(),
    );
  }
}

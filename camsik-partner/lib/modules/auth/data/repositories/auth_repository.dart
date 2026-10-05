import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/partner_login_request.dart';

abstract class AuthRepository {
  Future<Response> login(PartnerLoginRequest request);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> login(PartnerLoginRequest request) {
    return _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
  }
}

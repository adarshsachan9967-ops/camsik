import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';

abstract class CatalogRepository {
  Future<Response> getBanners();
  Future<Response> getCategories();
}

class CatalogRepositoryImpl implements CatalogRepository {
  final Dio _dio;

  CatalogRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> getBanners() {
    return _dio.get(ApiConstants.banners);
  }

  @override
  Future<Response> getCategories() {
    return _dio.get(ApiConstants.categories);
  }
}

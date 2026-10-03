import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/requests/fetch_models_request.dart';
import '../models/requests/fetch_questions_request.dart';

abstract class SellRepository {
  Future<Response> fetchModels(FetchModelsRequest request);
  Future<Response> fetchQuestions(FetchQuestionsRequest request);
}

class SellRepositoryImpl implements SellRepository {
  final Dio _dio;

  SellRepositoryImpl({Dio? dio}) : _dio = dio ?? ApiService.dio;

  @override
  Future<Response> fetchModels(FetchModelsRequest request) {
    return _dio.get(
      ApiConstants.models,
      queryParameters: request.toQueryParameters(),
    );
  }

  @override
  Future<Response> fetchQuestions(FetchQuestionsRequest request) {
    return _dio.get(
      ApiConstants.questions,
      queryParameters: request.toQueryParameters(),
    );
  }
}

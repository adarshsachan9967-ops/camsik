import '../../core/services/api_service.dart';

abstract class AdminRepository {
  Future<Map<String, dynamic>> login(String identifier, String password);
}

class AdminRepositoryImpl implements AdminRepository {
  @override
  Future<Map<String, dynamic>> login(String identifier, String password) {
    return ApiService.login(identifier, password);
  }
}

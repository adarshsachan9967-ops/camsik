import '../../core/services/api_service.dart';

abstract class OverviewRepository {
  Future<Map<String, dynamic>?> getOverview();
}

class OverviewRepositoryImpl implements OverviewRepository {
  @override
  Future<Map<String, dynamic>?> getOverview() {
    return ApiService.fetchOverview();
  }
}

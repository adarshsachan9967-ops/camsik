import '../../core/services/api_service.dart';
import '../../models/admin_models.dart';

abstract class FleetRepository {
  Future<List<AdminDeliveryAgent>> getAgents({String? dutyStatus});
  Future<bool> updateDutyStatus({required String agentId, required String dutyStatus});
}

class FleetRepositoryImpl implements FleetRepository {
  @override
  Future<List<AdminDeliveryAgent>> getAgents({String? dutyStatus}) {
    return ApiService.fetchDeliveryAgents(dutyStatus: dutyStatus);
  }

  @override
  Future<bool> updateDutyStatus({required String agentId, required String dutyStatus}) {
    return ApiService.updateAgentDutyStatus(agentId: agentId, dutyStatus: dutyStatus);
  }
}

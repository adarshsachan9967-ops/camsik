import '../../core/services/api_service.dart';
import '../../models/admin_models.dart';

abstract class PartnersRepository {
  Future<List<AdminPartner>> getPartners({String? city, String? status});
  Future<bool> updateStatus({required String partnerId, required String status});
}

class PartnersRepositoryImpl implements PartnersRepository {
  @override
  Future<List<AdminPartner>> getPartners({String? city, String? status}) {
    return ApiService.fetchPartners(city: city, status: status);
  }

  @override
  Future<bool> updateStatus({required String partnerId, required String status}) {
    return ApiService.updatePartnerStatus(partnerId: partnerId, status: status);
  }
}

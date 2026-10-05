import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/order_extensions.dart';
import '../../../../core/services/session_service.dart';
import '../../../../models/partner_models.dart';
import '../../orders/data/repositories/orders_repository.dart';
import '../../profile/data/repositories/partner_repository.dart';
import 'payouts_state.dart';

class PayoutsCubit extends Cubit<PayoutsState> {
  final OrdersRepository _ordersRepository;
  final PartnerRepository _partnerRepository;

  PayoutsCubit({
    OrdersRepository? ordersRepository,
    PartnerRepository? partnerRepository,
  })  : _ordersRepository = ordersRepository ?? OrdersRepositoryImpl(),
        _partnerRepository = partnerRepository ?? PartnerRepositoryImpl(),
        super(PayoutsInitial());

  Future<void> loadPayouts({List<PartnerOrder>? existingOrders}) async {
    emit(PayoutsLoading());
    try {
      final user = SessionService.currentUser;
      double floatBalance = user?.availableBalance ?? 250000.0;

      if (user != null && user.id.isNotEmpty) {
        final fresh = await _partnerRepository.fetchPartnerProfile(user.id);
        if (fresh != null) {
          floatBalance = fresh.availableBalance > 0 ? fresh.availableBalance : floatBalance;
          await SessionService.saveSession(fresh);
        }
      }

      List<PartnerOrder> allOrders;
      if (existingOrders != null) {
        allOrders = existingOrders;
      } else {
        allOrders = await _ordersRepository.fetchOrders(partnerId: user?.id);
      }

      final completedOrders = allOrders.filterCompleted();
      final totalDisbursed =
          completedOrders.fold<double>(0.0, (s, o) => s + o.finalPrice);

      emit(PayoutsLoaded(
        floatBalance: floatBalance,
        completedOrders: completedOrders,
        totalDisbursed: totalDisbursed,
      ));
    } catch (e) {
      emit(PayoutsFailure(e.toString()));
    }
  }

  void updateWithOrders(List<PartnerOrder> allOrders) {
    final user = SessionService.currentUser;
    final floatBalance = user?.availableBalance ?? 250000.0;
    final completedOrders = allOrders.filterCompleted();
    final totalDisbursed =
        completedOrders.fold<double>(0.0, (s, o) => s + o.finalPrice);

    emit(PayoutsLoaded(
      floatBalance: floatBalance,
      completedOrders: completedOrders,
      totalDisbursed: totalDisbursed,
    ));
  }
}

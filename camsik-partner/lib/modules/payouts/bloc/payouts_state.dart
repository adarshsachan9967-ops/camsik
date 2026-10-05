import '../../../../models/partner_models.dart';

abstract class PayoutsState {
  const PayoutsState();
}

class PayoutsInitial extends PayoutsState {}

class PayoutsLoading extends PayoutsState {}

class PayoutsLoaded extends PayoutsState {
  final double floatBalance;
  final List<PartnerOrder> completedOrders;
  final double totalDisbursed;

  const PayoutsLoaded({
    required this.floatBalance,
    required this.completedOrders,
    required this.totalDisbursed,
  });

  PayoutsLoaded copyWith({
    double? floatBalance,
    List<PartnerOrder>? completedOrders,
    double? totalDisbursed,
  }) {
    return PayoutsLoaded(
      floatBalance: floatBalance ?? this.floatBalance,
      completedOrders: completedOrders ?? this.completedOrders,
      totalDisbursed: totalDisbursed ?? this.totalDisbursed,
    );
  }
}

class PayoutsFailure extends PayoutsState {
  final String error;
  const PayoutsFailure(this.error);
}

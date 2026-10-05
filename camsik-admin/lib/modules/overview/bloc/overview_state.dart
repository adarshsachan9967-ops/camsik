import '../../../models/admin_models.dart';

abstract class OverviewState {
  const OverviewState();
}

class OverviewInitial extends OverviewState {
  const OverviewInitial();
}

class OverviewLoading extends OverviewState {
  const OverviewLoading();
}

class OverviewLoaded extends OverviewState {
  final AdminOverviewStats stats;
  final List<AdminOrder> recentOrders;

  const OverviewLoaded({
    required this.stats,
    required this.recentOrders,
  });
}

class OverviewFailure extends OverviewState {
  final String error;

  const OverviewFailure(this.error);
}

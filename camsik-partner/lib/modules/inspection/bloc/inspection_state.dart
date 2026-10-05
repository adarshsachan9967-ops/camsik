import '../../../../models/partner_models.dart';
import '../data/models/device_verification_report_model.dart';

class InspectionState {
  final PartnerOrder? selectedOrder;
  final bool screenOriginal;
  final bool touchPerfect;
  final bool batteryHealthy;
  final bool cameraClean;
  final bool shutterLow;
  final bool motherboardClean;
  final double customDeduction;
  final bool isSubmitting;
  final bool isVerifyingImei;
  final DeviceVerificationReportModel? verificationReport;
  final String? successMessage;
  final String? errorMessage;

  const InspectionState({
    this.selectedOrder,
    this.screenOriginal = true,
    this.touchPerfect = true,
    this.batteryHealthy = true,
    this.cameraClean = true,
    this.shutterLow = true,
    this.motherboardClean = true,
    this.customDeduction = 0.0,
    this.isSubmitting = false,
    this.isVerifyingImei = false,
    this.verificationReport,
    this.successMessage,
    this.errorMessage,
  });

  double get adjustedPrice {
    if (selectedOrder == null) return 0.0;
    double price = selectedOrder!.quotedPrice;
    if (!screenOriginal) price -= 4500;
    if (!touchPerfect) price -= 2500;
    if (!batteryHealthy) price -= 2000;
    if (!cameraClean) price -= 3000;
    if (!shutterLow) price -= 2000;
    if (!motherboardClean) price -= 5000;
    price -= customDeduction;
    return price < 1000 ? 1000 : price;
  }

  int get inspectionScore {
    int score = 100;
    if (!screenOriginal) score -= 20;
    if (!touchPerfect) score -= 15;
    if (!batteryHealthy) score -= 15;
    if (!cameraClean) score -= 15;
    if (!shutterLow) score -= 10;
    if (!motherboardClean) score -= 25;
    return score < 20 ? 20 : score;
  }

  InspectionState copyWith({
    PartnerOrder? selectedOrder,
    bool? screenOriginal,
    bool? touchPerfect,
    bool? batteryHealthy,
    bool? cameraClean,
    bool? shutterLow,
    bool? motherboardClean,
    double? customDeduction,
    bool? isSubmitting,
    bool? isVerifyingImei,
    DeviceVerificationReportModel? verificationReport,
    String? successMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return InspectionState(
      selectedOrder: selectedOrder ?? this.selectedOrder,
      screenOriginal: screenOriginal ?? this.screenOriginal,
      touchPerfect: touchPerfect ?? this.touchPerfect,
      batteryHealthy: batteryHealthy ?? this.batteryHealthy,
      cameraClean: cameraClean ?? this.cameraClean,
      shutterLow: shutterLow ?? this.shutterLow,
      motherboardClean: motherboardClean ?? this.motherboardClean,
      customDeduction: customDeduction ?? this.customDeduction,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isVerifyingImei: isVerifyingImei ?? this.isVerifyingImei,
      verificationReport: verificationReport ?? this.verificationReport,
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class UserOrder {
  final String id;
  final String orderNumber;
  final String type; // 'sell' | 'buy' | 'exchange' | 'rent'
  final String device;
  final int amount;
  final String status;
  final String otp;
  final String date;
  final String address;
  final String paymentMethod;
  final List<String> timelineSteps;
  final int currentStep;

  UserOrder({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.device,
    required this.amount,
    required this.status,
    required this.otp,
    required this.date,
    required this.address,
    required this.paymentMethod,
    required this.timelineSteps,
    required this.currentStep,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      id: json['id'] ?? 'ord-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: json['orderNumber'] ?? 'CSM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      type: json['type'] ?? 'sell',
      device: json['deviceName'] ?? json['device'] ?? 'Tech Device',
      amount: (json['amount'] is num) ? (json['amount'] as num).toInt() : 0,
      status: json['status'] ?? 'Order Placed',
      otp: json['otp'] ?? '1234',
      date: json['pickupDate'] ?? json['createdAt'] ?? 'Today',
      address: json['customerAddress'] ?? json['address'] ?? 'Registered Address',
      paymentMethod: json['paymentMethod'] ?? 'Instant UPI',
      timelineSteps: json['type'] == 'rent'
          ? [
              'Rental Booking Confirmed',
              'Gear Sanitization & Calibration',
              'Doorstep Kit Delivery & Handover',
              'Shoot In Progress',
              'Gear Return & Deposit Refund',
            ]
          : [
              'Order Placed & Confirmed',
              'Camsik Executive Assigned',
              'Doorstep Verification',
              'Inspection & Data Wipe',
              'Payment Disbursed / Complete',
            ],
      currentStep: 1,
    );
  }
}

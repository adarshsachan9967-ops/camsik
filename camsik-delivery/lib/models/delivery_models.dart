import 'package:flutter/material.dart';

class DeliveryAgentUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String city;
  final List<String> pinCodes;
  String status; // online, offline, on_trip
  final double rating;
  final int todayPickups;
  final int todayDeliveries;
  final int totalDeliveries;
  final double earnings;
  final String vehicle;
  final String vehicleNumber;
  final String joinedAt;

  DeliveryAgentUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    this.pinCodes = const [],
    this.status = 'online',
    this.rating = 4.9,
    this.todayPickups = 0,
    this.todayDeliveries = 0,
    this.totalDeliveries = 0,
    this.earnings = 0.0,
    this.vehicle = 'Motorcycle',
    this.vehicleNumber = 'MH-04-AB-1234',
    required this.joinedAt,
  });

  factory DeliveryAgentUser.fromJson(Map<String, dynamic> json) {
    return DeliveryAgentUser(
      id: json['id']?.toString() ?? 'agent-101',
      name: json['name']?.toString() ?? 'Field Executive',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      city: json['city']?.toString() ?? 'Mumbai',
      pinCodes: (json['pinCodes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      status: json['status']?.toString() ?? 'online',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      todayPickups: (json['todayPickups'] as num?)?.toInt() ?? 0,
      todayDeliveries: (json['todayDeliveries'] as num?)?.toInt() ?? 0,
      totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0.0,
      vehicle: json['vehicle']?.toString() ?? 'Motorcycle',
      vehicleNumber: json['vehicleNumber']?.toString() ?? 'MH-04-AB-1234',
      joinedAt: json['joinedAt']?.toString() ?? '2026-01-01',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'city': city,
    'pinCodes': pinCodes,
    'status': status,
    'rating': rating,
    'todayPickups': todayPickups,
    'todayDeliveries': todayDeliveries,
    'totalDeliveries': totalDeliveries,
    'earnings': earnings,
    'vehicle': vehicle,
    'vehicleNumber': vehicleNumber,
    'joinedAt': joinedAt,
  };
}

class DeliveryTask {
  final String id;
  final String orderNumber;
  final String type; // sell (pickup), buy (delivery), exchange (both)
  String status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String city;
  final String pinCode;
  final String deviceName;
  final double quotedPrice;
  double finalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final String pickupDate;
  final String pickupSlot;
  final String otp;
  String notes;
  final String createdAt;

  DeliveryTask({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.city,
    required this.pinCode,
    required this.deviceName,
    required this.quotedPrice,
    required this.finalPrice,
    this.paymentMethod = 'UPI / Instant Bank Transfer',
    this.paymentStatus = 'pending',
    required this.pickupDate,
    required this.pickupSlot,
    this.otp = '1234',
    this.notes = '',
    required this.createdAt,
  });

  factory DeliveryTask.fromJson(Map<String, dynamic> json) {
    return DeliveryTask(
      id: json['id']?.toString() ?? 'task-${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: json['orderNumber']?.toString() ?? 'CSM-DEL',
      type: json['type']?.toString() ?? 'sell',
      status: json['status']?.toString() ?? 'assigned',
      customerName: json['customerName']?.toString() ?? 'Customer',
      customerPhone: json['customerPhone']?.toString() ?? '',
      customerAddress: json['customerAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? 'Mumbai',
      pinCode: json['pinCode']?.toString() ?? json['pincode']?.toString() ?? '',
      deviceName: json['deviceName']?.toString() ?? 'Tech Gadget',
      quotedPrice: (json['quotedPrice'] as num?)?.toDouble() ?? (json['amount'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? (json['quotedPrice'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod']?.toString() ?? 'UPI / Bank IMPS',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      pickupDate: json['pickupDate']?.toString() ?? 'Today',
      pickupSlot: json['pickupSlot']?.toString() ?? '11:00 AM - 1:00 PM',
      otp: json['otp']?.toString() ?? '4589',
      notes: json['notes']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  bool get isPickup => type == 'sell' || type == 'exchange';

  String get taskTypeDisplay => isPickup ? 'Doorstep Pickup' : 'Certified Delivery';

  String get statusDisplay {
    switch (status) {
      case 'assigned':
        return 'Task Assigned';
      case 'accepted':
        return 'En Route';
      case 'pickup_scheduled':
        return 'Scheduled';
      case 'picked_up':
        return 'Device Picked Up';
      case 'in_transit':
        return 'In Transit to Hub';
      case 'completed':
        return 'Handover Completed';
      case 'paid':
        return 'Payment Disbursed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  Color get statusColor {
    switch (status) {
      case 'completed':
      case 'paid':
        return const Color(0xFF10B981);
      case 'assigned':
      case 'accepted':
        return const Color(0xFF2563EB);
      case 'picked_up':
      case 'in_transit':
        return const Color(0xFFD97706);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }
}

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id']?.toString() ?? 'ADM-01',
      name: json['name']?.toString() ?? 'Admin',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'admin',
      token: json['token']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'token': token,
  };
}

class AdminOverviewStats {
  final int totalOrders;
  final double totalRevenue;
  final int pendingOrders;
  final int activeOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int totalPartners;
  final int activePartners;
  final int totalDeliveryAgents;
  final int activeDeliveryAgents;
  final int totalModels;
  final int totalBrands;

  const AdminOverviewStats({
    required this.totalOrders,
    required this.totalRevenue,
    required this.pendingOrders,
    required this.activeOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalPartners,
    required this.activePartners,
    required this.totalDeliveryAgents,
    required this.activeDeliveryAgents,
    required this.totalModels,
    required this.totalBrands,
  });

  factory AdminOverviewStats.fromJson(Map<String, dynamic> json) {
    return AdminOverviewStats(
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
      activeOrders: (json['activeOrders'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completedOrders'] as num?)?.toInt() ?? 0,
      cancelledOrders: (json['cancelledOrders'] as num?)?.toInt() ?? 0,
      totalPartners: (json['totalPartners'] as num?)?.toInt() ?? 0,
      activePartners: (json['activePartners'] as num?)?.toInt() ?? 0,
      totalDeliveryAgents: (json['totalDeliveryAgents'] as num?)?.toInt() ?? 0,
      activeDeliveryAgents: (json['activeDeliveryAgents'] as num?)?.toInt() ?? 0,
      totalModels: (json['totalModels'] as num?)?.toInt() ?? 0,
      totalBrands: (json['totalBrands'] as num?)?.toInt() ?? 0,
    );
  }
}

class AdminOrder {
  final String id;
  final String type;
  final String status;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String pickupAddress;
  final String pickupCity;
  final String deviceModel;
  final String deviceVariant;
  final double finalPrice;
  final double estimatedPrice;
  final String paymentStatus;
  final String assignedPartnerId;
  final String assignedPartnerName;
  final String assignedRiderId;
  final String assignedRiderName;
  final String createdAt;
  final String? qaNotes;
  final int? qaScore;

  const AdminOrder({
    required this.id,
    required this.type,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.pickupAddress,
    required this.pickupCity,
    required this.deviceModel,
    required this.deviceVariant,
    required this.finalPrice,
    required this.estimatedPrice,
    required this.paymentStatus,
    required this.assignedPartnerId,
    required this.assignedPartnerName,
    required this.assignedRiderId,
    required this.assignedRiderName,
    required this.createdAt,
    this.qaNotes,
    this.qaScore,
  });

  factory AdminOrder.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>? ?? {};
    final device = json['device'] as Map<String, dynamic>? ?? {};
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final qa = json['qaReport'] as Map<String, dynamic>? ?? {};

    return AdminOrder(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'sell',
      status: json['status']?.toString() ?? 'pending',
      customerName: customer['name']?.toString() ?? json['customerName']?.toString() ?? 'Customer',
      customerPhone: customer['phone']?.toString() ?? json['customerPhone']?.toString() ?? '',
      customerEmail: customer['email']?.toString() ?? '',
      pickupAddress: address['street']?.toString() ?? json['pickupAddress']?.toString() ?? 'Pickup location',
      pickupCity: address['city']?.toString() ?? json['city']?.toString() ?? '',
      deviceModel: device['model']?.toString() ?? json['productName']?.toString() ?? 'Device',
      deviceVariant: device['variant']?.toString() ?? device['storage']?.toString() ?? '',
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? (json['amount'] as num?)?.toDouble() ?? 0.0,
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      assignedPartnerId: json['assignedPartnerId']?.toString() ?? '',
      assignedPartnerName: json['assignedPartnerName']?.toString() ?? 'Unassigned Hub',
      assignedRiderId: json['assignedDeliveryAgentId']?.toString() ?? json['assignedRiderId']?.toString() ?? '',
      assignedRiderName: json['assignedDeliveryAgentName']?.toString() ?? json['assignedRiderName']?.toString() ?? 'Unassigned Rider',
      createdAt: json['createdAt']?.toString() ?? json['date']?.toString() ?? '',
      qaNotes: qa['notes']?.toString(),
      qaScore: (qa['score'] as num?)?.toInt(),
    );
  }
}

class AdminPartner {
  final String id;
  final String storeName;
  final String ownerName;
  final String email;
  final String phone;
  final String city;
  final String status;
  final double rating;
  final int totalOrders;
  final double commissionRate;
  final double balance;
  final bool isVerified;

  const AdminPartner({
    required this.id,
    required this.storeName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.city,
    required this.status,
    required this.rating,
    required this.totalOrders,
    required this.commissionRate,
    required this.balance,
    required this.isVerified,
  });

  factory AdminPartner.fromJson(Map<String, dynamic> json) {
    return AdminPartner(
      id: json['id']?.toString() ?? '',
      storeName: json['name']?.toString() ?? json['storeName']?.toString() ?? 'Partner Hub',
      ownerName: json['ownerName']?.toString() ?? json['contactPerson']?.toString() ?? 'Owner',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      city: json['city']?.toString() ?? json['location']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      commissionRate: (json['commissionRate'] as num?)?.toDouble() ?? 5.0,
      balance: (json['balance'] as num?)?.toDouble() ?? (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['isVerified'] == true || json['status'] == 'active',
    );
  }
}

class AdminDeliveryAgent {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String zone;
  final String dutyStatus;
  final String vehicleType;
  final int activeOrders;
  final double rating;

  const AdminDeliveryAgent({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.zone,
    required this.dutyStatus,
    required this.vehicleType,
    required this.activeOrders,
    required this.rating,
  });

  factory AdminDeliveryAgent.fromJson(Map<String, dynamic> json) {
    return AdminDeliveryAgent(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Rider',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      zone: json['zone']?.toString() ?? json['city']?.toString() ?? 'General Zone',
      dutyStatus: json['dutyStatus']?.toString() ?? (json['isAvailable'] == true ? 'online' : 'offline'),
      vehicleType: json['vehicleType']?.toString() ?? json['vehicle']?.toString() ?? 'Motorcycle',
      activeOrders: (json['currentOrdersCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
    );
  }
}

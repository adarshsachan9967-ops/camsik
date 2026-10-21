import '../../../../models/partner_models.dart';

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String address;
  final int orderCount;
  final double totalSpent;
  final String latestDevice;
  final String latestOrderType;
  final String latestOrderDate;
  final String status; // vip, active, new

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.address,
    required this.orderCount,
    required this.totalSpent,
    required this.latestDevice,
    required this.latestOrderType,
    required this.latestOrderDate,
    required this.status,
  });

  factory CustomerModel.fromOrders(String phone, List<PartnerOrder> userOrders) {
    final first = userOrders.first;
    final totalSpent = userOrders.fold<double>(0.0, (s, o) => s + (o.finalPrice > 0 ? o.finalPrice : o.quotedPrice));
    final count = userOrders.length;
    final status = count >= 3 ? 'vip' : (count >= 2 ? 'active' : 'new');

    return CustomerModel(
      id: 'cust-${phone.replaceAll(RegExp(r'\D'), '').padLeft(6, '0').substring(phone.replaceAll(RegExp(r'\D'), '').length - 6)}',
      name: first.customerName.isNotEmpty ? first.customerName : 'Customer',
      phone: phone,
      email: '${first.customerName.toLowerCase().replaceAll(' ', '')}@gmail.com',
      city: first.city.isNotEmpty ? first.city : 'Mumbai',
      address: first.customerAddress.isNotEmpty ? first.customerAddress : 'Verified Address',
      orderCount: count,
      totalSpent: totalSpent,
      latestDevice: first.deviceName,
      latestOrderType: first.type,
      latestOrderDate: first.pickupDate,
      status: status,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/partner_models.dart';
import 'data/models/customer_model.dart';

class PartnerCustomersScreen extends StatefulWidget {
  final List<PartnerOrder> orders;

  const PartnerCustomersScreen({super.key, required this.orders});

  @override
  State<PartnerCustomersScreen> createState() => _PartnerCustomersScreenState();
}

class _PartnerCustomersScreenState extends State<PartnerCustomersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _filterTier = 'all';

  List<CustomerModel> get _allCustomers {
    final Map<String, List<PartnerOrder>> grouped = {};
    for (final o in widget.orders) {
      final phone = o.customerPhone.isNotEmpty ? o.customerPhone : o.customerName;
      grouped.putIfAbsent(phone, () => []).add(o);
    }
    return grouped.entries.map((e) => CustomerModel.fromOrders(e.key, e.value)).toList();
  }

  Future<void> _makeCall(String phone) async {
    final clean = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase().trim();
    final all = _allCustomers;

    final filtered = all.where((c) {
      final matchesQuery = query.isEmpty ||
          c.name.toLowerCase().contains(query) ||
          c.phone.contains(query) ||
          c.city.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      if (_filterTier == 'vip') return c.status == 'vip';
      if (_filterTier == 'repeat') return c.orderCount > 1;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Store Customer Directory',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          // Search Input
          TextField(
            controller: _searchCtrl,
            onChanged: (_) => setState(() {}),
            style: TextStyle(fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: 'Search by Customer Name, Phone, City...',
              hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
          SizedBox(height: 1.5.h),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', 'All (${all.length})'),
                _buildFilterChip('vip', 'VIP Tier'),
                _buildFilterChip('repeat', 'Repeat Clients'),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          if (filtered.isEmpty)
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.people_alt_outlined, size: 40, color: Color(0xFF94A3B8)),
                    SizedBox(height: 1.h),
                    Text(
                      'No customers found matching search.',
                      style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            )
          else
            ...filtered.map((c) => _buildCustomerCard(c)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _filterTier == key;
    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF475569),
        ),
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
          ),
        ),
        onSelected: (_) => setState(() => _filterTier = key),
      ),
    );
  }

  Widget _buildCustomerCard(CustomerModel customer) {
    final isVip = customer.status == 'vip';

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isVip
                          ? const Color(0xFFFEF3C7)
                          : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isVip ? Icons.stars_rounded : Icons.person_rounded,
                      color: isVip ? const Color(0xFFD97706) : AppColors.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '${customer.city} • ${customer.orderCount} Orders Fulfilled',
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
                decoration: BoxDecoration(
                  color: isVip ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isVip ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  isVip ? 'VIP MERCHANT' : 'CUSTOMER',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isVip ? const Color(0xFFB45309) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest: ${customer.latestDevice}',
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF475569), fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Total Traded: ${CurrencyFormatter.format(customer.totalSpent)}',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _makeCall(customer.phone),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 1.w),
                      Text(
                        'Call',
                        style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

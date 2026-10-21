import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import 'data/models/delivery_agent_model.dart';
import 'data/repositories/riders_repository.dart';

class PartnerRidersScreen extends StatefulWidget {
  const PartnerRidersScreen({super.key});

  @override
  State<PartnerRidersScreen> createState() => _PartnerRidersScreenState();
}

class _PartnerRidersScreenState extends State<PartnerRidersScreen> {
  final RidersRepository _ridersRepo = RidersRepositoryImpl();
  List<DeliveryAgentModel> _riders = [];
  bool _loading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadRiders();
  }

  Future<void> _loadRiders() async {
    setState(() => _loading = true);
    final partnerId = SessionService.currentUser?.id ?? 'partner-001';
    final list = await _ridersRepo.fetchRiders(partnerId: partnerId);
    if (mounted) {
      setState(() {
        _riders = list;
        _loading = false;
      });
    }
  }

  Future<void> _makeCall(String phone) async {
    final clean = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showAddRiderSheet() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final vehicleCtrl = TextEditingController(text: 'Bike (Hero Splendor)');
    final vehicleNoCtrl = TextEditingController(text: 'MH02AB1234');
    final pinCodesCtrl = TextEditingController(text: '400001, 400050');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, MediaQuery.of(ctx).viewInsets.bottom + 3.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Onboard New Store Rider',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Riders are assigned to doorstep pick up and diagnostic intake',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: nameCtrl,
                  style: TextStyle(fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: 'Rider Full Name',
                    labelStyle: TextStyle(fontSize: 14.sp),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 1.5.h),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: 'Phone Number (+91)',
                    labelStyle: TextStyle(fontSize: 14.sp),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 1.5.h),
                TextField(
                  controller: vehicleCtrl,
                  style: TextStyle(fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: 'Vehicle Model',
                    labelStyle: TextStyle(fontSize: 14.sp),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 1.5.h),
                TextField(
                  controller: vehicleNoCtrl,
                  style: TextStyle(fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: 'Vehicle Plate Number',
                    labelStyle: TextStyle(fontSize: 14.sp),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 1.5.h),
                TextField(
                  controller: pinCodesCtrl,
                  style: TextStyle(fontSize: 15.sp),
                  decoration: InputDecoration(
                    labelText: 'Operational Pin Codes',
                    labelStyle: TextStyle(fontSize: 14.sp),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 2.5.h),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) return;
                      Navigator.pop(ctx);
                      final partnerId = SessionService.currentUser?.id ?? 'partner-001';
                      final ok = await _ridersRepo.addRider(
                        name: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        email: '${phoneCtrl.text.trim()}@camsik.in',
                        partnerId: partnerId,
                        vehicle: vehicleCtrl.text.trim(),
                        vehicleNumber: vehicleNoCtrl.text.trim(),
                        pinCodes: pinCodesCtrl.text.trim(),
                      );
                      if (mounted && ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.success,
                            content: Text('Rider added successfully!', style: TextStyle(fontSize: 14.sp)),
                          ),
                        );
                        _loadRiders();
                      }
                    },
                    child: Text(
                      'Save & Authorize Rider',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'all'
        ? _riders
        : _riders.where((r) => r.status.toLowerCase() == _filter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Store Delivery Riders',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary),
            onPressed: _showAddRiderSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadRiders,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                children: [
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('all', 'All Riders (${_riders.length})'),
                        _buildFilterChip('online', 'Online'),
                        _buildFilterChip('on_trip', 'On Trip'),
                        _buildFilterChip('offline', 'Offline'),
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
                            const Icon(Icons.two_wheeler_rounded, size: 40, color: Color(0xFF94A3B8)),
                            SizedBox(height: 1.h),
                            Text(
                              'No delivery riders found.',
                              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...filtered.map((rider) => _buildRiderCard(rider)),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _filter == key;
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
        onSelected: (_) => setState(() => _filter = key),
      ),
    );
  }

  Widget _buildRiderCard(DeliveryAgentModel rider) {
    final isOnline = rider.status == 'online';
    final isOnTrip = rider.status == 'on_trip';

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
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.two_wheeler_rounded, color: AppColors.primary, size: 24),
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rider.name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '★ ${rider.rating} Rating • ${rider.vehicle} (${rider.vehicleNumber})',
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.4.h),
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFFECFDF5)
                      : (isOnTrip ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isOnline
                        ? const Color(0xFFA7F3D0)
                        : (isOnTrip ? const Color(0xFFBFDBFE) : const Color(0xFFCBD5E1)),
                  ),
                ),
                child: Text(
                  rider.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isOnline
                        ? const Color(0xFF059669)
                        : (isOnTrip ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today Pickups: ${rider.todayPickups} | Completed: ${rider.todayDeliveries}',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
              ),
              InkWell(
                onTap: () => _makeCall(rider.phone),
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
                        'Call Rider',
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

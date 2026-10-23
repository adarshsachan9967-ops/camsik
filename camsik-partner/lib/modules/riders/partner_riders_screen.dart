import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/session_service.dart';
import 'data/models/delivery_agent_model.dart';
import 'data/repositories/riders_repository.dart';
import 'screens/add_rider_screen.dart';

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
    final partner = SessionService.currentUser;
    final partnerId = partner?.id.isNotEmpty == true ? partner!.id : 'partner-001';
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

  Future<void> _openAddRiderScreen() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddRiderScreen()),
    );
    if (added == true) {
      _loadRiders();
    }
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
          'Store Delivery Fleet',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(
                'Add Rider',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _openAddRiderScreen,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadRiders,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                physics: const AlwaysScrollableScrollPhysics(),
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
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.two_wheeler_rounded, size: 38, color: Color(0xFF94A3B8)),
                            ),
                            SizedBox(height: 1.5.h),
                            Text(
                              'No store riders in this category',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Add your delivery executives to assign them doorstep inspections & device pick-up tasks.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
                            ),
                            SizedBox(height: 2.h),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.person_add_rounded, size: 18),
                              label: Text('Onboard New Rider', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: _openAddRiderScreen,
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
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected ? Colors.white : const Color(0xFF475569),
        ),
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
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
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 0.2.h),
                      Text(
                        '★ ${rider.rating} Rating • ${rider.vehicle} (${rider.vehicleNumber})',
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 0.5.h),
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
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          SizedBox(height: 1.2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today Pickups: ${rider.todayPickups} | Completed: ${rider.todayDeliveries}',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF475569), fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () => _makeCall(rider.phone),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 15),
                      SizedBox(width: 1.5.w),
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

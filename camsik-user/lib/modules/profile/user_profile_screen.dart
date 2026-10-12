import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';
import 'screens/saved_addresses_screen.dart';
import 'widgets/customer_support_sheet.dart';
import 'widgets/order_card_widget.dart';
import 'widgets/payout_bottom_sheet.dart';
import 'widgets/policy_details_sheet.dart';

class UserProfileWidget extends StatelessWidget {
  final UserProfile profile;
  final List<UserOrder> orders;
  final Function(UserProfile) onProfileUpdate;
  final VoidCallback onLogout;
  final VoidCallback onNavigateToSell;
  final VoidCallback onNavigateToBuy;

  const UserProfileWidget({
    super.key,
    required this.profile,
    required this.orders,
    required this.onProfileUpdate,
    required this.onLogout,
    required this.onNavigateToSell,
    required this.onNavigateToBuy,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF059669),
                  child: Text(
                    profile.name.isNotEmpty
                        ? profile.name.substring(0, 1).toUpperCase()
                        : 'C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        profile.phone,
                        style: const TextStyle(
                          color: Color(0xFF34D399),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        profile.email,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // MY ORDERS SECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Orders & Handover Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                '${orders.length} Active',
                style: const TextStyle(
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (orders.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 40, color: Color(0xFF94A3B8)),
                    SizedBox(height: 8),
                    Text(
                      'No orders yet',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Sell, buy, or exchange devices to see your orders here.',
                      style:
                          TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                    ),
                  ],
                ),
              ),
            )
          else
            ...orders.map((o) => OrderCardWidget(order: o)),

          const SizedBox(height: 24),
          const Text(
            'Account & Support',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(
            context,
            icon: Icons.location_on_outlined,
            title: 'Saved Doorstep Addresses',
            subtitle: profile.address.isNotEmpty
                ? profile.address
                : 'Add pickup and delivery address',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => SavedAddressesScreen(
                    profile: profile,
                    onAddressSelected: (selectedAddress) {
                      onProfileUpdate(profile.copyWith(address: selectedAddress));
                    },
                  ),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Payout UPI & Bank Account',
            subtitle: profile.upiId.isNotEmpty
                ? profile.upiId
                : 'Configure instant bank / UPI payout',
            onTap: () {
              PayoutBottomSheet.show(
                context,
                currentUpiId: profile.upiId,
                currentBankAccount: profile.bankAccount,
                onSave: (upi, bank) {
                  onProfileUpdate(profile.copyWith(
                    upiId: upi,
                    bankAccount: bank,
                  ));
                  ApiService.updateUserProfile(
                    phone: profile.phone,
                    upiId: upi,
                    bankAccount: bank,
                  );
                },
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.location_city_outlined,
            title: 'Serviceable Cities & Pincodes',
            subtitle: 'Check instant doorstep pickup in your area',
            onTap: () async {
              final cities = await ApiService.fetchCities();
              if (context.mounted) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (ctx) => StatefulBuilder(
                    builder: (ctx, setModalState) {
                      final controller = TextEditingController();
                      String? checkResult;
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Serviceable Metro Hubs & Cities',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Live doorstep pickup & inspection available across India:',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: cities.map((c) {
                                return Chip(
                                  backgroundColor: const Color(0xFFECFDF5),
                                  label: Text(
                                    c['name']?.toString() ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF059669),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  avatar: const Icon(Icons.check_circle, size: 14, color: Color(0xFF059669)),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            const Text('Check your pincode:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'e.g. 401107 or 110001',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF059669),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () async {
                                    if (controller.text.trim().isEmpty) return;
                                    final res = await ApiService.checkPincodeServiceability(controller.text.trim());
                                    setModalState(() {
                                      checkResult = res['message']?.toString() ?? 'Pincode checked';
                                    });
                                  },
                                  child: const Text('Check', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            if (checkResult != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                checkResult!,
                                style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_none_outlined,
            title: 'Notifications & Alerts',
            subtitle: 'Offers, pickup updates & transaction alerts',
            onTap: () async {
              final notifs = await ApiService.fetchNotifications(phone: profile.phone);
              if (context.mounted) {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (ctx) => Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Notifications',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        if (notifs.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text('No new notifications', style: TextStyle(color: Color(0xFF94A3B8))),
                            ),
                          )
                        else
                          ...notifs.map((n) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFFECFDF5),
                                  child: Icon(Icons.notifications_active, color: Color(0xFF059669), size: 18),
                                ),
                                title: Text(n['title']?.toString() ?? 'Alert', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                subtitle: Text(n['body']?.toString() ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              )),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.support_agent_outlined,
            title: 'Customer Support',
            subtitle: 'WhatsApp: +91 8976000010',
            onTap: () => CustomerSupportSheet.show(context),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.verified_outlined,
            title: 'Warranty & Data Protection Policy',
            subtitle: 'DoD 5220.22-M Wipe Certificate',
            onTap: () => PolicyDetailsSheet.showWarranty(context),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy & Terms',
            subtitle: 'Camsik ReCommerce terms',
            onTap: () => PolicyDetailsSheet.showPrivacyTerms(context),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                side: const BorderSide(color: Color(0xFFEF4444)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onLogout,
              child: const Text(
                'Log Out of Camsik',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF059669), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 12, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }
}

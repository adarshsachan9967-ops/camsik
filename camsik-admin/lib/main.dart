import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('CamsikAdmin Error: ${details.exception}');
    };
    runApp(const CamsikAdminApp());
  }, (error, stack) {
    debugPrint('CamsikAdmin Uncaught: $error\n$stack');
  });
}

class CamsikAdminApp extends StatelessWidget {
  const CamsikAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED), // Premium Violet
          primary: const Color(0xFF7C3AED),
          secondary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF090D16), // Dark Luxury Slate
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AdminMainNavigationScreen(),
    );
  }
}

class AdminMainNavigationScreen extends StatefulWidget {
  const AdminMainNavigationScreen({super.key});

  @override
  State<AdminMainNavigationScreen> createState() => _AdminMainNavigationScreenState();
}

class _AdminMainNavigationScreenState extends State<AdminMainNavigationScreen> {
  int _currentIndex = 0;

  // Mock Admin Orders
  final List<Map<String, dynamic>> _adminOrders = [
    {
      'id': 'ORD-9831',
      'type': 'Sell Phone',
      'customer': 'Ananya Verma',
      'phone': '+91 98765 43210',
      'device': 'iPhone 14 Pro 128GB Deep Purple',
      'quote': '₹48,500',
      'assignedRider': 'Rahul Sharma (RD-8842)',
      'status': 'Out for Pickup',
      'date': 'Today, 11:30 AM',
      'hub': 'South Delhi Hub',
    },
    {
      'id': 'ORD-9832',
      'type': 'Buy Refurbished',
      'customer': 'Vikram Mehra',
      'phone': '+91 98112 34567',
      'device': 'MacBook Pro M2 512GB Space Gray',
      'quote': '₹89,999',
      'assignedRider': 'Praveen Kumar (RD-4412)',
      'status': 'Processing',
      'date': 'Today, 10:15 AM',
      'hub': 'Noida Central Hub',
    },
    {
      'id': 'ORD-9833',
      'type': 'Screen Repair',
      'customer': 'Sneha Nair',
      'phone': '+91 99001 22334',
      'device': 'Samsung S22 Ultra Phantom Black',
      'quote': '₹8,499',
      'assignedRider': 'Unassigned',
      'status': 'Pending Dispatch',
      'date': 'Today, 09:45 AM',
      'hub': 'Indiranagar Lab Hub',
    },
    {
      'id': 'ORD-9828',
      'type': 'Sell Laptop',
      'customer': 'Arun Kapoor',
      'phone': '+91 97712 99881',
      'device': 'Dell XPS 15 16GB / 512GB SSD',
      'quote': '₹54,000',
      'assignedRider': 'Amit Joshi (RD-1092)',
      'status': 'Completed',
      'date': 'Yesterday, 04:20 PM',
      'hub': 'Gurgaon Cyber Hub',
    },
  ];

  // Mock Partners
  final List<Map<String, dynamic>> _partners = [
    {
      'name': 'Croma Mobile Exchange Desk',
      'location': 'South Extension, New Delhi',
      'owner': 'Rajesh Gupta',
      'margin': '8.5%',
      'devicesSold': '142 units',
      'kyc': 'Approved',
      'active': true,
    },
    {
      'name': 'Vijay Sales Device Counter',
      'location': 'Koramangala, Bengaluru',
      'owner': 'Kiran Patel',
      'margin': '9.0%',
      'devicesSold': '98 units',
      'kyc': 'Approved',
      'active': true,
    },
    {
      'name': 'Sangeetha Tech Corner',
      'location': 'Bandra West, Mumbai',
      'owner': 'Farhan Khan',
      'margin': '8.0%',
      'devicesSold': '64 units',
      'kyc': 'Pending Review',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CAMSIK ADMIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
                Text('Master Control • Super Admin', style: TextStyle(fontSize: 11, color: Color(0xFFA78BFA))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Synchronized latest system telemetry!'), duration: Duration(seconds: 1)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.campaign_outlined),
            onPressed: () => _openBroadcastDialog(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildOverviewTab(),
          _buildOrdersTab(),
          _buildPartnersTab(),
          _buildMarketingTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF7C3AED)),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF7C3AED)),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: Color(0xFF7C3AED)),
            label: 'Partners',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign, color: Color(0xFF7C3AED)),
            label: 'Marketing',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Color(0xFF7C3AED)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // TAB 1: EXECUTIVE OVERVIEW
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive GMV Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Today's Gross Volume (GMV)", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('+18.4% vs yday', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('₹24,85,920', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOverviewMetric('142 Orders', '86 Pickups', const Color(0xFFA78BFA)),
                    Container(width: 1, height: 28, color: Colors.white24),
                    _buildOverviewMetric('38 Fleet Active', '96% on-time', const Color(0xFF60A5FA)),
                    Container(width: 1, height: 28, color: Colors.white24),
                    _buildOverviewMetric('₹3.4L Profit', '13.8% Margin', const Color(0xFF34D399)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Items & Alerts
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Action Required: 3 Pending Approvals', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                      Text('1 Partner Store KYC awaiting review, 2 high-value payouts > ₹50,000.', style: TextStyle(fontSize: 11, color: Color(0xFF78350F))),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    setState(() => _currentIndex = 2); // Switch to partners
                  },
                  child: const Text('Review', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live Infrastructure Health
          const Text('Platform & Cloud Health', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildHealthCard('API Cluster', '42ms Latency', Icons.bolt, const Color(0xFF10B981))),
              const SizedBox(width: 10),
              Expanded(child: _buildHealthCard('Payments (Razorpay)', '99.9% Success', Icons.credit_card, const Color(0xFF10B981))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildHealthCard('Rider GPS Dispatch', '34 Active Nodes', Icons.radar, const Color(0xFF2563EB))),
              const SizedBox(width: 10),
              Expanded(child: _buildHealthCard('SMS & WhatsApp', '100% Delivered', Icons.sms, const Color(0xFF10B981))),
            ],
          ),
          const SizedBox(height: 20),

          // Recent Activity Feed
          const Text('Live Platform Audit Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          _buildActivityTile('New Order Placed', 'ORD-9834: iPhone 15 Pro Max 256GB - Quote ₹68,000', '2 mins ago', Icons.add_shopping_cart, const Color(0xFF2563EB)),
          _buildActivityTile('Rider Assigned', 'Rahul Sharma assigned to ORD-9831 (Pickup in 15 mins)', '8 mins ago', Icons.two_wheeler, const Color(0xFF7C3AED)),
          _buildActivityTile('Payout Completed', '₹48,500 transferred to Ananya Verma via IMPS', '24 mins ago', Icons.check_circle, const Color(0xFF10B981)),
          _buildActivityTile('Price Overwrite', 'Manager adjusted trade-in value on ORD-9825 (+₹1,200)', '1 hour ago', Icons.edit_note, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _buildOverviewMetric(String title, String subtitle, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _buildHealthCard(String title, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String desc, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 16),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
        trailing: Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
      ),
    );
  }

  // TAB 2: ORDER MANAGEMENT & DISPATCH
  Widget _buildOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Orders & Fulfillment Hub', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text('${_adminOrders.length} active', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(_adminOrders.length, (idx) {
            final o = _adminOrders[idx];
            return _buildOrderAdminCard(o, idx);
          }),
        ],
      ),
    );
  }

  Widget _buildOrderAdminCard(Map<String, dynamic> o, int index) {
    final bool isUnassigned = o['assignedRider'] == 'Unassigned';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(o['id'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF7C3AED))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(o['status'], style: const TextStyle(fontSize: 11, color: Color(0xFF1D4ED8), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(o['device'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text('${o['customer']} (${o['phone']})', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payout / Price: ${o['quote']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF059669))),
                  Text(o['hub'], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.two_wheeler, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Rider: ${o['assignedRider']}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isUnassigned ? FontWeight.bold : FontWeight.normal,
                      color: isUnassigned ? const Color(0xFFDC2626) : const Color(0xFF334155),
                    ),
                  ),
                ),
                if (isUnassigned)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {
                      setState(() {
                        o['assignedRider'] = 'Rahul Sharma (RD-8842)';
                        o['status'] = 'Assigned';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Dispatched order ${o['id']} to Rahul Sharma!')),
                      );
                    },
                    child: const Text('Assign Rider', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: PARTNER STORES
  Widget _buildPartnersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Registered Partner Stores', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text('${_partners.length} stores', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(_partners.length, (idx) {
            final p = _partners[idx];
            final bool isApproved = p['kyc'] == 'Approved';

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(p['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isApproved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            p['kyc'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isApproved ? const Color(0xFF166534) : const Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${p['location']} • Owner: ${p['owner']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Commission: ${p['margin']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                        Text('Volume: ${p['devicesSold']}', style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (!isApproved)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle, size: 16, color: Colors.white),
                          label: const Text('Approve KYC & Activate Store Portal', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            setState(() {
                              p['kyc'] = 'Approved';
                              p['active'] = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${p['name']} is now approved & active!')),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // TAB 4: MARKETING & PUSH BROADCASTS
  Widget _buildMarketingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Push Campaigns & Coupons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 6),
          const Text('Broadcast announcements and manage discount promotions across customer devices.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 16),

          // Broadcast Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.white, size: 22),
                    SizedBox(width: 8),
                    Text('Send Instant Push Notification', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Deliver real-time alerts to all 12,450+ installed customer & rider apps.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send, size: 16, color: Color(0xFF4F46E5)),
                  label: const Text('Compose Broadcast', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _openBroadcastDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Active Coupons
          const Text('Active Promo Codes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          _buildCouponCard('CAMSIK1000', 'Flat ₹1,000 Off on Refurbished Laptops & Phones', 'Used 418 times', 'Active'),
          _buildCouponCard('SELLBONUS500', 'Get Extra ₹500 trade-in credit when selling phone', 'Used 892 times', 'Active'),
          _buildCouponCard('FREEDELIVERY', 'Zero pickup fee for first-time doorstep inspections', 'Used 1,240 times', 'Active'),
        ],
      ),
    );
  }

  Widget _buildCouponCard(String code, String desc, String usage, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.local_offer, color: Color(0xFF7C3AED), size: 20),
        ),
        title: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
            Text(usage, style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(status, style: const TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // TAB 5: SYSTEM SETTINGS
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Column(
              children: [
                _buildSettingsTile(Icons.admin_panel_settings, 'Admin Access Control', '3 Super Admins, 12 Dispatch Managers'),
                const Divider(height: 1, indent: 56),
                _buildSettingsTile(Icons.price_change, 'Dynamic Valuation Algorithm', 'Standard 1.0x Base Multiplier Active'),
                const Divider(height: 1, indent: 56),
                _buildSettingsTile(Icons.verified_user, 'Biometric / 2FA Security', 'Mandatory for all admin logins'),
                const Divider(height: 1, indent: 56),
                _buildSettingsTile(Icons.cloud_sync, 'Cloud Database Backups', 'Hourly snapshots enabled (PostgreSQL)'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
            label: const Text('Exit Admin Console', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDC2626)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Admin session terminated.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF7C3AED)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFF94A3B8)),
    );
  }

  // Broadcast Composer Modal
  void _openBroadcastDialog(BuildContext context) {
    final titleCtrl = TextEditingController(text: 'Festive Flash Deal!');
    final bodyCtrl = TextEditingController(text: 'Extra ₹1,500 exchange bonus on all iPhones today only. Tap to sell!');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.campaign, color: Color(0xFF7C3AED)),
              SizedBox(width: 8),
              Text('Push Notification Broadcast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notification Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Message Body',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Push Broadcast dispatched to 12,450 devices!'),
                    backgroundColor: Color(0xFF059669),
                  ),
                );
              },
              child: const Text('Dispatch Push', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

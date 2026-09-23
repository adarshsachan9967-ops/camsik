import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };
    runApp(const CamsikPartnerApp());
  }, (error, stack) {
    debugPrint('Global Camsik Partner Error: $error');
  });
}

class CamsikPartnerApp extends StatelessWidget {
  const CamsikPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik Partner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const PartnerMainNavigationScreen(),
    );
  }
}

class PartnerMainNavigationScreen extends StatefulWidget {
  const PartnerMainNavigationScreen({super.key});

  @override
  State<PartnerMainNavigationScreen> createState() => _PartnerMainNavigationScreenState();
}

class _PartnerMainNavigationScreenState extends State<PartnerMainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.storefront, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CAMSIK PARTNER', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1.1)),
                Text('TechWorld Hub • Karol Bagh', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.star, color: Color(0xFFD97706), size: 14),
                SizedBox(width: 4),
                Text('Gold Tier', style: TextStyle(color: Color(0xFF92400E), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PartnerDashboardScreen(onNavigate: (idx) => setState(() => _currentIndex = idx)),
          const PartnerOrdersScreen(),
          const PartnerInspectionScreen(),
          const PartnerPayoutsScreen(),
          const PartnerProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: const Color(0xFF2563EB).withValues(alpha: 0.18),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: Color(0xFF2563EB)), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF2563EB)), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.fact_check_outlined), selectedIcon: Icon(Icons.fact_check, color: Color(0xFF2563EB)), label: 'Inspection'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF2563EB)), label: 'Payouts'),
          NavigationDestination(icon: Icon(Icons.store_outlined), selectedIcon: Icon(Icons.store, color: Color(0xFF2563EB)), label: 'Store KYC'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PARTNER TAB 0: DASHBOARD
// ─────────────────────────────────────────────────────────────
class PartnerDashboardScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const PartnerDashboardScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Revenue & Volume Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TODAY\'S STORE VOLUME', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  Icon(Icons.trending_up, color: Color(0xFF10B981), size: 18),
                ],
              ),
              const SizedBox(height: 8),
              const Text('₹48,250', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text('+18.4% vs yesterday • 7 Devices Liquidated', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Float Balance', style: TextStyle(color: Colors.white60, fontSize: 10)),
                          SizedBox(height: 2),
                          Text('₹2,50,000', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Commission Earned', style: TextStyle(color: Colors.white60, fontSize: 10)),
                          SizedBox(height: 2),
                          Text('₹5,790', style: TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Quick Actions Row
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.qr_code_scanner, size: 18),
                label: const Text('New Inspection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: () => onNavigate(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.flash_on, size: 18),
                label: const Text('Spot Payout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: () => onNavigate(3),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        const Text('Pending Store Queue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        _buildQueueCard('iPhone 14 Pro 128GB', 'Customer: Karan Verma', 'Quoted: ₹54,000', 'Awaiting Physical QA', onNavigate),
        _buildQueueCard('MacBook Air M2 256GB', 'Customer: Priya Sharma', 'Quoted: ₹68,500', 'Diagnostic Ready', onNavigate),
      ],
    );
  }

  Widget _buildQueueCard(String model, String customer, String quote, String status, Function(int) onNavigate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(customer, style: const TextStyle(color: Colors.black54, fontSize: 11)),
              const SizedBox(height: 4),
              Text(quote, style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEFF6FF), foregroundColor: const Color(0xFF2563EB), elevation: 0),
            onPressed: () => onNavigate(2),
            child: const Text('Inspect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PARTNER TAB 1: ORDERS MANAGEMENT
// ─────────────────────────────────────────────────────────────
class PartnerOrdersScreen extends StatelessWidget {
  const PartnerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Partner Orders Dispatch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Live orders assigned to your store for walk-in and hub drops.', style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 16),

        _buildOrderTile('ORD-99120', 'Samsung Galaxy S23 Ultra', 'Rajesh Gupta', '₹52,000', 'Arrived at Store', const Color(0xFF059669)),
        _buildOrderTile('ORD-99084', 'Sony Alpha A7 III Body', 'Vikramaditya Rao', '₹84,000', 'Inspection In-Progress', const Color(0xFF2563EB)),
        _buildOrderTile('ORD-98912', 'iPad Pro 11" M2 128GB', 'Neha Chawla', '₹44,500', 'Instant Payout Transferred', const Color(0xFF6B7280)),
      ],
    );
  }

  Widget _buildOrderTile(String id, String device, String seller, String price, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 2),
          Text('Seller: $seller • Valuation: $price', style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PARTNER TAB 2: INSPECTION DESK (45-POINT CHECKLIST)
// ─────────────────────────────────────────────────────────────
class PartnerInspectionScreen extends StatefulWidget {
  const PartnerInspectionScreen({super.key});

  @override
  State<PartnerInspectionScreen> createState() => _PartnerInspectionScreenState();
}

class _PartnerInspectionScreenState extends State<PartnerInspectionScreen> {
  bool _touchScreen = true;
  bool _cameras = true;
  bool _battery = true;
  bool _biometrics = true;
  bool _bodyFlawless = true;
  bool _boxAndBill = true;

  int _recalculatedQuote() {
    int base = 54000;
    if (!_touchScreen) base -= 8500;
    if (!_cameras) base -= 4000;
    if (!_battery) base -= 3000;
    if (!_biometrics) base -= 2500;
    if (!_bodyFlawless) base -= 2000;
    if (!_boxAndBill) base -= 1500;
    return base;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('45-Point Device Inspection Desk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Apple iPhone 14 Pro 128GB • IMEI: 354891028472911', style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 16),

        // Live Valuation Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.2))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FINAL CALCULATED OFFER', style: TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text('45-Point Pass Verified', style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
              Text('₹${_recalculatedQuote().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        const Text('Hardware Verification Checkpoints', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),

        SwitchListTile(
          title: const Text('Touchscreen Digitizer & Display (No Bleeding)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          value: _touchScreen,
          activeThumbColor: const Color(0xFF2563EB),
          onChanged: (v) => setState(() => _touchScreen = v),
        ),
        SwitchListTile(
          title: const Text('Front & Triple Cameras / OIS / Flash', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          value: _cameras,
          activeThumbColor: const Color(0xFF2563EB),
          onChanged: (v) => setState(() => _cameras = v),
        ),
        SwitchListTile(
          title: const Text('Battery Health > 85% & Normal Cycles', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          value: _battery,
          activeThumbColor: const Color(0xFF2563EB),
          onChanged: (v) => setState(() => _battery = v),
        ),
        SwitchListTile(
          title: const Text('FaceID / TouchID Biometric Working', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          value: _biometrics,
          activeThumbColor: const Color(0xFF2563EB),
          onChanged: (v) => setState(() => _biometrics = v),
        ),
        SwitchListTile(
          title: const Text('Body Frame & Back Glass Pristine', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          value: _bodyFlawless,
          activeThumbColor: const Color(0xFF2563EB),
          onChanged: (v) => setState(() => _bodyFlawless = v),
        ),
        SwitchListTile(
          title: const Text('Original Packaging Box & Tax Bill Included', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          value: _boxAndBill,
          activeThumbColor: const Color(0xFF2563EB),
          onChanged: (v) => setState(() => _boxAndBill = v),
        ),

        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Submit Inspection & Authorize Payout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('45-Point Inspection Certified! Ready for Spot UPI Transfer.')),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PARTNER TAB 3: SPOT PAYOUTS & WALLET
// ─────────────────────────────────────────────────────────────
class PartnerPayoutsScreen extends StatelessWidget {
  const PartnerPayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('FLOAT WALLET BALANCE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              const SizedBox(height: 6),
              const Text('₹2,50,000.00', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF059669), elevation: 0),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Float Balance via NetBanking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Instant Spot Payout to Seller', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.black.withValues(alpha: 0.06))),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Seller UPI ID / Mobile Number',
                  hintText: 'e.g. 9876543210@paytm',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Settlement Amount (₹)',
                  hintText: 'e.g. 48,000',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.send),
                label: const Text('Execute Instant IMPS / UPI Transfer', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Instant Payout Successful! UTR: CAS891028391 generated.')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PARTNER TAB 4: STORE PROFILE & KYC
// ─────────────────────────────────────────────────────────────
class PartnerProfileScreen extends StatelessWidget {
  const PartnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(22)),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF2563EB),
                child: Icon(Icons.store, color: Colors.white, size: 28),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TechWorld Hub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 2),
                    Text('GSTIN: 07AAAAA0000A1Z5 • Verified', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 11, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('Karol Bagh Main Market, New Delhi', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: const Icon(Icons.verified, color: Color(0xFF059669)),
          title: const Text('Aadhaar & PAN KYC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: const Text('Govt. Business Identity Approved', style: TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.check_circle, color: Color(0xFF059669)),
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          leading: const Icon(Icons.access_time, color: Color(0xFF2563EB)),
          title: const Text('Operating Hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: const Text('10:00 AM - 08:30 PM (Mon - Sun)', style: TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('CamsikDelivery Error: ${details.exception}');
    };
    runApp(const CamsikDeliveryApp());
  }, (error, stack) {
    debugPrint('CamsikDelivery Uncaught: $error\n$stack');
  });
}

class CamsikDeliveryApp extends StatelessWidget {
  const CamsikDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camsik Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Royal Blue
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF059669), // Emerald accent
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
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const DeliveryMainNavigationScreen(),
    );
  }
}

class DeliveryMainNavigationScreen extends StatefulWidget {
  const DeliveryMainNavigationScreen({super.key});

  @override
  State<DeliveryMainNavigationScreen> createState() => _DeliveryMainNavigationScreenState();
}

class _DeliveryMainNavigationScreenState extends State<DeliveryMainNavigationScreen> {
  int _currentIndex = 0;
  bool _isOnline = true;

  // Mock tasks
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': 'DEL-9081',
      'type': 'Pickup (Sell Order)',
      'customer': 'Ananya Verma',
      'phone': '+91 98765 43210',
      'address': 'Flat 402, Green Glen Heights, Bellandur, Bengaluru',
      'distance': '1.8 km away',
      'device': 'iPhone 14 Pro 128GB Space Black',
      'condition': 'Flawless - Screen original, battery 92%',
      'payoutToCustomer': '₹48,500',
      'feeEarned': '₹240',
      'otp': '7291',
      'status': 'Assigned',
      'timeSlot': '11:00 AM - 01:00 PM',
      'checks': [false, false, false, false],
    },
    {
      'id': 'DEL-9082',
      'type': 'Delivery (Refurbished)',
      'customer': 'Rohit Deshmukh',
      'phone': '+91 99887 66554',
      'address': 'B-12, Sector 62, Noida, NCR',
      'distance': '3.4 km away',
      'device': 'MacBook Pro M2 512GB Space Gray',
      'condition': 'Refurbished Superb - Sealed Box',
      'payoutToCustomer': '₹0 (Prepaid)',
      'feeEarned': '₹320',
      'otp': '4183',
      'status': 'In Transit',
      'timeSlot': '02:00 PM - 04:00 PM',
      'checks': [true, true, true, false],
    },
    {
      'id': 'DEL-9083',
      'type': 'Pickup (Exchange)',
      'customer': 'Siddharth Rao',
      'phone': '+91 91234 56789',
      'address': 'Villa 9, Palm Meadows, Whitefield, Bengaluru',
      'distance': '5.2 km away',
      'device': 'Samsung Galaxy S23 Ultra 256GB Phantom Black',
      'condition': 'Good - Minor hairline scratches',
      'payoutToCustomer': '₹42,000',
      'feeEarned': '₹280',
      'otp': '8845',
      'status': 'Assigned',
      'timeSlot': '04:30 PM - 06:30 PM',
      'checks': [false, false, false, false],
    },
    {
      'id': 'DEL-9079',
      'type': 'Pickup (Sell Order)',
      'customer': 'Pooja Iyer',
      'phone': '+91 98111 22334',
      'address': 'Flat 8A, Prestige Falcon Tower, South End, Bengaluru',
      'distance': 'Completed',
      'device': 'iPad Pro 11" M2 256GB Wi-Fi',
      'condition': 'Flawless - With Apple Pencil',
      'payoutToCustomer': '₹45,000',
      'feeEarned': '₹250',
      'otp': '6621',
      'status': 'Delivered',
      'timeSlot': '09:30 AM - 10:30 AM',
      'checks': [true, true, true, true],
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
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.two_wheeler, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CAMSIK RIDER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
                Text(
                  _isOnline ? 'Online • Ready for Orders' : 'Offline • Duty Paused',
                  style: TextStyle(
                    fontSize: 11,
                    color: _isOnline ? const Color(0xFF34D399) : Colors.white60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: _isOnline,
              activeThumbColor: const Color(0xFF10B981),
              onChanged: (val) {
                setState(() => _isOnline = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(val ? 'You are now ONLINE and visible for dispatch!' : 'You are now OFFLINE.'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: val ? const Color(0xFF059669) : const Color(0xFF475569),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotificationsModal(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildTasksTab(),
          _buildEarningsTab(),
          _buildHotspotsTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: Color(0xFF2563EB)),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF2563EB)),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on, color: Color(0xFF2563EB)),
            label: 'Hotspots',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF2563EB)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // TAB 1: TASKS
  Widget _buildTasksTab() {
    int activeCount = _tasks.where((t) => t['status'] != 'Delivered').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Shift", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          '$activeCount Active • 1 Done',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        border: Border.all(color: const Color(0xFF3B82F6)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Target: 6 Trips', style: TextStyle(color: Color(0xFF93C5FD), fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShiftStat('Est. Earnings', '₹1,090', Colors.white),
                    Container(width: 1, height: 28, color: Colors.white24),
                    _buildShiftStat('Completion', '68%', const Color(0xFF34D399)),
                    Container(width: 1, height: 28, color: Colors.white24),
                    _buildShiftStat('Customer Rating', '4.95 ⭐', const Color(0xFFFBBF24)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Assigned Pickups & Deliveries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text('${_tasks.length} total', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 12),

          // Tasks List
          ...List.generate(_tasks.length, (index) {
            final task = _tasks[index];
            return _buildTaskCard(task, index);
          }),
        ],
      ),
    );
  }

  Widget _buildShiftStat(String label, String val, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    final isDelivered = task['status'] == 'Delivered';
    final isInTransit = task['status'] == 'In Transit';

    Color badgeColor;
    if (isDelivered) {
      badgeColor = const Color(0xFF059669);
    } else if (isInTransit) {
      badgeColor = const Color(0xFFD97706);
    } else {
      badgeColor = const Color(0xFF2563EB);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    task['type'],
                    style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDelivered ? const Color(0xFFDCFCE7) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    task['status'],
                    style: TextStyle(
                      color: isDelivered ? const Color(0xFF166534) : const Color(0xFF1D4ED8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order ID & Device
            Text(task['id'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(task['device'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 2),
            Text(task['condition'], style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
            const SizedBox(height: 10),

            // Customer details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 8),
                      Text(task['customer'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                      const Spacer(),
                      Text(task['timeSlot'], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.place, size: 16, color: Color(0xFFEF4444)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task['address'],
                          style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.near_me, size: 14, color: Color(0xFF2563EB)),
                          const SizedBox(width: 4),
                          Text(task['distance'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        ],
                      ),
                      Text(
                        'Rider Fee: ${task['feeEarned']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Customer Call & Navigation Quick Buttons
            if (!isDelivered) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.call, size: 16, color: Color(0xFF2563EB)),
                      label: const Text('Call Customer', style: TextStyle(color: Color(0xFF2563EB), fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Dialing ${task['customer']} (${task['phone']})...')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.navigation, size: 16, color: Color(0xFF059669)),
                      label: const Text('Navigate (Maps)', style: TextStyle(color: Color(0xFF059669), fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF059669)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening Google Maps route to ${task['address']}...')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Action button (Verify & Complete Delivery / Inspect)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(isInTransit ? Icons.verified : Icons.play_arrow, color: Colors.white, size: 18),
                  label: Text(
                    isInTransit ? 'Verify & Complete Delivery' : 'Start Task / Inspect Device',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInTransit ? const Color(0xFF059669) : const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _openInspectionModal(task, index),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
                      SizedBox(width: 6),
                      Text('Successfully verified & completed', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Inspection & OTP Handover Modal
  void _openInspectionModal(Map<String, dynamic> task, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final List<String> checklistTitles = [
              'Physical Screen & Display (No cracks, touch works)',
              'Camera & Flash test (Front & Back sensors ok)',
              'Biometrics & Battery health verification',
              'Device unlocked & iCloud / Google account removed',
            ];

            final checks = task['checks'] as List<bool>;
            final allChecked = checks.every((c) => c);

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Handover Inspection: ${task['id']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(task['device'], style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text('Mandatory Inspection Checklist:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 10),
                    ...List.generate(checklistTitles.length, (chkIdx) {
                      return CheckboxListTile(
                        value: checks[chkIdx],
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: const Color(0xFF059669),
                        title: Text(checklistTitles[chkIdx], style: const TextStyle(fontSize: 13)),
                        onChanged: (val) {
                          setModalState(() {
                            checks[chkIdx] = val ?? false;
                          });
                          setState(() {});
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.security, color: Color(0xFFB45309), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Customer Payout: ${task['payoutToCustomer']}. Hand over funds or collect cash only after OTP check.',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: allChecked ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: allChecked
                            ? () {
                                Navigator.pop(ctx);
                                _showOtpDialog(task, index);
                              }
                            : null,
                        child: const Text('Proceed to OTP Handover Verification', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // OTP Verification Dialog
  void _showOtpDialog(Map<String, dynamic> task, int index) {
    final TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.lock_open, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text('Enter Customer OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ask customer ${task['customer']} for the 4-digit handover OTP sent to their phone.\n(Demo OTP: ${task['otp']})',
                style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                decoration: InputDecoration(
                  hintText: '----',
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (otpController.text == task['otp'] || otpController.text.length == 4) {
                  setState(() {
                    _tasks[index]['status'] = 'Delivered';
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order ${task['id']} completed! Fee of ${task['feeEarned']} added to wallet.'),
                      backgroundColor: const Color(0xFF059669),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid OTP! Please ask customer for correct 4 digits.'),
                      backgroundColor: Color(0xFFDC2626),
                    ),
                  );
                }
              },
              child: const Text('Verify & Finish', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // TAB 2: EARNINGS
  Widget _buildEarningsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Wallet Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Icon(Icons.account_balance_wallet, color: Colors.white70, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('₹4,890.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.send_to_mobile, size: 16, color: Color(0xFF1E3A8A)),
                        label: const Text('Instant Payout', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Instant transfer of ₹4,890.00 initiated to your HDFC Bank account!'),
                              backgroundColor: Color(0xFF059669),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Statement PDF downloaded to device.')),
                        );
                      },
                      child: const Text('Statement'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Daily Incentive Challenge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bolt, color: Color(0xFFF59E0B)),
                        SizedBox(width: 6),
                        Text('Super Shift Incentive', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    Text('+₹400 Bonus', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Complete 6 deliveries today between 10 AM - 7 PM to unlock ₹400 extra bonus!', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 4 / 6,
                    minHeight: 8,
                    backgroundColor: Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('4 of 6 completed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                    Text('2 trips left', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Earnings Breakdown
          const Text('Recent Trip Earnings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          _buildTripEarningTile('DEL-9079: iPad Pro Handover', 'Today, 10:28 AM', '₹250.00', 'Base ₹180 + Surge ₹70'),
          _buildTripEarningTile('DEL-9076: Galaxy S22 Pickup', 'Yesterday, 06:15 PM', '₹310.00', 'Base ₹200 + Distance ₹110'),
          _buildTripEarningTile('DEL-9074: iPhone 13 Pro', 'Yesterday, 02:40 PM', '₹280.00', 'Base ₹180 + Tip ₹100'),
          _buildTripEarningTile('Weekly Target Completion Bonus', 'Sunday, 11:59 PM', '₹1,200.00', 'Direct Incentive Credit'),
        ],
      ),
    );
  }

  Widget _buildTripEarningTile(String title, String date, String amount, String sub) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.check_circle, color: Color(0xFF059669), size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF059669))),
          ],
        ),
        trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
      ),
    );
  }

  // TAB 3: HOTSPOTS & HUBS
  Widget _buildHotspotsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('High-Demand Pickup Zones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 6),
          const Text('Move closer to these areas for instant order assignments with surge pricing.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 16),
          _buildHotspotCard('Indiranagar & Koramangala Hub', 'Bengaluru Central', '1.5x Surge', '28 orders awaiting rider', true),
          _buildHotspotCard('Whitefield ITPL Corridor', 'Bengaluru East', '1.3x Surge', '19 orders awaiting rider', true),
          _buildHotspotCard('HSR Layout & Electronic City', 'Bengaluru South', '1.2x Surge', '14 orders awaiting rider', false),
          const SizedBox(height: 20),
          const Text('Official Camsik Drop-off Hubs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          _buildHubCard('Camsik Tech Lab & Sorting Center', 'Koramangala 4th Block', 'Open until 09:00 PM', 'Drop inspected phones here'),
          _buildHubCard('Camsik Hub - North', 'Hebbal Ring Road', 'Open until 08:30 PM', 'Drop laptop & tablet boxes'),
        ],
      ),
    );
  }

  Widget _buildHotspotCard(String title, String zone, String surge, String orders, bool isHot) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isHot ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.local_fire_department, color: isHot ? const Color(0xFFEF4444) : const Color(0xFF2563EB), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(zone, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  Text(orders, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(surge, style: const TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHubCard(String name, String location, String timings, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.warehouse, color: Color(0xFF0F172A), size: 24),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$location • $timings', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.directions, color: Color(0xFF2563EB)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigating to $name...')),
            );
          },
        ),
      ),
    );
  }

  // TAB 4: PROFILE & COMPLIANCE
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF2563EB),
                  child: Text('RS', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                const Text('Rahul Sharma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                const Text('Delivery Rider ID: CAS-RD-8842', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, color: Color(0xFF059669), size: 14),
                          SizedBox(width: 4),
                          Text('KYC Verified Rider', style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFD97706), size: 14),
                          SizedBox(width: 4),
                          Text('4.95 Rating', style: TextStyle(color: Color(0xFF92400E), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Vehicle & Documents
          Card(
            child: Column(
              children: [
                _buildProfileListTile(Icons.two_wheeler, 'Vehicle Registered', 'Honda Activa 6G (KA-01-EQ-9812)', true),
                const Divider(height: 1, indent: 56),
                _buildProfileListTile(Icons.badge, 'Driving License', 'DL-KA-20190038841 (Valid)', true),
                const Divider(height: 1, indent: 56),
                _buildProfileListTile(Icons.account_balance, 'Bank Account for Payouts', 'HDFC Bank ending in **8491', true),
                const Divider(height: 1, indent: 56),
                _buildProfileListTile(Icons.health_and_safety, 'Rider Insurance Policy', 'Camsik Transit Cover Active (₹5 Lakh)', true),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // SOS Emergency button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.emergency, color: Colors.white),
              label: const Text('RIDER SOS / EMERGENCY DISPATCH', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('SOS Alert sent to Camsik Safety Center & Local Dispatch!'),
                    backgroundColor: Color(0xFFDC2626),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Color(0xFF64748B)),
            label: const Text('Log Out Shift', style: TextStyle(color: Color(0xFF64748B))),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rider shift logged out successfully.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileListTile(IconData icon, String title, String subtitle, bool isVerified) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2563EB)),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      trailing: isVerified ? const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18) : null,
    );
  }

  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rider Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Mark all read', style: TextStyle(fontSize: 12, color: Color(0xFF2563EB))),
                ],
              ),
              const Divider(height: 20),
              ListTile(
                dense: true,
                leading: const Icon(Icons.star, color: Color(0xFFF59E0B)),
                title: const Text('Great Job! 5-Star feedback received', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('Customer Ananya Verma rated your handover as super professional.', style: TextStyle(fontSize: 11)),
              ),
              ListTile(
                dense: true,
                leading: const Icon(Icons.attach_money, color: Color(0xFF10B981)),
                title: const Text('Daily payout processed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('₹1,450 deposited into your bank account.', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        );
      },
    );
  }
}

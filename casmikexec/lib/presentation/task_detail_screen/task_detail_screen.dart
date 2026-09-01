import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_badge_widget.dart';
import './widgets/device_details_card_widget.dart';
import './widgets/info_card_widget.dart';

class TaskDetailScreen extends StatefulWidget {
  final String orderId;
  const TaskDetailScreen({super.key, required this.orderId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production
  late Map<String, dynamic> _task;

  final List<Map<String, dynamic>> _taskMaps = [
    {
      'id': 'CSM-2847',
      'customerName': 'Arjun Mehta',
      'customerPhone': '+91 98765 43210',
      'customerAddress':
          'Flat 4B, Sunshine Apartments, Bandra West, Mumbai 400050',
      'partnerName': 'iRepair Solutions',
      'partnerPhone': '+91 98234 56789',
      'partnerAddress': 'Shop 12, Link Road, Andheri West, Mumbai 400053',
      'deviceBrand': 'Apple',
      'deviceModel': 'iPhone 14 Pro',
      'deviceType': 'Smartphone',
      'issue': 'Screen cracked, touch not responding',
      'timeSlot': '10:00 AM – 12:00 PM',
      'status': 'assigned',
      'priority': 'high',
      'type': 'pickup',
      'earnings': 85.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2851',
      'customerName': 'Priya Sharma',
      'customerPhone': '+91 87654 32109',
      'customerAddress':
          '302, Sai Residency, Marol Naka, Andheri East, Mumbai 400069',
      'partnerName': 'TechFix Mumbai',
      'partnerPhone': '+91 91234 56780',
      'partnerAddress': '45, MIDC Road, Andheri East, Mumbai 400093',
      'deviceBrand': 'Samsung',
      'deviceModel': 'Galaxy S23',
      'deviceType': 'Smartphone',
      'issue': 'Battery draining fast, overheating',
      'timeSlot': '01:00 PM – 03:00 PM',
      'status': 'inTransit',
      'priority': 'medium',
      'type': 'delivery',
      'earnings': 65.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2855',
      'customerName': 'Vikram Nair',
      'customerPhone': '+91 76543 21098',
      'customerAddress': '18, Hiranandani Gardens, Powai, Mumbai 400076',
      'partnerName': 'GadgetCare Pro',
      'partnerPhone': '+91 90123 45679',
      'partnerAddress':
          '7, Central Avenue, Hiranandani Business Park, Powai 400076',
      'deviceBrand': 'OnePlus',
      'deviceModel': 'OnePlus 11',
      'deviceType': 'Smartphone',
      'issue': 'Camera not working, app crashes',
      'timeSlot': '03:30 PM – 05:30 PM',
      'status': 'inTransit',
      'priority': 'high',
      'type': 'delivery',
      'earnings': 70.0,
      'date': '25 Aug 2026',
    },
    {
      'id': 'CSM-2860',
      'customerName': 'Sunita Rao',
      'customerPhone': '+91 65432 10987',
      'customerAddress': 'B-12, Evershine Nagar, Malad West, Mumbai 400064',
      'partnerName': 'QuickFix Electronics',
      'partnerPhone': '+91 89012 34568',
      'partnerAddress': '22, SV Road, Malad West, Mumbai 400064',
      'deviceBrand': 'Xiaomi',
      'deviceModel': 'Redmi Note 12',
      'deviceType': 'Smartphone',
      'issue': 'Speaker not working, mic issue',
      'timeSlot': '05:00 PM – 07:00 PM',
      'status': 'assigned',
      'priority': 'low',
      'type': 'pickup',
      'earnings': 55.0,
      'date': '25 Aug 2026',
    },
  ];

  @override
  void initState() {
    super.initState();
    _task = _taskMaps.firstWhere(
      (t) => t['id'] == widget.orderId,
      orElse: () => _taskMaps.first,
    );
  }

  String get _actionLabel {
    final status = _task['status'] as String;
    switch (status) {
      case 'assigned':
        return 'Start Trip';
      case 'inTransit':
        return 'Mark Arrived';
      default:
        return 'View Actions';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final status = _task['status'] as String;
    final taskStatus = status == 'assigned'
        ? TaskStatus.assigned
        : status == 'inTransit'
        ? TaskStatus.inTransit
        : status == 'delivered'
        ? TaskStatus.delivered
        : TaskStatus.failed;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom AppBar with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _task['id'] as String,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${_task['type'] == 'pickup' ? 'Pickup' : 'Delivery'} Task',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withAlpha(204),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          status == 'assigned' ? 'Assigned' : 'In Transit',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.navigation_rounded, size: 18),
                  label: const Text('Navigate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.push(AppRoutes.taskActions, extra: _task['id']),
                  icon: const Icon(Icons.play_arrow_rounded, size: 20),
                  label: Text(_actionLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InfoCardWidget(
            title: 'Customer Info',
            icon: Icons.person_rounded,
            iconColor: AppTheme.statusAssigned,
            fields: [
              {'label': 'Name', 'value': _task['customerName'] as String},
              {
                'label': 'Phone',
                'value': _task['customerPhone'] as String,
                'isPhone': true,
              },
              {'label': 'Address', 'value': _task['customerAddress'] as String},
              {'label': 'Time Slot', 'value': _task['timeSlot'] as String},
            ],
          ),
          const SizedBox(height: 12),
          InfoCardWidget(
            title: 'Partner / Store Info',
            icon: Icons.store_rounded,
            iconColor: AppTheme.secondary,
            fields: [
              {'label': 'Store', 'value': _task['partnerName'] as String},
              {
                'label': 'Phone',
                'value': _task['partnerPhone'] as String,
                'isPhone': true,
              },
              {'label': 'Address', 'value': _task['partnerAddress'] as String},
            ],
          ),
          const SizedBox(height: 12),
          DeviceDetailsCardWidget(
            deviceType: _task['deviceType'] as String,
            brand: _task['deviceBrand'] as String,
            model: _task['deviceModel'] as String,
            issue: _task['issue'] as String,
          ),
          const SizedBox(height: 12),
          _buildEarningsCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                InfoCardWidget(
                  title: 'Customer Info',
                  icon: Icons.person_rounded,
                  iconColor: AppTheme.statusAssigned,
                  fields: [
                    {'label': 'Name', 'value': _task['customerName'] as String},
                    {
                      'label': 'Phone',
                      'value': _task['customerPhone'] as String,
                      'isPhone': true,
                    },
                    {
                      'label': 'Address',
                      'value': _task['customerAddress'] as String,
                    },
                    {
                      'label': 'Time Slot',
                      'value': _task['timeSlot'] as String,
                    },
                  ],
                ),
                const SizedBox(height: 12),
                InfoCardWidget(
                  title: 'Partner / Store Info',
                  icon: Icons.store_rounded,
                  iconColor: AppTheme.secondary,
                  fields: [
                    {'label': 'Store', 'value': _task['partnerName'] as String},
                    {
                      'label': 'Phone',
                      'value': _task['partnerPhone'] as String,
                      'isPhone': true,
                    },
                    {
                      'label': 'Address',
                      'value': _task['partnerAddress'] as String,
                    },
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DeviceDetailsCardWidget(
                  deviceType: _task['deviceType'] as String,
                  brand: _task['deviceBrand'] as String,
                  model: _task['deviceModel'] as String,
                  issue: _task['issue'] as String,
                ),
                const SizedBox(height: 12),
                _buildEarningsCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.currency_rupee_rounded,
              color: AppTheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Earnings',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              Text(
                '₹${(_task['earnings'] as double).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _task['priority'] == 'high' ? '+₹15 Bonus' : 'Standard',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

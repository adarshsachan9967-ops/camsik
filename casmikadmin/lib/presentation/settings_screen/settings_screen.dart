import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Company settings
  final _companyNameCtrl = TextEditingController(
    text: 'Casmik Technologies Pvt Ltd',
  );
  final _companyEmailCtrl = TextEditingController(text: 'support@casmik.com');
  final _companyPhoneCtrl = TextEditingController(text: '+91 98765 43210');
  final _companyAddressCtrl = TextEditingController(
    text: 'Mumbai, Maharashtra, India',
  );

  // Payment settings
  bool _razorpayEnabled = true;
  bool _upiEnabled = true;
  bool _bankTransferEnabled = true;
  final _razorpayKeyCtrl = TextEditingController(text: 'rzp_live_xxxx');

  // Notification settings
  bool _orderNotifs = true;
  bool _partnerNotifs = true;
  bool _payoutNotifs = true;
  bool _systemNotifs = false;

  // Delivery settings
  final _deliveryRadiusCtrl = TextEditingController(text: '25');
  final _maxOrdersCtrl = TextEditingController(text: '5');
  bool _autoAssign = true;

  // Commission settings
  final _partnerCommissionCtrl = TextEditingController(text: '15');
  final _agentCommissionCtrl = TextEditingController(text: '8');
  final _platformFeeCtrl = TextEditingController(text: '5');

  // Security settings
  bool _twoFactorAuth = true;
  bool _sessionTimeout = true;
  final _sessionTimeoutCtrl = TextEditingController(text: '30');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5);
    final cardColor = isDark ? const Color(0xFF141414) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);
    final borderColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111111) : Colors.white,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF00C853),
                    unselectedLabelColor: subColor,
                    indicatorColor: const Color(0xFF00C853),
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: 'Company'),
                      Tab(text: 'Payment'),
                      Tab(text: 'Notifications'),
                      Tab(text: 'Delivery'),
                      Tab(text: 'Commission'),
                      Tab(text: 'Security'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCompanyTab(
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    isDark,
                  ),
                  _buildPaymentTab(
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    isDark,
                  ),
                  _buildNotificationsTab(
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    isDark,
                  ),
                  _buildDeliveryTab(
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    isDark,
                  ),
                  _buildCommissionTab(
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    isDark,
                  ),
                  _buildSecurityTab(
                    cardColor,
                    textColor,
                    subColor,
                    borderColor,
                    isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyTab(
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _settingsCard(
            'Company Information',
            [
              _settingsField(
                'Company Name',
                _companyNameCtrl,
                isDark,
                textColor,
                borderColor,
              ),
              _settingsField(
                'Support Email',
                _companyEmailCtrl,
                isDark,
                textColor,
                borderColor,
              ),
              _settingsField(
                'Phone Number',
                _companyPhoneCtrl,
                isDark,
                textColor,
                borderColor,
              ),
              _settingsField(
                'Address',
                _companyAddressCtrl,
                isDark,
                textColor,
                borderColor,
              ),
            ],
            cardColor,
            textColor,
            subColor,
            borderColor,
          ),
          const SizedBox(height: 12),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _buildPaymentTab(
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _settingsCard(
            'Payment Gateways',
            [
              _toggleRow(
                'Razorpay',
                'Primary payment gateway',
                _razorpayEnabled,
                (v) => setState(() => _razorpayEnabled = v),
                textColor,
                subColor,
              ),
              _toggleRow(
                'UPI Payments',
                'Accept UPI transactions',
                _upiEnabled,
                (v) => setState(() => _upiEnabled = v),
                textColor,
                subColor,
              ),
              _toggleRow(
                'Bank Transfer',
                'Direct bank transfers',
                _bankTransferEnabled,
                (v) => setState(() => _bankTransferEnabled = v),
                textColor,
                subColor,
              ),
              _settingsField(
                'Razorpay API Key',
                _razorpayKeyCtrl,
                isDark,
                textColor,
                borderColor,
              ),
            ],
            cardColor,
            textColor,
            subColor,
            borderColor,
          ),
          const SizedBox(height: 12),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab(
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _settingsCard(
            'Notification Preferences',
            [
              _toggleRow(
                'Order Notifications',
                'New orders and status updates',
                _orderNotifs,
                (v) => setState(() => _orderNotifs = v),
                textColor,
                subColor,
              ),
              _toggleRow(
                'Partner Notifications',
                'Partner approvals and activity',
                _partnerNotifs,
                (v) => setState(() => _partnerNotifs = v),
                textColor,
                subColor,
              ),
              _toggleRow(
                'Payout Notifications',
                'Payment and payout alerts',
                _payoutNotifs,
                (v) => setState(() => _payoutNotifs = v),
                textColor,
                subColor,
              ),
              _toggleRow(
                'System Notifications',
                'System updates and maintenance',
                _systemNotifs,
                (v) => setState(() => _systemNotifs = v),
                textColor,
                subColor,
              ),
            ],
            cardColor,
            textColor,
            subColor,
            borderColor,
          ),
          const SizedBox(height: 12),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _buildDeliveryTab(
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _settingsCard(
            'Delivery Configuration',
            [
              _settingsField(
                'Delivery Radius (km)',
                _deliveryRadiusCtrl,
                isDark,
                textColor,
                borderColor,
                isNumber: true,
              ),
              _settingsField(
                'Max Orders per Agent',
                _maxOrdersCtrl,
                isDark,
                textColor,
                borderColor,
                isNumber: true,
              ),
              _toggleRow(
                'Auto-assign Orders',
                'Automatically assign to nearest agent',
                _autoAssign,
                (v) => setState(() => _autoAssign = v),
                textColor,
                subColor,
              ),
            ],
            cardColor,
            textColor,
            subColor,
            borderColor,
          ),
          const SizedBox(height: 12),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _buildCommissionTab(
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _settingsCard(
            'Commission Rates',
            [
              _settingsField(
                'Partner Commission (%)',
                _partnerCommissionCtrl,
                isDark,
                textColor,
                borderColor,
                isNumber: true,
              ),
              _settingsField(
                'Agent Commission (%)',
                _agentCommissionCtrl,
                isDark,
                textColor,
                borderColor,
                isNumber: true,
              ),
              _settingsField(
                'Platform Fee (%)',
                _platformFeeCtrl,
                isDark,
                textColor,
                borderColor,
                isNumber: true,
              ),
            ],
            cardColor,
            textColor,
            subColor,
            borderColor,
          ),
          const SizedBox(height: 12),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _buildSecurityTab(
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _settingsCard(
            'Security Settings',
            [
              _toggleRow(
                'Two-Factor Authentication',
                'Require 2FA for admin login',
                _twoFactorAuth,
                (v) => setState(() => _twoFactorAuth = v),
                textColor,
                subColor,
              ),
              _toggleRow(
                'Session Timeout',
                'Auto logout after inactivity',
                _sessionTimeout,
                (v) => setState(() => _sessionTimeout = v),
                textColor,
                subColor,
              ),
              _settingsField(
                'Timeout Duration (minutes)',
                _sessionTimeoutCtrl,
                isDark,
                textColor,
                borderColor,
                isNumber: true,
              ),
            ],
            cardColor,
            textColor,
            subColor,
            borderColor,
          ),
          const SizedBox(height: 12),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _settingsCard(
    String title,
    List<Widget> children,
    Color cardColor,
    Color textColor,
    Color subColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...children.map(
            (w) =>
                Padding(padding: const EdgeInsets.only(bottom: 12), child: w),
          ),
        ],
      ),
    );
  }

  Widget _settingsField(
    String label,
    TextEditingController ctrl,
    bool isDark,
    Color textColor,
    Color borderColor, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: textColor, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark
                ? const Color(0xFF1E1E1E)
                : const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00C853)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    Color textColor,
    Color subColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(subtitle, style: TextStyle(color: subColor, fontSize: 11)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF00C853),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Color(0xFF00C853),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF00C853),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Save Changes',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
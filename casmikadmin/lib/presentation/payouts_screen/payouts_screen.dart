import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/bank_transfer_log_widget.dart';
import './widgets/bank_verification_tickets_widget.dart';
import './widgets/gateway_payments_widget.dart';
import './widgets/payouts_tab_bar_widget.dart';
import 'widgets/bank_transfer_log_widget.dart';
import 'widgets/bank_verification_tickets_widget.dart';
import 'widgets/gateway_payments_widget.dart';
import 'widgets/payouts_tab_bar_widget.dart';

class PayoutsScreen extends StatefulWidget {
  const PayoutsScreen({super.key});

  @override
  State<PayoutsScreen> createState() => _PayoutsScreenState();
}

class _PayoutsScreenState extends State<PayoutsScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with [Riverpod/Bloc] for production
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSummaryRow(),
            PayoutsTabBarWidget(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  GatewayPaymentsWidget(),
                  BankTransferLogWidget(),
                  BankVerificationTicketsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payouts',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Partners Payments & Wallets',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffff980015),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xffff980030)),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'pending_actions',
                  color: AppTheme.warning,
                  size: 13,
                ),
                const SizedBox(width: 4),
                const Text(
                  '23 pending',
                  style: TextStyle(
                    color: AppTheme.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          _SummaryTile(
            label: 'Total Payable',
            value: '\$42,180',
            color: AppTheme.casmikGreen,
          ),
          const SizedBox(width: 8),
          _SummaryTile(
            label: 'Paid This Month',
            value: '\$128,400',
            color: const Color(0xFF2196F3),
          ),
          const SizedBox(width: 8),
          _SummaryTile(
            label: 'Pending Verify',
            value: '7 tickets',
            color: AppTheme.warning,
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PayoutsTabBarWidget extends StatelessWidget {
  final TabController controller;

  const PayoutsTabBarWidget({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          color: AppTheme.casmikGreenDim,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.casmikGreenMuted),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppTheme.casmikGreen,
        unselectedLabelColor: AppTheme.textMuted,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Gateway Payments', height: 34),
          Tab(text: 'Bank Transfer Log', height: 34),
          Tab(text: 'Bank Verify Tickets', height: 34),
        ],
      ),
    );
  }
}

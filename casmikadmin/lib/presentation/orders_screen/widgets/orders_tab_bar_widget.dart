import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class OrdersTabBarWidget extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const OrdersTabBarWidget({
    required this.controller,
    required this.tabs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
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
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        padding: const EdgeInsets.all(4),
        tabs: tabs.map((t) => Tab(text: t, height: 32)).toList(),
      ),
    );
  }
}

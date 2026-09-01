import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class PartnersTabWidget extends StatelessWidget {
  final TabController controller;

  const PartnersTabWidget({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppTheme.casmikGreenDim,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.casmikGreenMuted),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppTheme.casmikGreen,
        unselectedLabelColor: AppTheme.textMuted,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Approved', height: 36),
          Tab(text: 'Pending Verification', height: 36),
        ],
      ),
    );
  }
}

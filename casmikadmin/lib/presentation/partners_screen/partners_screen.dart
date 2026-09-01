import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/approved_partners_widget.dart';
import './widgets/partners_tab_widget.dart';
import './widgets/pending_partners_widget.dart';
import 'widgets/approved_partners_widget.dart';
import 'widgets/partners_tab_widget.dart';
import 'widgets/pending_partners_widget.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with [Riverpod/Bloc] for production
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            PartnersTabWidget(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ApprovedPartnersWidget(),
                  PendingPartnersWidget(),
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
          const Text(
            'Partners',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xff9c27b015),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xff9c27b030)),
            ),
            child: const Text(
              '142 approved',
              style: TextStyle(
                color: Color(0xFF9C27B0),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xffff980015),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xffff980030)),
            ),
            child: const Text(
              '8 pending',
              style: TextStyle(
                color: AppTheme.warning,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

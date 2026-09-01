import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/customers_list_widget.dart';
import './widgets/customers_search_filter_widget.dart';
import 'widgets/customers_list_widget.dart';
import 'widgets/customers_search_filter_widget.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  // TODO: Replace with [Riverpod/Bloc] for production
  String _searchQuery = '';
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            CustomersSearchFilterWidget(
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              selectedFilter: _statusFilter,
              onFilterChanged: (v) => setState(() => _statusFilter = v),
            ),
            Expanded(
              child: CustomersListWidget(
                searchQuery: _searchQuery,
                statusFilter: _statusFilter,
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
            'Customers',
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
              color: const Color(0xff2196f315),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xff2196f330)),
            ),
            child: const Text(
              '18,294 total',
              style: TextStyle(
                color: Color(0xFF2196F3),
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
                iconName: 'download_outlined',
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

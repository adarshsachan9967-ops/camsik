import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/orders_list_widget.dart';
import './widgets/live_tracker_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  int _activeTab = 0; // 0 = Orders List, 1 = Live Tracker
  String _searchQuery = '';
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';

  static const List<String> _typeOptions = [
    'All Types',
    'Sell',
    'Buy',
    'Exchange',
    'Repair',
    'Pickup',
  ];
  static const List<String> _statusOptions = [
    'All Status',
    'Pending',
    'Under Inspection',
    'Active',
    'Completed',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabSwitcher(),
            _buildStatsRow(),
            _buildSearchAndFilter(),
            Expanded(
              child: _activeTab == 0
                  ? OrdersListWidget(
                      filterType: _selectedType == 'All Types'
                          ? 'All'
                          : _selectedType,
                      searchQuery: _searchQuery,
                      statusFilter: _selectedStatus == 'All Status'
                          ? 'All'
                          : _selectedStatus,
                    )
                  : const LiveTrackerWidget(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Orders',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Orders Management',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff00c85320),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.casmikGreen),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.casmikGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Live',
                          style: TextStyle(
                            color: AppTheme.casmikGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Text(
                'All orders across sell, buy, exchange & repair',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() {}),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Row(
                children: [
                  const CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.textSecondary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Refresh',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _TabButton(
            label: 'Orders List',
            icon: 'list_alt',
            isActive: _activeTab == 0,
            onTap: () => setState(() => _activeTab = 0),
          ),
          const SizedBox(width: 8),
          _TabButton(
            label: 'Live Tracker',
            icon: 'radio_button_checked',
            isActive: _activeTab == 1,
            onTap: () => setState(() => _activeTab = 1),
            isLive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {
        'icon': 'inventory_2',
        'value': '12',
        'label': 'Total Orders',
        'color': const Color(0xFF8B7355),
      },
      {
        'icon': 'hourglass_empty',
        'value': '3',
        'label': 'Pending',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': 'sync',
        'value': '5',
        'label': 'Active',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': 'check_circle',
        'value': '3',
        'label': 'Completed',
        'color': const Color(0xFF00C853),
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: stats.indexOf(s) < stats.length - 1 ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: s['icon'] as String,
                    color: s['color'] as Color,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s['value'] as String,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          s['label'] as String,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textMuted,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search orders, customers, devices...',
                        hintStyle: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _DropdownFilter(
            value: _selectedType,
            options: _typeOptions,
            onChanged: (v) => setState(() => _selectedType = v),
          ),
          const SizedBox(width: 8),
          _DropdownFilter(
            value: _selectedStatus,
            options: _statusOptions,
            onChanged: (v) => setState(() => _selectedStatus = v),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool isActive;
  final bool isLive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.casmikGreen : AppTheme.surfaceVariantDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppTheme.casmikGreen : const Color(0xFF2A2A2A),
          ),
        ),
        child: Row(
          children: [
            if (isLive && !isActive)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CustomIconWidget(
                  iconName: icon,
                  color: isActive ? Colors.black : AppTheme.textSecondary,
                  size: 14,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black : AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  final String value;
  final List<String> options;
  final void Function(String) onChanged;

  const _DropdownFilter({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppTheme.surfaceElevatedDark,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.textMuted,
            size: 14,
          ),
          items: options
              .map(
                (o) => DropdownMenuItem(
                  value: o,
                  child: Text(
                    o,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}

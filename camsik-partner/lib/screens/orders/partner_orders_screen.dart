import 'package:flutter/material.dart';
import '../../models/partner_models.dart';
import 'widgets/order_card_widget.dart';
import 'widgets/order_detail_sheet.dart';

class PartnerOrdersScreen extends StatefulWidget {
  final List<PartnerOrder> orders;
  final bool loading;
  final Future<void> Function() onRefresh;

  const PartnerOrdersScreen({
    super.key,
    required this.orders,
    required this.loading,
    required this.onRefresh,
  });

  @override
  State<PartnerOrdersScreen> createState() => _PartnerOrdersScreenState();
}

class _PartnerOrdersScreenState extends State<PartnerOrdersScreen> {
  String _selectedStatus = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PartnerOrder> get _filteredOrders {
    return widget.orders.where((o) {
      final matchesStatus =
          _selectedStatus == 'all' || o.status == _selectedStatus;
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          o.orderNumber.toLowerCase().contains(q) ||
          o.customerName.toLowerCase().contains(q) ||
          o.deviceName.toLowerCase().contains(q);
      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) =>
                      setState(() => _searchQuery = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search by Order ID, Device or Customer...',
                    hintStyle:
                        const TextStyle(fontSize: 12, color: Colors.black45),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip(
                          'all', 'All Orders (${widget.orders.length})'),
                      _buildChip('assigned', 'Assigned'),
                      _buildChip('inspection', 'In QA'),
                      _buildChip('completed', 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: widget.loading && widget.orders.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 48,
                                color: Colors.black.withValues(alpha: 0.2)),
                            const SizedBox(height: 12),
                            const Text(
                              'No orders match your filter criteria.',
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, idx) {
                          final order = _filteredOrders[idx];
                          return OrderCardWidget(
                            order: order,
                            onTap: () => OrderDetailSheet.show(
                              context: context,
                              order: order,
                              onRefresh: widget.onRefresh,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String status, String label) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFFF1F5F9),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        onSelected: (_) => setState(() => _selectedStatus = status),
      ),
    );
  }
}

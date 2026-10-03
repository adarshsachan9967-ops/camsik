import 'package:flutter/material.dart';
import '../../models/admin_models.dart';
import '../../services/api_service.dart';
import 'widgets/admin_order_card.dart';
import 'widgets/admin_order_detail_modal.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  bool _isLoading = true;
  List<AdminOrder> _allOrders = [];
  List<AdminPartner> _partners = [];
  List<AdminDeliveryAgent> _agents = [];

  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedType = 'all';

  final _searchController = TextEditingController();

  final List<String> _statuses = [
    'all',
    'pending',
    'assigned',
    'out_for_pickup',
    'picked_up',
    'inspection_in_progress',
    'completed',
    'cancelled',
  ];

  final List<String> _types = [
    'all',
    'sell',
    'buy',
    'repair',
    'exchange',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final orders = await ApiService.fetchOrders(
      search: _searchQuery,
      status: _selectedStatus,
      type: _selectedType,
    );
    final partners = await ApiService.fetchPartners();
    final agents = await ApiService.fetchDeliveryAgents();

    if (!mounted) return;
    setState(() {
      _allOrders = orders;
      _partners = partners;
      _agents = agents;
      _isLoading = false;
    });
  }

  void _showOrderDetailSheet(AdminOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AdminOrderDetailModal(
        order: order,
        partners: _partners,
        agents: _agents,
        onOrderUpdated: () {
          Navigator.pop(ctx);
          _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders Command Center',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                    _loadData();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Order ID, Customer, Phone, Device...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                              _loadData();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statuses.map((s) {
                      final isSelected = _selectedStatus == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(
                            s == 'all'
                                ? 'All Status'
                                : s.replaceAll('_', ' ').toUpperCase(),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF475569),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF7C3AED),
                          backgroundColor: const Color(0xFFF1F5F9),
                          showCheckmark: false,
                          onSelected: (_) {
                            setState(() => _selectedStatus = s);
                            _loadData();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 4),
                // Type Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _types.map((t) {
                      final isSelected = _selectedType == t;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(t == 'all' ? 'All Types' : t.toUpperCase()),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFF64748B),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF7C3AED).withAlpha(35),
                          backgroundColor: Colors.transparent,
                          onSelected: (_) {
                            setState(() => _selectedType = t);
                            _loadData();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Order Card List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
                  )
                : _allOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              size: 54,
                              color: Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No matching orders found',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try clearing filters or search term',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _selectedStatus = 'all';
                                  _selectedType = 'all';
                                });
                                _loadData();
                              },
                              child: const Text('Reset All Filters'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        color: const Color(0xFF7C3AED),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _allOrders.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (ctx, idx) {
                            final o = _allOrders[idx];
                            return AdminOrderCard(
                              order: o,
                              onTap: () => _showOrderDetailSheet(o),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

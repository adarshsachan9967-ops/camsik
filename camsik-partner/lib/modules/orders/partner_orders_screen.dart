import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/orders_cubit.dart';
import 'bloc/orders_state.dart';
import 'widgets/order_card_widget.dart';
import 'widgets/order_detail_sheet.dart';

class PartnerOrdersScreen extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const PartnerOrdersScreen({
    super.key,
    this.onRefresh,
  });

  @override
  State<PartnerOrdersScreen> createState() => _PartnerOrdersScreenState();
}

class _PartnerOrdersScreenState extends State<PartnerOrdersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
        }

        if (state is OrdersFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Color(0xFFDC2626)),
                const SizedBox(height: 12),
                Text(state.error, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<OrdersCubit>().loadOrders(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is OrdersLoaded) {
          final filtered = state.filteredOrders;

          return RefreshIndicator(
            onRefresh: () async {
              if (widget.onRefresh != null) {
                await widget.onRefresh!();
              } else {
                await context.read<OrdersCubit>().loadOrders();
              }
            },
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
                        onChanged: (val) => context.read<OrdersCubit>().searchOrders(val),
                        decoration: InputDecoration(
                          hintText: 'Search by Order ID, Device or Customer...',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.black45),
                          prefixIcon: const Icon(Icons.search, size: 18),
                          suffixIcon: state.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<OrdersCubit>().searchOrders('');
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
                              context,
                              'all',
                              'All Orders (${state.allOrders.length})',
                              state.selectedStatus,
                            ),
                            _buildChip(context, 'assigned', 'Assigned', state.selectedStatus),
                            _buildChip(context, 'inspection', 'In QA', state.selectedStatus),
                            _buildChip(context, 'completed', 'Completed', state.selectedStatus),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Orders List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 48, color: Colors.black.withValues(alpha: 0.2)),
                              const SizedBox(height: 12),
                              const Text(
                                'No orders match your filter criteria.',
                                style: TextStyle(color: Colors.black45, fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filtered.length,
                          itemBuilder: (ctx, idx) {
                            final order = filtered[idx];
                            return OrderCardWidget(
                              order: order,
                              onTap: () => OrderDetailSheet.show(
                                context: ctx,
                                order: order,
                                onUpdateStatus: (newStatus) {
                                  context.read<OrdersCubit>().updateOrderStatus(
                                        orderId: order.id,
                                        status: newStatus,
                                      );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChip(BuildContext context, String status, String label, String currentStatus) {
    final isSelected = currentStatus == status;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        onSelected: (_) => context.read<OrdersCubit>().filterByStatus(status),
      ),
    );
  }
}

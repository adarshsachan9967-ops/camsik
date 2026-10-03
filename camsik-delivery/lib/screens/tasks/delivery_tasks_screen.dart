import 'package:flutter/material.dart';
import '../../models/delivery_models.dart';
import 'widgets/task_card_widget.dart';
import 'widgets/task_detail_sheet.dart';

class DeliveryTasksScreen extends StatefulWidget {
  final List<DeliveryTask> tasks;
  final bool loading;
  final Future<void> Function() onRefresh;

  const DeliveryTasksScreen({
    super.key,
    required this.tasks,
    required this.loading,
    required this.onRefresh,
  });

  @override
  State<DeliveryTasksScreen> createState() => _DeliveryTasksScreenState();
}

class _DeliveryTasksScreenState extends State<DeliveryTasksScreen> {
  String _filter = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DeliveryTask> get _filteredTasks {
    return widget.tasks.where((t) {
      if (_filter == 'pickup' && !t.isPickup) {
        return false;
      }
      if (_filter == 'delivery' && t.isPickup) {
        return false;
      }
      if (_filter == 'completed' &&
          t.status != 'completed' &&
          t.status != 'paid') {
        return false;
      }

      final q = _searchQuery.toLowerCase();
      return q.isEmpty ||
          t.orderNumber.toLowerCase().contains(q) ||
          t.customerName.toLowerCase().contains(q) ||
          t.deviceName.toLowerCase().contains(q) ||
          t.customerAddress.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search Task ID, Customer or Street...',
                    hintStyle:
                        const TextStyle(fontSize: 12, color: Colors.black45),
                    prefixIcon: const Icon(Icons.search, size: 18),
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
                          'all', 'All Runs (${widget.tasks.length})'),
                      _buildChip('pickup', 'Pickups'),
                      _buildChip('delivery', 'Deliveries'),
                      _buildChip('completed', 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.loading && widget.tasks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No matching delivery tasks found.',
                          style: TextStyle(
                              color: Colors.black45, fontSize: 13),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredTasks.length,
                        itemBuilder: (_, idx) => TaskCardWidget(
                          task: _filteredTasks[idx],
                          onTap: () => TaskDetailSheet.show(
                            context: context,
                            task: _filteredTasks[idx],
                            onRefresh: widget.onRefresh,
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String key, String label) {
    final isSelected = _filter == key;
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
        selectedColor: const Color(0xFF059669),
        backgroundColor: const Color(0xFFF1F5F9),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCheckmark: false,
        onSelected: (_) => setState(() => _filter = key),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/admin_models.dart';
import '../../services/api_service.dart';

class AdminFleetScreen extends StatefulWidget {
  const AdminFleetScreen({super.key});

  @override
  State<AdminFleetScreen> createState() => _AdminFleetScreenState();
}

class _AdminFleetScreenState extends State<AdminFleetScreen> {
  bool _isLoading = true;
  List<AdminDeliveryAgent> _agents = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    setState(() => _isLoading = true);
    final list = await ApiService.fetchDeliveryAgents();
    if (!mounted) return;
    setState(() {
      _agents = list;
      _isLoading = false;
    });
  }

  Future<void> _toggleDuty(AdminDeliveryAgent agent) async {
    final newDuty = agent.dutyStatus == 'online' ? 'offline' : 'online';
    final ok = await ApiService.updateAgentDutyStatus(
      agentId: agent.id,
      dutyStatus: newDuty,
    );
    if (!mounted) return;
    if (ok) {
      _loadAgents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _agents.where((a) {
      final q = _searchQuery.toLowerCase();
      return a.name.toLowerCase().contains(q) ||
          a.zone.toLowerCase().contains(q) ||
          a.phone.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Fleet Logistics',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAgents),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search Rider Name, Phone, Zone...',
                prefixIcon: const Icon(Icons.search, size: 20),
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
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
                  )
                : RefreshIndicator(
                    onRefresh: _loadAgents,
                    color: const Color(0xFF7C3AED),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (ctx, idx) {
                        final a = filtered[idx];
                        final isOnline = a.dutyStatus == 'online';
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2563EB)
                                                .withAlpha(20),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.two_wheeler,
                                            color: Color(0xFF2563EB),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              a.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            Text(
                                              '${a.phone} • ${a.zone}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isOnline
                                            ? const Color(0xFF10B981)
                                                .withAlpha(25)
                                            : Colors.grey.withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        a.dutyStatus.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isOnline
                                              ? const Color(0xFF059669)
                                              : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color(0xFFF1F5F9),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Vehicle: ${a.vehicleType}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                    Text(
                                      'Rating: ⭐ ${a.rating.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                    Text(
                                      'Active Tasks: ${a.activeOrders}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isOnline
                                            ? Colors.orange[800]
                                            : const Color(0xFF059669),
                                      ),
                                      icon: Icon(
                                        isOnline
                                            ? Icons.bedtime_outlined
                                            : Icons.wb_sunny_outlined,
                                        size: 16,
                                      ),
                                      label: Text(
                                        isOnline ? 'Set Offline' : 'Set Online',
                                      ),
                                      onPressed: () => _toggleDuty(a),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

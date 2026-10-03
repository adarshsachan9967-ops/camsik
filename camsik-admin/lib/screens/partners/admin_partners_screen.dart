import 'package:flutter/material.dart';
import '../../models/admin_models.dart';
import '../../services/api_service.dart';

class AdminPartnersScreen extends StatefulWidget {
  const AdminPartnersScreen({super.key});

  @override
  State<AdminPartnersScreen> createState() => _AdminPartnersScreenState();
}

class _AdminPartnersScreenState extends State<AdminPartnersScreen> {
  bool _isLoading = true;
  List<AdminPartner> _partners = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    setState(() => _isLoading = true);
    final list = await ApiService.fetchPartners();
    if (!mounted) return;
    setState(() {
      _partners = list;
      _isLoading = false;
    });
  }

  Future<void> _togglePartnerStatus(AdminPartner partner) async {
    final newStatus = partner.status == 'active' ? 'suspended' : 'active';
    final ok = await ApiService.updatePartnerStatus(
      partnerId: partner.id,
      status: newStatus,
    );
    if (!mounted) return;
    if (ok) {
      _loadPartners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: newStatus == 'active'
              ? const Color(0xFF059669)
              : Colors.redAccent,
          content: Text(
            '${partner.storeName} status updated to ${newStatus.toUpperCase()}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _partners.where((p) {
      final q = _searchQuery.toLowerCase();
      return p.storeName.toLowerCase().contains(q) ||
          p.ownerName.toLowerCase().contains(q) ||
          p.city.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Partner Network',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPartners),
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
                hintText: 'Search Store Name, Owner, City...',
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
                    onRefresh: _loadPartners,
                    color: const Color(0xFF7C3AED),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (ctx, idx) {
                        final p = filtered[idx];
                        final isActive = p.status == 'active';
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
                                            color: const Color(0xFF7C3AED)
                                                .withAlpha(20),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.store,
                                            color: Color(0xFF7C3AED),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.storeName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            Text(
                                              '${p.ownerName} • ${p.city}',
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
                                        color: isActive
                                            ? const Color(0xFF10B981)
                                                .withAlpha(25)
                                            : Colors.redAccent.withAlpha(25),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        p.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isActive
                                              ? const Color(0xFF059669)
                                              : Colors.redAccent,
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
                                      'Rating: ⭐ ${p.rating.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                    Text(
                                      'Commission: ${p.commissionRate.toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                    Text(
                                      'Total QA: ${p.totalOrders}',
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
                                        foregroundColor: isActive
                                            ? Colors.redAccent
                                            : const Color(0xFF059669),
                                        side: BorderSide(
                                          color: isActive
                                              ? Colors.redAccent
                                              : const Color(0xFF059669),
                                        ),
                                      ),
                                      icon: Icon(
                                        isActive
                                            ? Icons.block
                                            : Icons.check_circle,
                                        size: 16,
                                      ),
                                      label: Text(
                                        isActive
                                            ? 'Suspend Hub'
                                            : 'Activate Hub',
                                      ),
                                      onPressed: () =>
                                          _togglePartnerStatus(p),
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

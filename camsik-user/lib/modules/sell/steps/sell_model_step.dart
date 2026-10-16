import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class SellModelStep extends StatefulWidget {
  final List<Map<String, dynamic>> models;
  final String? brandName;
  final bool isLoading;
  final Function(Map<String, dynamic> model) onSelectModel;

  const SellModelStep({
    super.key,
    required this.models,
    this.brandName,
    this.isLoading = false,
    required this.onSelectModel,
  });

  @override
  State<SellModelStep> createState() => _SellModelStepState();
}

class _SellModelStepState extends State<SellModelStep> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = widget.models.where((m) {
      if (query.isEmpty) return true;
      final name = (m['name'] as String? ?? '').toLowerCase();
      final brand = (m['brand'] as String? ?? '').toLowerCase();
      return name.contains(query) || brand.contains(query);
    }).toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: widget.brandName != null && widget.brandName!.isNotEmpty
                    ? 'Search ${widget.brandName} models...'
                    : 'Search device model...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
        ),

        // Subheader showing count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.brandName != null && widget.brandName!.isNotEmpty
                    ? '${widget.brandName} Models (${filtered.length})'
                    : 'Available Models (${filtered.length})',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                'Instant Doorstep Valuation',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF059669), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        // Models List
        Expanded(
          child: widget.isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF059669)))
              : filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.devices_other_rounded, size: 44, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 10),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No models found for "$_searchQuery"'
                                  : 'No models available for this brand',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Try clearing your search or choose a different brand',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 10),
                      itemBuilder: (ctx, idx) {
                        final m = filtered[idx];
                        final name = m['name'] as String? ?? 'Device';
                        final brand = m['brand'] as String? ?? '';
                        final basePrice = (m['basePrice'] as num?)?.toInt() ?? 50000;
                        final image = m['image'] as String? ?? 'assets/images/categories/dslr.png';
                        final specsRaw = m['specs'];
                        final specs = specsRaw is Map
                            ? (specsRaw.entries.map((e) => '${e.key}: ${e.value}').take(2).join(' · '))
                            : (specsRaw?.toString() ?? '');

                        return InkWell(
                          onTap: () => widget.onSelectModel(m),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Real Model Image
                                Container(
                                  width: 60,
                                  height: 60,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CamsikSmartImage(
                                    image: image,
                                    fit: BoxFit.contain,
                                    iconSize: 30,
                                    iconColor: const Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                      ),
                                      if (brand.isNotEmpty)
                                        Text(brand, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                      if (specs.isNotEmpty)
                                        Text(
                                          specs,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Up to', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                    Text(
                                      formatCurrency(basePrice),
                                      style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF059669), fontSize: 14),
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
      ],
    );
  }
}

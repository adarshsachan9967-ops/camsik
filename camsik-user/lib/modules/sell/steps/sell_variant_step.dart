import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../widgets/camsik_smart_image.dart';

class SellVariantStep extends StatefulWidget {
  final Map<String, dynamic>? selectedModel;
  final String? categoryId;
  final int basePrice;
  final String selectedStorage;
  final String selectedColor;
  final List<Map<String, dynamic>> selectedLenses;
  final Function(String storage) onStorageChanged;
  final Function(String color) onColorChanged;
  final Function(List<Map<String, dynamic>> lenses) onLensesChanged;
  final VoidCallback onProceed;

  const SellVariantStep({
    super.key,
    required this.selectedModel,
    this.categoryId,
    required this.basePrice,
    required this.selectedStorage,
    required this.selectedColor,
    required this.selectedLenses,
    required this.onStorageChanged,
    required this.onColorChanged,
    required this.onLensesChanged,
    required this.onProceed,
  });

  @override
  State<SellVariantStep> createState() => _SellVariantStepState();
}

class _SellVariantStepState extends State<SellVariantStep> {
  List<Map<String, dynamic>> _availableLenses = [];
  bool _isLoadingLenses = false;
  bool _showCustomLensInput = false;
  final TextEditingController _customLensController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLenses();
  }

  @override
  void dispose() {
    _customLensController.dispose();
    super.dispose();
  }

  void _loadLenses() {
    setState(() {
      _availableLenses = List.from(ApiService.cachedLenses);
      _isLoadingLenses = _availableLenses.isEmpty;
    });

    ApiService.fetchLenses().then((fetched) {
      if (mounted) {
        setState(() {
          _availableLenses = List.from(fetched);
          _isLoadingLenses = false;
        });
      }
    }).catchError((_) {
      if (mounted) setState(() => _isLoadingLenses = false);
    });
  }

  Color _resolveColorSwatch(String colorName) {
    final lower = colorName.toLowerCase();
    if (lower.contains('black') || lower.contains('midnight') || lower.contains('dark')) {
      return const Color(0xFF18181B);
    }
    if (lower.contains('white') || lower.contains('starlight') || lower.contains('silver')) {
      return const Color(0xFFE2E8F0);
    }
    if (lower.contains('grey') || lower.contains('gray') || lower.contains('graphite') || lower.contains('titanium')) {
      return const Color(0xFF64748B);
    }
    if (lower.contains('blue')) {
      return const Color(0xFF2563EB);
    }
    if (lower.contains('gold') || lower.contains('bronze') || lower.contains('yellow')) {
      return const Color(0xFFD97706);
    }
    if (lower.contains('green') || lower.contains('olive')) {
      return const Color(0xFF059669);
    }
    if (lower.contains('red')) {
      return const Color(0xFFDC2626);
    }
    if (lower.contains('purple') || lower.contains('violet')) {
      return const Color(0xFF7C3AED);
    }
    return const Color(0xFF475569);
  }

  void _toggleLens(Map<String, dynamic> lens) {
    final current = List<Map<String, dynamic>>.from(widget.selectedLenses);
    final existsIndex = current.indexWhere((l) => l['id'] == lens['id']);

    if (existsIndex != -1) {
      current.removeAt(existsIndex);
    } else {
      current.add(lens);
    }
    widget.onLensesChanged(current);
  }

  void _addCustomLens() {
    final text = _customLensController.text.trim();
    if (text.isEmpty) return;

    final customLens = {
      'id': 'custom-lens-${DateTime.now().millisecondsSinceEpoch}',
      'name': text,
      'type': 'Custom Lens',
      'price': 8000,
      'icon': '📷',
    };

    final current = List<Map<String, dynamic>>.from(widget.selectedLenses);
    current.add(customLens);
    widget.onLensesChanged(current);

    _customLensController.clear();
    setState(() => _showCustomLensInput = false);
  }

  @override
  Widget build(BuildContext context) {
    final storages = (widget.selectedModel?['storages'] as List?)?.cast<String>() ?? ['Standard'];
    final colors = (widget.selectedModel?['colors'] as List?)?.cast<String>() ?? ['Standard Color'];
    final modelName = widget.selectedModel?['name'] as String? ?? 'Selected Device';
    final image = widget.selectedModel?['image'] as String? ?? 'assets/images/categories/dslr.png';

    // Camera detection logic matching the web app
    final catId = widget.categoryId;
    final isCamera = (catId != null &&
            (catId == 'cat-dslr' ||
                catId == 'cat-video-camera' ||
                catId == 'cat-action-camera' ||
                catId == 'cat-lens')) ||
        RegExp(r'camera|dslr|mirrorless|eos|alpha|lumix|nikon|fuji|camcorder|cinema',
                caseSensitive: false)
            .hasMatch(modelName);

    // Calculate total lens bonus
    final totalLensBonus = widget.selectedLenses.fold<int>(
      0,
      (sum, item) => sum + ((item['price'] as num?)?.toInt() ?? 0),
    );
    final totalEstimated = widget.basePrice + totalLensBonus;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. SELECTED DEVICE SUMMARY CARD ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withValues(alpha: 0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CamsikSmartImage(
                    image: image,
                    fit: BoxFit.contain,
                    iconSize: 32,
                    iconColor: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                            width: 0.8,
                          ),
                        ),
                        child: const Text(
                          'DEVICE CONFIRMED',
                          style: TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        modelName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Estimated Base Payout: ',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            formatCurrency(widget.basePrice),
                            style: const TextStyle(
                              color: Color(0xFF34D399),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── 2. STORAGE / CONFIGURATION SELECTION ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.sd_storage_rounded, size: 16, color: Color(0xFF059669)),
                  SizedBox(width: 6),
                  Text(
                    'Storage & Configuration',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFA7F3D0), width: 0.8),
                ),
                child: Text(
                  widget.selectedStorage,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose the internal capacity or kit configuration of your gear',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: storages.map((s) {
              final isSel = widget.selectedStorage == s;
              return _ModernStorageChip(
                label: s,
                isSelected: isSel,
                onTap: () => widget.onStorageChanged(s),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── 3. COLOR / FINISH SELECTION ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.palette_rounded, size: 16, color: Color(0xFF059669)),
                  SizedBox(width: 6),
                  Text(
                    'Device Color & Finish',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFA7F3D0), width: 0.8),
                ),
                child: Text(
                  widget.selectedColor,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Select the exact exterior shade of your device',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: colors.map((c) {
              final isSel = widget.selectedColor == c;
              final swatch = _resolveColorSwatch(c);
              return _ModernColorChip(
                label: c,
                colorSwatch: swatch,
                isSelected: isSel,
                onTap: () => widget.onColorChanged(c),
              );
            }).toList(),
          ),

          // ── 4. CAMERA LENSES SELLING SECTION (DYNAMIC & MATCHING WEB) ──
          if (isCamera) ...[
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lenses Header Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('🔍', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Selling with Camera Lenses? (Optional)',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F172A),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Bundle your lenses with this camera to dramatically increase your final payout.',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      if (_isLoadingLenses)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: Color(0xFF059669),
                            ),
                          ),
                        )
                      else if (widget.selectedLenses.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF86EFAC), width: 0.8),
                          ),
                          child: Text(
                            '+${widget.selectedLenses.length} Lens (+₹$totalLensBonus)',
                            style: const TextStyle(
                              color: Color(0xFF047857),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Lenses List / Grid
                  ..._availableLenses.map((lens) {
                    final lensId = lens['id'] as String? ?? '';
                    final lensName = lens['name'] as String? ?? 'Camera Lens';
                    final lensType = lens['type'] as String? ?? 'Lens';
                    final lensPrice = (lens['price'] as num?)?.toInt() ?? 0;
                    final lensIcon = lens['icon'] as String? ?? '📷';
                    final isSelected = widget.selectedLenses.any((l) => l['id'] == lensId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => _toggleLens(lens),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.6 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Text(lensIcon, style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lensName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      lensType,
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+₹${lensPrice.toString()}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected
                                      ? const Color(0xFF047857)
                                      : const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF059669)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF059669)
                                        : const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 4),

                  // Custom Lens Input or Button
                  if (!_showCustomLensInput) ...[
                    InkWell(
                      onTap: () => setState(() => _showCustomLensInput = true),
                      borderRadius: BorderRadius.circular(10),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded, size: 16, color: Color(0xFF059669)),
                            SizedBox(width: 4),
                            Text(
                              '+ Have another lens? Add custom lens',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF059669), width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _customLensController,
                            style: const TextStyle(fontSize: 12.5),
                            decoration: InputDecoration(
                              hintText: 'e.g. Sigma 30mm f/1.4 DC DN Contemporary',
                              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: _addCustomLens,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Add (+₹8,000)',
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  _customLensController.clear();
                                  setState(() => _showCustomLensInput = false);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF64748B),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                                child: const Text('Cancel', style: TextStyle(fontSize: 11.5)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // ── COMBINED ESTIMATED PAYOUT CARD ──
          if (isCamera && widget.selectedLenses.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Base Camera + ${widget.selectedLenses.length} Lens Included:',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF047857),
                    ),
                  ),
                  Text(
                    formatCurrency(totalEstimated),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            ),

          // ── 5. PROCEED BUTTON ──
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onProceed,
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.selectedLenses.isNotEmpty
                          ? 'Proceed with ${widget.selectedLenses.length} Lenses'
                          : 'Proceed to Device Condition',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 17),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Trust Guarantee Pill
          const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 13, color: Color(0xFF059669)),
                SizedBox(width: 4),
                Text(
                  'Guaranteed price match with zero doorstep renegotiation',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── MODERN STORAGE CHIP ──
class _ModernStorageChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernStorageChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF059669) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.6 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF059669).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E293B),
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

// ── MODERN COLOR CHIP ──
class _ModernColorChip extends StatelessWidget {
  final String label;
  final Color colorSwatch;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernColorChip({
    required this.label,
    required this.colorSwatch,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF059669) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF059669).withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: colorSwatch,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.15),
                  width: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF047857) : const Color(0xFF1E293B),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/partner_models.dart';
import '../../services/api_service.dart';

class PartnerInspectionScreen extends StatefulWidget {
  final List<PartnerOrder> orders;
  final Future<void> Function() onOrderUpdated;

  const PartnerInspectionScreen({
    super.key,
    required this.orders,
    required this.onOrderUpdated,
  });

  @override
  State<PartnerInspectionScreen> createState() =>
      _PartnerInspectionScreenState();
}

class _PartnerInspectionScreenState extends State<PartnerInspectionScreen> {
  PartnerOrder? _selectedOrder;
  bool _screenOriginal = true;
  bool _touchPerfect = true;
  bool _batteryHealthy = true;
  bool _cameraClean = true;
  bool _shutterLow = true;
  bool _motherboardClean = true;
  final double _customDeduction = 0.0;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.orders.isNotEmpty) {
      _selectedOrder = widget.orders.first;
    }
  }

  double _calculateAdjustedPrice() {
    if (_selectedOrder == null) return 0.0;
    double price = _selectedOrder!.quotedPrice;
    if (!_screenOriginal) price -= 4500;
    if (!_touchPerfect) price -= 2500;
    if (!_batteryHealthy) price -= 2000;
    if (!_cameraClean) price -= 3000;
    if (!_shutterLow) price -= 2000;
    if (!_motherboardClean) price -= 5000;
    price -= _customDeduction;
    return price < 1000 ? 1000 : price;
  }

  int _calculateScore() {
    int score = 100;
    if (!_screenOriginal) score -= 20;
    if (!_touchPerfect) score -= 15;
    if (!_batteryHealthy) score -= 15;
    if (!_cameraClean) score -= 15;
    if (!_shutterLow) score -= 10;
    if (!_motherboardClean) score -= 25;
    return score < 20 ? 20 : score;
  }

  Future<void> _submitQA() async {
    if (_selectedOrder == null) return;
    setState(() => _submitting = true);

    final finalVal = _calculateAdjustedPrice();
    final score = _calculateScore();

    final ok = await ApiService.updateOrder(
      orderId: _selectedOrder!.id,
      status: 'inspection_completed',
      finalPrice: finalVal,
      inspectionScore: score,
      notes:
          '45-Point QA Score: $score/100. Certified by Hub Technician.',
    );

    if (mounted) {
      setState(() => _submitting = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text(
                'QA Completed! Score: $score/100 • New Price: ₹${finalVal.toStringAsFixed(0)}'),
          ),
        );
        widget.onOrderUpdated();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Failed to update inspection report on server'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return const Center(child: Text('No orders ready for QA inspection.'));
    }

    final finalPrice = _calculateAdjustedPrice();
    final score = _calculateScore();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Select Order Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PartnerOrder>(
              value: _selectedOrder ?? widget.orders.first,
              isExpanded: true,
              items: widget.orders.map((o) {
                return DropdownMenuItem(
                  value: o,
                  child: Text(
                    '${o.orderNumber} - ${o.deviceName}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedOrder = val);
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Live Valuation Summary Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '45-POINT QA SCORE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$score / 100',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'FINAL RE-VALUATION',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${finalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF34D399),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'Hardware Diagnostic Checklist',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),

        _buildCheckTile(
          'Original OEM Display / Glass',
          'No lines, spots, or third-party replacement',
          _screenOriginal,
          (v) => setState(() => _screenOriginal = v),
        ),
        _buildCheckTile(
          'Touchscreen & Multi-Touch Response',
          'Zero touch ghosting or dead zones',
          _touchPerfect,
          (v) => setState(() => _touchPerfect = v),
        ),
        _buildCheckTile(
          'Battery Health (> 85% / Cycle Count)',
          'Holds peak operational performance',
          _batteryHealthy,
          (v) => setState(() => _batteryHealthy = v),
        ),
        _buildCheckTile(
          'Camera Optics / Sensor Glass',
          'Zero fungus, scratches, or sensor dust',
          _cameraClean,
          (v) => setState(() => _cameraClean = v),
        ),
        _buildCheckTile(
          'Shutter Actuations (< 50k count)',
          'Mechanical shutter within safe lifecycle',
          _shutterLow,
          (v) => setState(() => _shutterLow = v),
        ),
        _buildCheckTile(
          'Motherboard, IC & Wi-Fi / Bluetooth',
          'No liquid intrusion or motherboard repair history',
          _motherboardClean,
          (v) => setState(() => _motherboardClean = v),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _submitting ? null : _submitQA,
          child: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  'Submit Certified QA Report (₹${finalPrice.toStringAsFixed(0)})',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
        ),
      ],
    );
  }

  Widget _buildCheckTile(String title, String subtitle, bool value,
      ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: SwitchListTile(
        activeTrackColor: const Color(0xFF10B981),
        title: Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle:
            Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 11)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

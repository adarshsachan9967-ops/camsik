import 'package:flutter/material.dart';

class TrustScorecard extends StatelessWidget {
  const TrustScorecard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34D399).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_user, color: Color(0xFF34D399), size: 18),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Camsik Quality & Trust Guarantee',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildTrustMetric('3,20,000+', 'Devices Rehomed'),
                _buildTrustMetric('4.8 / 5.0', 'Google Rating'),
                _buildTrustMetric('15 Mins', 'Spot UPI Payout'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF38BDF8), size: 16),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'DoD 5220.22-M military-grade certified data wipe on every device before handover.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustMetric(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 16),
          ),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }
}

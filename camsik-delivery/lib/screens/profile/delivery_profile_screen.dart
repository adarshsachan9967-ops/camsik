import 'package:flutter/material.dart';
import '../../models/delivery_models.dart';
import '../../services/session_service.dart';
import '../auth/delivery_login_screen.dart';

class DeliveryProfileScreen extends StatelessWidget {
  final DeliveryAgentUser? user;
  final bool isOnline;
  final VoidCallback onToggleStatus;

  const DeliveryProfileScreen({
    super.key,
    required this.user,
    required this.isOnline,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.two_wheeler,
                    size: 36, color: Color(0xFF059669)),
              ),
              const SizedBox(height: 12),
              Text(
                user?.name ?? 'Delivery Executive',
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              Text(
                user?.phone ?? '+91 98765 43210',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onToggleStatus,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isOnline
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                  child: Text(
                    isOnline
                        ? 'Active On Duty • Online'
                        : 'Currently Offline • Tap to Go Online',
                    style: TextStyle(
                      color: isOnline
                          ? const Color(0xFF059669)
                          : const Color(0xFFDC2626),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildCard('Vehicle & Fleet Assignment', [
          _buildRow('Vehicle Type', user?.vehicle ?? 'Motorcycle'),
          _buildRow('Plate Number', user?.vehicleNumber ?? 'MH-04-AB-1234'),
          _buildRow('Base Operating City', user?.city ?? 'Mumbai'),
        ]),

        const SizedBox(height: 14),

        _buildCard('Logistics Coverage', [
          _buildRow('Active Hubs', 'Western Suburbs & Thane Corridor'),
          _buildRow(
            'Covered Pincodes',
            user?.pinCodes.isNotEmpty == true
                ? user!.pinCodes.join(', ')
                : '401107, 400068, 400092',
          ),
        ]),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFEE2E2),
            foregroundColor: const Color(0xFFDC2626),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text(
            'Sign Out from Delivery App',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          onPressed: () async {
            await SessionService.clearSession();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => const DeliveryLoginScreen()),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black54)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black45)),
          Text(
            value,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

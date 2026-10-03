import 'package:flutter/material.dart';
import '../../models/partner_models.dart';
import '../../services/session_service.dart';
import '../auth/partner_login_screen.dart';

class PartnerProfileScreen extends StatelessWidget {
  final PartnerUser? user;
  const PartnerProfileScreen({super.key, required this.user});

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
                  color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront,
                    size: 36, color: Color(0xFF2563EB)),
              ),
              const SizedBox(height: 12),
              Text(
                user?.storeName ?? 'Tech Store Hub',
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
              Text(
                user?.name ?? 'Partner Owner',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Verified Camsik Partner Hub',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildInfoCard('Contact & Location', [
          _buildInfoRow('Phone', user?.phone ?? '+91 98765 43210'),
          _buildInfoRow('Email', user?.email ?? 'partner@camsik.com'),
          _buildInfoRow('City & State',
              '${user?.city ?? "Mumbai"}, ${user?.state ?? "Maharashtra"}'),
        ]),

        const SizedBox(height: 14),

        _buildInfoCard('Operating Parameters', [
          _buildInfoRow('Commission Rate',
              '${user?.commission ?? 5.0}% per unit liquidated'),
          _buildInfoRow(
            'Operating Pin Codes',
            user?.pinCodes.isNotEmpty == true
                ? user!.pinCodes.join(', ')
                : '400001, 400050, 401107',
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
            'Sign Out from Partner App',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          onPressed: () async {
            await SessionService.clearSession();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => const PartnerLoginScreen()),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
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
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black54),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

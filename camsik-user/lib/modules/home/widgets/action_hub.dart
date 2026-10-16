import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class CompactHorizontalActionHub extends StatelessWidget {
  final VoidCallback onTapSell;
  final VoidCallback onTapBuy;
  final VoidCallback onTapExchange;
  final VoidCallback onTapRent;

  const CompactHorizontalActionHub({
    super.key,
    required this.onTapSell,
    required this.onTapBuy,
    required this.onTapExchange,
    required this.onTapRent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title: What would you like to do?
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'What would you like to do?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
              letterSpacing: -0.4,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 2x2 Grid Layout
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              // Row 1: Sell & Buy
              Row(
                children: [
                  // 1. Sell
                  _buildActionCard(
                    title: 'Sell',
                    subtitle: 'Instant Cash',
                    cardBgColor: const Color(0xFFF0FDF4),
                    borderColor: const Color(0xFFDCFCE7),
                    iconBgColor: const Color(0xFF059669),
                    subtitleColor: const Color(0xFF059669),
                    chevronColor: const Color(0xFF059669),
                    icon: const Text(
                      kRupee,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    onTap: onTapSell,
                  ),
                  const SizedBox(width: 10),

                  // 2. Buy
                  _buildActionCard(
                    title: 'Buy',
                    subtitle: 'Refurbished',
                    cardBgColor: const Color(0xFFEEF2FF),
                    borderColor: const Color(0xFFE0E7FF),
                    iconBgColor: const Color(0xFF4F46E5),
                    subtitleColor: const Color(0xFF6366F1),
                    chevronColor: const Color(0xFF6366F1),
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: onTapBuy,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Row 2: Exchange & Rent
              Row(
                children: [
                  // 3. Exchange
                  _buildActionCard(
                    title: 'Exchange',
                    subtitle: 'Upgrade your gear',
                    cardBgColor: const Color(0xFFFAF5FF),
                    borderColor: const Color(0xFFF3E8FF),
                    iconBgColor: const Color(0xFF9333EA),
                    subtitleColor: const Color(0xFFA855F7),
                    chevronColor: const Color(0xFFA855F7),
                    icon: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: onTapExchange,
                  ),
                  const SizedBox(width: 10),

                  // 4. Rent
                  _buildActionCard(
                    title: 'Rent',
                    subtitle: 'Pro Cameras',
                    cardBgColor: const Color(0xFFFEF2F2),
                    borderColor: const Color(0xFFFEE2E2),
                    iconBgColor: const Color(0xFFEF4444),
                    subtitleColor: const Color(0xFFEF4444),
                    chevronColor: const Color(0xFFEF4444),
                    icon: const Icon(
                      Icons.videocam_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: onTapRent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required Color cardBgColor,
    required Color borderColor,
    required Color iconBgColor,
    required Color subtitleColor,
    required Color chevronColor,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.2),
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
              // Circle Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconBgColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(child: icon),
              ),
              const SizedBox(width: 10),

              // Title & Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w900,
                        fontSize: 14.5,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Arrow Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: chevronColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

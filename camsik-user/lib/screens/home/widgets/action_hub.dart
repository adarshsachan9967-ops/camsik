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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Action 1: Sell
            Expanded(
              child: InkWell(
                onTap: onTapSell,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF10B981)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF059669).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            kRupee,
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sell',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const Text(
                        'Instant Cash',
                        style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1, height: 48, color: const Color(0xFFE2E8F0)),
            // Action 2: Buy
            Expanded(
              child: InkWell(
                onTap: onTapBuy,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Buy',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const Text(
                        'Refurbished',
                        style: TextStyle(color: Color(0xFF4F46E5), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1, height: 48, color: const Color(0xFFE2E8F0)),
            // Action 3: Exchange
            Expanded(
              child: InkWell(
                onTap: onTapExchange,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Exchange',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const Text(
                        '+$kRupee 5,000 Bonus',
                        style: TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(width: 1, height: 48, color: const Color(0xFFE2E8F0)),
            // Action 4: Rent Pro Cameras
            Expanded(
              child: InkWell(
                onTap: onTapRent,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE11D48), Color(0xFFF43F5E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE11D48).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.videocam_outlined, color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Rent',
                        style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                      const Text(
                        'Pro Cameras',
                        style: TextStyle(color: Color(0xFFE11D48), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

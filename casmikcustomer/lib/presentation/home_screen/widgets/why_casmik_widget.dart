import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class WhyCasmikWidget extends StatelessWidget {
  const WhyCasmikWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final points = [
      {
        'icon': 'timer',
        'title': 'Instant Quote',
        'desc':
            'Get your device price in under 60 seconds with our AI-powered valuation',
        'color': const Color(0xFF00C853),
      },
      {
        'icon': 'truck',
        'title': 'Free Pickup',
        'desc':
            'Doorstep pickup at no extra cost — we come to you anywhere in India',
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': 'shield',
        'title': 'Best Price Guarantee',
        'desc': 'We match any better offer or give you ₹500 CASMIK Coins extra',
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Why ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'CASMIK?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (p['color'] as Color).withAlpha(38),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: p['icon'] as String,
                        color: p['color'] as Color,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          p['desc'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withAlpha(166),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

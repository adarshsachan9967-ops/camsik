import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class TopValueDevicesWidget extends StatelessWidget {
  const TopValueDevicesWidget({super.key});

  final List<Map<String, dynamic>> _devices = const [
    {
      'name': 'iPhone 14',
      'brand': 'Apple',
      'price': '₹38,999',
      'originalPrice': '₹69,900',
      'condition': 'Superb',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_16dfe30c3-1773054281505.png',
      'semanticLabel':
          'Apple iPhone 14 in midnight black color on white background',
      'discount': '44% off',
    },
    {
      'name': 'Galaxy S23',
      'brand': 'Samsung',
      'price': '₹34,499',
      'originalPrice': '₹74,999',
      'condition': 'Good',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_175e093df-1771887531027.png',
      'semanticLabel':
          'Samsung Galaxy S23 smartphone with triple camera module',
      'discount': '54% off',
    },
    {
      'name': 'OnePlus 11',
      'brand': 'OnePlus',
      'price': '₹29,999',
      'originalPrice': '₹56,999',
      'condition': 'Superb',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1c9a7c7b6-1767529494953.png',
      'semanticLabel':
          'OnePlus 11 smartphone in Titan Black with Hasselblad camera',
      'discount': '47% off',
    },
    {
      'name': 'Pixel 8',
      'brand': 'Google',
      'price': '₹42,999',
      'originalPrice': '₹75,999',
      'condition': 'Superb',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_11ee23cf4-1772285499125.png',
      'semanticLabel': 'Google Pixel 8 smartphone showing camera bar design',
      'discount': '43% off',
    },
    {
      'name': 'Redmi Note 13 Pro',
      'brand': 'Xiaomi',
      'price': '₹16,499',
      'originalPrice': '₹26,999',
      'condition': 'Good',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1ba6bbe58-1772382695993.png',
      'semanticLabel': 'Xiaomi Redmi Note 13 Pro in Aurora Purple color',
      'discount': '39% off',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Value Devices',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              InkWell(
                onTap: () => context.go(AppRoutes.buyRefurbishedScreen),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderLight),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: AppTheme.primary,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final device = _devices[index];
              return _DeviceCard(device: device);
            },
          ),
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final Map<String, dynamic> device;
  const _DeviceCard({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image top 55%
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: device['imageUrl'] as String,
                    width: 160,
                    height: 130,
                    fit: BoxFit.cover,
                    semanticLabel: device['semanticLabel'] as String,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        device['discount'] as String,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device['name'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        device['price'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ConditionBadgeWidget(
                    condition: device['condition'] as String,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

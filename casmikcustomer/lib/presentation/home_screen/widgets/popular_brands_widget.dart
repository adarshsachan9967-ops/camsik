import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PopularBrandsWidget extends StatelessWidget {
  const PopularBrandsWidget({super.key});

  final List<Map<String, String>> _brands = const [
    {
      'name': 'Apple',
      'imageUrl':
          'https://images.unsplash.com/photo-1678059285248-031d5128c38a',
      'semanticLabel': 'Apple logo on silver background',
    },
    {
      'name': 'Samsung',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_19293aed4-1784623997220.png',
      'semanticLabel': 'Samsung brand logo on white surface',
    },
    {
      'name': 'OnePlus',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_12b42f3b3-1773054280340.png',
      'semanticLabel': 'OnePlus logo in red on dark background',
    },
    {
      'name': 'Xiaomi',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1512d7a44-1784856998588.png',
      'semanticLabel': 'Xiaomi Mi logo in orange on white',
    },
    {
      'name': 'Realme',
      'imageUrl':
          'https://images.unsplash.com/photo-1683797879465-3db6df6d1d68',
      'semanticLabel': 'Realme brand logo in yellow on black',
    },
    {
      'name': 'Google',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1bc57bf86-1767072446961.png',
      'semanticLabel': 'Google logo multicolored on white background',
    },
    {
      'name': 'Vivo',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_12a5c2ead-1787599664429.png',
      'semanticLabel': 'Vivo brand logo in blue',
    },
    {
      'name': 'OPPO',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1e1fb8f49-1767767849751.png',
      'semanticLabel': 'OPPO logo in green on white',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Brands',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderLight),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'arrow_forward',
                  color: AppTheme.textPrimary,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          itemCount: _brands.length,
          itemBuilder: (context, index) {
            final brand = _brands[index];
            return InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: brand['imageUrl']!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        semanticLabel: brand['semanticLabel']!,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      brand['name']!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

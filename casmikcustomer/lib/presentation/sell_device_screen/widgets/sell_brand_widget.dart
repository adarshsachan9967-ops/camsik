import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SellBrandWidget extends StatefulWidget {
  final String category;
  final void Function(String brand) onSelected;

  const SellBrandWidget({
    required this.category,
    required this.onSelected,
    super.key,
  });

  @override
  State<SellBrandWidget> createState() => _SellBrandWidgetState();
}

class _SellBrandWidgetState extends State<SellBrandWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  final List<Map<String, String>> _brands = [
    {
      'name': 'Apple',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_146b70ab7-1787599664029.png',
      'semanticLabel': 'Apple brand logo',
    },
    {
      'name': 'Samsung',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1654de991-1787599663950.png',
      'semanticLabel': 'Samsung brand logo',
    },
    {
      'name': 'OnePlus',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1cef954b0-1787599664361.png',
      'semanticLabel': 'OnePlus brand logo',
    },
    {
      'name': 'Xiaomi',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_10a5a3d7a-1787599664653.png',
      'semanticLabel': 'Xiaomi brand logo',
    },
    {
      'name': 'Realme',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_151d9c4af-1787599664520.png',
      'semanticLabel': 'Realme brand logo',
    },
    {
      'name': 'Vivo',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1959e6cd5-1787599666783.png',
      'semanticLabel': 'Vivo brand logo',
    },
    {
      'name': 'OPPO',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1de65c6fa-1787599664779.png',
      'semanticLabel': 'OPPO brand logo',
    },
    {
      'name': 'Google',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_16f2be864-1787599666033.png',
      'semanticLabel': 'Google brand logo',
    },
    {
      'name': 'Motorola',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a32f9b2a-1787599666036.png',
      'semanticLabel': 'Motorola brand logo',
    },
    {
      'name': 'Nokia',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a56d11e0-1787599665008.png',
      'semanticLabel': 'Nokia brand logo',
    },
  ];

  List<Map<String, String>> get _filtered => _query.isEmpty
      ? _brands
      : _brands
            .where(
              (b) => b['name']!.toLowerCase().contains(_query.toLowerCase()),
            )
            .toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Brand',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Category: ${widget.category}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              // Search bar
              TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _query = val),
                decoration: InputDecoration(
                  hintText: 'Search brands...',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.textMuted,
                      size: 18,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primary,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final brand = _filtered[index];
              return InkWell(
                onTap: () => widget.onSelected(brand['name']!),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomImageWidget(
                          imageUrl: brand['imageUrl']!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          semanticLabel: brand['semanticLabel']!,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        brand['name']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

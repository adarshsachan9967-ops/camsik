import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SellModelWidget extends StatefulWidget {
  final String brand;
  final void Function(Map<String, dynamic> model) onSelected;

  const SellModelWidget({
    required this.brand,
    required this.onSelected,
    super.key,
  });

  @override
  State<SellModelWidget> createState() => _SellModelWidgetState();
}

class _SellModelWidgetState extends State<SellModelWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _allModels = [
    {
      'name': 'iPhone 15 Pro',
      'brand': 'Apple',
      'basePrice': 52000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1ac872aa5-1772414311954.png',
      'semanticLabel': 'Apple iPhone 15 Pro in natural titanium color',
    },
    {
      'name': 'iPhone 14',
      'brand': 'Apple',
      'basePrice': 38000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_19199dee7-1770037001792.png',
      'semanticLabel': 'Apple iPhone 14 in midnight black',
    },
    {
      'name': 'iPhone 13',
      'brand': 'Apple',
      'basePrice': 28000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1c95f6d14-1775058099616.png',
      'semanticLabel': 'Apple iPhone 13 in blue color',
    },
    {
      'name': 'Galaxy S24 Ultra',
      'brand': 'Samsung',
      'basePrice': 58000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1d40efa47-1773056836850.png',
      'semanticLabel': 'Samsung Galaxy S24 Ultra in titanium gray',
    },
    {
      'name': 'Galaxy S23',
      'brand': 'Samsung',
      'basePrice': 34000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_122e5667e-1772368533819.png',
      'semanticLabel': 'Samsung Galaxy S23 in phantom black',
    },
    {
      'name': 'OnePlus 12',
      'brand': 'OnePlus',
      'basePrice': 36000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a112ad95-1764684278747.png',
      'semanticLabel': 'OnePlus 12 in flowy emerald green',
    },
    {
      'name': 'OnePlus 11',
      'brand': 'OnePlus',
      'basePrice': 28000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1c9a7c7b6-1767529494953.png',
      'semanticLabel': 'OnePlus 11 in titan black',
    },
    {
      'name': 'Redmi Note 13 Pro+',
      'brand': 'Xiaomi',
      'basePrice': 18000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_142c5359c-1785589423615.png',
      'semanticLabel': 'Xiaomi Redmi Note 13 Pro Plus in aurora purple',
    },
    {
      'name': 'Pixel 8 Pro',
      'brand': 'Google',
      'basePrice': 48000,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a6e2df26-1772329995405.png',
      'semanticLabel': 'Google Pixel 8 Pro in bay blue',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    final brandFiltered = widget.brand.isEmpty
        ? _allModels
        : _allModels.where((m) => m['brand'] == widget.brand).toList();
    if (_query.isEmpty) return brandFiltered;
    return brandFiltered
        .where(
          (m) => (m['name'] as String).toLowerCase().contains(
            _query.toLowerCase(),
          ),
        )
        .toList();
  }

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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Model',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Brand: ${widget.brand}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _query = val),
                decoration: InputDecoration(
                  hintText: 'Search models...',
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
            ],
          ),
        ),
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: EmptyStateWidget(
                    iconName: 'smartphone',
                    title: 'No models found',
                    subtitle:
                        'Try a different search term or select a different brand',
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final model = _filtered[index];
                    return InkWell(
                      onTap: () => widget.onSelected(model),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: CustomImageWidget(
                                imageUrl: model['imageUrl'] as String,
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                semanticLabel: model['semanticLabel'] as String,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Base: ₹${(model['basePrice'] as int).toString()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
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

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

// ProductCard anatomy locked: image top 60% + wishlist heart overlay top-right
// + name + price (green) + condition badge + chevron (from Images 1.2 and 2.2)
// Grid type: UNIFORM (2 columns, fixed aspect ratio)
class BuyProductGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function(Map<String, dynamic> product) onProductTap;
  final void Function(String id) onWishlistTap;

  const BuyProductGridWidget({
    required this.products,
    required this.onProductTap,
    required this.onWishlistTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return EmptyStateWidget(
        iconName: 'shopping_bag',
        title: 'No devices found',
        subtitle:
            'Try selecting a different category to find refurbished devices',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(
          product: product,
          onTap: () => onProductTap(product),
          onWishlist: () => onWishlistTap(product['id'] as String),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onWishlist;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final isWishlisted = product['isWishlisted'] as bool;
    final discount =
        (((product['originalPrice'] as int) - (product['price'] as int)) /
                (product['originalPrice'] as int) *
                100)
            .round();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image top ~60% (anatomy locked from Images 1.2 and 2.2)
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CustomImageWidget(
                      imageUrl: product['imageUrl'] as String,
                      fit: BoxFit.cover,
                      semanticLabel: product['semanticLabel'] as String,
                    ),
                  ),
                  // Discount badge top-left
                  Positioned(
                    top: 8,
                    left: 8,
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
                        '$discount% off',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Wishlist heart overlay top-right (anatomy locked from Image 2.2)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: onWishlist,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: isWishlisted
                                ? 'wishlist_filled'
                                : 'wishlist',
                            color: isWishlisted
                                ? AppTheme.error
                                : AppTheme.textMuted,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content below image (anatomy locked)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Price in green (anatomy locked from Image 1.2)
                        Text(
                          '₹${(product['price'] as int).toString()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConditionBadgeWidget(
                          condition: product['condition'] as String,
                        ),
                        // Chevron circle button (anatomy from Image 2.2)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderLight),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'arrow_forward',
                              color: AppTheme.textPrimary,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

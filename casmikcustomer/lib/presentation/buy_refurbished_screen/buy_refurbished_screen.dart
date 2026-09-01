import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/buy_filter_chips_widget.dart';
import './widgets/buy_product_detail_sheet.dart';
import './widgets/buy_product_grid_widget.dart';

class BuyRefurbishedScreen extends StatefulWidget {
  const BuyRefurbishedScreen({super.key});

  @override
  State<BuyRefurbishedScreen> createState() => _BuyRefurbishedScreenState();
}

class _BuyRefurbishedScreenState extends State<BuyRefurbishedScreen> {
  // TODO: Replace with Riverpod/Bloc for production
  String _selectedFilter = 'All';
  Map<String, dynamic>? _selectedProduct;

  final List<Map<String, dynamic>> _productMaps = [
    {
      'id': 'p1',
      'name': 'iPhone 14',
      'brand': 'Apple',
      'category': 'Smartphones',
      'condition': 'Superb',
      'price': 38999,
      'originalPrice': 69900,
      'batteryHealth': 94,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_16dfe30c3-1773054281505.png',
      'semanticLabel':
          'Apple iPhone 14 in midnight black on clean white background',
      'warranty': '6 months',
      'isWishlisted': false,
      'rating': 4.8,
      'reviewCount': 142,
    },
    {
      'id': 'p2',
      'name': 'Samsung Galaxy S23',
      'brand': 'Samsung',
      'category': 'Smartphones',
      'condition': 'Good',
      'price': 34499,
      'originalPrice': 74999,
      'batteryHealth': 87,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_175e093df-1771887531027.png',
      'semanticLabel':
          'Samsung Galaxy S23 in phantom black with triple camera array',
      'warranty': '6 months',
      'isWishlisted': true,
      'rating': 4.6,
      'reviewCount': 89,
    },
    {
      'id': 'p3',
      'name': 'OnePlus 11',
      'brand': 'OnePlus',
      'category': 'Smartphones',
      'condition': 'Superb',
      'price': 29999,
      'originalPrice': 56999,
      'batteryHealth': 96,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1c9a7c7b6-1767529494953.png',
      'semanticLabel':
          'OnePlus 11 in titan black with Hasselblad camera system',
      'warranty': '6 months',
      'isWishlisted': false,
      'rating': 4.7,
      'reviewCount': 203,
    },
    {
      'id': 'p4',
      'name': 'Google Pixel 8',
      'brand': 'Google',
      'category': 'Smartphones',
      'condition': 'Superb',
      'price': 42999,
      'originalPrice': 75999,
      'batteryHealth': 92,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1f1d82a15-1766527795297.png',
      'semanticLabel':
          'Google Pixel 8 in hazel brown showing camera bar design',
      'warranty': '6 months',
      'isWishlisted': false,
      'rating': 4.9,
      'reviewCount': 67,
    },
    {
      'id': 'p5',
      'name': 'Redmi Note 13 Pro',
      'brand': 'Xiaomi',
      'category': 'Smartphones',
      'condition': 'Good',
      'price': 16499,
      'originalPrice': 26999,
      'batteryHealth': 88,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_142c5359c-1785589423615.png',
      'semanticLabel':
          'Xiaomi Redmi Note 13 Pro in aurora purple with curved design',
      'warranty': '6 months',
      'isWishlisted': false,
      'rating': 4.4,
      'reviewCount': 318,
    },
    {
      'id': 'p6',
      'name': 'iPad Air 5',
      'brand': 'Apple',
      'category': 'Tablets',
      'condition': 'Good',
      'price': 44999,
      'originalPrice': 79900,
      'batteryHealth': 89,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1f8a03328-1767042617648.png',
      'semanticLabel':
          'Apple iPad Air 5th generation in space gray with keyboard',
      'warranty': '6 months',
      'isWishlisted': false,
      'rating': 4.7,
      'reviewCount': 55,
    },
    {
      'id': 'p7',
      'name': 'MacBook Air M1',
      'brand': 'Apple',
      'category': 'Laptops',
      'condition': 'Superb',
      'price': 68999,
      'originalPrice': 114900,
      'batteryHealth': 91,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_17d746289-1767469901251.png',
      'semanticLabel': 'Apple MacBook Air M1 in space gray open on white desk',
      'warranty': '6 months',
      'isWishlisted': true,
      'rating': 4.9,
      'reviewCount': 412,
    },
    {
      'id': 'p8',
      'name': 'Realme GT 5',
      'brand': 'Realme',
      'category': 'Smartphones',
      'condition': 'Fair',
      'price': 18999,
      'originalPrice': 35999,
      'batteryHealth': 78,
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1a822dfa8-1784803828112.png',
      'semanticLabel': 'Realme GT 5 in racing yellow with leather texture back',
      'warranty': '3 months',
      'isWishlisted': false,
      'rating': 4.2,
      'reviewCount': 156,
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedFilter == 'All') return _productMaps;
    return _productMaps.where((p) => p['category'] == _selectedFilter).toList();
  }

  void _toggleWishlist(String id) {
    // TODO: Replace with Riverpod/Bloc for production
    setState(() {
      final idx = _productMaps.indexWhere((p) => p['id'] == id);
      if (idx != -1) {
        _productMaps[idx]['isWishlisted'] =
            !(_productMaps[idx]['isWishlisted'] as bool);
      }
    });
  }

  void _openProductDetail(Map<String, dynamic> product) {
    setState(() => _selectedProduct = product);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BuyProductDetailSheet(
        product: product,
        onWishlist: () => _toggleWishlist(product['id'] as String),
        onAddToCart: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${product['name']} added to cart!'),
              backgroundColor: AppTheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed chrome: app bar
            _buildAppBar(context),
            // Fixed chrome: headline (anatomy from Image 2.2)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Explore ',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'Refurbished',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Fixed chrome: filter chips (anatomy from Image 2.2)
            BuyFilterChipsWidget(
              selectedFilter: _selectedFilter,
              onFilterChanged: (f) => setState(() => _selectedFilter = f),
            ),
            const SizedBox(height: 14),
            // Scrolls: product grid
            Expanded(
              child: BuyProductGridWidget(
                products: _filteredProducts,
                onProductTap: _openProductDetail,
                onWishlistTap: (id) => _toggleWishlist(id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Hamburger (anatomy from Image 2.2)
          SizedBox(
            width: 40,
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 22, height: 2, color: AppTheme.textPrimary),
                const SizedBox(height: 5),
                Container(width: 16, height: 2, color: AppTheme.textPrimary),
              ],
            ),
          ),
          const Spacer(),
          // Search icon (anatomy from Image 2.2)
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderLight),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar (anatomy from Image 2.2)
          ClipOval(
            child: CustomImageWidget(
              imageUrl:
                  'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=80',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              semanticLabel:
                  'Profile photo of user, young Indian woman with dark hair',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../routes/app_routes.dart';

class HeroBannerWidget extends StatefulWidget {
  const HeroBannerWidget({super.key});

  @override
  State<HeroBannerWidget> createState() => _HeroBannerWidgetState();
}

class _HeroBannerWidgetState extends State<HeroBannerWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Sell Your Device',
      'subtitle': 'Get instant quotes in 60 seconds\nFree doorstep pickup',
      'cta': 'Get Quote',
      'imageUrl':
          'https://images.unsplash.com/photo-1723128674760-56c92d50af7d',
      'semanticLabel':
          'Person holding a smartphone ready to sell, tech background',
      'route': AppRoutes.sellDeviceScreen,
      'accent': const Color(0xFF00C853),
    },
    {
      'title': 'Buy Certified\nRefurbished',
      'subtitle': '6-month warranty • Full inspection\nBest prices guaranteed',
      'cta': 'Shop Now',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_13767ad7f-1771884148719.png',
      'semanticLabel': 'Premium refurbished smartphone on clean white surface',
      'route': AppRoutes.buyRefurbishedScreen,
      'accent': const Color(0xFF3B82F6),
    },
    {
      'title': 'Exchange &\nUpgrade',
      'subtitle': 'Trade-in your old device\nPay only the difference',
      'cta': 'Exchange Now',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1b9fad2ae-1767051195970.png',
      'semanticLabel': 'Two smartphones side by side showing exchange concept',
      'route': AppRoutes.sellDeviceScreen,
      'accent': const Color(0xFFF59E0B),
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _pageController.hasClients) {
        final next = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return GestureDetector(
                onTap: () => context.go(banner['route'] as String),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (banner['accent'] as Color).withAlpha(51),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomImageWidget(
                            imageUrl: banner['imageUrl'] as String,
                            fit: BoxFit.cover,
                            semanticLabel: banner['semanticLabel'] as String,
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withAlpha(184),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Text overlay bottom-left
                          Positioned(
                            left: 20,
                            bottom: 20,
                            right: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  banner['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  banner['subtitle'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withAlpha(217),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: banner['accent'] as Color,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    banner['cta'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _currentPage ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _currentPage
                    ? AppTheme.primary
                    : AppTheme.borderLight,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

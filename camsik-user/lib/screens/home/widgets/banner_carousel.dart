import 'dart:async';
import 'package:flutter/material.dart';
import '../../../widgets/camsik_smart_image.dart';

class CamsikFullWidthBannerCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> banners;
  final Function(String) onBannerTap;

  const CamsikFullWidthBannerCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  @override
  State<CamsikFullWidthBannerCarousel> createState() => _CamsikFullWidthBannerCarouselState();
}

class _CamsikFullWidthBannerCarouselState extends State<CamsikFullWidthBannerCarousel> {
  late final PageController _pageController;
  int _virtualPage = 1000;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _virtualPage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && widget.banners.isNotEmpty) {
        _virtualPage++;
        _pageController.animateToPage(
          _virtualPage,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final actualCount = widget.banners.length;
    final currentActualIndex = _virtualPage % actualCount;

    return Column(
      children: [
        // FULL WIDTH CONTAINER (Edge-to-Edge)
        SizedBox(
          height: 195,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _virtualPage = page;
              });
            },
            itemBuilder: (ctx, index) {
              final banner = widget.banners[index % actualCount];
              final catId = banner['categoryFilter'] as String? ?? 'cat-smartphone';
              final badge = banner['badge'] as String? ?? 'CAMSIK RECOMMERCE';
              final titlePrefix = banner['titlePrefix'] as String? ?? 'Sell ';
              final titleHighlight = banner['titleHighlight'] as String? ?? 'Devices';
              final desc = banner['description'] as String? ?? '';
              final ctaText = banner['ctaText'] as String? ?? 'Check Price';
              final image = banner['image'] as String? ?? 'assets/images/categories/smartphone.png';

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: titlePrefix,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                                ),
                                TextSpan(
                                  text: titleHighlight,
                                  style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.w900, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 10, height: 1.25),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  minimumSize: const Size(0, 28),
                                  elevation: 2,
                                ),
                                onPressed: () => widget.onBannerTap(catId),
                                child: Text(
                                  ctaText,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Row(
                                children: [
                                  Icon(Icons.local_shipping, size: 11, color: Color(0xFF34D399)),
                                  SizedBox(width: 3),
                                  Text(
                                    'Free Pickup',
                                    style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Image Column
                    Expanded(
                      flex: 2,
                      child: CamsikSmartImage(
                        image: image,
                        fit: BoxFit.contain,
                        fallback: const Icon(Icons.devices, color: Colors.white70, size: 48),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            actualCount,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentActualIndex == i ? 18 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: currentActualIndex == i ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

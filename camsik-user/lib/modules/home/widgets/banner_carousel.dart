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
          curve: Curves.easeOutCubic,
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
    // When live banners are loading from API, show a modern shimmer skeleton
    if (widget.banners.isEmpty) {
      return Container(
        height: 185,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF059669)),
          ),
        ),
      );
    }

    final actualCount = widget.banners.length;
    final currentActualIndex = _virtualPage % actualCount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 185,
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
              final titleSuffix = banner['titleSuffix'] as String? ?? '';
              final desc = banner['description'] as String? ?? '';
              final ctaText = banner['ctaText'] as String? ?? 'Check Price';
              final image = banner['image'] as String? ?? 'assets/images/categories/smartphone.png';

              // Clean badge text of excessive emojis for clean look
              final cleanBadgeText = badge
                  .replaceAll('📱', '')
                  .replaceAll('💻', '')
                  .replaceAll('📟', '')
                  .replaceAll('★', '')
                  .replaceAll('🔍', '')
                  .replaceAll('🎥', '')
                  .trim();

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B132B), Color(0xFF172554), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF059669).withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Ambient luminous spotlight behind the device image to make it POP
                      Positioned(
                        right: -15,
                        top: -15,
                        bottom: -15,
                        width: 170,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFF10B981).withValues(alpha: 0.28),
                                const Color(0xFF38BDF8).withValues(alpha: 0.14),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Content Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text Column - Big, Bold, Crystal Clear & Readable
                            Expanded(
                              flex: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 1. High-Contrast Branded Pill Tag
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFF38BDF8), width: 0.9),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.bolt_rounded, size: 12, color: Color(0xFF38BDF8)),
                                        const SizedBox(width: 3),
                                        Flexible(
                                          child: Text(
                                            cleanBadgeText.isNotEmpty ? cleanBadgeText : 'TOP RECOMMERCE',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFFE0F2FE),
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // 2. Large Bold Headline
                                  RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: titlePrefix,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            letterSpacing: -0.4,
                                            height: 1.18,
                                          ),
                                        ),
                                        TextSpan(
                                          text: titleHighlight,
                                          style: const TextStyle(
                                            color: Color(0xFF34D399),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            letterSpacing: -0.4,
                                            height: 1.18,
                                          ),
                                        ),
                                        if (titleSuffix.isNotEmpty)
                                          TextSpan(
                                            text: titleSuffix,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                              letterSpacing: -0.4,
                                              height: 1.18,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  // 3. Clear, High-Contrast Subtitle (Slate-100, easily readable)
                                  Text(
                                    desc.isNotEmpty ? desc : 'Instant AI Quote • Free Doorstep Pickup • Spot Cash',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFFE2E8F0),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // 4. Action CTA & Verified Trust Capsule (With FittedBox to prevent any right overflow)
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () => widget.onBannerTap(catId),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF059669), Color(0xFF10B981)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF059669).withValues(alpha: 0.45),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  ctaText,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.8),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.verified_rounded, size: 12, color: Color(0xFF34D399)),
                                              SizedBox(width: 3),
                                              Text(
                                                'Free Pickup',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Right Image Column - Prominently Illuminated & Well-Sized
                            Expanded(
                              flex: 7,
                              child: Container(
                                constraints: const BoxConstraints(maxHeight: 140),
                                alignment: Alignment.center,
                                child: CamsikSmartImage(
                                  image: image,
                                  fit: BoxFit.contain,
                                  fallback: const Icon(Icons.devices, color: Colors.white70, size: 60),
                                ),
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
        const SizedBox(height: 7),
        // Modern Pill Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            actualCount,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentActualIndex == i ? 22 : 6,
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


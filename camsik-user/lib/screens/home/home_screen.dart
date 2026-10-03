import 'package:flutter/material.dart';
import '../../models/user_order.dart';
import '../../models/user_profile.dart';
import '../rent/rental_cameras_screen.dart';
import 'widgets/action_hub.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/categories_bar.dart';
import 'widgets/faq_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/rental_cameras_showcase.dart';
import 'widgets/top_deals_showcase.dart';
import 'widgets/trust_scorecard.dart';
import 'widgets/why_camsik_section.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> banners;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> refurbishedProducts;
  final List<Map<String, dynamic>> rentalCameras;
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final Function(UserOrder) onOrderCreated;
  final Function(String catId) onNavigateToSellWithCategory;
  final Function(int index) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.banners,
    required this.categories,
    required this.refurbishedProducts,
    required this.rentalCameras,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onOrderCreated,
    required this.onNavigateToSellWithCategory,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. FULL-WIDTH INFINITE LOOPING BANNER
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 8),
            child: CamsikFullWidthBannerCarousel(
              banners: banners,
              onBannerTap: onNavigateToSellWithCategory,
            ),
          ),

          const SizedBox(height: 10),

          // 2. COMPACT HORIZONTAL 1-ROW ACTION HUB (SELL | BUY | EXCHANGE | RENT)
          CompactHorizontalActionHub(
            onTapSell: () => onNavigateToTab(1),
            onTapBuy: () => onNavigateToTab(2),
            onTapExchange: () => onNavigateToTab(3),
            onTapRent: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => RentalCamerasWidget(
                    rentalCameras: rentalCameras,
                    userProfile: userProfile,
                    onProfileUpdate: onProfileUpdate,
                    onOrderCreated: onOrderCreated,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // 3. EXPLORE 8 TECH CATEGORIES
          EightCategoriesBar(
            categories: categories,
            onCategorySelected: onNavigateToSellWithCategory,
            onViewAll: () => onNavigateToTab(1),
          ),

          const SizedBox(height: 24),

          // 4. TOP REFURBISHED DEALS
          TopDealsShowcase(
            products: refurbishedProducts,
            onShopAll: () => onNavigateToTab(2),
          ),

          const SizedBox(height: 24),

          // 4b. RENT PRO CAMERAS & GEAR
          RentalCamerasShowcase(
            rentalCameras: rentalCameras,
            userProfile: userProfile,
            onProfileUpdate: onProfileUpdate,
            onOrderCreated: onOrderCreated,
          ),

          const SizedBox(height: 24),

          // 5. CAMSIK TRUST SCORECARD
          const TrustScorecard(),

          const SizedBox(height: 24),

          // 6. 3-STEP RECOMMERCE WORKFLOW
          const HowItWorksSection(),

          const SizedBox(height: 24),

          // 7. WHY CAMSIK
          const WhyCamsikSection(),

          const SizedBox(height: 24),

          // 8. FAQS & GUARANTEES
          const CamsikFaqSectionWidget(),
        ],
      ),
    );
  }
}

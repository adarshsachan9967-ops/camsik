import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/exclusive_offers_widget.dart';
import './widgets/hero_banner_widget.dart';
import './widgets/home_app_bar_widget.dart';
import './widgets/popular_brands_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/service_card_grid_widget.dart';
import './widgets/testimonials_widget.dart';
import './widgets/top_value_devices_widget.dart';
import './widgets/why_casmik_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: Replace with Riverpod/Bloc for production

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeAppBarWidget()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: HomeSearchBarWidget(),
              ),
            ),
            SliverToBoxAdapter(child: HeroBannerWidget()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: ServiceCardGridWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: TopValueDevicesWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: PopularBrandsWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: WhyCasmikWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: TestimonialsWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: ExclusiveOffersWidget(),
              ),
            ),
            // Bottom padding for floating nav
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

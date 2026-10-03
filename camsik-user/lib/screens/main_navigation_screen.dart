import 'package:flutter/material.dart';
import '../core/services/notification_service.dart';
import '../models/user_order.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';
import '../widgets/camsik_bottom_bar.dart';
import '../widgets/location_picker_sheet.dart';
import '../widgets/notification_bottom_sheet.dart';
import 'buy/buy_refurbished_screen.dart';
import 'exchange/exchange_workflow_screen.dart';
import 'home/home_screen.dart';
import 'profile/user_profile_screen.dart';
import 'sell/sell_workflow_screen.dart';

class UserMainNavigationScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onProfileUpdate;
  final VoidCallback onLogout;

  const UserMainNavigationScreen({
    super.key,
    required this.userProfile,
    required this.onProfileUpdate,
    required this.onLogout,
  });

  @override
  State<UserMainNavigationScreen> createState() =>
      _UserMainNavigationScreenState();
}

class _UserMainNavigationScreenState extends State<UserMainNavigationScreen> {
  int _currentIndex = 0;
  String _selectedCity = 'Mumbai';
  String _selectedArea = 'Mira Road';

  // Dynamic state loaded from eager cache for instant 0ms UI rendering
  List<Map<String, dynamic>> _banners = ApiService.cachedBanners;
  List<Map<String, dynamic>> _categories = ApiService.cachedCategories;
  List<Map<String, dynamic>> _refurbishedProducts =
      ApiService.cachedRefurbished;
  List<Map<String, dynamic>> _rentalCameras = ApiService.cachedRentalCameras;
  final List<UserOrder> _orders = [];

  // Selected category for Sell workflow
  String? _preselectedSellCategory;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // 1. Silent background sync to get any admin updates without showing any progress spinner
    ApiService.syncDataInBackground().then((_) {
      if (mounted) {
        setState(() {
          _banners = ApiService.cachedBanners;
          _categories = ApiService.cachedCategories;
          _refurbishedProducts = ApiService.cachedRefurbished;
          _rentalCameras = ApiService.cachedRentalCameras;
        });
      }
    });

    // 2. Fetch user orders if logged in
    if (widget.userProfile.phone.isNotEmpty) {
      ApiService.fetchOrders(phone: widget.userProfile.phone)
          .then((fetchedOrders) {
        if (mounted && fetchedOrders.isNotEmpty) {
          setState(() {
            _orders.clear();
            for (final o in fetchedOrders) {
              _orders.add(UserOrder.fromJson(o));
            }
          });
        }
      });
    }
  }

  void _navigateToSellWithCategory(String catId) {
    setState(() {
      _preselectedSellCategory = catId;
      _currentIndex = 1;
    });
  }

  void _handleOrderCreated(UserOrder order) {
    setState(() {
      _orders.insert(0, order);
      _currentIndex = 4; // Navigate to Profile / My Orders
    });

    // Native Android Notification & In-App SnackBar
    NotificationService.triggerNotification(
      context: context,
      title: 'Order Confirmed · ${order.orderNumber}',
      message:
          'Your ${order.type.toUpperCase()} request for ${order.device} has been successfully scheduled.',
      orderId: order.orderNumber,
      onTapViewOrder: () {
        setState(() => _currentIndex = 4);
      },
    );
  }

  void _openLocationPicker() {
    LocationPickerSheet.show(
      context: context,
      selectedCity: _selectedCity,
      onLocationSelected: (city, area) {
        setState(() {
          _selectedCity = city;
          _selectedArea = area;
        });
      },
    );
  }

  void _showNotificationsDialog() {
    NotificationBottomSheet.show(
      context: context,
      onNavigateToOrders: () {
        setState(() => _currentIndex = 4);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C3AED),
                        Color(0xFF4F46E5),
                        Color(0xFF2563EB)
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(0xFF7C3AED).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'CAM',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'SIK',
                            style: TextStyle(
                              color: Color(0xFF818CF8),
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _openLocationPicker,
                      child: Row(
                        children: [
                          const Icon(Icons.place,
                              color: Color(0xFF34D399), size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '$_selectedArea, $_selectedCity',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on_outlined,
                  color: Colors.white70, size: 22),
              tooltip: 'Select Location',
              onPressed: _openLocationPicker,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white70, size: 22),
              tooltip: 'Notifications',
              onPressed: _showNotificationsDialog,
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            banners: _banners,
            categories: _categories,
            refurbishedProducts: _refurbishedProducts,
            rentalCameras: _rentalCameras,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
            onNavigateToSellWithCategory: _navigateToSellWithCategory,
            onNavigateToTab: (idx) => setState(() => _currentIndex = idx),
          ),
          SellWorkflowWidget(
            categories: _categories,
            preselectedCategory: _preselectedSellCategory,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          BuyRefurbishedWidget(
            products: _refurbishedProducts,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          ExchangeWorkflowWidget(
            refurbishedProducts: _refurbishedProducts,
            userProfile: widget.userProfile,
            onProfileUpdate: widget.onProfileUpdate,
            onOrderCreated: _handleOrderCreated,
          ),
          UserProfileWidget(
            profile: widget.userProfile,
            orders: _orders,
            onProfileUpdate: widget.onProfileUpdate,
            onLogout: widget.onLogout,
            onNavigateToSell: () => setState(() => _currentIndex = 1),
            onNavigateToBuy: () => setState(() => _currentIndex = 2),
          ),
        ],
      ),
      bottomNavigationBar: CamsikBottomBar(
        selectedIndex: _currentIndex,
        onItemSelected: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CamsikBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CamsikBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemSelected,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFF059669).withValues(alpha: 0.15),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Color(0xFF059669)),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.attach_money_rounded),
          selectedIcon: Icon(Icons.attach_money, color: Color(0xFF059669)),
          label: 'Sell',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFF059669)),
          label: 'Buy',
        ),
        NavigationDestination(
          icon: Icon(Icons.swap_horiz_rounded),
          selectedIcon: Icon(Icons.swap_horiz, color: Color(0xFF7C3AED)),
          label: 'Exchange',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: Color(0xFF059669)),
          label: 'Profile',
        ),
      ],
    );
  }
}

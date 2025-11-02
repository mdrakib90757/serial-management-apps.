import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../utils/color.dart';

class CustomServicecenterNavigationbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isExtraScreen;
  CustomServicecenterNavigationbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isExtraScreen = false,
  });

  @override
  State<CustomServicecenterNavigationbar> createState() =>
      _CustomServicecenterNavigationbarState();
}

class _CustomServicecenterNavigationbarState
    extends State<CustomServicecenterNavigationbar> {
  @override
  Widget build(BuildContext context) {
    // Define colors based on whether it's an extra screen
    final Color selectedColor = widget.isExtraScreen
        ? Colors.grey.shade600
        : AppColor().primariColor;
    final Color unselectedColor = Colors.grey.shade600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 28,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            duration: const Duration(milliseconds: 200),
            tabBackgroundColor: selectedColor,
            color: unselectedColor,
            tabs: const [
              GButton(icon: Icons.home_outlined, text: 'Home'),
              GButton(
                icon: Icons.corporate_fare_outlined,
                text: 'Service-Center',
              ),
              GButton(icon: Icons.category_outlined, text: 'Service-Types'),
              GButton(icon: Icons.settings_outlined, text: 'Settings'),
            ],
            selectedIndex: widget.currentIndex,
            onTabChange: widget.onTap,
          ),
        ),
      ),
    );
  }
}

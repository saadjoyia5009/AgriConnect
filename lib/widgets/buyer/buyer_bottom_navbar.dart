import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BuyerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BuyerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black12,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          child: GNav(
            selectedIndex: currentIndex,
            onTabChange: onTap,
            gap: 8,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutExpo,
            rippleColor: Colors.transparent,
            hoverColor: Colors.transparent,
            tabBackgroundColor: const Color(0xffA8F0C8),
            color: Colors.grey,
            activeColor: const Color(0xff1B5E20),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite_border,
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.chat_bubble_outline,
                text: 'Inquiries',
              ),
              GButton(
                icon: Icons.person_outline,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
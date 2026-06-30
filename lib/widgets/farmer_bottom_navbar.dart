import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class FarmerBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const FarmerBottomNavbar({
    super.key,
    required this.currentIndex,
  });

  static const Color darkGreen = Color(0xff075739);

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    final routes = [
      '/farmerDashboard',
      '/myCrops',
      '/farmerChats',
      '/farmerInquiries',
      '/profile',
    ];

    Navigator.pushReplacementNamed(
      context,
      routes[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ConvexAppBar(
      initialActiveIndex: currentIndex,
      backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
      color: isDark ? Colors.white60 : Colors.grey,
      activeColor: isDark ? const Color(0xff9ff2c1) : darkGreen,
      style: TabStyle.fixedCircle,
      height: 62,
      curveSize: 86,
      top: -22,
      elevation: isDark ? 0 : 8,
      onTap: (index) => _navigate(context, index),
      items: const [
        TabItem(icon: Icons.home_rounded, title: 'Home'),
        TabItem(icon: Icons.local_florist_rounded, title: 'Crops'),
        TabItem(icon: Icons.chat_bubble_rounded, title: 'Chats'),
        TabItem(icon: Icons.assignment_rounded, title: 'Inquiry'),
        TabItem(icon: Icons.person_rounded, title: 'Profile'),
      ],
    );
  }
}
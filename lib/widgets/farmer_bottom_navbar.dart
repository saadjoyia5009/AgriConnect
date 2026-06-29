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
    return ConvexAppBar(
      initialActiveIndex: currentIndex,
      backgroundColor: Colors.white,
      color: Colors.grey,
      activeColor: darkGreen,
      style: TabStyle.fixedCircle,
      height: 62,
      curveSize: 86,
      top: -22,
      elevation: 8,
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
import 'package:flutter/material.dart';

import '../../widgets/admin/admin_bottom_navbar.dart';
import 'admin_analytics_screen.dart';
import 'admin_crops_screen.dart';
import 'admin_dashboard_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_users_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int currentIndex = 0;

  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);

  final List<Widget> screens = const [
    AdminDashboardScreen(),
    AdminUsersScreen(),
    AdminCropsScreen(),
    AdminAnalyticsScreen(),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? darkBackground : lightBackground,

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: AdminBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
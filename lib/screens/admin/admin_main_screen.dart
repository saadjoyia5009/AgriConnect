import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive/responsive_builder.dart';
import '../../providers/language_provider.dart';
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

    final content = IndexedStack(index: currentIndex, children: screens);

    return ResponsiveBuilder(
      mobile: (context, constraints) => Scaffold(
        backgroundColor: isDark ? darkBackground : lightBackground,
        body: content,
        bottomNavigationBar: AdminBottomNavbar(
          currentIndex: currentIndex,
          onTap: _selectPage,
        ),
      ),
      tablet: (context, constraints) => _wideScaffold(content),
      desktop: (context, constraints) => _wideScaffold(content, extended: true),
    );
  }

  void _selectPage(int index) => setState(() => currentIndex = index);

  Widget _wideScaffold(Widget content, {bool extended = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();
    final labels = [
      lang.t('home'),
      lang.t('users'),
      lang.t('crops'),
      lang.t('stats'),
      lang.t('profile'),
    ];
    const icons = [
      Icons.dashboard_rounded,
      Icons.people_alt_rounded,
      Icons.grass_rounded,
      Icons.bar_chart_rounded,
      Icons.person_rounded,
    ];

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: extended,
              selectedIndex: currentIndex,
              onDestinationSelected: _selectPage,
              backgroundColor: isDark
                  ? const Color(0xFF15251E)
                  : const Color(0xFF0E5A3C),
              indicatorColor: isDark ? const Color(0xFF1E352B) : Colors.white,
              selectedIconTheme: IconThemeData(
                color: isDark
                    ? const Color(0xff9ff2c1)
                    : const Color(0xFF0E5A3C),
              ),
              unselectedIconTheme: const IconThemeData(color: Colors.white70),
              selectedLabelTextStyle: TextStyle(
                color: isDark ? const Color(0xff9ff2c1) : Colors.white,
                fontWeight: FontWeight.w800,
              ),
              unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
              destinations: List.generate(
                icons.length,
                (index) => NavigationRailDestination(
                  icon: Icon(icons[index]),
                  label: Text(labels[index]),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: content),
        ],
      ),
    );
  }
}

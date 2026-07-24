import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class BuyerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BuyerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

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
      onTap: onTap,
      items: [
        TabItem(icon: Icons.home_rounded, title: lang.t("home")),
        TabItem(icon: Icons.favorite_rounded, title: lang.t("favorites")),
        TabItem(icon: Icons.chat_bubble_rounded, title: lang.t("chats")),
        TabItem(icon: Icons.assignment_rounded, title: lang.t("inquiries")),
        TabItem(icon: Icons.person_rounded, title: lang.t("profile")),
      ],
    );
  }
}

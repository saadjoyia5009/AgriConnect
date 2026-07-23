import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightGreen = Color(0xffA8F0C8);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF15251E) : Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: isDark ? Colors.black.withOpacity(0.35) : Colors.black12,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              return GNav(
                selectedIndex: currentIndex,
                onTabChange: onTap,
                gap: compact ? 3 : 6,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutExpo,
                rippleColor: Colors.transparent,
                hoverColor: Colors.transparent,
                tabBackgroundColor: isDark
                    ? darkGreen.withOpacity(0.35)
                    : lightGreen,
                color: isDark ? Colors.white60 : Colors.grey,
                activeColor: isDark ? lightGreen : darkGreen,
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 7 : 12,
                  vertical: compact ? 12 : 14,
                ),
                tabs: [
                  GButton(icon: Icons.home_outlined, text: lang.t("home")),
                  GButton(
                    icon: Icons.favorite_border,
                    text: lang.t("favorites"),
                  ),
                  GButton(icon: Icons.forum_outlined, text: lang.t("chats")),
                  GButton(
                    icon: Icons.chat_bubble_outline,
                    text: lang.t("inquiries"),
                  ),
                  GButton(icon: Icons.person_outline, text: lang.t("profile")),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

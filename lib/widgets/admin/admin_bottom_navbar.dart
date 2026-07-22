import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class AdminBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightGreen = Color(0xff9ff2c1);
  static const Color darkCard = Color(0xFF15251E);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? darkCard : darkGreen,
        borderRadius: BorderRadius.circular(26),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : darkGreen.withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _item(
            context,
            Icons.dashboard_rounded,
            context.watch<LanguageProvider>().t("home"),
            0,
          ),
          _item(
            context,
            Icons.people_alt_rounded,
            context.watch<LanguageProvider>().t("users"),
            1,
          ),
          _item(
            context,
            Icons.grass_rounded,
            context.watch<LanguageProvider>().t("crops"),
            2,
          ),
          _item(
            context,
            Icons.bar_chart_rounded,
            context.watch<LanguageProvider>().t("stats"),
            3,
          ),
          _item(
            context,
            Icons.person_rounded,
            context.watch<LanguageProvider>().t("profile"),
            4,
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? const Color(0xFF1E352B) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: selected && isDark
                ? Border.all(color: lightGreen.withOpacity(0.25))
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? (isDark ? lightGreen : darkGreen)
                    : Colors.white70,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: selected
                      ? (isDark ? lightGreen : darkGreen)
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

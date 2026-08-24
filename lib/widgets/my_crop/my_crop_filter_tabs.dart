import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';

class MyCropFilterTabs extends StatelessWidget {
  const MyCropFilterTabs({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 2, 18, 22),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1b241f) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xffe0ebe4),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _tab(
              context,
              title: lang.t("all"),
              count: provider.allCount,
              filter: "All",
              selected: provider.selectedFilter == "All",
              icon: Icons.grid_view_rounded,
            ),
          ),
          Expanded(
            child: _tab(
              context,
              title: lang.t("active"),
              count: provider.activeCount,
              filter: "Active",
              selected: provider.selectedFilter == "Active",
              icon: Icons.eco_outlined,
            ),
          ),
          Expanded(
            child: _tab(
              context,
              title: lang.t("soldOut"),
              count: provider.soldOutCount,
              filter: "Sold Out",
              selected: provider.selectedFilter == "Sold Out",
              icon: Icons.inventory_2_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(
      BuildContext context, {
        required String title,
        required int count,
        required String filter,
        required bool selected,
        required IconData icon,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.read<CropProvider>().changeFilter(filter);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? darkGreen
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: selected
              ? [
            BoxShadow(
              color: darkGreen.withValues(alpha: 0.20),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? Colors.white
                  : (isDark ? Colors.white70 : darkGreen),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                "$title ($count)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : (isDark ? Colors.white70 : darkGreen),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
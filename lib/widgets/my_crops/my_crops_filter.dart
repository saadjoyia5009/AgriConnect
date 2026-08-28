import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';

class MyCropsFilter extends StatelessWidget {
  const MyCropsFilter({super.key});

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CropProvider>();
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff18221c) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xffdcebe2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _chip(
              context,
              provider,
              "All",
              lang.t("all"),
              provider.allCount,
              Icons.grid_view_rounded,
            ),
          ),
          Expanded(
            child: _chip(
              context,
              provider,
              "Active",
              lang.t("active"),
              provider.activeCount,
              Icons.eco_outlined,
            ),
          ),
          Expanded(
            child: _chip(
              context,
              provider,
              "Sold Out",
              lang.t("soldOut"),
              provider.soldOutCount,
              Icons.inventory_2_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
      BuildContext context,
      CropProvider provider,
      String title,
      String displayTitle,
      int count,
      IconData icon,
      ) {
    final selected = provider.selectedFilter == title;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => provider.changeFilter(title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected ? darkGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected ? Colors.white : darkGreen,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                "$displayTitle ($count)",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : darkGreen,
                  fontSize: 12,
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

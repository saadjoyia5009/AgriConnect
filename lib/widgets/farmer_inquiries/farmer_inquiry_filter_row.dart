import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class FarmerInquiryFilterRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const FarmerInquiryFilterRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Row(
      children: [
        Expanded(
          child: _FilterChip(
            title: "Pending",
            displayTitle: lang.t("pending"),
            selected: selectedFilter == "Pending",
            icon: Icons.schedule_rounded,
            onTap: () => onFilterChanged("Pending"),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _FilterChip(
            title: "Active",
            displayTitle: lang.t("active"),
            selected: selectedFilter == "Active",
            icon: Icons.eco_rounded,
            onTap: () => onFilterChanged("Active"),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _FilterChip(
            title: "History",
            displayTitle: lang.t("history"),
            selected: selectedFilter == "History",
            icon: Icons.inventory_2_outlined,
            onTap: () => onFilterChanged("History"),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String title;
  final String displayTitle;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.title,
    required this.displayTitle,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 42,
        decoration: BoxDecoration(
          color: selected
              ? darkGreen
              : isDark
              ? const Color(0xff1d251f)
              : Colors.white,
          borderRadius: BorderRadius.circular(27),
          border: Border.all(
            color: selected
                ? darkGreen
                : isDark
                ? Colors.white12
                : const Color(0xffd8e6de),
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: darkGreen.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : darkGreen,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                displayTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : darkGreen,
                  fontSize: 12.5,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class FarmerChatsFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const FarmerChatsFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    const filters = ['All', 'Unread', 'Active', 'Closed'];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = selectedFilter == filter;

          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: selected
                    ? darkGreen
                    : (isDark ? const Color(0xff1d251f) : Colors.white),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected
                      ? darkGreen
                      : (isDark ? Colors.white10 : const Color(0xffe1e9e4)),
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: darkGreen.withValues(alpha: 0.16),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icon(filter),
                    size: 15,
                    color: selected ? Colors.white : darkGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _label(filter, lang),
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : (isDark ? Colors.white : darkGreen),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _icon(String filter) {
    switch (filter) {
      case 'Unread':
        return Icons.mark_email_unread_outlined;
      case 'Active':
        return Icons.eco_outlined;
      case 'Closed':
        return Icons.inventory_2_outlined;
      default:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  String _label(String filter, LanguageProvider lang) {
    switch (filter) {
      case 'All':
        return lang.t('all');
      case 'Unread':
        return lang.t('unread');
      case 'Active':
        return lang.t('active');
      case 'Closed':
        return lang.t('closed');
      default:
        return filter;
    }
  }
}

import 'package:flutter/material.dart';

class CropAttributeChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const CropAttributeChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(title),
        avatar: Icon(
          selected ? Icons.check_circle : Icons.add_circle_outline,
          size: 16,
          color: selected
              ? darkGreen
              : (isDark ? Colors.white70 : Colors.grey),
        ),
        backgroundColor: selected
            ? (isDark
            ? darkGreen.withOpacity(0.25)
            : const Color(0xffe2f4ea))
            : (isDark
            ? const Color(0xff1E1E1E)
            : Colors.white),
        side: BorderSide(
          color: selected
              ? darkGreen
              : (isDark
              ? Colors.white24
              : const Color(0xffd8e6de)),
        ),
        labelStyle: TextStyle(
          color: selected
              ? (isDark ? Colors.white : darkGreen)
              : (isDark
              ? Colors.white70
              : const Color(0xff4f5955)),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.transparent,
      ),
    );
  }
}
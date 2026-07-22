import 'package:flutter/material.dart';

class BuyerSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const BuyerSearchBar({super.key, required this.hintText, this.onChanged});

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color darkCard = Color(0xFF15251E);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      onChanged: onChanged,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: darkGreen,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : const Color(0xff6B7280),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? Colors.white60 : const Color(0xff6B7280),
        ),
        filled: true,
        fillColor: isDark ? darkCard : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xffD9DED8),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xffD9DED8),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkGreen, width: 1.3),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WeatherSearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final Color accentColor;
  final String hintText;
  final void Function(String value) onSearch;

  const WeatherSearchField({
    super.key,
    required this.controller,
    required this.isDark,
    required this.accentColor,
    required this.hintText,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSearch,
      cursorColor: accentColor,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xff202525),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.send_rounded, color: accentColor),
          onPressed: () => onSearch(controller.text),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF15251E) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
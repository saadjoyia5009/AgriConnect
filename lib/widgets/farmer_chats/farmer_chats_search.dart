import 'package:flutter/material.dart';

class FarmerChatsSearch extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;

  const FarmerChatsSearch({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 7),
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1d251f) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xffe1e9e4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xff202723),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xff9ca5a0),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 18, right: 8),
              child: Icon(
                Icons.search_rounded,
                color: Color(0xff222a26),
                size: 27,
              ),
            ),
            suffixIcon: controller.text.isEmpty
                ? Container(
              margin: const EdgeInsets.all(7),
              width: 42,
              decoration: const BoxDecoration(
                color: Color(0xfff1f8f3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: darkGreen,
                size: 21,
              ),
            )
                : IconButton(
              onPressed: () {
                controller.clear();
                onChanged();
              },
              icon: const Icon(Icons.close_rounded),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 17),
          ),
        ),
      ),
    );
  }
}

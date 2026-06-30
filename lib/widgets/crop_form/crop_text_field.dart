import 'package:flutter/material.dart';

class CropTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final VoidCallback? onTap;
  final bool readOnly;

  const CropTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.icon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget(label, context),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xff26332e),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          cursorColor: darkGreen,
          decoration: inputDecoration(
            context: context,
            hint: hint,
            icon: icon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  static Widget labelWidget(String text, [BuildContext? context]) {
    final isDark = context != null &&
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white.withOpacity(0.86) : const Color(0xff333333),
        ),
      ),
    );
  }

  static InputDecoration inputDecoration({
    BuildContext? context,
    required String hint,
    IconData? icon,
    IconData? suffixIcon,
  }) {
    final isDark = context != null &&
        Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark ? Colors.white60 : const Color(0xff777777);
    final borderColor = isDark ? Colors.white24 : const Color(0xffd8e6de);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 13,
        color: isDark ? Colors.white38 : const Color(0xff777777),
      ),
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        size: 18,
        color: iconColor,
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Icon(
        suffixIcon,
        size: 18,
        color: iconColor,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xff1E1E1E) : const Color(0xfffbfcfb),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(
          color: isDark ? const Color(0xff39b77a) : darkGreen,
          width: 1.3,
        ),
      ),
    );
  }
}
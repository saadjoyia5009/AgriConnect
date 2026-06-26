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
        _label(label),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: inputDecoration(
            hint: hint,
            icon: icon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  static Widget labelWidget(String text) {
    return _label(text);
  }

  static Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xff333333),
        ),
      ),
    );
  }

  static InputDecoration inputDecoration({
    required String hint,
    IconData? icon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xff777777)),
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        size: 18,
        color: Color(0xff777777),
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Icon(
        suffixIcon,
        size: 18,
        color: Color(0xff777777),
      ),
      filled: true,
      fillColor: const Color(0xfffbfcfb),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xffd8e6de)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: darkGreen),
      ),
    );
  }
}
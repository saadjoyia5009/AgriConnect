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
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(title),
        avatar: Icon(
          selected ? Icons.check_circle : Icons.add_circle_outline,
          size: 16,
          color: selected ? darkGreen : Colors.grey,
        ),
        backgroundColor: selected ? const Color(0xffe2f4ea) : Colors.white,
        side: BorderSide(
          color: selected ? darkGreen : const Color(0xffd8e6de),
        ),
        labelStyle: TextStyle(
          color: selected ? darkGreen : const Color(0xff4f5955),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
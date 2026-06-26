import 'package:flutter/material.dart';
import 'crop_text_field.dart';

class CropDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final IconData? icon;

  const CropDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = "",
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CropTextField.labelWidget(label),
        DropdownButtonFormField<String>(
          value: value,
          decoration: CropTextField.inputDecoration(
            hint: hint,
            icon: icon,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
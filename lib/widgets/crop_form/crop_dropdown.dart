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

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CropTextField.labelWidget(label, context),

        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
          iconEnabledColor: isDark ? Colors.white70 : darkGreen,
          iconDisabledColor: isDark ? Colors.white38 : Colors.grey,

          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xff26332e),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),

          decoration: CropTextField.inputDecoration(
            context: context,
            hint: hint,
            icon: icon,
          ).copyWith(
            filled: true,
            fillColor: isDark
                ? const Color(0xff1E1E1E)
                : const Color(0xfffbfcfb),
          ),

          selectedItemBuilder: (context) {
            return items.map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xff26332e),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList();
          },

          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xff26332e),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),

          onChanged: onChanged,
        ),
      ],
    );
  }
}
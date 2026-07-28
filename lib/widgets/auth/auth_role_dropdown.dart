import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class AuthRoleDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const AuthRoleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);
  static const List<String> _allowedRoles = ["Farmer", "Buyer"];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final safeValue = _allowedRoles.contains(value) ? value : "Farmer";

    return Theme(
      data: ThemeData.light(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          initialValue: safeValue,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: darkGreen,
            size: 28,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          style: const TextStyle(
            color: Color(0xFF1D1D1D),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.92),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: darkGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_outline, color: darkGreen),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFDDE5E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFDDE5E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: darkGreen, width: 1.5),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: "Farmer",
              child: Row(
                children: [
                  const Icon(Icons.agriculture, color: darkGreen, size: 20),
                  const SizedBox(width: 10),
                  Flexible(child: Text(lang.t("roleFarmer"))),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "Buyer",
              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: darkGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Flexible(child: Text(lang.t("roleBuyer"))),
                ],
              ),
            ),
          ],
          onChanged: (selectedValue) {
            if (selectedValue != null) {
              onChanged(selectedValue);
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AuthRoleDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const AuthRoleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const Color darkGreen = Color(0xFF0E5A3C);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: darkGreen,
          size: 28,
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),

        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: darkGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              color: darkGreen,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFDDE5E0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFDDE5E0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: darkGreen,
              width: 1.5,
            ),
          ),
        ),

        items: const [
          DropdownMenuItem(
            value: "Farmer",
            child: Row(
              children: [
                Icon(Icons.agriculture,
                    color: darkGreen, size: 20),
                SizedBox(width: 10),
                Text("Farmer"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "Buyer",
            child: Row(
              children: [
                Icon(Icons.shopping_cart_outlined,
                    color: darkGreen, size: 20),
                SizedBox(width: 10),
                Text("Buyer"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "Admin",
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings_outlined,
                    color: darkGreen, size: 20),
                SizedBox(width: 10),
                Text("Admin"),
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
    );
  }
}
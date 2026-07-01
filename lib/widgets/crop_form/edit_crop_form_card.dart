import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import 'crop_dropdown.dart';
import 'crop_text_field.dart';

class EditCropFormCard extends StatelessWidget {
  final bool isSubmitting;
  final TextEditingController cropNameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;

  final String selectedCategory;
  final String selectedStatus;

  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onStatusChanged;

  const EditCropFormCard({
    super.key,
    required this.isSubmitting,
    required this.cropNameController,
    required this.quantityController,
    required this.priceController,
    required this.locationController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.onCategoryChanged,
    required this.onStatusChanged,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return AbsorbPointer(
      absorbing: isSubmitting,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff121212) : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(8),
          ),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CropTextField(
              label: lang.t("cropName"),
              controller: cropNameController,
              hint: "",
              icon: Icons.local_florist_outlined,
            ),
            const SizedBox(height: 22),

            CropDropdown(
              label: lang.t("category"),
              value: selectedCategory,
              items: const ["Vegetables", "Fruits", "Wheat", "Rice"],
              icon: Icons.category_outlined,
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 22),

            CropDropdown(
              label: lang.t("cropStatus"),
              value: selectedStatus,
              items: const ["Active", "Sold Out"],
              icon: Icons.inventory_outlined,
              onChanged: onStatusChanged,
            ),
            const SizedBox(height: 22),

            Row(
              children: [
                Expanded(
                  child: CropTextField(
                    label: lang.t("quantity"),
                    controller: quantityController,
                    hint: "",
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CropTextField(
                    label: lang.t("price"),
                    controller: priceController,
                    hint: "",
                    icon: Icons.payments_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CropTextField(
                    label: lang.t("location"),
                    controller: locationController,
                    hint: "",
                    icon: Icons.location_on_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: isDark
                        ? darkGreen.withOpacity(0.25)
                        : const Color(0xffa7f2c8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    Icons.my_location,
                    color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            CropTextField(
              label: lang.t("description"),
              controller: descriptionController,
              hint: "",
              icon: Icons.description_outlined,
              maxLines: 5,
            ),
            const SizedBox(height: 28),

            Divider(color: isDark ? Colors.white12 : const Color(0xffeef2ef)),
            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  lang.t("visibilitySettings"),
                  style: TextStyle(
                    color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

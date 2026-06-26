import 'package:flutter/material.dart';
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
    return AbsorbPointer(
      absorbing: isSubmitting,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CropTextField(
              label: "Crop Name",
              controller: cropNameController,
              hint: "",
              icon: Icons.local_florist_outlined,
            ),
            const SizedBox(height: 22),

            CropDropdown(
              label: "Category",
              value: selectedCategory,
              items: const ["Vegetables", "Fruits", "Wheat", "Rice"],
              icon: Icons.category_outlined,
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 22),

            CropDropdown(
              label: "Crop Status",
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
                    label: "Quantity",
                    controller: quantityController,
                    hint: "",
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CropTextField(
                    label: "Price",
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
                    label: "Location",
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
                    color: const Color(0xffa7f2c8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.my_location, color: darkGreen),
                ),
              ],
            ),
            const SizedBox(height: 22),

            CropTextField(
              label: "Description",
              controller: descriptionController,
              hint: "",
              icon: Icons.description_outlined,
              maxLines: 5,
            ),
            const SizedBox(height: 28),

            const Divider(color: Color(0xffeef2ef)),
            const SizedBox(height: 8),

            const Row(
              children: [
                Text(
                  "Visibility Settings",
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: darkGreen),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
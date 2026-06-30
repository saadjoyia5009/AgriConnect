import 'package:flutter/material.dart';

import 'crop_attribute_chip.dart';
import 'crop_dropdown.dart';
import 'crop_text_field.dart';

class AddCropFormCard extends StatelessWidget {
  final bool isSubmitting;

  final TextEditingController cropNameController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;

  final String selectedCategory;
  final String selectedUnit;
  final String selectedStatus;
  final String harvestDate;

  final bool isOrganic;
  final bool isDeliveryAvailable;
  final bool isPremiumGrade;

  final VoidCallback onPickHarvestDate;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onUnitChanged;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onOrganicTap;
  final VoidCallback onDeliveryTap;
  final VoidCallback onPremiumTap;

  const AddCropFormCard({
    super.key,
    required this.isSubmitting,
    required this.cropNameController,
    required this.quantityController,
    required this.priceController,
    required this.locationController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.selectedUnit,
    required this.selectedStatus,
    required this.harvestDate,
    required this.isOrganic,
    required this.isDeliveryAvailable,
    required this.isPremiumGrade,
    required this.onPickHarvestDate,
    required this.onCategoryChanged,
    required this.onUnitChanged,
    required this.onStatusChanged,
    required this.onOrganicTap,
    required this.onDeliveryTap,
    required this.onPremiumTap,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AbsorbPointer(
      absorbing: isSubmitting,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xffd8e6de),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Crop Details",
              style: TextStyle(
                color: darkGreen,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            Divider(
              height: 28,
              color: isDark ? Colors.white12 : Colors.grey.shade300,
            ),
            CropTextField(
              label: "Crop Name",
              controller: cropNameController,
              hint: "e.g., Organic Honeycrisp Apples",
              icon: Icons.grass_outlined,
            ),
            const SizedBox(height: 18),
            CropDropdown(
              label: "Category",
              value: selectedCategory,
              hint: "Select a category...",
              icon: Icons.category_outlined,
              items: const [
                "Select a category...",
                "Wheat",
                "Rice",
                "Vegetables",
                "Fruits",
                "Organic",
              ],
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 18),
            CropDropdown(
              label: "Crop Status",
              value: selectedStatus,
              hint: "Select crop status",
              icon: Icons.inventory_outlined,
              items: const ["Active", "Sold Out"],
              onChanged: onStatusChanged,
            ),
            const SizedBox(height: 18),
            CropTextField(
              label: "Est. Harvest Date",
              controller: TextEditingController(text: harvestDate),
              hint: harvestDate,
              icon: Icons.calendar_today_outlined,
              suffixIcon: Icons.calendar_month,
              readOnly: true,
              onTap: onPickHarvestDate,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: CropTextField(
                    label: "Available Quantity",
                    controller: quantityController,
                    hint: "0.00",
                    icon: Icons.scale_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: CropDropdown(
                    label: "Unit",
                    value: selectedUnit,
                    items: const ["kg", "ton", "box"],
                    onChanged: onUnitChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            CropTextField(
              label: "Price (per unit)",
              controller: priceController,
              hint: "0.00",
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  "Farm Location",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white70 : const Color(0xff333333),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.my_location, size: 14, color: darkGreen),
                const SizedBox(width: 4),
                const Text(
                  "Use Current Location",
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: CropTextField.inputDecoration(
                hint: "Search address or drop a pin...",
                icon: Icons.location_on_outlined,
              ).copyWith(
                fillColor: Theme.of(context).cardColor,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 95,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : const Color(0xffe7e7f3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.transparent,
                ),
              ),
              child: const Center(
                child: Icon(Icons.location_on, color: Colors.red, size: 36),
              ),
            ),
            const SizedBox(height: 18),
            CropTextField(
              label: "Description",
              controller: descriptionController,
              hint:
              "Describe the quality, farming methods, and any other relevant details...",
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 18),
            Text(
              "Quick Attributes",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white70 : const Color(0xff333333),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CropAttributeChip(
                  title: "Organic",
                  selected: isOrganic,
                  onTap: onOrganicTap,
                ),
                CropAttributeChip(
                  title: "Delivery Available",
                  selected: isDeliveryAvailable,
                  onTap: onDeliveryTap,
                ),
                CropAttributeChip(
                  title: "Premium Grade",
                  selected: isPremiumGrade,
                  onTap: onPremiumTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
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

  // Location
  final LatLng? selectedLocation;
  final MapController mapController;
  final bool isGettingLocation;

  final VoidCallback onUseCurrentLocation;
  final VoidCallback onSelectMapLocation;

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

    // Location
    required this.selectedLocation,
    required this.mapController,
    required this.isGettingLocation,
    required this.onUseCurrentLocation,
    required this.onSelectMapLocation,

    required this.onPickHarvestDate,
    required this.onCategoryChanged,
    required this.onUnitChanged,
    required this.onStatusChanged,
    required this.onOrganicTap,
    required this.onDeliveryTap,
    required this.onPremiumTap,
  });

  static const Color darkGreen = Color(0xff075739);

  static const LatLng _defaultLocation = LatLng(
    31.5204,
    74.3587,
  );

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    const categoryItems = [
      'Select a category...',
      'Grains',
      'Vegetables',
      'Fruits',
      'Pulses',
      'Cotton',
      'Sugarcane',
      'Other',
    ];

    final safeCategory =
    categoryItems.contains(selectedCategory)
        ? selectedCategory
        : 'Select a category...';

    final mapLocation =
        selectedLocation ?? _defaultLocation;

    return AbsorbPointer(
      absorbing: isSubmitting,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          18,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: isDark
                ? Colors.white12
                : const Color(0xffd8e6de),
          ),
          borderRadius:
          BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              lang.t('cropDetails'),
              style: const TextStyle(
                color: darkGreen,
                fontSize: 17,
                fontWeight:
                FontWeight.w900,
              ),
            ),

            Divider(
              height: 28,
              color: isDark
                  ? Colors.white12
                  : Colors.grey.shade300,
            ),

            CropTextField(
              label: lang.t('cropName'),
              controller:
              cropNameController,
              hint:
              lang.t('cropNameHint'),
              icon:
              Icons.grass_outlined,
            ),

            const SizedBox(height: 18),

            CropDropdown(
              label: lang.t('category'),
              value: safeCategory,
              hint:
              lang.t('selectCategory'),
              icon:
              Icons.category_outlined,
              items: categoryItems,
              onChanged:
              onCategoryChanged,
            ),

            const SizedBox(height: 18),

            CropDropdown(
              label:
              lang.t('cropStatus'),
              value: selectedStatus,
              hint: lang.t(
                'selectCropStatus',
              ),
              icon:
              Icons.inventory_outlined,
              items: const [
                'Active',
                'Sold Out',
              ],
              onChanged:
              onStatusChanged,
            ),

            const SizedBox(height: 18),

            CropTextField(
              label: lang.t(
                'estHarvestDate',
              ),
              controller:
              TextEditingController(
                text: harvestDate,
              ),
              hint: harvestDate,
              icon: Icons
                  .calendar_today_outlined,
              suffixIcon:
              Icons.calendar_month,
              readOnly: true,
              onTap:
              onPickHarvestDate,
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: CropTextField(
                    label: lang.t(
                      'availableQuantity',
                    ),
                    controller:
                    quantityController,
                    hint: '0.00',
                    icon: Icons
                        .scale_outlined,
                    keyboardType:
                    TextInputType.number,
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  width: 100,
                  child: CropDropdown(
                    label:
                    lang.t('unit'),
                    value: selectedUnit,
                    items: const [
                      'kg',
                      'ton',
                      'box',
                      'bundle',
                      'bag',
                    ],
                    onChanged:
                    onUnitChanged,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            CropTextField(
              label: lang.t(
                'pricePerUnit',
              ),
              controller:
              priceController,
              hint: '0.00',
              icon:
              Icons.attach_money,
              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 18),

            // =====================================================
            // FARM LOCATION HEADER
            // =====================================================

            Row(
              children: [
                Text(
                  lang.t(
                    'farmLocation',
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w800,
                    color: isDark
                        ? Colors.white70
                        : const Color(
                      0xff333333,
                    ),
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap:
                  isGettingLocation
                      ? null
                      : onUseCurrentLocation,
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      isGettingLocation
                          ? const SizedBox(
                        width: 14,
                        height: 14,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                          darkGreen,
                        ),
                      )
                          : const Icon(
                        Icons.my_location,
                        size: 14,
                        color:
                        darkGreen,
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      Text(
                        isGettingLocation
                            ? 'Getting location...'
                            : lang.t(
                          'useCurrentLocation',
                        ),
                        style:
                        const TextStyle(
                          color:
                          darkGreen,
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // =====================================================
            // LOCATION TEXT FIELD
            // =====================================================

            TextField(
              controller:
              locationController,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color,
              ),
              decoration:
              CropTextField
                  .inputDecoration(
                hint: lang.t(
                  'locationHint',
                ),
                icon: Icons
                    .location_on_outlined,
              ).copyWith(
                fillColor:
                Theme.of(context)
                    .cardColor,
                hintStyle: TextStyle(
                  color: isDark
                      ? Colors.white54
                      : Colors.grey.shade500,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // =====================================================
            // MAP + CENTER PIN
            // =====================================================

            Container(
              height: 210,
              width: double.infinity,
              clipBehavior:
              Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
                border: Border.all(
                  color: isDark
                      ? Colors.white12
                      : const Color(
                    0xffd8e6de,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController:
                    mapController,
                    options: MapOptions(
                      initialCenter:
                      mapLocation,
                      initialZoom:
                      selectedLocation !=
                          null
                          ? 16
                          : 12,

                      interactionOptions:
                      const InteractionOptions(
                        flags:
                        InteractiveFlag
                            .all,
                      ),

                      // When farmer moves the map,
                      // save the center coordinates.
                      onPositionChanged:
                          (camera, hasGesture) {
                        if (!hasGesture) {
                          return;
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                        'com.example.agriconnect',
                      ),
                    ],
                  ),

                  // ------------------------------------------------
                  // FIXED CENTER PIN
                  // ------------------------------------------------

                  IgnorePointer(
                    child: Center(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                          bottom: 24,
                        ),
                        child: Column(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color:
                              Colors.red,
                              size: 46,
                            ),

                            Container(
                              width: 8,
                              height: 4,
                              decoration:
                              BoxDecoration(
                                color:
                                Colors.black26,
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // SELECT THIS LOCATION BUTTON
                  // ------------------------------------------------

                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Center(
                      child:
                      ElevatedButton.icon(
                        onPressed:
                        isGettingLocation
                            ? null
                            : () {
                          onSelectMapLocation();
                        },
                        icon: const Icon(
                          Icons
                              .check_circle_outline,
                          size: 18,
                        ),
                        label: const Text(
                          'Select This Location',
                        ),
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          darkGreen,
                          foregroundColor:
                          Colors.white,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Helpful instruction
            Text(
              'Move the map until the pin is exactly on your farm, then select the location.',
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? Colors.white54
                    : Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            // =====================================================
            // DESCRIPTION
            // =====================================================

            CropTextField(
              label:
              lang.t('description'),
              controller:
              descriptionController,
              hint: lang.t(
                'descriptionHint',
              ),
              icon: Icons
                  .description_outlined,
              maxLines: 4,
            ),

            const SizedBox(height: 18),

            // =====================================================
            // QUICK ATTRIBUTES
            // =====================================================

            Text(
              lang.t(
                'quickAttributes',
              ),
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w800,
                color: isDark
                    ? Colors.white70
                    : const Color(
                  0xff333333,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CropAttributeChip(
                  title:
                  lang.t('organic'),
                  selected:
                  isOrganic,
                  onTap:
                  onOrganicTap,
                ),

                CropAttributeChip(
                  title: lang.t(
                    'deliveryAvailable',
                  ),
                  selected:
                  isDeliveryAvailable,
                  onTap:
                  onDeliveryTap,
                ),

                CropAttributeChip(
                  title: lang.t(
                    'premiumGrade',
                  ),
                  selected:
                  isPremiumGrade,
                  onTap:
                  onPremiumTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as location_package;
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/crop_form/add_crop_form_card.dart';
import '../../widgets/crop_form/crop_image_picker_box.dart';
import '../../widgets/crop_form/crop_submit_button.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  static const Color darkGreen = Color(0xff075739);

  final cropNameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // Map controller
  final MapController _mapController = MapController();

  // Geocoding instance
  final Geocoding _geocoding = Geocoding();

  // Selected/current farm location
  LatLng? selectedLocation;

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  String selectedCategory = 'Select a category...';
  String selectedUnit = 'kg';
  String selectedStatus = 'Active';
  String harvestDate = 'dd/mm/yyyy';

  bool isOrganic = false;
  bool isDeliveryAvailable = false;
  bool isPremiumGrade = false;

  bool isGettingLocation = false;

  @override
  void dispose() {
    cropNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<void> _pickCropImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        selectedImage = image;
        selectedImageBytes = bytes;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context
                .read<LanguageProvider>()
                .t('imageSelectionFailed')
                .replaceAll('{value}', error.toString()),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // HARVEST DATE
  // ============================================================

  Future<void> _pickHarvestDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      harvestDate =
      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    });
  }

  // ============================================================
  // USE CURRENT LOCATION
  // ============================================================

  Future<void> _useCurrentLocation() async {
    if (isGettingLocation) return;

    setState(() {
      isGettingLocation = true;
    });

    try {
      final location = location_package.Location();

      // --------------------------------------------------------
      // 1. Check location service / GPS
      // --------------------------------------------------------

      bool serviceEnabled = await location.serviceEnabled();

      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();

        if (!serviceEnabled) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location service is required to select your farm location.',
              ),
              backgroundColor: Colors.red,
            ),
          );

          return;
        }
      }

      // --------------------------------------------------------
      // 2. Check permission
      // --------------------------------------------------------

      var permission = await location.hasPermission();

      if (permission ==
          location_package.PermissionStatus.denied) {
        permission = await location.requestPermission();
      }

      if (permission !=
          location_package.PermissionStatus.granted &&
          permission !=
              location_package.PermissionStatus.grantedLimited) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission is required to select your farm location.',
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      // --------------------------------------------------------
      // 3. Get current coordinates
      // --------------------------------------------------------

      final locationData = await location.getLocation();

      final latitude = locationData.latitude;
      final longitude = locationData.longitude;



      final currentLocation = LatLng(
        latitude,
        longitude,
      );

      if (!mounted) return;

      // --------------------------------------------------------
      // 4. Save location
      // --------------------------------------------------------

      setState(() {
        selectedLocation = currentLocation;
      });

      // --------------------------------------------------------
      // 5. Move map to current location
      // --------------------------------------------------------

      _mapController.move(
        currentLocation,
        16,
      );

      // --------------------------------------------------------
      // 6. Get address
      // --------------------------------------------------------

      await _getAddressFromCoordinates(
        latitude,
        longitude,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Current location selected successfully.',
          ),
          backgroundColor: darkGreen,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to get current location: $error',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  // ============================================================
  // SELECT LOCATION FROM MAP
  // ============================================================

  Future<void> _selectMapLocation() async {
    if (isGettingLocation) return;

    try {
      // Get the current center of the map.
      final mapCenter = _mapController.camera.center;

      if (!mounted) return;

      setState(() {
        selectedLocation = mapCenter;
        isGettingLocation = true;
      });

      // Reverse geocode the map center.
      await _getAddressFromCoordinates(
        mapCenter.latitude,
        mapCenter.longitude,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Farm location selected successfully.',
          ),
          backgroundColor: darkGreen,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not select this location: $error',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  // ============================================================
  // REVERSE GEOCODING
  // Coordinates -> Address
  // ============================================================

  Future<void> _getAddressFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    try {
      final placemarks =
      await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
        locale: const Locale('en', 'PK'),
      );

      if (placemarks.isEmpty) {
        throw Exception(
          'No address found for this location.',
        );
      }

      final place = placemarks.first;

      // House/building number - optional
      final houseNumber =
      place.subThoroughfare?.trim();

      // Street/road
      final street =
      place.thoroughfare?.trim();

      // Area/neighborhood
      final area =
      place.subLocality?.trim();

      // City
      final city =
      place.locality?.trim();

      // District
      final district =
      place.subAdministrativeArea?.trim();

      // Province
      final province =
      place.administrativeArea?.trim();

      // Postal code
      final postalCode =
      place.postalCode?.trim();

      // Country
      final country =
      place.country?.trim();

      final parts = <String>[];

      // House number - optional
      if (houseNumber != null &&
          houseNumber.isNotEmpty) {
        parts.add(houseNumber);
      }

      // Street
      if (street != null &&
          street.isNotEmpty) {
        parts.add(street);
      }

      // Area
      if (area != null &&
          area.isNotEmpty) {
        parts.add(area);
      }

      // City
      if (city != null &&
          city.isNotEmpty) {
        parts.add(city);
      }

      // District
      if (district != null &&
          district.isNotEmpty &&
          district != city) {
        parts.add(district);
      }

      // Province
      if (province != null &&
          province.isNotEmpty &&
          province != district) {
        parts.add(province);
      }

      // Postal code
      if (postalCode != null &&
          postalCode.isNotEmpty) {
        parts.add(postalCode);
      }

      // Country
      if (country != null &&
          country.isNotEmpty) {
        parts.add(country);
      }

      final address = parts.join(', ');

      if (!mounted) return;

      setState(() {
        locationController.text =
        address.isNotEmpty
            ? address
            : '$latitude, $longitude';
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not get address: $error',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool _validateForm() {
    return cropNameController.text.trim().isNotEmpty &&
        quantityController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        locationController.text.trim().isNotEmpty &&
        selectedCategory != 'Select a category...' &&
        harvestDate != 'dd/mm/yyyy';
  }

  // ============================================================
  // BUILD CROP MODEL
  // ============================================================

  CropModel _buildCropModel() {
    return CropModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: cropNameController.text.trim(),
      imageUrl: '',
      quantity:
      '${quantityController.text.trim()} $selectedUnit left',
      price: '\$${priceController.text.trim()}',
      unit: '/$selectedUnit',
      category: selectedCategory,
      status: selectedStatus,
      isOrganic: isOrganic,
      isReadyToShip: isDeliveryAvailable,
      isPremiumGrade: isPremiumGrade,
      location: locationController.text.trim(),
      description: descriptionController.text.trim(),
      harvestDate: harvestDate,
    );
  }

  // ============================================================
  // SUBMIT CROP
  // ============================================================

  Future<void> _submitCrop() async {
    final lang =
    context.read<LanguageProvider>();

    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.t('pleaseFillRequiredFields'),
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final success =
    await context.read<CropProvider>().addCrop(
      _buildCropModel(),
      imageFile: selectedImage,
      imageBytes: selectedImageBytes,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? lang.t('cropListedSuccessfully')
              : lang.t('failedListCrop'),
        ),
        backgroundColor:
        success ? darkGreen : Colors.red,
      ),
    );

    if (success) {
      Navigator.pushReplacementNamed(
        context,
        '/myCrops',
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        context.watch<CropProvider>().isSubmitting;

    final lang =
    context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(isSubmitting),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  24,
                ),
                child: Column(
                  children: [
                    CropImagePickerBox(
                      selectedImageBytes:
                      selectedImageBytes,
                      onTap:
                      _pickCropImage,
                    ),

                    const SizedBox(height: 22),

                    AddCropFormCard(
                      isSubmitting:
                      isSubmitting,

                      cropNameController:
                      cropNameController,

                      quantityController:
                      quantityController,

                      priceController:
                      priceController,

                      locationController:
                      locationController,

                      descriptionController:
                      descriptionController,

                      selectedCategory:
                      selectedCategory,

                      selectedUnit:
                      selectedUnit,

                      selectedStatus:
                      selectedStatus,

                      harvestDate:
                      harvestDate,

                      isOrganic:
                      isOrganic,

                      isDeliveryAvailable:
                      isDeliveryAvailable,

                      isPremiumGrade:
                      isPremiumGrade,

                      // ----------------------------
                      // LOCATION
                      // ----------------------------

                      selectedLocation:
                      selectedLocation,

                      mapController:
                      _mapController,

                      isGettingLocation:
                      isGettingLocation,

                      onUseCurrentLocation:
                      _useCurrentLocation,

                      onSelectMapLocation:
                      _selectMapLocation,

                      // ----------------------------
                      // OTHER CALLBACKS
                      // ----------------------------

                      onPickHarvestDate:
                      _pickHarvestDate,

                      onCategoryChanged:
                          (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedCategory =
                              value;
                        });
                      },

                      onUnitChanged:
                          (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedUnit =
                              value;
                        });
                      },

                      onStatusChanged:
                          (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedStatus =
                              value;
                        });
                      },

                      onOrganicTap: () {
                        setState(() {
                          isOrganic =
                          !isOrganic;
                        });
                      },

                      onDeliveryTap: () {
                        setState(() {
                          isDeliveryAvailable =
                          !isDeliveryAvailable;
                        });
                      },

                      onPremiumTap: () {
                        setState(() {
                          isPremiumGrade =
                          !isPremiumGrade;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    CropSubmitButton(
                      isSubmitting:
                      isSubmitting,

                      title: lang.t(
                        'listCropMarketplace',
                      ),

                      loadingTitle: lang.t(
                        'listingCrop',
                      ),

                      onPressed:
                      _submitCrop,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _topBar(bool isSubmitting) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final lang =
    context.watch<LanguageProvider>();

    return Container(
      height: 58,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white12
                : const Color(0xffe4eee8),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isSubmitting
                ? null
                : () {
              Navigator
                  .pushReplacementNamed(
                context,
                '/myCrops',
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context)
                  .iconTheme
                  .color,
              size: 22,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                lang.t('listNewCrop'),
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : darkGreen,
                  fontSize: 17,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(width: 22),
        ],
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? selectedImage;

  String selectedCategory = "Select a category...";
  String selectedUnit = "kg";
  String selectedStatus = "Active";
  String harvestDate = "dd/mm/yyyy";

  bool isOrganic = false;
  bool isDeliveryAvailable = false;
  bool isPremiumGrade = false;

  @override
  void dispose() {
    cropNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickCropImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> _pickHarvestDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        harvestDate =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  bool _validateForm() {
    return cropNameController.text.trim().isNotEmpty &&
        quantityController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        selectedCategory != "Select a category...";
  }

  CropModel _buildCropModel() {
    return CropModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: cropNameController.text.trim(),
      imageUrl: selectedImage != null
          ? selectedImage!.path
          : "https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800",
      quantity: "${quantityController.text.trim()} $selectedUnit left",
      price: "\$${priceController.text.trim()}",
      unit: "/$selectedUnit",
      category: selectedCategory,
      status: selectedStatus,
      isOrganic: isOrganic,
      isReadyToShip: isDeliveryAvailable,
      location: locationController.text.trim(),
      description: descriptionController.text.trim(),
      harvestDate: harvestDate,
    );
  }

  Future<void> _submitCrop() async {
    final lang = context.read<LanguageProvider>();

    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t("pleaseFillRequiredFields"))),
      );
      return;
    }

    final success = await context.read<CropProvider>().addCrop(
      _buildCropModel(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? lang.t("cropListedSuccessfully") : lang.t("failedListCrop"),
        ),
        backgroundColor: success ? darkGreen : Colors.red,
      ),
    );

    if (success) {
      Navigator.pushReplacementNamed(context, '/myCrops');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<CropProvider>().isSubmitting;
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(isSubmitting),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                child: Column(
                  children: [
                    CropImagePickerBox(
                      selectedImage: selectedImage,
                      onTap: _pickCropImage,
                    ),
                    const SizedBox(height: 22),
                    AddCropFormCard(
                      isSubmitting: isSubmitting,
                      cropNameController: cropNameController,
                      quantityController: quantityController,
                      priceController: priceController,
                      locationController: locationController,
                      descriptionController: descriptionController,
                      selectedCategory: selectedCategory,
                      selectedUnit: selectedUnit,
                      selectedStatus: selectedStatus,
                      harvestDate: harvestDate,
                      isOrganic: isOrganic,
                      isDeliveryAvailable: isDeliveryAvailable,
                      isPremiumGrade: isPremiumGrade,
                      onPickHarvestDate: _pickHarvestDate,
                      onCategoryChanged: (v) {
                        setState(() => selectedCategory = v!);
                      },
                      onUnitChanged: (v) {
                        setState(() => selectedUnit = v!);
                      },
                      onStatusChanged: (v) {
                        setState(() => selectedStatus = v!);
                      },
                      onOrganicTap: () {
                        setState(() => isOrganic = !isOrganic);
                      },
                      onDeliveryTap: () {
                        setState(() {
                          isDeliveryAvailable = !isDeliveryAvailable;
                        });
                      },
                      onPremiumTap: () {
                        setState(() => isPremiumGrade = !isPremiumGrade);
                      },
                    ),
                    const SizedBox(height: 25),
                    CropSubmitButton(
                      isSubmitting: isSubmitting,
                      title: lang.t("listCropMarketplace"),
                      loadingTitle: lang.t("listingCrop"),
                      onPressed: _submitCrop,
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

  Widget _topBar(bool isSubmitting) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xffe4eee8),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isSubmitting
                ? null
                : () => Navigator.pushReplacementNamed(context, '/myCrops'),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
              size: 22,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                lang.t("listNewCrop"),
                style: TextStyle(
                  color: isDark ? Colors.white : darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
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

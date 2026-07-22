import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/crop_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/crop_form/crop_submit_button.dart';
import '../../widgets/crop_form/edit_crop_form_card.dart';

class EditCropScreen extends StatefulWidget {
  const EditCropScreen({super.key});

  @override
  State<EditCropScreen> createState() => _EditCropScreenState();
}

class _EditCropScreenState extends State<EditCropScreen> {
  static const Color darkGreen = Color(0xff075739);

  late final TextEditingController cropNameController;
  late final TextEditingController quantityController;
  late final TextEditingController priceController;
  late final TextEditingController locationController;
  late final TextEditingController descriptionController;

  final ImagePicker _picker = ImagePicker();

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  late String cropId;
  late String selectedCategory;
  late String selectedStatus;
  late String currentImageUrl;
  late String harvestDate;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is CropModel) {
        cropId = args.id;
        cropNameController = TextEditingController(text: args.name);
        // If quantity has " left", remove it for editing
        final qText = args.quantity.replaceAll(
          RegExp(r'\s*left\s*$', caseSensitive: false),
          '',
        );
        quantityController = TextEditingController(text: qText);

        final pText = args.price.replaceAll('\$', '');
        priceController = TextEditingController(text: pText);

        locationController = TextEditingController(text: args.location);
        descriptionController = TextEditingController(text: args.description);
        selectedCategory = args.category;
        selectedStatus = args.status;
        currentImageUrl = args.imageUrl;
        harvestDate = args.harvestDate;
      } else {
        // Fallback
        cropId = "2";
        cropNameController = TextEditingController(text: "Fresh Red Tomatoes");
        quantityController = TextEditingController(text: "500");
        priceController = TextEditingController(text: "1.50");
        locationController = TextEditingController(text: "Faisalabad, Punjab");
        descriptionController = TextEditingController(
          text:
              "Organic, pesticide-free tomatoes harvested directly from our family farm. Sweet and juicy.",
        );
        selectedCategory = "Vegetables";
        selectedStatus = "Active";
        currentImageUrl =
            "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=900";
        harvestDate = "20/06/2026";
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    cropNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
  }

  Future<void> _saveChanges() async {
    final lang = context.read<LanguageProvider>();

    if (cropNameController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t("pleaseFillRequiredFields"))),
      );
      return;
    }

    final updatedCrop = CropModel(
      id: cropId,
      name: cropNameController.text.trim(),
      imageUrl: currentImageUrl,
      quantity: quantityController.text.trim(),
      price: priceController.text.trim(),
      unit: "/kg",
      category: selectedCategory,
      status: selectedStatus,
      isOrganic: true,
      isReadyToShip: true,
      location: locationController.text.trim(),
      description: descriptionController.text.trim(),
      harvestDate: harvestDate,
    );

    final success = await context.read<CropProvider>().updateCrop(
      updatedCrop,
      imageFile: selectedImage,
      imageBytes: selectedImageBytes,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? lang.t("cropUpdatedSuccessfully")
              : lang.t("failedUpdateCrop"),
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(isSubmitting),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _imageHeader(),
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: EditCropFormCard(
                        isSubmitting: isSubmitting,
                        cropNameController: cropNameController,
                        quantityController: quantityController,
                        priceController: priceController,
                        locationController: locationController,
                        descriptionController: descriptionController,
                        selectedCategory: selectedCategory,
                        selectedStatus: selectedStatus,
                        onCategoryChanged: (value) {
                          setState(() => selectedCategory = value!);
                        },
                        onStatusChanged: (value) {
                          setState(() => selectedStatus = value!);
                        },
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
            _bottomSaveSection(isSubmitting),
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
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          GestureDetector(
            onTap: isSubmitting ? null : () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : darkGreen,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                lang.t("editCropListing"),
                style: TextStyle(
                  color: isDark ? Colors.white : darkGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const Icon(Icons.delete_outline, color: Colors.red),
        ],
      ),
    );
  }

  Widget _imageHeader() {
    final lang = context.watch<LanguageProvider>();

    return Stack(
      alignment: Alignment.center,
      children: [
        selectedImageBytes != null
            ? Image.memory(
                selectedImageBytes!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : currentImageUrl.isNotEmpty
            ? Image.network(
                currentImageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              )
            : Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
        Container(height: 250, color: Colors.black.withOpacity(0.15)),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt, size: 18),
          label: Text(lang.t("changePhoto")),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: darkGreen,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomSaveSection(bool isSubmitting) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          CropSubmitButton(
            isSubmitting: isSubmitting,
            title: lang.t("saveChanges"),
            loadingTitle: lang.t("savingChanges"),
            icon: Icons.save_outlined,
            borderRadius: 28,
            onPressed: _saveChanges,
          ),
          const SizedBox(height: 8),
          Text(
            lang.t("saveListingTerms"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white60 : const Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }
}

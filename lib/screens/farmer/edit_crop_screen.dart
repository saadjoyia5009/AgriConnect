import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/crop_provider.dart';
import '../../widgets/crop_form/crop_submit_button.dart';
import '../../widgets/crop_form/edit_crop_form_card.dart';

class EditCropScreen extends StatefulWidget {
  const EditCropScreen({super.key});

  @override
  State<EditCropScreen> createState() => _EditCropScreenState();
}

class _EditCropScreenState extends State<EditCropScreen> {
  static const Color darkGreen = Color(0xff075739);

  final cropNameController = TextEditingController(text: "Fresh Red Tomatoes");
  final quantityController = TextEditingController(text: "500 kg");
  final priceController = TextEditingController(text: "\$1.50 /kg");
  final locationController = TextEditingController(text: "Faisalabad, Punjab");
  final descriptionController = TextEditingController(
    text:
    "Organic, pesticide-free tomatoes harvested directly from our family farm. Sweet and juicy.",
  );

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  String cropId = "2";
  String selectedCategory = "Vegetables";
  String selectedStatus = "Active";
  String currentImageUrl =
      "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=900";

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

    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future<void> _saveChanges() async {
    if (cropNameController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    final updatedCrop = CropModel(
      id: cropId,
      name: cropNameController.text.trim(),
      imageUrl: selectedImage != null ? selectedImage!.path : currentImageUrl,
      quantity: quantityController.text.trim(),
      price: priceController.text.trim(),
      unit: "/kg",
      category: selectedCategory,
      status: selectedStatus,
      isOrganic: true,
      isReadyToShip: true,
      location: locationController.text.trim(),
      description: descriptionController.text.trim(),
      harvestDate: "20/06/2026",
    );

    final success = await context.read<CropProvider>().updateCrop(
      updatedCrop,
      imageFile: selectedImage,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Crop listing updated successfully"
              : "Failed to update crop. Please try again.",
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
      backgroundColor: const Color(0xfff9fbfa),
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
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: isSubmitting ? null : () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: darkGreen),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Edit Crop Listing",
                style: TextStyle(
                  color: darkGreen,
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
    return Stack(
      alignment: Alignment.center,
      children: [
        selectedImage != null
            ? Image.file(
          selectedImage!,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        )
            : Image.network(
          currentImageUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 250,
          color: Colors.black.withOpacity(0.15),
        ),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt, size: 18),
          label: const Text("Change Photo"),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      color: const Color(0xfff9fbfa),
      child: Column(
        children: [
          CropSubmitButton(
            isSubmitting: isSubmitting,
            title: "Save Changes",
            loadingTitle: "Saving Changes...",
            icon: Icons.save_outlined,
            borderRadius: 28,
            onPressed: _saveChanges,
          ),
          const SizedBox(height: 8),
          const Text(
            "By saving, you agree to update your listing\nterms in the marketplace.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xff333333)),
          ),
        ],
      ),
    );
  }
}
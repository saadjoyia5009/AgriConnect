import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/buyer_profile_model.dart';
import '../../providers/buyer_profile_provider.dart';
import '../common/profile_image_picker.dart';

class EditBuyerProfileScreen extends StatefulWidget {
  final BuyerProfileModel profile;

  const EditBuyerProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditBuyerProfileScreen> createState() => _EditBuyerProfileScreenState();
}

class _EditBuyerProfileScreenState extends State<EditBuyerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _locationController = TextEditingController(text: widget.profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);

    if (!mounted) return;

    context.read<BuyerProfileProvider>().setProfileImage(imageFile);
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = BuyerProfileModel(
      id: widget.profile.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      imageUrl: widget.profile.imageUrl,
      totalInquiries: widget.profile.totalInquiries,
      acceptedDeals: widget.profile.acceptedDeals,
      favoriteCrops: widget.profile.favoriteCrops,
    );

    final success = await context
        .read<BuyerProfileProvider>()
        .updateProfile(updatedProfile);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAF7),
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xff0F5C3A),
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0F5C3A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<BuyerProfileProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _profileImage(),
                  const SizedBox(height: 24),
                  _textField(
                    controller: _nameController,
                    label: "Full Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                  _textField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 14),
                  _textField(
                    controller: _phoneController,
                    label: "Phone",
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 14),
                  _textField(
                    controller: _locationController,
                    label: "Location",
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: provider.isUpdating ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0F5C3A),
                        disabledBackgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: provider.isUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _profileImage() {
    return Consumer<BuyerProfileProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            ProfileImagePicker(
              selectedImage: provider.selectedImage,
              imageUrl: widget.profile.imageUrl,
              onTap: _pickProfileImage,
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap image to change profile photo",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff5F675F),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff0F5C3A)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffDCE7DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffDCE7DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff0F5C3A)),
        ),
      ),
    );
  }
}
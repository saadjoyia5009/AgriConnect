import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/buyer_profile_model.dart';
import '../../providers/buyer_profile_provider.dart';
import '../../providers/language_provider.dart';
import '../common/profile_image_picker.dart';
import '../../widgets/buyer/buyer_app_bar.dart';

class EditBuyerProfileScreen extends StatefulWidget {
  final BuyerProfileModel profile;

  const EditBuyerProfileScreen({super.key, required this.profile});

  @override
  State<EditBuyerProfileScreen> createState() => _EditBuyerProfileScreenState();
}

class _EditBuyerProfileScreenState extends State<EditBuyerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;
  Color get primaryText => isDark ? Colors.white : const Color(0xff10291D);
  Color get secondaryText => isDark ? Colors.white70 : const Color(0xff5F675F);

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

    final success = await context.read<BuyerProfileProvider>().updateProfile(
      updatedProfile,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LanguageProvider>().t("profileUpdatedSuccessfully"),
          ),
          backgroundColor: darkGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: BuyerAppBar(
        title: context.watch<LanguageProvider>().t("editProfile"),
        showBackButton: true,
      ),
      body: SafeArea(
        child: Consumer<BuyerProfileProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                18,
                18,
                18,
                18 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _profileImage(),
                    const SizedBox(height: 24),
                    _textField(
                      controller: _nameController,
                      label: context.watch<LanguageProvider>().t("fullName"),
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    _textField(
                      controller: _emailController,
                      label: context.watch<LanguageProvider>().t("email"),
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 14),
                    _textField(
                      controller: _phoneController,
                      label: context.watch<LanguageProvider>().t("phone"),
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 14),
                    _textField(
                      controller: _locationController,
                      label: context.watch<LanguageProvider>().t("location"),
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: provider.isUpdating ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          disabledBackgroundColor: isDark
                              ? darkGreen.withOpacity(0.45)
                              : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: provider.isUpdating
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.watch<LanguageProvider>().t(
                                  "updateProfile",
                                ),
                                style: const TextStyle(
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
            Text(
              context.watch<LanguageProvider>().t("tapImageChangeProfilePhoto"),
              style: TextStyle(fontSize: 12, color: secondaryText),
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
      style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
      cursorColor: accentColor,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return context
              .read<LanguageProvider>()
              .t("fieldRequired")
              .replaceAll("{field}", label);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white60 : const Color(0xff5F675F),
        ),
        errorStyle: TextStyle(
          color: isDark ? Colors.red.shade200 : Colors.red,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: accentColor),
        filled: true,
        fillColor: isDark ? darkCard : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xffDCE7DD),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : const Color(0xffDCE7DD),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accentColor, width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.red.shade200 : Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.red.shade200 : Colors.red,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

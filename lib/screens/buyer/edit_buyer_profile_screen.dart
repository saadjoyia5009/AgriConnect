import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile_model.dart';
import '../../providers/buyer_language_provider.dart';
import '../../providers/profile_provider.dart';

class EditBuyerProfileScreen extends StatefulWidget {
  final UserProfileModel profile;

  const EditBuyerProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditBuyerProfileScreen> createState() {
    return _EditBuyerProfileScreenState();
  }
}

class _EditBuyerProfileScreenState
    extends State<EditBuyerProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;

  XFile? _selectedImage;

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get accentColor {
    return isDark ? lightGreen : darkGreen;
  }

  Color get primaryText {
    return isDark
        ? Colors.white
        : const Color(0xff10291D);
  }

  Color get secondaryText {
    return isDark
        ? Colors.white70
        : const Color(0xff5F675F);
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.profile.displayName,
    );

    _emailController = TextEditingController(
      text: widget.profile.email,
    );

    _phoneController = TextEditingController(
      text: widget.profile.phone,
    );

    _locationController = TextEditingController(
      text: widget.profile.address,
    );
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
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (pickedImage == null || !mounted) {
      return;
    }

    setState(() {
      _selectedImage = pickedImage;
    });
  }

  Future<void> _updateProfile() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final ProfileProvider profileProvider =
    context.read<ProfileProvider>();

    final bool success = await profileProvider.updateProfile(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _locationController.text.trim(),
      profileImage: _selectedImage,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileProvider.errorMessage ??
                'Unable to update profile.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile updated successfully.',
        ),
        backgroundColor: darkGreen,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
    context.watch<ProfileProvider>();

    final BuyerLanguageProvider language =
    context.watch<BuyerLanguageProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
      isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor:
        isDark ? darkBackground : lightBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: accentColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          language.t('editProfile'),
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProfileImage(),
                const SizedBox(height: 14),

                TextButton.icon(
                  onPressed: profileProvider.isUpdating
                      ? null
                      : _pickProfileImage,
                  icon: Icon(
                    Icons.photo_library_outlined,
                    color: accentColor,
                  ),
                  label: Text(
                    language.t('changePhoto'),
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  controller: _nameController,
                  label: language.t('fullName'),
                  icon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your full name.';
                    }

                    if (value.trim().length < 2) {
                      return 'Name must contain at least 2 characters.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                _buildTextField(
                  controller: _emailController,
                  label: language.t('email'),
                  icon: Icons.email_outlined,
                  enabled: false,
                  keyboardType:
                  TextInputType.emailAddress,
                ),

                const SizedBox(height: 14),

                _buildTextField(
                  controller: _phoneController,
                  label: language.t('phone'),
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return null;
                    }

                    if (value.trim().length < 10) {
                      return 'Please enter a valid phone number.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                _buildTextField(
                  controller: _locationController,
                  label: language.t('address'),
                  icon: Icons.location_on_outlined,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: profileProvider.isUpdating
                        ? null
                        : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                      darkGreen.withOpacity(0.55),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: profileProvider.isUpdating
                        ? const SizedBox(
                      width: 23,
                      height: 23,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      language.t('saveChanges'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final String networkImage =
    widget.profile.profileImage.trim();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: accentColor,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 54,
            backgroundColor: isDark
                ? const Color(0xFF1D3329)
                : const Color(0xffE4F4E8),
            child: ClipOval(
              child: _selectedImage != null
                  ? kIsWeb
                  ? Image.network(
                _selectedImage!.path,
                width: 108,
                height: 108,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _buildInitials();
                },
              )
                  : Image.file(
                File(_selectedImage!.path),
                width: 108,
                height: 108,
                fit: BoxFit.cover,
              )
                  : _buildInitials(),
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: 3,
          child: Material(
            color: accentColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _pickProfileImage,
              child: const Padding(
                padding: EdgeInsets.all(9),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitials() {
    return Container(
      width: 108,
      height: 108,
      alignment: Alignment.center,
      color: isDark
          ? const Color(0xFF1D3329)
          : const Color(0xffE4F4E8),
      child: Text(
        widget.profile.initials,
        style: TextStyle(
          color: accentColor,
          fontSize: 32,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines,
      style: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: accentColor,
        ),
        filled: true,
        fillColor: isDark
            ? darkCard
            : Colors.white,
        labelStyle: TextStyle(
          color: secondaryText,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white10
                : const Color(0xffDCE7DD),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white10
                : const Color(0xffDCE7DD),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: accentColor,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  static const Color darkGreen = Color(0xff075739);

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;

  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();

    final profile =
        context.read<ProfileProvider>().profile;

    _nameController = TextEditingController(
      text: profile?.fullName ?? "",
    );

    _emailController = TextEditingController(
      text: profile?.email ?? "",
    );

    _phoneController = TextEditingController(
      text: profile?.phone ?? "",
    );

    _locationController = TextEditingController(
      text: profile?.address ?? "",
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

  Future<void> _pickImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedImage == null) return;

      final bytes = await pickedImage.readAsBytes();

      const maxSize = 5 * 1024 * 1024;

      if (bytes.length > maxSize) {
        if (!mounted) return;

        _showMessage(
          "Profile image cannot exceed 5 MB.",
          isError: true,
        );
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedImage = pickedImage;
        _selectedImageBytes = bytes;
      });
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        "Unable to select image: $error",
        isError: true,
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    final profileProvider =
    context.read<ProfileProvider>();

    final success = await profileProvider.updateProfile(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _locationController.text.trim(),
      profileImage: _selectedImage,
    );

    if (!mounted) return;

    if (!success) {
      _showMessage(
        profileProvider.errorMessage ??
            "Unable to update profile.",
        isError: true,
      );
      return;
    }

    _showMessage(
      context
          .read<LanguageProvider>()
          .t("profileUpdatedSuccessfully"),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final profileProvider =
    context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          lang.t("editProfile"),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _profileImageSection(
                profileProvider.profile,
              ),
              const SizedBox(height: 30),
              _inputField(
                controller: _nameController,
                label: lang.t("fullName"),
                icon: Icons.person_outline,
                textCapitalization:
                TextCapitalization.words,
                validator: (value) {
                  final name = value?.trim() ?? "";

                  if (name.isEmpty) {
                    return "Please enter full name";
                  }

                  if (name.length < 2) {
                    return "Full name must contain at least 2 characters";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 18),
              _inputField(
                controller: _emailController,
                label: lang.t("emailAddress"),
                icon: Icons.email_outlined,
                keyboardType:
                TextInputType.emailAddress,
                readOnly: true,
                validator: (_) => null,
              ),
              const SizedBox(height: 18),
              _inputField(
                controller: _phoneController,
                label: lang.t("phoneNumber"),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final phone = value?.trim() ?? "";

                  if (phone.isEmpty) {
                    return lang.t(
                      "pleaseEnterPhoneNumber",
                    );
                  }

                  if (phone.length < 10) {
                    return "Enter a valid phone number";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 18),
              _inputField(
                controller: _locationController,
                label: lang.t("location"),
                icon: Icons.location_on_outlined,
                textCapitalization:
                TextCapitalization.words,
                validator: (value) {
                  if (
                  value == null ||
                      value.trim().isEmpty
                  ) {
                    return lang.t(
                      "pleaseEnterLocation",
                    );
                  }

                  return null;
                },
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: profileProvider.isUpdating
                      ? null
                      : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    disabledBackgroundColor:
                    Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  child: profileProvider.isUpdating
                      ? const SizedBox(
                    height: 23,
                    width: 23,
                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4,
                    ),
                  )
                      : Text(
                    lang.t("saveChanges"),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImageSection(
      UserProfileModel? profile,
      ) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 120,
              width: 120,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: darkGreen,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _profileImage(profile),
              ),
            ),
            Positioned(
              right: -3,
              bottom: 2,
              child: InkWell(
                onTap: _pickImage,
                borderRadius:
                BorderRadius.circular(25),
                child: Container(
                  height: 43,
                  width: 43,
                  decoration: BoxDecoration(
                    color: darkGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.photo_library_outlined,
          ),
          label: const Text(
            "Change profile picture",
          ),
          style: TextButton.styleFrom(
            foregroundColor: darkGreen,
          ),
        ),
      ],
    );
  }

  Widget _profileImage(
      UserProfileModel? profile,
      ) {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        width: 112,
        height: 112,
        fit: BoxFit.cover,
      );
    }

    if (
    profile != null &&
        profile.profileImage.trim().isNotEmpty
    ) {
      return Image.network(
        profile.profileImage,
        width: 112,
        height: 112,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _initialsAvatar(profile);
        },
      );
    }

    return _initialsAvatar(profile);
  }

  Widget _initialsAvatar(
      UserProfileModel? profile,
      ) {
    return Container(
      color: const Color(0xffe8f5ee),
      alignment: Alignment.center,
      child: Text(
        profile?.initials ?? "F",
        style: const TextStyle(
          color: darkGreen,
          fontSize: 34,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType =
        TextInputType.text,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    bool readOnly = false,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      style: TextStyle(
        color: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.color,
      ),
      decoration: InputDecoration(
        labelText: label,
        helperText: readOnly
            ? "Email cannot be changed"
            : null,
        labelStyle: TextStyle(
          color: isDark
              ? Colors.white70
              : Colors.grey.shade700,
        ),
        prefixIcon: Icon(
          icon,
          color: darkGreen,
        ),
        filled: true,
        fillColor: readOnly
            ? (
            isDark
                ? Colors.white10
                : Colors.grey.shade100
        )
            : Theme.of(context).cardColor,
        border: _inputBorder(isDark),
        enabledBorder: _inputBorder(isDark),
        focusedBorder: _inputBorder(
          isDark,
          color: darkGreen,
          width: 2,
        ),
        errorBorder: _inputBorder(
          isDark,
          color: Colors.red,
        ),
        focusedErrorBorder: _inputBorder(
          isDark,
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder(
      bool isDark, {
        Color? color,
        double width = 1,
      }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: color ??
            (
                isDark
                    ? Colors.white24
                    : Colors.grey.shade300
            ),
        width: width,
      ),
    );
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? Colors.red : darkGreen,
      ),
    );
  }
}
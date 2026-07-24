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

  static const Color primaryGreen = Color(0xff0D6B45);
  static const Color secondaryGreen = Color(0xff18A66A);
  static const Color softGreen = Color(0xffEAF8F1);

  static const Color lightBackground = Color(0xffF4F7F5);
  static const Color darkBackground = Color(0xff0C1511);
  static const Color darkCard = Color(0xff16241D);

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get primaryText {
    return isDark ? Colors.white : const Color(0xff17211C);
  }

  Color get secondaryText {
    return isDark ? Colors.white60 : const Color(0xff6B746F);
  }

  Color get cardColor {
    return isDark ? darkCard : Colors.white;
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
    try {
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
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to select image.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        content: Text('Profile updated successfully.'),
        backgroundColor: primaryGreen,
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
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              _buildModernHeader(
                language,
                profileProvider,
              ),
              Transform.translate(
                offset: const Offset(0, -48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfileCard(
                          language,
                          profileProvider,
                        ),
                        const SizedBox(height: 18),
                        _buildFormCard(language),
                        const SizedBox(height: 22),
                        _buildSaveButton(
                          language,
                          profileProvider,
                        ),
                        const SizedBox(height: 16),
                      ],
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

  Widget _buildModernHeader(
      BuyerLanguageProvider language,
      ProfileProvider profileProvider,
      ) {
    return Container(
      height: 235,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff0B5D3B),
            Color(0xff0F8452),
            Color(0xff19A86A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -35,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -55,
            left: -35,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.07,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            right: 18,
            child: Row(
              children: [
                Material(
                  color: Colors.white.withValues(
                    alpha: 0.15,
                  ),
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed:
                    profileProvider.isUpdating
                        ? null
                        : () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.t('editProfile'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keep your profile information updated',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(
                            alpha: 0.78,
                          ),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
      BuyerLanguageProvider language,
      ProfileProvider profileProvider,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : Colors.white,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.22 : 0.09,
            ),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProfileImage(profileProvider),
          const SizedBox(height: 14),
          Text(
            _nameController.text.trim().isEmpty
                ? widget.profile.displayName
                : _nameController.text.trim(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: primaryText,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.profile.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: profileProvider.isUpdating
                ? null
                : _pickProfileImage,
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryGreen,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              side: BorderSide(
                color: primaryGreen.withValues(
                  alpha: 0.28,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: isDark
                  ? Colors.white.withValues(
                alpha: 0.04,
              )
                  : softGreen,
            ),
            icon: const Icon(
              Icons.photo_camera_outlined,
              size: 20,
            ),
            label: Text(
              language.t('changePhoto'),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(
      ProfileProvider profileProvider,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 122,
          width: 122,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                primaryGreen,
                secondaryGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: secondaryGreen.withValues(
                  alpha: 0.28,
                ),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: _buildProfileImageContent(),
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: 2,
          child: Material(
            color: primaryGreen,
            shape: const CircleBorder(),
            elevation: 4,
            child: InkWell(
              onTap: profileProvider.isUpdating
                  ? null
                  : _pickProfileImage,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImageContent() {
    if (_selectedImage != null) {
      if (kIsWeb) {
        return Image.network(
          _selectedImage!.path,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _buildInitials();
          },
        );
      }

      return Image.file(
        File(_selectedImage!.path),
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildInitials();
        },
      );
    }

    final String networkImage =
    widget.profile.profileImage.trim();

    if (networkImage.isNotEmpty) {
      return Image.network(
        networkImage,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildInitials();
        },
      );
    }

    return _buildInitials();
  }

  Widget _buildInitials() {
    return Container(
      width: 110,
      height: 110,
      alignment: Alignment.center,
      color: isDark
          ? const Color(0xff20352A)
          : softGreen,
      child: Text(
        widget.profile.initials,
        style: const TextStyle(
          color: primaryGreen,
          fontSize: 32,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildFormCard(
      BuyerLanguageProvider language,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        22,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xffE6ECE8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.14 : 0.05,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(
                    alpha: 0.06,
                  )
                      : softGreen,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: primaryGreen,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  language.t('personalInformation'),
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildModernTextField(
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
          const SizedBox(height: 15),
          _buildModernTextField(
            controller: _emailController,
            label: language.t('email'),
            icon: Icons.alternate_email_rounded,
            enabled: false,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          _buildModernTextField(
            controller: _phoneController,
            label: language.t('phone'),
            icon: Icons.phone_iphone_rounded,
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
          const SizedBox(height: 15),
          _buildModernTextField(
            controller: _locationController,
            label: language.t('address'),
            icon: Icons.location_on_outlined,
            textInputAction: TextInputAction.done,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
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
      minLines: maxLines > 1 ? maxLines : 1,
      style: TextStyle(
        color: enabled ? primaryText : secondaryText,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: Container(
          margin: EdgeInsets.fromLTRB(
            10,
            9,
            10,
            maxLines > 1 ? 48 : 9,
          ),
          decoration: BoxDecoration(
            color: enabled
                ? isDark
                ? Colors.white.withValues(
              alpha: 0.06,
            )
                : softGreen
                : isDark
                ? Colors.white.withValues(
              alpha: 0.03,
            )
                : const Color(0xffECEFED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: enabled
                ? primaryGreen
                : secondaryText,
            size: 21,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 58,
          minHeight: 54,
        ),
        filled: true,
        fillColor: enabled
            ? isDark
            ? Colors.white.withValues(alpha: 0.035)
            : const Color(0xffFBFCFB)
            : isDark
            ? Colors.white.withValues(alpha: 0.025)
            : const Color(0xffF1F3F2),
        labelStyle: TextStyle(
          color: secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: const TextStyle(
          color: primaryGreen,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: maxLines > 1 ? 18 : 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white10
                : const Color(0xffE2E8E4),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white10
                : const Color(0xffE5E8E6),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: primaryGreen,
            width: 1.7,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.6,
          ),
        ),
        errorMaxLines: 2,
      ),
    );
  }

  Widget _buildSaveButton(
      BuyerLanguageProvider language,
      ProfileProvider profileProvider,
      ) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            primaryGreen,
            secondaryGreen,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: secondaryGreen.withValues(
              alpha: 0.28,
            ),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: profileProvider.isUpdating
            ? null
            : _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: profileProvider.isUpdating
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              language.t('saveChanges'),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
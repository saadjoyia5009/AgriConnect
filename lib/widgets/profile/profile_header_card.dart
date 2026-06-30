import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/auth_provider.dart';
import '../../screens/farmer/edit_profile_screen.dart';

class ProfileHeaderCard extends StatelessWidget {
  final AuthProvider authProvider;

  const ProfileHeaderCard({
    super.key,
    required this.authProvider,
  });

  static const Color darkGreen = Color(0xff075739);

  Future<void> _pickProfileImage(BuildContext context) async {
    try {
      final picker = ImagePicker();

      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) return;

      authProvider.updateProfileImage(pickedImage.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile picture updated successfully"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image picker error: $e")),
      );
    }
  }

  ImageProvider _getProfileImage() {
    if (authProvider.profileImagePath != null &&
        authProvider.profileImagePath!.isNotEmpty) {
      return FileImage(File(authProvider.profileImagePath!));
    }

    return const NetworkImage(
      "https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=300",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xff202525);
    final subtitleColor =
    isDark ? Colors.grey.shade400 : const Color(0xff4f5955);
    final avatarBgColor =
    isDark ? const Color(0xFF2A3A33) : const Color(0xffe4efe9);
    final badgeBgColor =
    isDark ? darkGreen.withOpacity(0.18) : const Color(0xffdff3e8);
    final borderColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfileScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text("Edit Profile"),
              style: TextButton.styleFrom(
                foregroundColor:
                isDark ? const Color(0xFF6FD59D) : darkGreen,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: avatarBgColor,
                backgroundImage: _getProfileImage(),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () async {
                    await _pickProfileImage(context);
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: darkGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            authProvider.userName.isEmpty
                ? "Farmer User"
                : authProvider.userName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Certified Organic Farmer",
              style: TextStyle(
                color: isDark ? const Color(0xFF6FD59D) : darkGreen,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: subtitleColor,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  authProvider.location,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
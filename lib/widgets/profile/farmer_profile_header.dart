import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/auth_provider.dart';
import '../../screens/farmer/edit_profile_screen.dart';

class FarmerProfileHeader extends StatelessWidget {
  final AuthProvider authProvider;

  const FarmerProfileHeader({
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

  ImageProvider _profileImage() {
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
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff063d2c),
            Color(0xff075739),
            Color(0xff0b8f4d),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: 18,
            child: Icon(
              Icons.eco,
              size: 130,
              color: Colors.white.withOpacity(0.12),
            ),
          ),

          Positioned(
            top: 46,
            left: 20,
            right: 20,
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 18),
                const Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),

              ],
            ),
          ),

          Positioned(
            left: 26,
            right: 26,
            top: 115,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 72,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 66,
                        backgroundImage: _profileImage(),
                      ),
                    ),
                    Positioned(
                      right: -3,
                      bottom: -2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () async {
                          await _pickProfileImage(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff089b55),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 28),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              authProvider.userName.isEmpty
                                  ? "Farmer User"
                                  : authProvider.userName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 28,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff18b65f),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Verified Farmer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      _headerInfo(
                        icon: Icons.location_on_outlined,
                        text: authProvider.location.isEmpty
                            ? "Sahiwal, Punjab, Pakistan"
                            : authProvider.location,
                      ),

                      const SizedBox(height: 12),

                      _headerInfo(
                        icon: Icons.calendar_month_outlined,
                        text: "Member since May 2023",
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

  Widget _headerInfo({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
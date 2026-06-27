import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  final VoidCallback onTap;

  const ProfileImagePicker({
    super.key,
    required this.selectedImage,
    required this.onTap,
    this.imageUrl,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final hasImage =
        selectedImage != null || (imageUrl != null && imageUrl!.isNotEmpty);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: const Color(0xffEAF5EE),
            backgroundImage: _profileImage(),
            child: hasImage
                ? null
                : const Icon(
              Icons.person,
              size: 52,
              color: darkGreen,
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                color: darkGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _profileImage() {
    if (selectedImage != null) {
      return FileImage(selectedImage!);
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }

    return null;
  }
}
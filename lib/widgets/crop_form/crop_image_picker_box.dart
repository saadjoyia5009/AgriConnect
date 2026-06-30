import 'dart:io';
import 'package:flutter/material.dart';

class CropImagePickerBox extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  final VoidCallback onTap;
  final double height;

  const CropImagePickerBox({
    super.key,
    required this.selectedImage,
    required this.onTap,
    this.imageUrl,
    this.height = 175,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1E1E1E) : Colors.white,
          border: Border.all(
            color: isDark ? Colors.white24 : const Color(0xffcfd8d3),
          ),
          borderRadius: BorderRadius.circular(10),
          image: _backgroundImage(),
        ),
        child: _hasImage()
            ? Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(isDark ? 0.38 : 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.white, size: 30),
                  SizedBox(height: 8),
                  Text(
                    "Tap to Change Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            : _emptyView(context),
      ),
    );
  }

  DecorationImage? _backgroundImage() {
    if (selectedImage != null) {
      return DecorationImage(
        image: FileImage(selectedImage!),
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(imageUrl!),
        fit: BoxFit.cover,
      );
    }

    return null;
  }

  bool _hasImage() {
    return selectedImage != null || (imageUrl != null && imageUrl!.isNotEmpty);
  }

  Widget _emptyView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: isDark
              ? darkGreen.withOpacity(0.22)
              : Colors.grey.shade200,
          child: Icon(
            Icons.camera_alt,
            color: isDark ? const Color(0xff9ff2c1) : darkGreen,
            size: 26,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "Upload Crop Image",
          style: TextStyle(
            color: isDark ? const Color(0xff9ff2c1) : darkGreen,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "High-quality, well-lit photos attract more\nbuyers. Tap to upload.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xff4f5955),
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "JPEG, PNG up to 5MB",
          style: TextStyle(
            color: isDark ? Colors.white54 : const Color(0xff4f5955),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
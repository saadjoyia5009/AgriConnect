import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class CropImagePickerBox extends StatelessWidget {
  final Uint8List? selectedImageBytes;
  final String? imageUrl;
  final VoidCallback onTap;
  final double height;

  const CropImagePickerBox({
    super.key,
    required this.selectedImageBytes,
    required this.onTap,
    this.imageUrl,
    this.height = 175,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

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
        ),
        clipBehavior: Clip.antiAlias,
        child: _hasImage()
            ? Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            Container(
              color: Colors.black.withOpacity(
                isDark ? 0.38 : 0.25,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lang.t('tapChangeImage'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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

  Widget _buildImage() {
    if (selectedImageBytes != null) {
      return Image.memory(
        selectedImageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) {
          return Container(
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.grey,
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  bool _hasImage() {
    return selectedImageBytes != null ||
        (imageUrl != null && imageUrl!.isNotEmpty);
  }

  Widget _emptyView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

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
          lang.t('uploadCropImage'),
          style: TextStyle(
            color: isDark ? const Color(0xff9ff2c1) : darkGreen,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lang.t('cropImageHelp'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xff4f5955),
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          lang.t('cropImageFormat'),
          style: TextStyle(
            color: isDark ? Colors.white54 : const Color(0xff4f5955),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
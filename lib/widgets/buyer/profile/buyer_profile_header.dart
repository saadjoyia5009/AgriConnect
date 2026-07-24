import 'package:flutter/material.dart';

import '../../../models/user_profile_model.dart';

class BuyerProfileHeader extends StatelessWidget {
  final UserProfileModel profile;
  final VoidCallback? onCameraTap;

  const BuyerProfileHeader({
    super.key,
    required this.profile,
    this.onCameraTap,
  });

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightGreen = Color(0xff9ff2c1);

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final String displayName =
    profile.displayName.trim().isNotEmpty
        ? profile.displayName.trim()
        : 'Buyer';

    final String email = profile.email.trim();
    final String imageUrl = profile.profileImage.trim();

    return Column(
      children: [
        _buildProfileImage(
          displayName: displayName,
          imageUrl: imageUrl,
          isDark: isDark,
        ),
        const SizedBox(height: 14),

        Text(
          displayName,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: isDark
                ? Colors.white
                : const Color(0xff10291D),
          ),
        ),

        const SizedBox(height: 7),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? lightGreen.withOpacity(0.15)
                : darkGreen.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? lightGreen.withOpacity(0.45)
                  : darkGreen.withOpacity(0.25),
            ),
          ),
          child: Text(
            profile.displayRole.trim().isNotEmpty
                ? profile.displayRole
                : 'Buyer',
            style: TextStyle(
              color: isDark ? lightGreen : darkGreen,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        if (email.isNotEmpty) ...[
          const SizedBox(height: 9),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                email,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark
                      ? Colors.white70
                      : const Color(0xff5F675F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfileImage({
    required String displayName,
    required String imageUrl,
    required bool isDark,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? lightGreen : darkGreen,
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 47,
            backgroundColor: isDark
                ? const Color(0xFF1D3329)
                : const Color(0xffE4F4E8),
            child: ClipOval(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                width: 94,
                height: 94,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _buildInitials(
                    displayName: displayName,
                    isDark: isDark,
                  );
                },
              )
                  : _buildInitials(
                displayName: displayName,
                isDark: isDark,
              ),
            ),
          ),
        ),

        if (onCameraTap != null)
          Positioned(
            right: -3,
            bottom: 0,
            child: Material(
              color: isDark ? lightGreen : darkGreen,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                onTap: onCameraTap,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xff10291D)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials({
    required String displayName,
    required bool isDark,
  }) {
    return Container(
      width: 94,
      height: 94,
      alignment: Alignment.center,
      color: isDark
          ? const Color(0xFF1D3329)
          : const Color(0xffE4F4E8),
      child: Text(
        _getInitials(displayName),
        style: TextStyle(
          color: isDark ? lightGreen : darkGreen,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final List<String> words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'B';
    }

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'
        .toUpperCase();
  }
}
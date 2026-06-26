import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final String? subtitle;
  final bool showArrow;

  static const Color darkGreen = Color(0xff075739);

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.subtitle,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSetting = subtitle != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: const Color(0xfff0f1f0),
              child: Icon(icon, color: darkGreen, size: 24),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSetting ? 18 : 14,
                      color: isSetting
                          ? const Color(0xff202525)
                          : const Color(0xff4f5955),
                      fontWeight:
                      isSetting ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle ?? value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSetting ? 13 : 17,
                      color: isSetting
                          ? const Color(0xff4f5955)
                          : const Color(0xff202525),
                      fontWeight:
                      isSetting ? FontWeight.w500 : FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right,
                size: 30,
                color: Color(0xff333333),
              ),
          ],
        ),
      ),
    );
  }
}
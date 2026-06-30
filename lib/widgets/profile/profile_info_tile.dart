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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark
        ? Colors.white
        : (isSetting
        ? const Color(0xff202525)
        : const Color(0xff4f5955));

    final valueColor = isDark
        ? Colors.grey.shade300
        : (isSetting
        ? const Color(0xff4f5955)
        : const Color(0xff202525));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: isDark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xfff0f1f0),
              child: Icon(
                icon,
                color: darkGreen,
                size: 24,
              ),
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
                      color: titleColor,
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
                      color: valueColor,
                      fontWeight:
                      isSetting ? FontWeight.w500 : FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                size: 30,
                color: isDark
                    ? Colors.grey.shade400
                    : const Color(0xff333333),
              ),
          ],
        ),
      ),
    );
  }
}
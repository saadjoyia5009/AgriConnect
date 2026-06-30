import 'package:flutter/material.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      style: TextStyle(
        color: isDark
            ? Colors.grey.shade400
            : const Color(0xff4f5955),
        fontSize: 15,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class FarmerInquiryMessageSection extends StatelessWidget {
  final String title;
  final String message;

  const FarmerInquiryMessageSection({
    super.key,
    required this.title,
    required this.message,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color accentGreen = Color(0xff36a66b);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white10
                    : const Color(0xffdff4e7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: darkGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xff123a2a),
                fontSize: 21,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.eco_rounded,
              color: accentGreen,
              size: 18,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff172019) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white12
                  : const Color(0xffcfe5d8),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isDark
                  ? Colors.white70
                  : const Color(0xff28352e),
              fontSize: 16,
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

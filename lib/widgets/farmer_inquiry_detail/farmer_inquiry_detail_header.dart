import 'package:flutter/material.dart';

class FarmerInquiryDetailHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const FarmerInquiryDetailHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  static const Color darkGreen = Color(0xff075739);
  static const Color accentGreen = Color(0xff36a66b);
  static const Color borderGreen = Color(0xffcfe5d8);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 88,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xff101f17)
            : const Color(0xfff7fbf8),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: 0,
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                Icons.eco_rounded,
                size: 100,
                color: accentGreen,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : borderGreen,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.025),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: onBack,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark ? Colors.white : darkGreen,
                      size: 27,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : darkGreen,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                const Icon(
                  Icons.eco_rounded,
                  color: accentGreen,
                  size: 19,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

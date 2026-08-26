import 'package:flutter/material.dart';

class ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          children: [
            // --------------------------------------------------
            // ICON
            // --------------------------------------------------

            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xff20372b)
                    : const Color(0xffe8f5ee),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isDark
                    ? const Color(0xff65c98e)
                    : darkGreen,
                size: 22,
              ),
            ),

            const SizedBox(width: 16),

            // --------------------------------------------------
            // TITLE
            // --------------------------------------------------

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? Colors.white
                      : const Color(0xff202525),
                ),
              ),
            ),

            // --------------------------------------------------
            // TRAILING TEXT
            // --------------------------------------------------

            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xff65c98e)
                      : darkGreen,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

            const SizedBox(width: 8),

            // --------------------------------------------------
            // ARROW
            // --------------------------------------------------

            Icon(
              Icons.chevron_right,
              color: isDark
                  ? Colors.white54
                  : const Color(0xff4f5955),
            ),
          ],
        ),
      ),
    );
  }
}
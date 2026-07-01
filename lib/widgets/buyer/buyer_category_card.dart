import 'package:flutter/material.dart';

class BuyerCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;

  const BuyerCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.icon,
    this.onTap,
  });

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightGreen = Color(0xffA8F0C8);

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: hasImage
              ? null
              : (isDark
              ? const Color(0xFF15251E)
              : const Color(0xffD4F0DC)),
          borderRadius: BorderRadius.circular(12),
          border: isDark && !hasImage
              ? Border.all(color: Colors.white10)
              : null,
          image: hasImage
              ? DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                isDark ? 0.55 : 0.35,
              ),
              BlendMode.darken,
            ),
          )
              : null,
        ),
        padding: const EdgeInsets.all(12),
        child: hasImage
            ? Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.category,
              color: isDark ? lightGreen : darkGreen,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: isDark
                    ? Colors.white
                    : const Color(0xff1F2722),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

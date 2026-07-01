import 'package:flutter/material.dart';

class BuyerProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;

  const BuyerProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = const Color(0xff0F5C3A),
  });

  static const Color darkCard = Color(0xFF15251E);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xffDCE7DD),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isDark
                ? Colors.white
                : const Color(0xff10291D),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: isDark
              ? Colors.white54
              : const Color(0xff7A837C),
        ),
      ),
    );
  }
}

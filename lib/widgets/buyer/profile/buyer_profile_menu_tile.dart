import 'package:flutter/material.dart';

class BuyerProfileMenuTile extends StatelessWidget {
final IconData icon;
final String title;
final String? subtitle;
final VoidCallback onTap;
final Color iconColor;

const BuyerProfileMenuTile({
super.key,
required this.icon,
required this.title,
this.subtitle,
required this.onTap,
this.iconColor = const Color(0xff075739),
});

static const Color darkGreen = Color(0xff075739);

@override
Widget build(BuildContext context) {
final bool isDark =
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
Container(
height: 42,
width: 42,
decoration: BoxDecoration(
color: iconColor == Colors.red
? Colors.red.withValues(
alpha: isDark ? 0.15 : 0.08,
)
    : isDark
? const Color(0xFF263B31)
    : const Color(0xffe8f5ee),
borderRadius: BorderRadius.circular(14),
),
child: Icon(
icon,
color: iconColor == Colors.red
? Colors.red
    : isDark
? const Color(0xff9ff2c1)
    : darkGreen,
size: 22,
),
),

const SizedBox(width: 16),

Expanded(
child: Text(
title,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w800,
color: iconColor == Colors.red
? Colors.red
    : isDark
? Colors.white
    : const Color(0xff202525),
),
),
),

if (subtitle != null &&
subtitle!.trim().isNotEmpty) ...[
const SizedBox(width: 18),
  Text(
    subtitle!,
    style: TextStyle(
      color: iconColor == Colors.red
          ? Colors.red
          : isDark
          ? const Color(0xff9ff2c1)
          : darkGreen,
      fontSize: 14,
      fontWeight: FontWeight.w800,
    ),
  ),
],

const SizedBox(width: 8),

Icon(
Icons.chevron_right,
color: isDark
? Colors.white54
    : const Color(0xff4f5955),
size: 26,
),
],
),
),
);
}
}

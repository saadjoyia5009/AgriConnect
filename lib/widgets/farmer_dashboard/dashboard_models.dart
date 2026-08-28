import 'package:flutter/material.dart';

class DashboardActionData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color background;
  final Widget? screen;
  final VoidCallback? onTap;

  const DashboardActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.background,
    this.screen,
    this.onTap,
  });
}

class DashboardAttentionData {
  final IconData icon;
  final Color iconColor;
  final String text;
  final VoidCallback onTap;

  const DashboardAttentionData({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
  });
}

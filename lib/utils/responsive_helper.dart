import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isTablet(BuildContext context) =>
      width(context) >= 600;

  static double horizontalPadding(BuildContext context) {
    return isTablet(context) ? 32 : 20;
  }

  static double titleFont(BuildContext context) {
    return isTablet(context) ? 28 : 24;
  }

  static double bodyFont(BuildContext context) {
    return isTablet(context) ? 18 : 16;
  }

  static double avatarRadius(BuildContext context) {
    return isTablet(context) ? 65 : 52;
  }

  static double cardRadius(BuildContext context) {
    return isTablet(context) ? 20 : 14;
  }
}
import 'package:flutter/material.dart';

import '../core/responsive/app_breakpoints.dart';

class ResponsiveHelper {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isMobile(BuildContext context) =>
      AppBreakpoints.isMobile(context);

  static bool isTablet(BuildContext context) =>
      AppBreakpoints.isTablet(context);

  static bool isDesktop(BuildContext context) =>
      AppBreakpoints.isDesktop(context);

  static int gridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int wideDesktop = 4,
  }) => AppBreakpoints.gridColumns(
    width(context),
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
    wideDesktop: wideDesktop,
  );

  static double horizontalPadding(BuildContext context) {
    return isDesktop(context) ? 32 : (isTablet(context) ? 28 : 20);
  }

  static double titleFont(BuildContext context) {
    return isMobile(context) ? 24 : 28;
  }

  static double bodyFont(BuildContext context) {
    return isMobile(context) ? 16 : 18;
  }

  static double avatarRadius(BuildContext context) {
    return isMobile(context) ? 52 : 65;
  }

  static double cardRadius(BuildContext context) {
    return isMobile(context) ? 14 : 20;
  }
}

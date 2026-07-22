import 'package:flutter/widgets.dart';

/// The single source of truth for AgriConnect's adaptive breakpoints.
abstract final class AppBreakpoints {
  static const double mobile = 600;
  static const double desktop = 1024;
  static const double maxContentWidth = 1360;

  static bool isMobileWidth(double width) => width < mobile;
  static bool isTabletWidth(double width) => width >= mobile && width < desktop;
  static bool isDesktopWidth(double width) => width >= desktop;

  static bool isMobile(BuildContext context) =>
      isMobileWidth(MediaQuery.sizeOf(context).width);
  static bool isTablet(BuildContext context) =>
      isTabletWidth(MediaQuery.sizeOf(context).width);
  static bool isDesktop(BuildContext context) =>
      isDesktopWidth(MediaQuery.sizeOf(context).width);

  static int gridColumns(
    double width, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int wideDesktop = 4,
  }) {
    if (width >= maxContentWidth) return wideDesktop;
    if (isDesktopWidth(width)) return desktop;
    if (isTabletWidth(width)) return tablet;
    return mobile;
  }
}

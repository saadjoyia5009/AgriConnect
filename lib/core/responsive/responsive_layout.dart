import 'package:flutter/material.dart';

import 'app_breakpoints.dart';
import 'responsive_builder.dart';

/// Centers wide-screen pages and applies comfortable adaptive gutters.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    this.mobilePadding = 0,
    this.tabletPadding = 24,
    this.desktopPadding = 32,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final double mobilePadding;
  final double tabletPadding;
  final double desktopPadding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (_, __) => child,
      tablet: (_, __) => _constrained(child, tabletPadding),
      desktop: (_, __) => _constrained(child, desktopPadding),
    );
  }

  Widget _constrained(Widget content, double padding) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: content,
        ),
      ),
    );
  }
}

/// A non-scrolling responsive grid intended for use inside a page scroll view.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.wideDesktopColumns = 4,
    this.spacing = 16,
    this.childAspectRatio = 1,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int wideDesktopColumns;
  final double spacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = AppBreakpoints.gridColumns(
          constraints.maxWidth,
          mobile: mobileColumns,
          tablet: tabletColumns,
          desktop: desktopColumns,
          wideDesktop: wideDesktopColumns,
        );
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
          children: children,
        );
      },
    );
  }
}

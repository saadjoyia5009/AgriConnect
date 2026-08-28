import 'package:flutter/material.dart';

class InquiryImageCurveClipper extends CustomClipper<Path> {
  final double bottomPadding;

  const InquiryImageCurveClipper({
    this.bottomPadding = 0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final double curveHeight = 38 + bottomPadding;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - curveHeight);

    path.quadraticBezierTo(
      size.width * 0.78,
      size.height - 2 - bottomPadding,
      size.width * 0.50,
      size.height - 4 - bottomPadding,
    );

    path.quadraticBezierTo(
      size.width * 0.24,
      size.height - 10 - bottomPadding,
      0,
      size.height - curveHeight,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(
      covariant InquiryImageCurveClipper oldClipper,
      ) {
    return oldClipper.bottomPadding != bottomPadding;
  }
}

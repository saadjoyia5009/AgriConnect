import 'package:flutter/material.dart';

class InquiryImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(24, 0);
    path.quadraticBezierTo(0, 0, 0, 24);
    path.lineTo(0, size.height - 24);
    path.quadraticBezierTo(
      0,
      size.height,
      24,
      size.height,
    );
    path.lineTo(size.width - 28, size.height);

    path.cubicTo(
      size.width - 17,
      size.height * 0.82,
      size.width - 8,
      size.height * 0.65,
      size.width - 8,
      size.height * 0.50,
    );

    path.cubicTo(
      size.width - 8,
      size.height * 0.35,
      size.width - 17,
      size.height * 0.18,
      size.width - 28,
      0,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class InquiryImageCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(size.width - 28, 0);

    path.cubicTo(
      size.width - 17,
      size.height * 0.18,
      size.width - 8,
      size.height * 0.35,
      size.width - 8,
      size.height * 0.50,
    );

    path.cubicTo(
      size.width - 8,
      size.height * 0.65,
      size.width - 17,
      size.height * 0.82,
      size.width - 28,
      size.height,
    );

    final paint = Paint()
      ..color = const Color(0xff63c895)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

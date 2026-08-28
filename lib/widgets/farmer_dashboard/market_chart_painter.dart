import 'package:flutter/material.dart';

class MarketChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xff4ca95d)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x304ca95d),
          Color(0x004ca95d),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.72),
      Offset(size.width * 0.12, size.height * 0.58),
      Offset(size.width * 0.22, size.height * 0.66),
      Offset(size.width * 0.34, size.height * 0.48),
      Offset(size.width * 0.45, size.height * 0.50),
      Offset(size.width * 0.57, size.height * 0.30),
      Offset(size.width * 0.67, size.height * 0.38),
      Offset(size.width * 0.79, size.height * 0.13),
      Offset(size.width * 0.91, size.height * 0.19),
      Offset(size.width, size.height * 0.08),
    ];

    final path = Path()
      ..moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xff4ca95d);

    for (final point in points) {
      canvas.drawCircle(point, 2.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class GradientCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect =
    Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);
    const Gradient gradient = LinearGradient(
        colors: [Color(0xFFFFA553), Color(0xFFEE8C34), Color(0xFFEA5434)], stops: [0.0, 0.478064, 1.0]);

    final Paint paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
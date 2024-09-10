import 'package:flutter/material.dart';

class RibbonPainter extends CustomPainter {
  final Color color;

  RibbonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width + 15, 0)
      ..lineTo(size.width + 15 - 10, size.height / 2)
      ..lineTo(size.width + 15, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class FingerPen extends CustomPainter {
  final List<Offset?> points;

  FingerPen(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i]!, points[i+1]!, paint);
        // TODO: używać Path oraz quadraticBezierTo()
      }
    }
  }

  @override
  bool shouldRepaint(FingerPen oldDelegate) => true;

}
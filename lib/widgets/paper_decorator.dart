import 'package:flutter/material.dart';


class PaperDecorator extends CustomPainter {
  final bool showGrid;
  final bool showSymbol;
  final String? backgroundSymbol;
  final bool useStrokeOrderFont;

  PaperDecorator({
    this.showGrid = false,
    this.showSymbol = false,
    this.backgroundSymbol,
    this.useStrokeOrderFont = false,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (showSymbol && backgroundSymbol != null) _drawSymbol(canvas, size);
    if (showGrid) _drawGrid(canvas, size);
  }

  void _drawSymbol(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: backgroundSymbol,
        style: TextStyle(
          fontSize: size.height * 0.9,
          fontFamily: useStrokeOrderFont ? 'KanjiStrokeOrder' : null,
          color: Colors.grey.withValues(alpha: 0.2),
          // fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 1.0;
    final x = (size.width) / 2;
    final y = (size.height) / 2;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, 0), paint);
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

    canvas.drawLine(Offset(0, y/2), Offset(size.width, y/2), paint);
    canvas.drawLine(Offset(0, y/2*3), Offset(size.width, y/2*3), paint);
    canvas.drawLine(Offset(x/2, 0), Offset(x/2, size.height), paint);
    canvas.drawLine(Offset(x/2*3, 0), Offset(x/2*3, size.height), paint);
  }
  
  @override
  bool shouldRepaint(PaperDecorator oldDelegate) => true;
 
}

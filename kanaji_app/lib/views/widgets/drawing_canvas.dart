import 'package:flutter/material.dart';
import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/views/widgets/drawing_painter.dart';
import 'package:provider/provider.dart';

class DrawingCanvas extends StatelessWidget{
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IDrawingCanvasViewModel>(context);
    return GestureDetector(
      onPanUpdate: (details) {
        vm.addPoints(details.localPosition);
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: DrawingPainter(points: vm.points),
      ),
    );
  }
}
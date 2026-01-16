// combined_canvas.dart

import 'package:flutter/material.dart';
import 'package:kanaji/presentation/views/widgets/drawing_canvas.dart';

class CombinedCanvas extends StatelessWidget {
  final Widget grid;
  final DrawingCanvas drawing;

  const CombinedCanvas({
    super.key,
    required this.grid,
    required this.drawing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                grid,
                drawing,
              ],
            ),
          ),
        );
      },
    );
  }
}
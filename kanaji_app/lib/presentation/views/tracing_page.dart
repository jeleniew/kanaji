// tracing_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/presentation/viewmodels/tracing_viewmodel.dart';
import 'package:kanaji/presentation/views/widgets/drawing_canvas.dart';
import 'package:kanaji/presentation/views/widgets/grid_canvas.dart';
import 'package:kanaji/presentation/views/writing_page.dart';

class TracingPage extends StatelessWidget {
  final String title;
  const TracingPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return WritingPage<TracingViewModel>(
      title: title,
      gridBuilder: (vm) => GridCanvas(
        character: vm.currentCharacter,
        svgData: vm.currentCharacterSvg,
      ),
      drawingBuilder: (vm) => DrawingCanvas(),
    );
  }
}
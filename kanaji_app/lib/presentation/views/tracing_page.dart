// tracing_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/presentation/viewmodels/tracing_viewmodel.dart';
import 'package:kanaji/presentation/views/widgets/combined_canvas.dart';
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
      canvas: (vm) => CombinedCanvas(
        grid: FutureBuilder(
          future: vm.currentCharacter,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No character data available.'));
            }
            final character = snapshot.data!;

            return GridCanvas(
              character: character,
              svgData: vm.currentCharacterSvg,
            );
          },
        ),
        drawing: DrawingCanvas(),
      ),
    );
  }
}
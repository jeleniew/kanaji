// writing_page.dart

import 'package:flutter/material.dart';
import 'package:kanaji/presentation/viewmodels/practice_viewmodel.dart';
import 'package:kanaji/presentation/views/widgets/combined_canvas.dart';
import 'package:kanaji/presentation/views/widgets/drawing_canvas.dart';
import 'package:kanaji/presentation/views/widgets/grid_canvas.dart';
import 'package:kanaji/presentation/views/writing_page.dart';

class PracticePage extends StatelessWidget {
  final String title;
  const PracticePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return WritingPage<PracticeViewModel>(
      title: title,
      canvas: (vm) => FutureBuilder(
        future: vm.currentCharacter,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final character = snapshot.data![0];
          final svgData = vm.currentCharacterSvg;

          return CombinedCanvas(
            grid: GridCanvas(
              character: character,
              svgData: svgData,
            ),
            drawing: DrawingCanvas(),
          );
        },
      ),
    );
  }
}
// writing_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanaji/domain/entities/tracing_result.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';
import 'package:kanaji/presentation/views/widgets/drawing_canvas.dart';
import 'package:kanaji/presentation/views/widgets/grid_canvas.dart';
import 'package:provider/provider.dart';

class WritingPage extends StatelessWidget {
  final String title;
  const WritingPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IWritingViewModel>(context);
    final drawingVM = context.read<IDrawingCanvasViewModel>();
    vm.attachDrawingVM(drawingVM);

    return BasePage(
      title: title,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // TODO: both should be the same size
                // if (vm.hint.isNotEmpty)
                //   _buildKanjiSvg(vm.currentCharacter, vm)
                // else
                GridCanvas(
                  character: vm.hint,
                ),
                const DrawingCanvas(),
              ],
            ),
          ),
          if (vm.tracingResult == TracingResult.none)
            _buildActionBar(vm),
            if (vm.tracingResult != TracingResult.none) _buildResultBar(vm),
        ],
      ),
    );
  }

  Widget _buildActionBar(IWritingViewModel vm) {
    return Row(
      children: [
        ElevatedButton(onPressed: vm.clear, child: Text('Clear')),
        ElevatedButton(onPressed: vm.check, child: Text('Check')),
        ElevatedButton(onPressed: vm.checkAI, child: Text('Check AI')),
        ElevatedButton(onPressed: vm.showHint, child: Text('Show hint')),
      ],
    );
  }
  
  Widget _buildResultBar(IWritingViewModel vm) {
    final isCorrect = vm.tracingResult == TracingResult.correct;
    return Container(
      padding: EdgeInsets.all(16),
      color: isCorrect ? Colors.green : Colors.red,
      child: Row(
        children: [
          Expanded(
            child: Text(
              isCorrect ? 'Correct!' : 'Incorrect, try again.',
              style: TextStyle(color: Colors.white, fontSize: 24)
            ),
          ),
          if (isCorrect) ...[
            ElevatedButton(onPressed: vm.previous, child: Text('Previous')),
            SizedBox(width: 8),
            ElevatedButton(onPressed: vm.next, child: Text('Next')),
            ElevatedButton(onPressed: vm.clear, child: Text('Try Again')),
          ] else ...[
            ElevatedButton(onPressed: vm.clear, child: Text('Try Again')),
          ],
        ],
      ),
    );
  }

  FutureBuilder<String> _buildKanjiSvg(String kanji, IWritingViewModel vm) {
    return FutureBuilder<String>(
      future: vm.currentCharacterSvg,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading SVG');
        } else {
          final svgData = snapshot.data!;
          return SvgPicture.string(
            svgData,
            width: 128,
            height: 127,
          );
        }
      },
    );
  }
}
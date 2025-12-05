// tracing_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/tracing_result.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:provider/provider.dart';

class WritingPage<T extends IWritingViewModel> extends StatelessWidget {
  final String title;
  final Widget Function(T vm) gridBuilder;
  final Widget Function(T vm) drawingBuilder;

  const WritingPage({
    super.key,
    required this.title,
    required this.gridBuilder,
    required this.drawingBuilder
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<T>(context);
    final drawingVM = context.read<IDrawingCanvasViewModel>();
    vm.attachDrawingVM(drawingVM);

    return BasePage(
      title: title,
      body: Column(
        children: [
          Text(vm.currentMeaning, style: TextStyle(fontSize: 48),),
          Expanded(
            child: Stack(
              children: [
                gridBuilder(vm),
                drawingBuilder(vm),
              ],
            ),
          ),
          // if (vm.processedImage != null)
          //   Container(
          //     width: 128,
          //     height: 127,
          //     color: Colors.red,
          //     child: RawImage(image: vm.processedImage),
          //   ),
          if (vm.tracingResult == TracingResult.none) _buildActionBar(vm),
          if (vm.tracingResult != TracingResult.none) _buildResultBar(vm),
        ],
      ),
    );
  }

  Widget _buildActionBar(T vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 8),
        ElevatedButton(onPressed: vm.clear, child: Text('Clear')),
        SizedBox(width: 8),
        ElevatedButton(onPressed: vm.check, child: Text('Check')),
        SizedBox(width: 8),
        ElevatedButton(onPressed: vm.checkAI, child: Text('Check AI')),
        SizedBox(width: 8),
        ElevatedButton(onPressed: vm.showHint, child: Text('Hint')),
      ],
    );
  }
  
  Widget _buildResultBar(T vm) {
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
          ] else ...[
            ElevatedButton(onPressed: vm.clear, child: Text('Try Again')),
          ],
        ],
      ),
    );
  }
}
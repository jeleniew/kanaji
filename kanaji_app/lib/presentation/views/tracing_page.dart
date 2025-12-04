// tracing_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/tracing_result.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_tracing_viewmodel.dart';
import 'package:kanaji/presentation/views/widgets/drawing_canvas.dart';
import 'package:kanaji/presentation/views/widgets/grid_canvas.dart';
import 'package:provider/provider.dart';

class TracingPage extends StatelessWidget {
  final String title;
  const TracingPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ITracingViewModel>(context);
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
                // TODO: both should be the same size
                GridCanvas(
                  character: vm.currentCharacter,
                  font: vm.font,
                ),
                const DrawingCanvas(),
              ],
            ),
          ),
          if (vm.processedImage != null)
            Container(
              width: 128,
              height: 127,
              color: Colors.red,
              child: RawImage(image: vm.processedImage),
            ),
          if (vm.tracingResult == TracingResult.none) _buildActionBar(vm),
          if (vm.tracingResult != TracingResult.none) _buildResultBar(vm),
        ],
      ),
    );
  }

  Widget _buildActionBar(ITracingViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 8),
        ElevatedButton(onPressed: vm.clear, child: Text('Clear')),
        SizedBox(width: 8),
        ElevatedButton(onPressed: vm.check, child: Text('Check')),
        SizedBox(width: 8),
        ElevatedButton(onPressed: vm.checkAI, child: Text('Check AI')),
        // SizedBox(width: 8),
        // ElevatedButton(onPressed: vm.changeFont, child: Text('Font')),
      ],
    );
  }
  
  Widget _buildResultBar(ITracingViewModel vm) {
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
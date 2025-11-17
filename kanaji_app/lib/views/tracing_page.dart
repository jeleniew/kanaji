// tracing_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/viewmodels/drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_tracing_viewmodel.dart';
import 'package:kanaji/views/widgets/drawing_canvas.dart';
import 'package:kanaji/views/widgets/grid_canvas.dart';
import 'package:provider/provider.dart';

class TracingPage extends StatelessWidget {
  const TracingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ITracingViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tracing Page')),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GridCanvas(
                  character: vm.currentCharacter
                ),
                const DrawingCanvas(),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: () {
                final drawingVM = Provider.of<IDrawingCanvasViewModel>(context, listen: false);
                drawingVM.clear();
              }, child: Text('Clear')),
              ElevatedButton(onPressed: vm.previous, child: Text('Previous')),
              ElevatedButton(onPressed: vm.next, child: Text('Next')),
              ElevatedButton(onPressed: () {
                final drawingVM = Provider.of<IDrawingCanvasViewModel>(context, listen: false);
                vm.check(drawingVM.strokes);
              }, child: Text('Check')),
              ElevatedButton(onPressed: () {
                final drawingVM = Provider.of<IDrawingCanvasViewModel>(context, listen: false);
                vm.checkAI(drawingVM.strokes);
              }, child: Text('Check AI')),
              ElevatedButton(onPressed: vm.font, child: Text('Font')),
            ],
          )
        ],
      ),
    );
  }
}
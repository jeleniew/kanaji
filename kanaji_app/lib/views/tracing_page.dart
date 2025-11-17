// tracing_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/viewmodels/drawing_canvas_viewmodel.dart';
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
              ElevatedButton(onPressed: vm.clear, child: Text('Clear')),
              ElevatedButton(onPressed: vm.previous, child: Text('Previous')),
              ElevatedButton(onPressed: vm.next, child: Text('Next')),
              ElevatedButton(onPressed: () {
                final drawingVM = Provider.of<DrawingCanvasViewModel>(context);
                vm.check(drawingVM.points);
              }, child: Text('Check')),
              ElevatedButton(onPressed: () {
                final drawingVM = Provider.of<DrawingCanvasViewModel>(context);
                vm.checkAI(drawingVM.points);
              }, child: Text('Check AI')),
              ElevatedButton(onPressed: vm.font, child: Text('Font')),
            ],
          )
        ],
      ),
    );
  }
}
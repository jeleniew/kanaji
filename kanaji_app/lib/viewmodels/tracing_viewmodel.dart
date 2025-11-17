// tracing_viewmodel.dart
import 'package:flutter/widgets.dart';
import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_tracing_viewmodel.dart';

class TracingViewModel extends ITracingViewModel {
  @override
  String get currentCharacter => 'あ';
  
  @override
  void previous() {
    // Implementation for going to the previous character
  }

  @override
  void next() {
    // Implementation for going to the next character
  }

  @override
  void check(List<List<Offset?>> points) {
    // Implementation for checking the tracing accuracy
  }

  @override
  void checkAI(List<List<Offset?>> points) {
    // Implementation for AI-based checking of the tracing
  }

  @override
  void font() {
    // Implementation for changing the font style
  }
}
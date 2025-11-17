// tracing_viewmodel.dart
import 'package:flutter/widgets.dart';
import 'package:kanaji/viewmodels/interfaces/i_tracing_viewmodel.dart';

class TracingViewModel extends ITracingViewModel {
  @override
  String get currentCharacter => 'あ'; // Example character

  @override
  void clear() {
    // Implementation for clearing the tracing area
  }

  @override
  void previous() {
    // Implementation for going to the previous character
  }

  @override
  void next() {
    // Implementation for going to the next character
  }

  @override
  void check(List<Offset?> points) {
    // Implementation for checking the tracing accuracy
  }

  @override
  void checkAI(List<Offset?> points) {
    // Implementation for AI-based checking of the tracing
  }

  @override
  void font() {
    // Implementation for changing the font style
  }
}
// tracing_viewmodel.dart
import 'package:flutter/widgets.dart';
import 'package:kanaji/viewmodels/interfaces/i_tracing_viewmodel.dart';

class TracingViewModel extends ITracingViewModel {
  final List<String> _characters = ['あ', 'い', 'う', 'え', 'お'];
  final List<int> jisLabel = [9250, 9252, 9254, 9256, 9258];
  int _currentIndex = 0;
  bool _isKanjiOrderFont = true;

  @override
  String get currentCharacter => _characters[_currentIndex];

  @override
  String? get font => _isKanjiOrderFont ? 'KanjiStrokeOrder' : null;
  
  @override
  void previous() {
    _currentIndex = (_currentIndex - 1 + _characters.length) % _characters.length;
    notifyListeners();
  }

  @override
  void next() {
    _currentIndex = (_currentIndex + 1) % _characters.length;
    notifyListeners();
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
  void changeFont() {
    _isKanjiOrderFont = !_isKanjiOrderFont;
    notifyListeners();
  }
}
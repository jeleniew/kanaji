// tracing_viewmodel.dart
import 'package:flutter/widgets.dart';
import 'package:kanaji/services/character_repository.dart';
import 'package:kanaji/services/drawing_analyzer_service.dart';
import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_tracing_viewmodel.dart';

// TODO: move to a separate file
enum TracingResult {none, correct, incorrect}

class TracingViewModel extends ITracingViewModel {
  int _currentIndex = 0;
  bool _isKanjiOrderFont = true;
  late IDrawingCanvasViewModel _drawingCanvasViewModel;
  final CharacterRepository _characterRepository = CharacterRepository();
  TracingResult _tracingResult = TracingResult.none;

  @override
  void attachDrawingVM(IDrawingCanvasViewModel vm) {
    _drawingCanvasViewModel = vm;
  }

  @override
  String get currentCharacter => _characterRepository.getCharacterByIndex(_currentIndex).glyph;

  @override
  String? get font => _isKanjiOrderFont ? 'KanjiStrokeOrder' : null;

  @override
  TracingResult get tracingResult => _tracingResult;
  
  @override
  void previous() {
    // TODO: notifyListeners is invoked twice here
    clear();
    int charactersLength = _characterRepository.characters.length;
    _currentIndex = (_currentIndex - 1 + charactersLength) % charactersLength;
    notifyListeners();
  }

  @override
  void next() {
    clear();
    int charactersLength = _characterRepository.characters.length;
    _currentIndex = (_currentIndex + 1) % charactersLength;
    notifyListeners();
  }

  @override
  void check() {
    List<List<Offset>> expectedStrokes = _drawingCanvasViewModel.strokes;

    final character = _characterRepository.getCharacterByIndex(_currentIndex);
    final result =  DrawingAnalyzerService().compare(expectedStrokes, character);

    if (result) {
      _tracingResult = TracingResult.correct;
    } else {
      _tracingResult = TracingResult.incorrect;
    }
    notifyListeners();
  }

  @override
  void checkAI() {
    // Implementation for AI-based checking of the tracing
  }

  @override
  void changeFont() {
    _isKanjiOrderFont = !_isKanjiOrderFont;
    notifyListeners();
  }

  @override
  void clear() {
    _tracingResult = TracingResult.none;
    _drawingCanvasViewModel.clear();
    notifyListeners();
  }
}
import 'dart:ui';

import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';

class DrawingCanvasViewModel extends IDrawingCanvasViewModel {
  List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  // TODO: add smoothing lines

  @override
  List<List<Offset>> get strokes  {
    if (_currentStroke.isEmpty) {
      return _strokes;
    }
    return List.from(_strokes)..add(_currentStroke);
  }

  @override
  void addPoints(Offset localPosition) {
    _currentStroke = List.from(_currentStroke)..add(localPosition);
    notifyListeners();
  }

  @override
  void endStroke() {
    if (_currentStroke.isNotEmpty) {
      _strokes = List.from(_strokes)..add(_currentStroke);
      _currentStroke = [];
      notifyListeners();
    }
  }

  @override
  void clear() {
    _strokes = [];
    _currentStroke = [];
    notifyListeners();
  }
}
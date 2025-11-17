import 'dart:ui';

import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';

class DrawingCanvasViewModel extends IDrawingCanvasViewModel {
  List<Offset> _points = [];
  
  @override
  List<Offset?> get points => _points;

  @override
  void addPoints(Offset localPosition) {
    _points = List.from(_points)..add(localPosition);
    notifyListeners();
  }
}
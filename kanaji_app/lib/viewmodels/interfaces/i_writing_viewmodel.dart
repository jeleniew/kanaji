import 'package:flutter/material.dart';
import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/tracing_viewmodel.dart';

abstract class IWritingViewModel extends ChangeNotifier {
  void attachDrawingVM(IDrawingCanvasViewModel vm);
  String get currentCharacter;
  TracingResult get tracingResult;
  String get hint;
  void previous();
  void next();
  void check();
  void checkAI();
  void clear();
  void showHint();
}
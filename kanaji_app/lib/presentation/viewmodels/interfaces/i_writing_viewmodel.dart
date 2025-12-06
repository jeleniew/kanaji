import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/tracing_result.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';

abstract class IWritingViewModel extends ChangeNotifier {
  String get currentCharacter;
  String get currentMeaning;
  TracingResult get tracingResult;

  void attachDrawingVM(IDrawingCanvasViewModel vm);
  void clear();
  void check();
  void checkAI();
  void previous();
  void next();
  void showHint();
}
import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/result.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';

abstract class IWritingViewModel extends ChangeNotifier {
  Future<void> init();
  String get currentCharacter;
  String get currentMeaning;
  Result get tracingResult;

  void attachDrawingVM(IDrawingCanvasViewModel vm);
  void clear();
  void check();
  void checkAI();
  void previous();
  void next(BuildContext context);
  void showHint();
}
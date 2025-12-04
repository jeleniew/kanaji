import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/tracing_result.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';

abstract class ITracingViewModel extends ChangeNotifier {
  String get currentCharacter;
  String get currentMeaning;
  String? get font;
  TracingResult get tracingResult;
  ui.Image? get processedImage;
  void previous();
  void next();
  void check();
  void checkAI();
  void changeFont();
  void attachDrawingVM(IDrawingCanvasViewModel vm);
  void clear();
}
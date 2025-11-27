// i_drawing_analyzer_service.dart

import 'dart:ui';
import 'package:kanaji/domain/entities/character.dart';

abstract class IDrawingAnalyzerService {
  bool compare(List<List<Offset>> userStrokes, Character character);
}
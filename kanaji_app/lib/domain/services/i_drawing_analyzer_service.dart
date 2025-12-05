// i_drawing_analyzer_service.dart

import 'dart:ui';

abstract class IDrawingAnalyzerService {
  bool compare(List<List<Offset>> userStrokes, String svgPathData);
}
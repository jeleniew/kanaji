// i_drawing_analyzer_service.dart

import 'dart:ui';

abstract class IDrawingAnalyzerService {
  bool comapre2(List<List<Offset>> userStrokes, String svgPathData);
}
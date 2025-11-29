import 'dart:ui';
import 'package:svg_path_parser/svg_path_parser.dart';

class SvgParser {
  // TODO: probably move to some util package or move to drawing_analyzer_service.dart
  static const int _resamplePoints = 64;
  List<List<Offset>> svgPathToPoints(String svgPathData) {
    final Path path = parseSvgPath(svgPathData);
    final List<List<Offset>> points = [];

    for (final PathMetric metric in path.computeMetrics()) {
      double length = metric.length;
      List<Offset> strokePoints = [];
      for (int i = 0; i <= _resamplePoints; i++) {
        double distance = (i / (_resamplePoints - 1)) * length;
        final targent = metric.getTangentForOffset(distance);
        if (targent != null) {
          strokePoints.add(targent.position);
        }
      }
      points.add(strokePoints);
    }
    return points;
  }
}
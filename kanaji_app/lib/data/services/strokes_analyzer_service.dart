// drawing_analyzer_service.dart
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:xml/xml.dart';

// TODO: in 'ta' character 3rd and 4th storke was switched and still was correct
// TODO: 'chi' in incorect in my test

class StrokesAnalyzerService implements IDrawingAnalyzerService {
  static const double _threshold = 0.35;

  List<String> _extractPaths(String svgData) {
    final document = XmlDocument.parse(svgData);
    final paths = document.findAllElements('path');

    return paths
      .map((node) => node.getAttribute('d'))
      .where((d) => d != null && d.isNotEmpty)
      .cast<String>()
      .toList();
  }

  List<Offset> _resamplePathMetric(PathMetric metric, int sampleNumber) {
    double length = metric.length;
    List<Offset> strokePoints = [];

    for (int i = 0; i <= sampleNumber; i++) {
      double distance = (i / (sampleNumber - 1)) * length;
      final targent = metric.getTangentForOffset(distance);
      if (targent != null) strokePoints.add(targent.position);
    }
      
    return strokePoints;
  }

  @override
  bool compare(List<List<Offset>> userStrokes, String svgPathData) {
    final List<String> pathsDatas = _extractPaths(svgPathData);

    if (userStrokes.length != pathsDatas.length) {
      return false;
    }

    if (!_compareStrokes(userStrokes, svgPathData)) {
      return false;
    }

    return true;
  }

  bool _compareStrokes(List<List<Offset>> userStrokes, String svgPathData) {
    final normalizedUser = _normalize(userStrokes);
    final normalizedReference = _getNormalizedReferenceMetrics(svgPathData);

    for (int i = 0; i < normalizedUser.length; i++) {
      final userStroke = normalizedUser[i];
      final referenceMetric = normalizedReference[i];

      final userStrokeLength = _pathLength(userStroke);
      final referenceStrokeLength = referenceMetric.length;

      // TODO: tune threshold
      final lengthRatioThreshold = 0.75;

      if (userStrokeLength/referenceStrokeLength < (1 - lengthRatioThreshold) ||
          userStrokeLength/referenceStrokeLength > (1 + lengthRatioThreshold)) {
        print("Stroke $i length mismatch: ${userStrokeLength/referenceStrokeLength}");
        print("User stroke length: $userStrokeLength");
        print("Reference stroke length: $referenceStrokeLength");
        return false;
      }

      final int sampleNumber = (userStrokeLength > referenceStrokeLength ? userStrokeLength : referenceStrokeLength) ~/ 0.1;

      final sampledUserStroke = _resample(userStroke, sampleNumber);
      final sampledReferenceStroke = _resamplePathMetric(referenceMetric, sampleNumber);

      final strokeDistance = _pathDistance(sampledUserStroke, sampledReferenceStroke);

      if (strokeDistance > _threshold) {
        print("Stroke $i distance too high: $strokeDistance");
        return false;
      }
    }
    return true;
  }

  List<List<Offset>> _normalize(List<List<Offset>> strokes) {
    if (strokes.isEmpty) return strokes;

    List<Offset> allPoints = strokes.expand((stroke) => stroke).toList();

    double minX = allPoints.first.dx;
    double maxX = allPoints.first.dx;
    double minY = allPoints.first.dy;
    double maxY = allPoints.first.dy;

    for (final point in allPoints) {
      if (point.dx < minX) minX = point.dx;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dy > maxY) maxY = point.dy;
    }

    final width = maxX - minX;
    final height = maxY - minY;
    final scale = 1.0 / (width > height ? width : height);

    return strokes.map((stroke) {
      return stroke
          .map((point) => Offset(
                (point.dx - minX) * scale,
                (point.dy - minY) * scale,
              ))
          .toList();
    }).toList();
  }

  List<PathMetric> _getNormalizedReferenceMetrics(String svgPathData) {
    final paths = _extractPaths(svgPathData)
        .map(parseSvgPath)
        .toList();

    Rect? bounds;
    for (final p in paths) {
      bounds = bounds == null ? p.getBounds() : bounds.expandToInclude(p.getBounds());
    }

    final scale = 1.0 / max(bounds!.width, bounds.height);

    final matrix = Float64List.fromList([
      scale, 0,     0, 0,
      0,     scale, 0, 0,
      0,     0,     1, 0,
      -bounds.left * scale,
      -bounds.top  * scale,
      0,
      1,
    ]);

    final metrics = <PathMetric>[];
    for (final p in paths) {
      final normalized = p.transform(matrix);
      metrics.addAll(normalized.computeMetrics());
    }

    return metrics;
  }

  List<Offset> _resample(List<Offset> stroke, int n) {
    if (stroke.length < 2) return stroke;

    final totalLength = _pathLength(stroke);
    final interval = totalLength / (n - 1);
    final resampled = <Offset>[stroke.first];
    double D = 0.0;

    for (int i = 1; i < stroke.length; i++) {
      final prevPoint = stroke[i - 1];
      final currPoint = stroke[i];
      final d = (currPoint - prevPoint).distance;

      if ((D + d) >= interval) {
        final t = (interval - D) / d;
        final newX = prevPoint.dx + t * (currPoint.dx - prevPoint.dx);
        final newY = prevPoint.dy + t * (currPoint.dy - prevPoint.dy);
        final newPoint = Offset(newX, newY);
        resampled.add(newPoint);
        D = 0.0;
      } else {
        D += d;
      }
    }

    while (resampled.length < n) {
      resampled.add(stroke.last);
    }

    return resampled;
  }

  double _pathLength(List<Offset> stroke) {
    double length = 0.0;
    for (int i = 1; i < stroke.length; i++) {
      length += (stroke[i] - stroke[i - 1]).distance;
    }
    return length;
  }

  double _pathDistance(List<Offset> a, List<Offset> b) {
    double distance = 0.0;
    for (int i = 0; i < a.length; i++) {
      distance += (a[i] - b[i]).distance;
    }
    return distance / a.length;
  }
}
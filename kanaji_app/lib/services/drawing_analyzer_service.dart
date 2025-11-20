// drawing_analyzer_service.dart
import 'dart:ui';
import 'package:kanaji/models/character.dart';

class DrawingAnalyzerService {
  static const double _threshold = 0.35;
  // TODO: consider making this singleton
  bool compare(List<List<Offset>> userStrokes, Character character) {
    if (userStrokes.length != character.trajectory.length) {
      for (var stroke in userStrokes) {
        print("User stroke length: ${stroke.length}");
        print("Stroke: ${stroke}");
      }
      return false;
    }
    print("is fine");

    for (int i = 0; i < userStrokes.length; i++) {
      final userStroke = userStrokes[i];
      final referenceStroke = character.trajectory[i];

      if (!_compareStrokes(userStroke, referenceStroke)) {
        return false;
      }
    }
    return true;
  }

  bool _compareStrokes(List<Offset> userStroke, List<Offset> referenceStroke) {
    final normalizedUser = normalize(userStroke);
    final normalizedReference = normalize(referenceStroke);

    // TODO: how many samples?
    final sampledUser = _resample(normalizedUser, 64);
    final sampledReference = _resample(normalizedReference, 64);

    final distance = _pathDistance(sampledUser, sampledReference);

    return distance < _threshold;
  }

  List<Offset> normalize(List<Offset> stroke) {
    if (stroke.isEmpty) return stroke;

    double minX = stroke.first.dx;
    double maxX = stroke.first.dx;
    double minY = stroke.first.dy;
    double maxY = stroke.first.dy;

    for (final point in stroke) {
      if (point.dx < minX) minX = point.dx;
      if (point.dx > maxX) maxX = point.dx;
      if (point.dy < minY) minY = point.dy;
      if (point.dy > maxY) maxY = point.dy;
    }

    final width = maxX - minX;
    final height = maxY - minY;
    final scale = 1.0 / (width > height ? width : height);

    return stroke
        .map((point) => Offset(
              (point.dx - minX) * scale,
              (point.dy - minY) * scale,
            ))
        .toList();
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
        stroke.insert(i, newPoint);
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
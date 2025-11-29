// image_processing.dart
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:kanaji/domain/services/i_image_processing_service.dart';


class ImageProcessingService implements IImageProcessingService {
  
  @override
  Future<Image> convertPointsToImage(List<List<Offset?>> strokes, Size canvasSize) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height));
    
    final backgroundPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true;

    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), backgroundPaint);
    canvas.save();

    final preprocessedStrokes = preprocessStrokes(strokes.cast<List<Offset>>());

    for (var stroke in preprocessedStrokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i+1], strokePaint);
      }
    }

    canvas.restore();

    final picture = recorder.endRecording();
    final imgImage = await picture.toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt()
    );
    return imgImage;
  }

  @override
  Future<Float32List> processImage(ByteData inputImage) {
    final Uint8List imgBytes = inputImage.buffer.asUint8List();

    final img.Image? decoded = img.decodeImage(imgBytes);
    if (decoded == null) {
      print("Błąd: nie udało się zdekodować obrazu.");
      throw Exception("Nie można zdekodować obrazu.");
    }

    img.Image image = decoded;

    image = _cleanImageBackground(image);
    image = _cutCenterAndScale(image, addMargin: true);
    image = _smoothEdges(image, kernelSize: 3);
    image = _cutCenterAndScale(image, addMargin: true);
    image = _convertToBinaryImage(image, threshold: 64);
    // TODO: or just cutCenterAndScale 

    Float32List floatInput = _imageToFloat32List(image);

    return Future.value(floatInput);
  }

  Float32List _imageToFloat32List(img.Image image) {
    final floatList = Float32List(127 * 128);
    int index = 0;
    for (int y = 0; y < 127; y++) {
      for (int x = 0; x < 128; x++) {
        final gray = img.getLuminance(image.getPixel(x, y)).toDouble() / 255.0; // normalize [0,1]
        floatList[index++] = gray;
      }
    }
    return floatList;
  }

  List<List<Offset>> preprocessStrokes(List<List<Offset>> strokes) {
    // TODO: this is necessary to work, try to reduce code - it is done twice -> here and in cutCenterAndScale
    if (strokes.isEmpty || strokes.every((stroke) => stroke.isEmpty)) {
      return strokes;
    }

    double minX = strokes
        .expand((stroke) => stroke)
        .map((p) => p.dx)
        .reduce(min);
    double maxX = strokes
        .expand((stroke) => stroke)
        .map((p) => p.dx)
        .reduce(max);
    double minY = strokes
        .expand((stroke) => stroke)
        .map((p) => p.dy)
        .reduce(min);
    double maxY = strokes
        .expand((stroke) => stroke)
        .map((p) => p.dy)
        .reduce(max);

    double width = maxX - minX;
    double height = maxY - minY;

    if (width == 0 || height == 0) {
      return strokes;
    }

    const targetAspectRatio = 128 / 127;
    final aspectRatio = width / height;

    double newMinX = minX;
    double newMaxX = maxX;
    double newMinY = minY;
    double newMaxY = maxY;

    if (aspectRatio > targetAspectRatio) {
      final newH = width / targetAspectRatio;
      final diff = newH - height;
      newMinY -= diff / 2;
      newMaxY += diff / 2;
    } else if (aspectRatio < targetAspectRatio) {
      final newW = height * targetAspectRatio;
      final diff = newW - width;
      newMinX -= diff / 2;
      newMaxX += diff / 2;
    }

    const marginRatio = 0.1;
    final scaledStrokes = strokes.map((stroke) {
      return stroke.map((p) {
        final normX = (p.dx - newMinX) / (newMaxX - newMinX);
        final normY = (p.dy - newMinY) / (newMaxY - newMinY);
        final dx = (normX * (1 - 2 * marginRatio)) + marginRatio;
        final dy = (normY * (1 - 2 * marginRatio)) + marginRatio;
        return Offset(dx * 128, dy * 127);
      }).toList();
    }).toList();
    
    return scaledStrokes;
  }


  /// Removes unwanted objects that touch the edges of the image using BFS.
  img.Image _cleanImageBackground(img.Image input) {
    // TODO: consider removing small objects inside the image
    final output = img.Image.from(input);
    final visited =
        List.generate(output.height, (_) => List.filled(output.width, false));

    void bfs(int startX, int startY) {
      final queue = <Point<int>>[];
      queue.add(Point(startX, startY));

      while (queue.isNotEmpty) {
        final point = queue.removeAt(0);
        final x = point.x;
        final y = point.y;

        if (visited[y][x]) continue;
        visited[y][x] = true;

        final pixel = img.getLuminance(output.getPixel(x, y));
        if (pixel < 255) {
          output.setPixelRgba(x, y, 255, 255, 255, 255);
          for (final dir in [
            const Point(-1, 0),
            const Point(1, 0),
            const Point(0, -1),
            const Point(0, 1),
          ]) {
            final nx = x + dir.x;
            final ny = y + dir.y;
            if (nx >= 0 &&
                nx < output.width &&
                ny >= 0 &&
                ny < output.height &&
                !visited[ny][nx]) {
              queue.add(Point(nx, ny));
            }
          }
        }
      }
    }

    for (int i = 0; i < output.height; i++) {
      if (!visited[i][0]) bfs(0, i);
      if (!visited[i][output.width - 1]) bfs(output.width - 1, i);
    }
    for (int i = 0; i < output.width; i++) {
      if (!visited[0][i]) bfs(i, 0);
      if (!visited[output.height - 1][i]) bfs(i, output.height - 1);
    }

    return output;
  }

  /// Cuts the center of the image and scales it to 127x128.
  img.Image _cutCenterAndScale(img.Image input, {bool addMargin = false}) {
    final maskCoords = <Point<int>>[];

    for (int y = 0; y < input.height; y++) {
      for (int x = 0; x < input.width; x++) {
        final pixel = img.getLuminance(input.getPixel(x, y));
        if (pixel < 223) maskCoords.add(Point(x, y));
      }
    }

    if (maskCoords.isEmpty) return input;

    final xs = maskCoords.map((p) => p.x);
    final ys = maskCoords.map((p) => p.y);

    final x0 = xs.reduce(min);
    final x1 = xs.reduce(max) + 1;
    final y0 = ys.reduce(min);
    final y1 = ys.reduce(max) + 1;

    img.Image cropped = img.copyCrop(input, x: x0, y: y0, width: x1 - x0, height: y1 - y0);

    if (addMargin) {
      cropped = _addWhiteMargin(cropped, 2);
    }

    final scale = min(127 / cropped.height, 128 / cropped.width);
    final newW = (cropped.width * scale).toInt();
    final newH = (cropped.height * scale).toInt();

    final resized = img.copyResize(cropped, width: newW, height: newH);
    final canvas = img.Image(width: 128, height: 127);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));

    final xOffset = ((128 - newW) / 2).floor();
    final yOffset = ((127 - newH) / 2).floor();

    img.compositeImage(canvas, resized, dstX: xOffset, dstY: yOffset);

    return canvas;
  }

  /// Adds a black border (replacement for copyExpand).
  img.Image _addWhiteMargin(img.Image input, int margin) {
    final newW = input.width + 2 * margin;
    final newH = input.height + 2 * margin;
    final canvas = img.Image(width: newW, height: newH);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255)); // white background
    img.compositeImage(canvas, input, dstX: margin, dstY: margin);
    return canvas;
  }

  /// Converts grayscale to binary (black and white).
  img.Image _convertToBinaryImage(img.Image input, {int threshold = 207}) {
    final output = img.Image.from(input);
    for (int y = 0; y < output.height; y++) {
      for (int x = 0; x < output.width; x++) {
        final gray = img.getLuminance(output.getPixel(x, y));
        final val = gray < threshold ? 0 : 255;
        output.setPixelRgba(x, y, val, val, val, 255);
      }
    }
    return output;
  }

  /// Smooths edges with Gaussian blur.
  img.Image _smoothEdges(img.Image input, {int kernelSize = 5}) {
    return img.gaussianBlur(input, radius: kernelSize);
  }


  Future<Image> convertToUIImage(img.Image image) async {
    final pngBytes = Uint8List.fromList(img.encodePng(image));
    final codec = await instantiateImageCodec(pngBytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }


  Future<Image> float32ListToImage(Float32List input, int width, int height) async {
    final pixels = Uint8List(width * height * 4);

    for (int i = 0; i < width * height; i++) {
      final value = (input[i] * 255).clamp(0, 255).toInt(); // skala [0,255]
      // ustawiamy grayscale jako RGBA
      pixels[i * 4] = value;     // R
      pixels[i * 4 + 1] = value; // G
      pixels[i * 4 + 2] = value; // B
      pixels[i * 4 + 3] = 255;   // A
    }

    final completer = Completer<Image>();
    decodeImageFromPixels(
      pixels,
      width,
      height,
      PixelFormat.rgba8888,
      (img) => completer.complete(img),
    );

    return completer.future;
  }
}

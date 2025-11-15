// image_processing.dart

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'dart:math';
import 'package:image/image.dart' as img;


Future<(img.Image, Float32List)> processImage(ByteData inputImage) async {
  final Uint8List imgBytes = inputImage.buffer.asUint8List();

  final img.Image? decoded = img.decodeImage(imgBytes);
  if (decoded == null) {
    print("Błąd: nie udało się zdekodować obrazu.");
    throw Exception("Nie można zdekodować obrazu.");
  }

  img.Image image = decoded;

  image = cleanImageBackground(image);
  image = cutCenterAndScale(image, addMargin: true);
  image = smoothEdges(image, kernelSize: 3);
  image = cutCenterAndScale(image, addMargin: true);
  image = convertToBinaryImage(image, threshold: 64);
  // TODO: or just cutCenterAndScale 

  Float32List floatInput = _imageToFloat32List(image);

  return Future.value((image, floatInput));
}


/// Removes unwanted objects that touch the edges of the image using BFS.
img.Image cleanImageBackground(img.Image input) {
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
img.Image cutCenterAndScale(img.Image input, {bool addMargin = false}) {
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
    cropped = addWhiteMargin(cropped, 2);
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
img.Image addWhiteMargin(img.Image input, int margin) {
  final newW = input.width + 2 * margin;
  final newH = input.height + 2 * margin;
  final canvas = img.Image(width: newW, height: newH);
  img.fill(canvas, color: img.ColorRgb8(255, 255, 255)); // white background
  img.compositeImage(canvas, input, dstX: margin, dstY: margin);
  return canvas;
}

/// Converts grayscale to binary (black and white).
img.Image convertToBinaryImage(img.Image input, {int threshold = 207}) {
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
img.Image smoothEdges(img.Image input, {int kernelSize = 5}) {
  return img.gaussianBlur(input, radius: kernelSize);
}


Future<ui.Image> convertToUIImage(img.Image image) async {
  final pngBytes = Uint8List.fromList(img.encodePng(image));
  final codec = await ui.instantiateImageCodec(pngBytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Float32List _imageToFloat32List(img.Image image) {
  final floatList = Float32List(127 * 128);
  int index = 0;
  for (int y = 0; y < 127; y++) {
    for (int x = 0; x < 128; x++) {
      final gray = img.getLuminance(image.getPixel(x, y)).toDouble() / 255.0; // normalizacja [0,1]
      floatList[index++] = gray;
    }
  }
  return floatList;
}

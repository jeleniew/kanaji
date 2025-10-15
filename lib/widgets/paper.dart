import 'dart:math';

import 'package:flutter/material.dart';
import 'paper_decorator.dart';
import 'finger_pen.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class Paper extends StatefulWidget {
  final bool showGrid;
  final bool showSymbol;
  final String backgroundSymbol;

  const Paper({
    super.key,
    this.showGrid = true,
    this.showSymbol = false,
    required this.backgroundSymbol,
  });

  @override
  PaperState createState() => PaperState();
}

class PaperState extends State<Paper> {
  List<Offset?> points = [];
  String? backgroundSymbol;
  bool _useStrokeOrderFont = false;
  late PaperDecorator decorator;
  late Size drawingAreaSize;

  @override
  void initState() {
    super.initState();
    backgroundSymbol = widget.backgroundSymbol;
    decorator = PaperDecorator(
      showGrid: widget.showGrid,
      showSymbol: widget.showSymbol,
      backgroundSymbol: backgroundSymbol,
      useStrokeOrderFont: _useStrokeOrderFont,
    );
  }

  void changeBackgroundSymbol(String? newSymbol) {
    setState(() {
      backgroundSymbol = newSymbol;
    });
  }

  void toggleFont() {
    setState(() {
      _useStrokeOrderFont = !_useStrokeOrderFont;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            drawingAreaSize = Size(constraints.maxWidth, constraints.maxHeight);
            final drawingArea = decorator.getDrawingArea(drawingAreaSize);
            if (drawingArea.contains(details.localPosition)) {
              setState(() {
                points.add(details.localPosition);
              });
            }
          },
          onPanEnd: (details) => setState(() => points.add(null)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 255, 221, 233),
            child: Stack(
              children:[
                CustomPaint(
                  size: Size.infinite,
                  painter: decorator,
                ),
                CustomPaint(
                  painter: FingerPen(points),
                ),
              ]
            )
          )
        );
      },
    );
  }

  void clear() {
    setState(() {
      points.clear();
    });
  }

  Future<List<List<Offset>>> prepreparePoints(List<Offset?> points) async {
    /// [memory_practice_page.dart -> _saveDrawing()]
    
    const targetWidth = 127.0;
    const targetHeight = 128.0;

    // Utworzenie listy kresek
    List<List<Offset>> strokes = [];
    List<Offset> current = [];

    for (final p in points) {
      if (p == null) {
        if (current.isNotEmpty) {
          strokes.add(current);
          current = [];
        }
      } else {
        current.add(p);
      }
    }
    if (current.isNotEmpty) strokes.add(current);
    // Zbierz wszystkie punkty do normalizacji
    final validPoints = strokes.expand((stroke) => stroke);

    // Znajdź minimalne i maksymalne współrzędne (bounding box)
    final minX = validPoints.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
    final maxX = validPoints.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
    final minY = validPoints.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
    final maxY = validPoints.map((p) => p.dy).reduce((a, b) => a > b ? a : b);

    // Oblicz szerokość i wysokość
    final width = maxX - minX;
    final height = maxY - minY;
    if (width == 0 || height == 0) return strokes;

    // Ustal docelowe proporcje (128x127)
    const targetAspect = 128 / 127;
    final aspect = width / height;

    double newMinX = minX;
    double newMaxX = maxX;
    double newMinY = minY;
    double newMaxY = maxY;

    if (aspect > targetAspect) {
      // za szeroki — zwiększ wysokość
      final newH = width / targetAspect;
      final diff = newH - height;
      newMinY -= diff / 2;
      newMaxY += diff / 2;
    } else if (aspect < targetAspect) {
      // za wysoki — zwiększ szerokość
      final newW = height * targetAspect;
      final diff = newW - width;
      newMinX -= diff / 2;
      newMaxX += diff / 2;
    }

    // Przeskalowanie punktów do zakresu 0–1
    const marginRatio = 0.1; // 10% marginesu
    final scaledPoints = strokes.map((stroke) {
      return stroke.map((p) {
        final normX = (p.dx - newMinX) / (newMaxX - newMinX);
        final normY = (p.dy - newMinY) / (newMaxY - newMinY);
        final dx = (normX * (1 - 2 * marginRatio)) + marginRatio;
        final dy = (normY * (1 - 2 * marginRatio)) + marginRatio;
        return Offset(dx * targetWidth, dy * targetHeight);
      }).toList();
    }).toList();

    return scaledPoints;
  }



  Future<ui.Image> exportToImage(List<Offset?> points) async {
    const targetWidth = 127.0;
    const targetHeight = 128.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, targetWidth, targetHeight));

    // Wypełnij tło białym kolorem
    canvas.drawRect(Rect.fromLTWH(0, 0, targetWidth, targetHeight),
        Paint()..color = const Color(0xFFFFFFFF));

    // Oblicz skalowanie
    final scaleX = targetWidth / drawingAreaSize.width;
    final scaleY = targetHeight / drawingAreaSize.height;

    // Zastosuj skalowanie do canvas - alternatywnei można skalować w preprocessing
    canvas.save();
    // canvas.scale(scaleX, scaleY);

    // Preprocessing/preparing
    final processedPoints = await prepreparePoints(points);

    // Narysuj rysunek w oryginalnych współrzędnych
    final newDrawingAreaSize = Size(targetWidth, targetHeight);
    for (final stroke in processedPoints){
      FingerPen(stroke).paint(canvas, newDrawingAreaSize);
    }

    canvas.restore();

    final picture = recorder.endRecording();
    return picture.toImage(targetWidth.toInt(), targetHeight.toInt());
  }


  // Future<Float32List> imageToByteList(ui.Image img) async {
  //   final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
  //   final buffer = byteData!.buffer.asUint8List();

  //   final input = Float32List(127 * 128);
  //   for (int i = 0; i < 127 * 128; i++) {
  //     final r = buffer[i * 4];
  //     final g = buffer[i * 4 + 1];
  //     final b = buffer[i * 4 + 2];
  //     final gray = ((r + g + b) / 3);
  //     final inverted = gray;//255 - gray;
  //     input[i] = inverted / 255.0; // [0,1] zamiast 0–15
  //   }
  //   return input;
  // }

  Future<ui.Image> scaleImage(ui.Image img, int targetW, int targetH) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(0, 0, targetW.toDouble(), targetH.toDouble()),
    );

    // Tło białe
    final paint = ui.Paint()..color = const ui.Color(0xFFFFFFFF);
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, targetW.toDouble(), targetH.toDouble()), paint);

    // Rysuj i przeskaluj cały obraz
    final src = ui.Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    final dst = ui.Rect.fromLTWH(0, 0, targetW.toDouble(), targetH.toDouble());
    canvas.drawImageRect(img, src, dst, ui.Paint());

    final picture = recorder.endRecording();
    return await picture.toImage(targetW, targetH);
  }

  /// Konwertuje obraz do Float32List 0–1 (czarno-biały)
  Future<Float32List> imageToBinaryBW(ui.Image img) async {
    final w = img.width;
    final h = img.height;
    final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) throw Exception("Nie można pobrać byteData z obrazu");

    final buffer = byteData.buffer.asUint8List();
    final result = Float32List(w * h);

    for (int i = 0; i < w * h; i++) {
      final r = buffer[i * 4];
      final g = buffer[i * 4 + 1];
      final b = buffer[i * 4 + 2];
      final gray = (r + g + b) / 3.0;

      // final inverted = 255.0 - gray;

      // Normalizacja 0–1
      final normalized = gray / 255.0;

      // TODO: sprawdzić czy konwertowanie ze skali szarości na czarno-biały obraz ma sens
      result[i] = normalized;// < 0.8 ? 0.0 : 1.0;
    }

    return result;
  }

  Future<Float32List> cropAndAddMargin(
    Float32List img,
    int width,
    int height, {
    int margin = 2,
    double targetAspect = 128 / 127,
  }) async {
    // Zakładamy, że img to flattenowana tablica [height * width]
    // i wartości są w zakresie 0–1

    // Zbuduj maskę binarną (piksele "litery" > 0.2)
    List<int> ys = [];
    List<int> xs = [];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final idx = y * width + x;
        if (img[idx] < 0.8) {
          ys.add(y);
          xs.add(x);
        }
      }
    }

    // Jeśli nic nie znaleziono — zwróć pusty obraz
    if (xs.isEmpty || ys.isEmpty) {
      print("Brak litery w obrazie (pusta maska)");
      return Float32List(width * height);
    }

    // Wyznacz bounding box
    int y0 = ys.reduce(min);
    int y1 = ys.reduce(max) + 1;
    int x0 = xs.reduce(min);
    int x1 = xs.reduce(max) + 1;
    print("box: $y0 $y1, $x0 $x1");

    // Dodaj margines
    y0 = max(0, y0 - margin);
    x0 = max(0, x0 - margin);
    y1 = min(height, y1 + margin);
    x1 = min(width, x1 + margin);

    int cropH = y1 - y0;
    int cropW = x1 - x0;

    // Zachowaj proporcje
    double aspect = cropW / cropH;
    if (aspect > targetAspect) {
      // obraz zbyt szeroki -> zwiększ wysokość
      int newH = (cropW / targetAspect).round();
      int diff = newH - cropH;
      y0 = max(0, y0 - diff ~/ 2);
      y1 = min(height, y1 + diff - diff ~/ 2);
    } else if (aspect < targetAspect) {
      // obraz zbyt wysoki -> zwiększ szerokość
      int newW = (cropH * targetAspect).round();
      int diff = newW - cropW;
      x0 = max(0, x0 - diff ~/ 2);
      x1 = min(width, x1 + diff - diff ~/ 2);
    }

    // Przygotuj wycięty fragment (zachowując porządek row-major)
    int newH = y1 - y0;
    int newW = x1 - x0;
    final cropped = Float32List(newW * newH);

    for (int y = 0; y < newH; y++) {
      for (int x = 0; x < newW; x++) {
        final srcY = y0 + y;
        final srcX = x0 + x;
        if (srcY < height && srcX < width) {
          cropped[y * newW + x] = img[srcY * width + srcX];
        }
      }
    }

    print("Przycięto: ($x0,$y0) -> ($x1,$y1), nowy rozmiar: $newW×$newH");

    
    // Skalowanie bilinear do oryginalnych wymiarów
    final scaled = Float32List(width * height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // współrzędne w przyciętym obrazie
        double srcX = x * (newW - 1) / (width - 1);
        double srcY = y * (newH - 1) / (height - 1);

        int x0f = srcX.floor();
        int y0f = srcY.floor();
        int x1f = min(x0f + 1, newW - 1);
        int y1f = min(y0f + 1, newH - 1);

        double dx = srcX - x0f;
        double dy = srcY - y0f;

        double top = cropped[y0f * newW + x0f] * (1 - dx) + cropped[y0f * newW + x1f] * dx;
        double bottom = cropped[y1f * newW + x0f] * (1 - dx) + cropped[y1f * newW + x1f] * dx;
        double value = top * (1 - dy) + bottom * dy;

        scaled[y * width + x] = value;
      }
    }

    return scaled;
  }

  /// Główna funkcja do przygotowania obrazu dla modelu
  Future<Float32List> imageToByteList(ui.Image img) async {
    final scaled = await scaleImage(img, 127, 128);
    final bw = await cropAndAddMargin(await imageToBinaryBW(scaled), 127, 128);
    return bw;
  }


}
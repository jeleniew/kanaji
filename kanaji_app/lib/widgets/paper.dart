import 'package:flutter/material.dart';
import 'paper_decorator.dart';
import 'finger_pen.dart';
import 'dart:ui' as ui;


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
            // drawingAreaSize = Size(constraints.maxWidth, constraints.maxHeight);
            // final drawingArea = decorator.getDrawingArea(drawingAreaSize);
            // if (drawingArea.contains(details.localPosition)) {
              setState(() {
                points.add(details.localPosition);
              });
            // }
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
    
    const targetWidth = 128.0;
    const targetHeight = 127.0;

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
      // za szeroki - zwiększ wysokość
      final newH = width / targetAspect;
      final diff = newH - height;
      newMinY -= diff / 2;
      newMaxY += diff / 2;
    } else if (aspect < targetAspect) {
      // za wysoki - zwiększ szerokość
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
    const targetWidth = 128.0;
    const targetHeight = 127.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, targetWidth, targetHeight));

    // TODO: choose best best method to set white background
    // canvas.drawRect(Rect.fromLTWH(0, 0, targetWidth, targetHeight),
    //     Paint()..color = const Color.fromARGB(255, 255, 255, 255));
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    // canvas.drawPaint(paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, targetWidth, targetHeight), paint);

    // Oblicz skalowanie
    // final scaleX = targetWidth / drawingAreaSize.width;
    // final scaleY = targetHeight / drawingAreaSize.height;

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
}
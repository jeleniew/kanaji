// memory_practice_page.dart

import 'dart:async';
// import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanaji/services/model_service.dart';
import 'package:kanaji/symbols.dart';
import 'package:kanaji/widgets/paper.dart';
import 'package:image/image.dart' as img;
import '../services/image_processing.dart';

class MemoryPracticePage extends StatefulWidget {
  const MemoryPracticePage({super.key});

  @override
  State<MemoryPracticePage> createState() => _MemoryPracticePageState();
}

class _MemoryPracticePageState extends State<MemoryPracticePage> {
  final GlobalKey<PaperState> paperKey = GlobalKey<PaperState>();

  /// reference: [lib/pages/second_page.dart -> _compareDrawing()]
  void _compareDrawing() {
    final points = paperKey.currentState?.points ?? [];

    List<List<Offset>> userStrokes = [];
    List<Offset> currentStroke = [];
    for (final p in points) {
      if (p == null) {
        if (currentStroke.isNotEmpty) {
          userStrokes.add(currentStroke);
          currentStroke = [];
        }
      } else {
        currentStroke.add(p);
      }
    }

    if (currentStroke.isNotEmpty) {
      userStrokes.add(currentStroke);
    }

    // Pobierz referencję symbolu 'あ' (zakładam, że masz mapę symboli)
    final SymbolTrajectory? reference = symbolDB.firstWhere(
      (element) => element.symbol == paperKey.currentState?.backgroundSymbol,
      // orElse () => null,
    ); // dostosuj nazwę i mapę

    if (reference == null) {
      print("Brak trajektorii dla symbolu");
      return;
    }

    bool result = compareSymbol(userStrokes, reference, threshold: 0.35);

    final snackBar = SnackBar(
      content: Text(result ? 'Correct!' : 'Incorrect'),
      backgroundColor: result ? Colors.green : Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _clearPaper() {
    paperKey.currentState?.clear();
  }

  final List<String> hiraganaSymbols = ['あ','い', 'う', 'え', 'お'];//, 'か'];
  final List<int> jisLabel = [9250, 9252, 9254, 9256, 9258];

  void _changeSymbol() {
    final paperState = paperKey.currentState;
    if (paperState == null) {
      print("null");
      return;
    }

    final currentSymbol = paperState.backgroundSymbol ?? '';
    int currentIndex = hiraganaSymbols.indexOf(currentSymbol);

    if (currentIndex == -1) {
      // Jeśli aktualny symbol nie jest w liście, zacznij od pierwszego
      paperState.changeBackgroundSymbol(hiraganaSymbols[0]);
      print("Set to ${hiraganaSymbols[0]}");
    } else {
      // Przełącz na następny, wracając na początek, jeśli na końcu listy
      int nextIndex = (currentIndex + 1) % hiraganaSymbols.length;
      paperState.changeBackgroundSymbol(hiraganaSymbols[nextIndex]);
      print("Changed to ${hiraganaSymbols[nextIndex]}");
    }
  }

  void _bringBackSymbol() {
    final paperState = paperKey.currentState;
    if (paperState == null) {
      print("null");
      return;
    }

    final currentSymbol = paperState.backgroundSymbol ?? '';
    int currentIndex = hiraganaSymbols.indexOf(currentSymbol);

    if (currentIndex == -1) {
      // Jeśli aktualny symbol nie jest w liście, zacznij od pierwszego
      paperState.changeBackgroundSymbol(hiraganaSymbols[0]);
      print("Set to ${hiraganaSymbols[0]}");
    } else {
      // Przełącz na następny, wracając na początek, jeśli na końcu listy
      int nextIndex = (hiraganaSymbols.length + currentIndex - 1) % hiraganaSymbols.length;
      paperState.changeBackgroundSymbol(hiraganaSymbols[nextIndex]);
      print("Changed to ${hiraganaSymbols[nextIndex]}");
    }
  }


  void _saveDrawing() {
    final points = paperKey.currentState?.points ?? [];
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
    final allPoints = strokes.expand((stroke) => stroke);
    final minX = allPoints.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
    final maxX = allPoints.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
    final minY = allPoints.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
    final maxY = allPoints.map((p) => p.dy).reduce((a, b) => a > b ? a : b);

    final width = maxX - minX;
    final height = maxY - minY;

    // Normalizuj punkty
    final normalizedStrokes = strokes
        .map((stroke) => stroke.map((p) {
              final normX = (p.dx - minX) / (width == 0 ? 1 : width);
              final normY = (p.dy - minY) / (height == 0 ? 1 : height);
              return [normX, normY];
            }).toList())
        .toList();

    for (var stroke in normalizedStrokes) {
      int step = (stroke.length ~/ 20);
      if (step == 0) step = 1;

      List<List<double>> chunk = [];

      for (int i = 0; i < stroke.length && chunk.length < 20; i += step) {
        chunk.add(stroke[i]);
      }

      final result = chunk.map((o) => 'Offset(${o[0]},${o[1]})').join(',');
    }
  }

  ui.Image? previewImage;

  Future<Float32List> loadAssetAsModelInput({
    required String assetPath,
    int targetW = 127,
    int targetH = 128,
  }) async {
    // wczytaj plik binarnie
    final bytes = await rootBundle.load(assetPath);
    final Uint8List imgBytes = bytes.buffer.asUint8List();

    // decode do ui.Image
    final ui.Image decoded = await decodeImageFromList(imgBytes);

    // stwórz nowy obraz o docelowym rozmiarze i narysuj tam decoded (skalowanie zachowa orientację)
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, targetW.toDouble(), targetH.toDouble()));

    // białe tło (jeśli chcesz czarne, zmień kolor)
    final paint = ui.Paint()..color = const ui.Color(0xFFFFFFFF);
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, targetW.toDouble(), targetH.toDouble()), paint);

    // drawImageRect: narysuj cały decoded do całego docelowego rect (skalowanie)
    final src = ui.Rect.fromLTWH(0, 0, decoded.width.toDouble(), decoded.height.toDouble());
    final dst = ui.Rect.fromLTWH(0, 0, targetW.toDouble(), targetH.toDouble());
    canvas.drawImageRect(decoded, src, dst, ui.Paint());

    final picture = recorder.endRecording();
    final ui.Image resized = await picture.toImage(targetW, targetH);

    // konwersja do Float32List z funkcji niżej (dynamicznie wykorzystuje rozmiar obrazu)
    final input = await imageToFloat32List(resized);
    return input;
  }

  // Konwertuje ui.Image (dowolny rozmiar) -> Float32List (row-major), wartości 0..1
  Future<Float32List> imageToFloat32List(ui.Image img) async {
    final w = img.width;
    final h = img.height;

    final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) throw Exception("Nie można pobrać byteData z obrazu");

    final buffer = byteData.buffer.asUint8List();
    final result = Float32List(w * h);

    // iterujemy po pikselach w porządku row-major
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        final int idx = (y * w + x);
        final int byteIndex = idx * 4;
        final int r = buffer[byteIndex];
        final int g = buffer[byteIndex + 1];
        final int b = buffer[byteIndex + 2];
        // jeśli potrzebujesz grayscale:
        final double gray = (r + g + b) / 3.0;
        // optional: invert if your model expects inverted colors:
        // final double inverted = 255.0 - gray; // usuń / zmień jeśli nie trzeba inwersji
        result[idx] = gray / 255.0; // scala do [0,1]
      }
    }
    return result;
  }

  void _checkAI() async {
    final paperState = paperKey.currentState;
    if (paperState == null) {
      print("Brak PaperState");
      return;
    }

    final points = paperState.points;
    if (points.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Narysuj coś najpierw!")),
      );
      return;
    }

    try {
      final image = await paperState.exportToImage(points);

      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        print("Nie można uzyskać ByteData z obrazu");
        return;
      }
      final Float32List input = await processImage(byteData);

      final models = ModelService().allModels;
      final predictedSymbols = [];
      for (final m in models) {
        final predictedIdx = await m.predict(input);
        final predictedSymbol = hiraganaSymbols[predictedIdx % hiraganaSymbols.length];
        
        print("przewidziano: $predictedSymbol");
        predictedSymbols.add(predictedSymbol);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("AI rozpoznało: $predictedSymbols"),
          backgroundColor: Colors.blue,
        ),
      );

      final preview = await float32ListToImage(input, 128, 127);

      setState(() {
        previewImage = preview;
      });

    } catch (e, st) {
      print("Błąd AI: $e\n$st");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wystąpił błąd podczas predykcji")),
      );
    }
  }

  
  void _checkAITestImage() async {
    try {
      final jis = jisLabel[hiraganaSymbols.indexOf(paperKey.currentState?.backgroundSymbol ?? 'あ')];
      final bytes = await rootBundle.load('assets/icons/test_$jis.png');
      final (img.Image processed, Float32List input) = await processImage(bytes);

      final ui.Image preview = await convertToUIImage(processed);

      setState(() {
        previewImage = preview;
      });

      final models = ModelService().allModels;
      final predictedSymbols = [];
      for (final m in models) {
        final predictedIdx = await m.predict(input);
        final predictedSymbol = hiraganaSymbols[predictedIdx % hiraganaSymbols.length];
        
        print("przewidziano: $predictedSymbol");
        predictedSymbols.add(predictedSymbol);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("AI rozpoznało: $predictedSymbols"),
          backgroundColor: Colors.blue,
        ),
      );

    } catch (e) {
      print("Błąd podczas testowania modelu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Błąd: $e")),
      );
    }
  }



  Future<ui.Image> float32ListToImage(Float32List input, int width, int height) async {
    final pixels = Uint8List(width * height * 4);

    for (int i = 0; i < width * height; i++) {
      final value = (input[i] * 255).clamp(0, 255).toInt(); // skala [0,255]
      // ustawiamy grayscale jako RGBA
      pixels[i * 4] = value;     // R
      pixels[i * 4 + 1] = value; // G
      pixels[i * 4 + 2] = value; // B
      pixels[i * 4 + 3] = 255;   // A
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (img) => completer.complete(img),
    );

    return completer.future;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Porównanie symbolu')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("a"),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Paper(
                    key: paperKey,
                    showGrid: true,
                    showSymbol: false,
                    backgroundSymbol: 'あ',
                  )
                )
              ),
            ),
            if (kDebugMode && previewImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    const Text("Podgląd dla modelu (128x127)"),
                    Container(
                      width: 128,
                      height: 127,
                      color: Colors.red,
                      child: RawImage(image: previewImage),
                    ),
                  ],
                ),
              ),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ElevatedButton(
                  onPressed: _clearPaper,
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: _compareDrawing,
                  child: const Text('Check'),
                ),
                ElevatedButton(
                  onPressed: _checkAI,
                  // onPressed: _checkAITestImage,
                  child: const Text('Check AI'),
                ),
                // ElevatedButton(onPressed: _saveDrawing, child: const Text('Save')),
                ElevatedButton(onPressed: _bringBackSymbol, child: const Text('Previous')),
                ElevatedButton(onPressed: _changeSymbol, child: const Text('Next')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

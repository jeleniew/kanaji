// memory_practice_page.dart

import 'package:flutter/material.dart';
import 'package:kanaji/symbols.dart';
import 'package:kanaji/widgets/paper.dart';

class MemoryPracticePage extends StatefulWidget {
  const MemoryPracticePage({super.key});

  @override
  State<MemoryPracticePage> createState() => _MemoryPracticePageState();
}

class _MemoryPracticePageState extends State<MemoryPracticePage> {
  final GlobalKey<PaperState> paperKey = GlobalKey<PaperState>();

  void _compareDrawing() {
    final points = paperKey.currentState?.points ?? [];

    List<List<Offset>> userStrokes = [];
    List<Offset> currentStroke = [];
    for (final p in points) {
      if (p == null) {
        if (currentStroke.isNotEmpty) {
          userStrokes.add(currentStroke);
          print("Added ${currentStroke.length}");
          currentStroke = [];
        }
      } else {
        currentStroke.add(p);
      }
    }
    if (currentStroke.isNotEmpty) {
      userStrokes.add(currentStroke);
      print("Added");
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

    if (!result) {
      for (int i = 0; i < userStrokes.length; i++) {
        final stroke = userStrokes[i];
        print("Kreska ${i + 1}:");
        // Wypisz maksymalnie 3 punkty (równomiernie wybrane, jeśli więcej)
        int count = stroke.length;
        List<Offset> pointsToShow;
        if (count <= 3) {
          pointsToShow = stroke;
        } else {
          // Wybierz 3 punkty równomiernie rozmieszczone
          pointsToShow = [
            stroke[0],
            stroke[count ~/ 2],
            stroke[count - 1],
          ];
        }
        // for (var pt in pointsToShow) {
        //   print("  Punkt: (${pt.dx.toStringAsFixed(1)}, ${pt.dy.toStringAsFixed(1)})");
        // }
      }
    }
    final snackBar = SnackBar(
      content: Text(result ? 'Correct!' : 'Incorrect'),
      backgroundColor: result ? Colors.green : Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _clearPaper() {
    paperKey.currentState?.clear();
  }

  final List<String> hiraganaSymbols = ['あ','い', 'う', 'え', 'お', 'か'];

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

  void _toggleFont() {
    paperKey.currentState?.toggleFont();
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
      print('[$result]');
    }
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
                  )
                )
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _clearPaper,
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: _compareDrawing,
                  child: const Text('Check'),
                ),
                ElevatedButton(onPressed: _saveDrawing, child: const Text('Save')),
                ElevatedButton(onPressed: _toggleFont, child: const Text('Font')),
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

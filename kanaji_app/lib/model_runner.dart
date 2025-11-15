import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

class ModelRunner {
  final String modelPath;
  late Interpreter _interpreter;
  final int numClasses = 5; // 'a', 'i', 'u', 'e', 'o'
  
  ModelRunner (this.modelPath);

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      print("Model załadowany poprawnie");
    } catch (e, stackTrace) {
      print("Błąd ładowania modelu: $e");
      print(stackTrace);
    }
  }

  Future<int> predict(Float32List input) async {
    // Konwersja Float32List -> tensor [1,127,128,1]
    var inputTensor = List.generate(
      1,
      (_) => List.generate(
        127,
        (y) => List.generate(
          128,
          (x) => [input[y * 128 + x].toDouble()],
        ),
      ),
    );

    // Przygotuj wyjście [1, numClasses]
    var output = List.generate(1, (_) => List.filled(numClasses, 0.0));

    // Uruchomienie modelu
    _interpreter.run(inputTensor, output);

    // Wyniki
    final scores = output[0];
    print("$modelPath\nWyniki to: $scores");
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final predictedIdx = scores.indexOf(maxScore);

    return predictedIdx;
  }

  Interpreter get interpreter => _interpreter;
}
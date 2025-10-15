import 'dart:typed_data';
import 'package:kanaji/model_service.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

late Interpreter interpreter;
final int numClasses = 5; // 'a', 'i', 'u', 'e', 'o'

Future<void> loadModel() async {
  print("Weszło w loadModel");
  try {
    interpreter = await Interpreter.fromAsset('assets/models/cnn_etl9b_4s_20e_rev_cut_bw.tflite');
    print("Model załadowany poprawnie");
  } catch (e, stackTrace) {
    print("Błąd ładowania modelu: $e");
    print(stackTrace);
  }
}

Future<int> predict(Float32List input) async {
  // Linia testowa
  interpreter = ModelService().allModels[3].interpreter;
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
  interpreter.run(inputTensor, output);

  // Wyniki
  final scores = output[0];
  final maxScore = scores.reduce((a, b) => a > b ? a : b);
  final predictedIdx = scores.indexOf(maxScore);

  return predictedIdx;
}

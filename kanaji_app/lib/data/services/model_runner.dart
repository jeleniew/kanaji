// model_runner.dart
import 'dart:typed_data';

import 'package:kanaji/domain/services/i_model_runner.dart';
import 'package:kanaji/domain/entities/model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelRunner implements IModelRunner{
  final int numClasses = 5; // 'a', 'i', 'u', 'e', 'o'
  late Interpreter _interpreter;

  @override
  Future<void> loadModel(Model model) async {
    try {
      _interpreter = await Interpreter.fromAsset(model.assetPath);
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  @override
  Future<int> predict(Float32List inputData) async {
    var inputTensor = List.generate(
      1,
      (_) => List.generate(
        127,
        (y) => List.generate(
          128,
          (x) => [inputData[y * 128 + x].toDouble()],
        ),
      ),
    );

    var output = List.generate(1, (_) => List.filled(numClasses, 0.0));
    _interpreter.run(inputTensor, output);
    final scores = output[0];
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final predictedIdx = scores.indexOf(maxScore);
    return predictedIdx;
  }
}
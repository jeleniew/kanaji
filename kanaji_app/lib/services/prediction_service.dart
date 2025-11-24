// prediction_service.dart
import 'dart:typed_data';
import 'package:kanaji/services/character_repository.dart';

import 'model_service.dart';

class PredictionService {
  static final PredictionService _instance = PredictionService._internal();
  factory PredictionService() => _instance;
  PredictionService._internal();

  final ModelService _modelService = ModelService();

  Future<List<dynamic>> predictAllModels(Float32List inputData) async {
    List<dynamic> results = [];

    for (var model in _modelService.allModels) {
      try {
        var predictedIdx = await model.predict(inputData);
        print(predictedIdx);
        var prediction = CharacterRepository().characters[predictedIdx].glyph;
        print(prediction);
        results.add({'model': model, 'prediction': prediction});
      } catch (e) {
        print("Prediction failed for model ${model.modelPath}: $e");
      }
    }

    return results;
  }
}
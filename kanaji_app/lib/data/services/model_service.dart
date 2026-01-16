// model_service.dart

import 'dart:typed_data';

import 'package:kanaji/data/datasources/character_data_source.dart';
import 'package:kanaji/data/datasources/model_data_source.dart';
import 'package:kanaji/data/services/model_runner.dart';
import 'package:kanaji/domain/entities/model.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';

// TODO: consider making prediction service
class ModelPredictionService implements IModelPredictionService {
  static final ModelPredictionService _instance = ModelPredictionService._internal();
  factory ModelPredictionService() => _instance;
  ModelPredictionService._internal();

  List<Model> models = ModelDataSource().models;
  List<ModelRunner> runners = [];

  @override
  Future<void> init() async {
    for (var model in models) {
      if (!{"kanji_grade1v2", "hiragana2"}.contains(model.name)) {
        continue;
      }
      ModelRunner runner = ModelRunner();
      await runner.loadModel(model);
      runners.add(runner);
    }
  }

  @override
  Future<List<dynamic>> predictAllModels(Float32List inputData, CharacterType? trainingMode) async {
    List<dynamic> results = [];

    for (var runner in runners) {
      if (runner.model.trainingMode != trainingMode) {
        continue;
      }
      try {
        var predictedIdx = await runner.predict(inputData, trainingMode);
        print("Predicted index: $predictedIdx");
        var prediction = trainingMode == CharacterType.kanji
          ? CharacterDataSource().getAllKanji()[predictedIdx].glyph 
          : trainingMode == CharacterType.hiragana
          ? CharacterDataSource().getAllHiragana()[predictedIdx].glyph 
          : "?";
        print("Model ${runner.model.name} predicted: $prediction");
        results.add({"model": runner.model.name, "prediction": prediction});
      } catch (e) {
        print("Prediction failed for model ${runner.model}: $e");
      }
    }

    return results;
  }
}
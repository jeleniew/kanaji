// model_service.dart

import 'dart:typed_data';

import 'package:kanaji/data/datasources/character_data_source.dart';
import 'package:kanaji/data/datasources/model_data_source.dart';
import 'package:kanaji/data/services/model_runner.dart';
import 'package:kanaji/domain/entities/model.dart';
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
      ModelRunner runner = ModelRunner();
      await runner.loadModel(model);
      runners.add(runner);
    }
  }

  @override
  Future<List<dynamic>> predictAllModels(Float32List inputData) async {
    List<dynamic> results = [];

    for (var model in runners) {
      try {
        var predictedIdx = await model.predict(inputData);
        var prediction = CharacterDataSource().getAllHiragana()[predictedIdx].glyph;
        results.add({"model": "TODO", "prediction": prediction});
      } catch (e) {
        print("Prediction failed for model ${"TODO"}: $e");
      }
    }

    return results;
  }
}
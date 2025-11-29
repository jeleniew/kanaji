// model_service.dart

import 'dart:typed_data';

import 'package:kanaji/data/datasources/character_data_source.dart';
import 'package:kanaji/data/datasources/model_data_source.dart';
import 'package:kanaji/data/services/model_runner.dart';
import 'package:kanaji/domain/entities/model.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';

// TODO: consider making prediction service
class ModelPredictionService implements IModelPredictionService {
  static final ModelPredictionService _instance = ModelPredictionService._internal();
  factory ModelPredictionService() => _instance;
  ModelPredictionService._internal();
  late IImageProcessingService imageProcessingService;

  List<Model> models = ModelDataSource().models;
  List<ModelRunner> runners = [];

  @override
  Future<void> init(IImageProcessingService imageProcessingService) async {
    this.imageProcessingService = imageProcessingService;
    for (var model in models) {
      ModelRunner runner = ModelRunner();
      await runner.loadModel(model);
      runners.add(runner);
    }
  }

  @override
  Future<List<dynamic>> predictAllModels(Float32List inputData) async {
    List<dynamic> results = [];

    for (var runner in runners) {
      try {
        // if (runner.model.type == 'resnet50') {
        //   inputData = Float32List.fromList(
        //     imageProcessingService.adjustToResnet(inputData)
        //   );
        //   final inputTensor = Float32List(1 * 224 * 224 * 3);
        //   inputTensor.setAll(0, inputData);
        //   print("adjusting");
        // }
        var predictedIdx = await runner.predict(inputData);
        var prediction = CharacterDataSource().characters[predictedIdx].glyph;
        results.add({"model": runner.model.name, "prediction": prediction});
      } catch (e) {
        print("Prediction failed for model ${runner.model.name}: $e");
      }
    }

    return results;
  }
}
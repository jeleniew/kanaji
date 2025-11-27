import 'dart:typed_data';

abstract class IModelPredictionService {
  Future<void> init();
  Future<List<dynamic>> predictAllModels(Float32List input);
}
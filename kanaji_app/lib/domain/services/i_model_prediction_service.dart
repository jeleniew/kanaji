import 'dart:typed_data';

import 'package:kanaji/domain/entities/training_mode.dart';

abstract class IModelPredictionService {
  Future<void> init();
  Future<List<dynamic>> predictAllModels(Float32List input, TrainingMode? trainingMode);
}
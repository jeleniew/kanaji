import 'dart:typed_data';

import 'package:kanaji/domain/entities/character_type.dart';

abstract class IModelPredictionService {
  Future<void> init();
  Future<List<dynamic>> predictAllModels(Float32List input, CharacterType? trainingMode);
}
import 'package:kanaji/domain/entities/training_mode.dart';

class Model {
  final String name;
  final String assetPath;
  final int numClasses;
  final TrainingMode? trainingMode;

  Model({
    required this.name,
    required this.assetPath,
    required this.numClasses,
    this.trainingMode,
  });
}
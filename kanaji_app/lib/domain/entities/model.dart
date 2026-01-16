import 'package:kanaji/domain/entities/character_type.dart';

class Model {
  final String name;
  final String assetPath;
  final int numClasses;
  final CharacterType? trainingMode;

  Model({
    required this.name,
    required this.assetPath,
    required this.numClasses,
    this.trainingMode,
  });
}
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/training_mode.dart';

abstract class ICharacterRepository {
  List<Character> getCharacters();
  Character getCharacterByIndex(int index);
  TrainingMode? getCurrentTrainingMode();
}
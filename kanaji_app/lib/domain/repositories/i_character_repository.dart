import 'package:kanaji/domain/entities/character.dart';

abstract class ICharacterRepository {
  List<Character> getCharacters();
  Character getCharacterByIndex(int index);
}
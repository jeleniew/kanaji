import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/domain/entities/character_type.dart';

abstract class ICharacterRepository {
  Future<List<Character>> getCharacters();
  Future<List<Character>> getCharactersByType(CharacterType characterType);
  Future<Character> getCharacterByIndex(int index);
  CharacterType? getCurrentCharacterType();
  Future<List<CharacterSet>> getAvailableCharacterSets();
  void saveCharacterSet(String title, String? description, CharacterType characterType, List<String> characterGlyphs);
}
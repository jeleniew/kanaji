import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/domain/entities/character_type.dart';

abstract class ICharacterRepository {
  Future<List<Character>> getCharactersByType(CharacterType characterType);
  Future<List<Character>> getCharactersBySetId(int setId);
  CharacterType? getCurrentCharacterType();
  Future<Character> getCharacterByIndex(int index);
  Future<List<CharacterSet>> getAvailableCharacterSets();
  void saveCharacterSet(String title, String? description, CharacterType characterType, List<String> characterGlyphs);
}
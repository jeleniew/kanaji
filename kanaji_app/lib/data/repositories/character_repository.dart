// character_repository.dart
import 'package:kanaji/data/datasources/character_data_source.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';

class CharacterRepository implements ICharacterRepository {
  final List<Character> _characters = CharacterDataSource().characters;

  @override
  List<Character> getCharacters() {
    return _characters;
  }

  @override
  Character getCharacterByIndex(int index) {
    return _characters[index];
  }
}
import 'package:kanaji/domain/entities/character.dart';

abstract class ICharacterDataSource {
  List<Character> getAllHiragana();
  List<Character> getAllKatakana();
  List<Character> getAllKanji();
}
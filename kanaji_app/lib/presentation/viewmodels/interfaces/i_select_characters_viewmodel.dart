import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/character_type.dart';

abstract class ISelectCharactersViewmodel extends ChangeNotifier {
  String? get datasetTitle;
  CharacterType? get characterType;
  Future<List<Character>> get availableCharacters;
  void setDatasetInfo({
    required String title,
    required String? description,
    required CharacterType characterType,
  });
  void saveSet();
  void toggleCharacterSelection(Character character);
  bool checkIfSelected(Character character);
}
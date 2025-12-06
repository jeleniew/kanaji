// character_repository.dart
import 'package:kanaji/domain/datasources/i_character_data_source.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/training_mode.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';

class CharacterRepository implements ICharacterRepository {
  final IConfigurationService _configurationService;
  final ICharacterDataSource _dataSource;

  CharacterRepository({
    required IConfigurationService configurationService,
    required ICharacterDataSource characterDataSource,
  }) :
    _configurationService = configurationService,
    _dataSource = characterDataSource;

  @override
  List<Character> getCharacters() {
    return switch(_configurationService.selectedMode) {
      TrainingMode.hiragana => _dataSource.getAllHiragana(),
      TrainingMode.katakana => _dataSource.getAllKatakana(),
      TrainingMode.kanji => _dataSource.getAllKanji(),
      _ => [],
    };
  }

  @override
  Character getCharacterByIndex(int index) {
    final list = getCharacters();
    return list[index];
  }
}
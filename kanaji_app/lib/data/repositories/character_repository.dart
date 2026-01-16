// character_repository.dart
import 'package:kanaji/domain/datasources/i_character_data_source.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/data/helpers/database_helper.dart';

class CharacterRepository implements ICharacterRepository {
  final IConfigurationService _configurationService;

// TODO: czy robić przez DI?
  final dbHelper = DatabaseHelper();

  CharacterRepository({
    required IConfigurationService configurationService,
    required ICharacterDataSource characterDataSource,
  }) :
    _configurationService = configurationService;

  @override
  Future<List<Character>> getCharacters() async {
    // TODO: consier using sets
    final db = await dbHelper.database;

    final result = await db.query(
      'characters',
      where: 'type = ?',
      whereArgs: [_configurationService.selectedCharacterType?.name ?? ""]);

      return result.map((e) => Character.fromMap(e)).toList();
  }

  @override
  Future<Character> getCharacterByIndex(int index) async {
    final characters = await getCharacters();
    return characters[index];
  }

  @override
  CharacterType? getCurrentCharacterType() {
    return _configurationService.selectedCharacterType;
  }
}
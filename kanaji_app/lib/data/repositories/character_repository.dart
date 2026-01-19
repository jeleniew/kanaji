// character_repository.dart
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/helpers/i_database_helper.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';

class CharacterRepository implements ICharacterRepository {
  final IConfigurationService _configurationService;
  final IDatabaseHelper dbHelper;

  CharacterRepository({
    required IConfigurationService configurationService,
    required IDatabaseHelper databaseHelper,
  }) :
    _configurationService = configurationService,
    dbHelper = databaseHelper;

  @override
  Future<List<Character>> getCharactersByType(CharacterType characterType) async {
    // TODO: consier using sets
    final db = await dbHelper.database;

    final result = await db.query(
      'characters',
      where: 'type = ?',
      whereArgs: [characterType.name]);

      return result.map((e) => Character.fromMap(e)).toList();
  }

  @override
  Future<List<Character>> getCharactersBySetId(int setId) async {
    final db = await dbHelper.database;

    final result = await db.rawQuery('''
      SELECT c.*
      FROM characters c
      JOIN character_set_items csi ON c.id = csi.character_id
      WHERE csi.character_set_id = ?
    ''', [setId]);

    return result.map((e) => Character.fromMap(e)).toList();
  }

  @override
  Future<Character> getCharacterByIndex(int index) async {
    final characters = await getCharactersByType(_configurationService.selectedSet?.type ?? CharacterType.hiragana);
    return characters[index];
  }

  @override
  CharacterType? getCurrentCharacterType() {
    return _configurationService.selectedSet?.type;
  }

  @override
  Future<List<CharacterSet>> getAvailableCharacterSets() async {
    final db = await dbHelper.database;
    final result = await db.query('character_sets');
    return result.map((e) => CharacterSet.fromMap(e)).toList();
  }

  @override
  void saveCharacterSet(String title, String? description, CharacterType characterType, List<String> characterGlyphs) async {
    final db = await dbHelper.database;

    final characterSetId = await db.insert('character_sets', {
      'name': title,
      'description': description,
      'type': characterType.name,
    });

    for (var characterGlyph in characterGlyphs) {
      final result = await db.query(
        'characters',
        columns: ['id'],
        where: 'glyph = ? AND type = ?',
        whereArgs: [characterGlyph, characterType.name],
        limit: 1,
      );

      if (result.isEmpty) {
        continue;
      }

      final characterId = result.first['id'] as int;

      await db.insert('character_set_items', {
        'character_id': characterId,
        'character_set_id': characterSetId,
      });
    }
  }
}
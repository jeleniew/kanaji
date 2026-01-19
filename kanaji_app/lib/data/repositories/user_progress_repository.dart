import 'package:kanaji/domain/entities/attempt_result.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/progress_mode.dart';
import 'package:kanaji/domain/entities/result.dart';
import 'package:kanaji/domain/entities/user_progress.dart';
import 'package:kanaji/domain/helpers/i_database_helper.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';

class UserProgressRepository {
  final IDatabaseHelper _databaseHelper;
  final IConfigurationService _configurationService;

  UserProgressRepository(
    this._databaseHelper,
    this._configurationService,
  );

  Future<List<UserProgress>> getUserProgress() async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'user_progress'
    );

    final userProgressList = result.map((e) => UserProgress.fromMap(e)).toList();

    return userProgressList;
  }

  Future<List<UserProgress>> getUserProgressByParams(int? setId, ProgressMode? mode) async {
    final db = await _databaseHelper.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (setId != null) {
      whereClause += 'set_id = ?';
      whereArgs.add(setId);
    }

    if (mode != null) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'mode = ?';
      whereArgs.add(mode.name);
    }

    final result = await db.query(
      'user_progress',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    final userProgressList = result.map((e) => UserProgress.fromMap(e)).toList();

    return userProgressList;
  }

  Future<List<UserProgress>> getLastProgress({
    required int setId,
    required ProgressMode mode,
  }) async {
    final db = await _databaseHelper.database;

    final lastTimestampResult = await db.rawQuery(
      '''
      SELECT created_at
      FROM user_progress
      WHERE set_id = ? AND mode = ?
      ORDER BY created_at DESC
      LIMIT 1
      ''',
      [setId, mode.name],
    );

    if (lastTimestampResult.isEmpty) {
      return [];
    }

    final lastCreatedAt = lastTimestampResult.first['created_at'];

    final result = await db.query(
      'user_progress',
      where: 'set_id = ? AND mode = ? AND created_at = ?',
      whereArgs: [setId, mode.name, lastCreatedAt],
    );

    return result.map((e) => UserProgress.fromMap(e)).toList();
  }

  Future<void> addUserProgress(List<Character> character, List<Result> results, int setId, ProgressMode mode) async {
    final db = await _databaseHelper.database;

    final now = DateTime.now().toIso8601String();

    for (int i = 0; i < character.length; i++) {
      await db.insert(
        'user_progress',
        {
          'character_id': character[i].id,
          'set_id': setId,
          'mode': mode.name,
          'result': results[i] == Result.correct ? 1 : 0,
          'created_at': now,
        },
      );
    }    
  }

  Future<void> addUserProgressByCharacterIds(List<int> characterIds, List<Result> results, int setId, ProgressMode mode) async {
    final db = await _databaseHelper.database;

    final now = DateTime.now().toIso8601String();

    for (int i = 0; i < characterIds.length; i++) {
      await db.insert(
        'user_progress',
        {
          'character_id': characterIds[i],
          'set_id': setId,
          'mode': mode.name,
          'result': results[i] == Result.correct ? 1 : 0,
          'created_at': now,
        },
      );
    }    
  }

  Future<List<AttemptResult>> getLastSessionAccuracies({
    required ProgressMode mode,
    required int limit,
  }) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT 
        created_at,
        COUNT(*) as total,
        SUM(result) as correct
      FROM user_progress
      WHERE mode = ?
      GROUP BY created_at
      ORDER BY created_at DESC
      LIMIT ?
    ''', [mode.name, limit]);

    return result.map((row) {
      final total = row['total'] as int;
      final correct = row['correct'] as int;
      return AttemptResult(
        date: DateTime.parse(row['created_at'] as String),
        accuracy: total == 0 ? 0 : correct / total,
      );
    }).toList();
  }

  Future<List<int>> getNewlyLearnedCharacterIds({int limit = 5}) async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT character_id
      FROM user_progress
      GROUP BY character_id
      HAVING COUNT(*) = 1
      ORDER BY MAX(created_at) DESC
      LIMIT ?
    ''', [limit]);

    return result.map((e) => e['character_id'] as int).toList();
  }

}
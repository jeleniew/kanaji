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
      'user_progress',
      // where: 'set_id = ?',
      // whereArgs: [_configurationService.selectedSet?.id]
    );

    final userProgressList = result.map((e) => UserProgress.fromMap(e)).toList();

    return userProgressList;
  }

}
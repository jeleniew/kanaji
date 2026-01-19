import 'package:flutter_test/flutter_test.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/entities/result.dart';
import 'package:kanaji/domain/helpers/i_database_helper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:kanaji/data/repositories/user_progress_repository.dart';
import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';

/// =====================
/// Mocks / Fakes
/// =====================

class MockConfigurationService extends Mock implements IConfigurationService {}

class FakeDatabaseHelper implements IDatabaseHelper {
  late Database db;

  Future<Database> get database async => db;
}

void main() {
  late FakeDatabaseHelper databaseHelper;
  late MockConfigurationService configurationService;
  late UserProgressRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = FakeDatabaseHelper();
    configurationService = MockConfigurationService();

    final db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_progress (
            id INTEGER PRIMARY KEY,
            character_id INTEGER NOT NULL,
            set_id INTEGER NOT NULL,
            mode TEXT NOT NULL,
            result INTEGER NOT NULL,
            created_at TEXT
          )
        ''');
      },
    );

    databaseHelper.db = db;

    repository = UserProgressRepository(
      databaseHelper as dynamic,
      configurationService,
    );
  });

  tearDown(() async {
    await databaseHelper.db.close();
  });

  group('UserProgressRepository.getUserProgress', () {
    test('returns empty list when no progress exists', () async {
      // GIVEN
      when(() => configurationService.selectedSet).thenReturn(CharacterSet(
        id: 1,
        name: 'Hiragana',
        description: '',
        type: CharacterType.hiragana
      ));

      // WHEN
      final result = await repository.getUserProgress();

      // THEN
      expect(result, isEmpty);
    });

    test('returns progress', () async {
      // GIVEN
      when(() => configurationService.selectedSet).thenReturn(CharacterSet(
        id: 1,
        name:
        'Hiragana',
        description: '',
        type: CharacterType.hiragana
      ));

      final now = DateTime.now().toIso8601String();

      await databaseHelper.db.insert('user_progress', {
        'character_id': 1,
        'set_id': 1,
        'mode': 'practice',
        'result': 1,
        'created_at': now,
      });

      await databaseHelper.db.insert('user_progress', {
        'character_id': 2,
        'set_id': 2,
        'mode': 'practice',
        'result': 0,
        'created_at': now,
      });

      // WHEN
      final result = await repository.getUserProgress();

      // THEN
      expect(result.length, 2);
      expect(result.first.characterId, 1);
      expect(result.first.result, ResultExtension.fromInt(1));
    });
  });
}

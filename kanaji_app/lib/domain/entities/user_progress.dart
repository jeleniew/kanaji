import 'package:kanaji/domain/entities/result.dart';

import 'progress_mode.dart';

class UserProgress {
  final int characterId;
  final int setId;
  final ProgressMode mode;
  final Result result;
  final DateTime createdAt;

  UserProgress({
    required this.characterId,
    required this.setId,
    required this.mode,
    required this.result,
    required this.createdAt,
  });

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      characterId: map['character_id'],
      setId: map['set_id'],
      mode: ProgressMode.values.firstWhere((e) => e.name == map['mode']),
      result: ResultExtension.fromInt(map['result']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
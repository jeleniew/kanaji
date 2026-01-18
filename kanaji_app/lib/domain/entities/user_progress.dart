import 'progress_mode.dart';
import 'progress_result.dart';

class UserProgress {
  final int id;
  final int characterId;
  final int setId;
  final ProgressMode mode;
  final ProgressResult result;
  final DateTime createdAt;

  UserProgress({
    required this.id,
    required this.characterId,
    required this.setId,
    required this.mode,
    required this.result,
    required this.createdAt,
  });

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'],
      characterId: map['character_id'],
      setId: map['set_id'],
      mode: ProgressMode.values.firstWhere((e) => e.name == map['mode']),
      result: ProgressResultExtension.fromInt(map['result']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
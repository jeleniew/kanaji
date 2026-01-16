import 'package:kanaji/domain/entities/character_type.dart';

class CharacterSet {
  final int id;
  final String name;
  final String description;
  final CharacterType type;

  CharacterSet({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  static CharacterSet fromMap(Map<String, Object?> map) {
    return CharacterSet(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      type: CharacterType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CharacterType.kanji,
      ),
    );
  }
}
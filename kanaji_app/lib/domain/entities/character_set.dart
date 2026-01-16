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
}
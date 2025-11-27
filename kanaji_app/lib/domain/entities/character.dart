// character.dart
import 'dart:ui';

class Character {
  final String glyph;
  final String definition;
  final int jisLabel;
  final List<List<Offset>> trajectory;

  Character({required this.glyph, required this.definition, required this.jisLabel, required this.trajectory});
}
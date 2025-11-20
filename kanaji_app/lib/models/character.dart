// character.dart
import 'dart:ui';

class Character {
  final String glyph;
  final int jisLabel;
  final List<List<Offset>> trajectory;

  Character({required this.glyph, required this.jisLabel, required this.trajectory});
}
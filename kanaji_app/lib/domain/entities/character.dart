class Character {
  final String glyph;
  final List<String> meaning;
  final List<String>? reading;

  Character({
    required this.glyph,
    required this.meaning,
    this.reading,
  });
}
class Character {
  final String glyph;
  final String meaning;
  final String? reading;

  Character({
    required this.glyph,
    required this.meaning,
    this.reading,
  });

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      glyph: map['glyph'],
      meaning: map['meaning'],
      reading: map['reading'],
    );
  }
}
class Character {
  final int id;
  final String glyph;
  final String meaning;
  final String? reading;

  Character({
    required this.id,
    required this.glyph,
    required this.meaning,
    this.reading,
  });

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'],
      glyph: map['glyph'],
      meaning: map['meaning'],
      reading: map['reading'],
    );
  }
}
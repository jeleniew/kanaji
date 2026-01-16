// character_type.dart

enum CharacterType { hiragana, katakana, kanji}

extension CharacterTypeExtension on CharacterType {
  String get displayName {
    switch (this) {
      case CharacterType.hiragana:
        return 'Hiragana';
      case CharacterType.katakana:
        return 'Katakana';
      case CharacterType.kanji:
        return 'Kanji';
    }
  }
}
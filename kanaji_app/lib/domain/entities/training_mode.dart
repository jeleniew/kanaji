// training_mode.dart

enum TrainingMode { hiragana, katakana, kanji}

extension TrainingModeExtension on TrainingMode {
  String get displayName {
    switch (this) {
      case TrainingMode.hiragana:
        return 'Hiragana';
      case TrainingMode.katakana:
        return 'Katakana';
      case TrainingMode.kanji:
        return 'Kanji';
    }
  }
}
enum ProgressResult { incorrect, correct }

extension ProgressResultExtension on ProgressResult {
  
  int resultToInt(ProgressResult result) {
    switch (result) {
      case ProgressResult.incorrect:
        return 0;
      case ProgressResult.correct:
        return 1;
    }
  }

  static ProgressResult fromInt(int value) {
    switch (value) {
      case 0:
        return ProgressResult.incorrect;
      case 1:
        return ProgressResult.correct;
      default:
        throw ArgumentError('Invalid integer value for ProgressResult: $value');
    }
  }
}
// tracing_result.dart
enum Result { none, correct, incorrect}

extension ResultExtension on Result {
  
  int resultToInt(Result result) {
    switch (result) {
      case Result.incorrect:
        return 0;
      case Result.correct:
        return 1;
      default:
        throw ArgumentError('Invalid TracingResult: $result');
    }
  }

  static Result fromInt(int value) {
    switch (value) {
      case 0:
        return Result.incorrect;
      case 1:
        return Result.correct;
      default:
        throw ArgumentError('Invalid integer value for ProgressResult: $value');
    }
  }
}
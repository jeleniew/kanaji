// i_home_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:kanaji/domain/entities/attempt_result.dart';

abstract class IHomeViewModel extends ChangeNotifier {
  bool get isLoading;
  List<AttemptResult> get lastPracticeAccuracies;
  List<AttemptResult> get lastTestAccuracies;
  List<String> get newlyLearnedGlyphs;
}
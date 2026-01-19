import 'package:flutter/foundation.dart';
import 'package:kanaji/data/repositories/user_progress_repository.dart';
import 'package:kanaji/domain/entities/progress_mode.dart';
import 'package:kanaji/domain/entities/result.dart';

class ResultViewmodel extends ChangeNotifier {
  final UserProgressRepository _userProgressRepository;

  ResultViewmodel(this._userProgressRepository);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  late int total;
  late int correct;
  late int incorrect;
  late double accuracy;

  Future<void> load({
    required int setId,
    required ProgressMode mode,
  }) async {
    _isLoading = true;
    notifyListeners();

    final progress = await _userProgressRepository.getLastProgress(setId: setId, mode: mode);

    total = progress.length;
    correct = progress.where((e) => e.result == Result.correct).length;
    incorrect = total - correct;
    accuracy = total == 0 ? 0 : correct / total;

    _isLoading = false;
    notifyListeners();
  }
}
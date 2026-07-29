// home_viewmodel.dart

import 'package:kanaji/data/repositories/user_progress_repository.dart';
import 'package:kanaji/domain/entities/attempt_result.dart';
import 'package:kanaji/domain/entities/progress_mode.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_home_viewmodel.dart';

class HomeViewModel extends IHomeViewModel {
  final ICharacterRepository characterRepository;
  final UserProgressRepository userProgressRepository;

  HomeViewModel({
    required this.characterRepository,
    required this.userProgressRepository,
  });

  bool _isLoading = true;

  @override
  bool get isLoading => _isLoading;

  @override
  List<AttemptResult> lastPracticeAccuracies = [];
  @override
  List<AttemptResult> lastTestAccuracies = [];
  @override
  List<String> newlyLearnedGlyphs = [];

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    print('started');

    lastPracticeAccuracies =
        await userProgressRepository.getLastSessionAccuracies(
      mode: ProgressMode.practice,
      limit: 5,
    );

    lastTestAccuracies =
        await userProgressRepository.getLastSessionAccuracies(
      mode: ProgressMode.test,
      limit: 3,
    );

    final ids =
        await userProgressRepository.getNewlyLearnedCharacterIds();

    newlyLearnedGlyphs.clear();
    for (final id in ids) {
      final char = await characterRepository.getCharacterByIndex(id);
      if (char != null) {
        newlyLearnedGlyphs.add(char.glyph);
      }
    }
    print('finished');

    _isLoading = false;
    notifyListeners();
  }
}


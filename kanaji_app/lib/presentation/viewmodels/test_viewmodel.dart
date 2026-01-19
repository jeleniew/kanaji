import 'package:kanaji/data/repositories/user_progress_repository.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/progress_mode.dart';
import 'package:kanaji/domain/entities/result.dart';
import 'package:kanaji/domain/entities/test_answer.dart';
import 'package:kanaji/domain/entities/test_task.dart';
import 'package:kanaji/domain/entities/test_task_type.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_test_viewmodel.dart';

class TestViewmodel extends ITestViewmodel {
  final ICharacterRepository _characterRepository;
  final UserProgressRepository _userProgressRepository;

  TestViewmodel({
    required ICharacterRepository characterRepository,
    required UserProgressRepository userProgressRepository,
  })  : _characterRepository = characterRepository,
        _userProgressRepository = userProgressRepository;

  final List<TestTask> _tasks = [];
  final List<Character> _characters = [];
  final List<TestAnswer> _answers = [];
  late int setId;

  bool _isFinished = false;
  bool _isLoading = true;

  @override
  bool get isLoading => _isLoading;

  @override
  bool get isFinished => _isFinished;

  @override
  Future<void> load(int setId) async {
    _isFinished = false;
    _answers.clear();
    _tasks.clear();
    _characters.clear();

    _isLoading = true;
    notifyListeners();

    this.setId = setId;

    _characters
      ..clear()
      ..addAll(await _characterRepository.getCharactersBySetId(
          setId,
        ));

    _tasks
      ..clear()
      ..addAll(_generateTasks(_characters));

    _isLoading = false;
    notifyListeners();
  }
  
  @override
  List<TestTask> get tasks => _tasks;

  @override
  void setAnswer(int taskIndex, int characterId, bool isCorrect) {
    _answers.removeWhere((r) => r.taskIndex == taskIndex);

    _answers.add(
      TestAnswer(taskIndex, characterId, isCorrect),
    );
  }

  @override
  Future<void> submitAnswer(dynamic _) async {
    if (_answers.isEmpty) return;

    final characters = _answers.map((a) => a.characterId).toList();
    final answers = _answers
      .map((a) => a.isCorrect ? Result.correct : Result.incorrect)
      .toList();

    await _userProgressRepository.addUserProgressByCharacterIds(
      characters,
      answers,
      setId,
      ProgressMode.test,
    );

    _isFinished = true;
    notifyListeners();
  }

  List<TestTask> _generateTasks(List<Character> chars) {
    final tasks = <TestTask>[];
    final shuffledChars = List<Character>.from(chars)..shuffle();

    final mcChars = shuffledChars.take(5).toList();

    for (final c in mcChars) {
      tasks.add(TestTask(
        type: TestTaskType.multipleChoice,
        characters: [c.meaning],
        correctCharacterId: c.id,
        correctAnswer: c.glyph,
        options: _buildOptions(c),
      ));
    }

    final tiChars = shuffledChars.take(5).toList();
    for (final c in tiChars) {
      tasks.add(TestTask(
        type: TestTaskType.textInput,
        characters: [c.glyph],
        correctCharacterId: c.id,
        correctAnswer: c.glyph,
      ));
    }

    final mChars = shuffledChars.take(5).toList();
    for (final c in mChars) {
      tasks.add(TestTask(
        type: TestTaskType.matching,
        characters: [c.glyph],
        correctCharacterId: c.id,
        correctAnswer: c.meaning,
        matchingOptions: _buildMatchingOptions(c),
      ));
    }

    return tasks;
  }

  List<String> _buildOptions(Character correct) {
    final allGlyphs = _characters.map((c) => c.glyph).toList();

    allGlyphs.remove(correct.glyph);

    allGlyphs.shuffle();
    final options = allGlyphs.take(4).toList();

    options.add(correct.glyph);

    return options..shuffle();
  }

  List<Map<String, String>> _buildMatchingOptions(Character correct) {
    final otherOptions = _characters
        .where((c) => c.glyph != correct.glyph)
        .toList()
          ..shuffle();
    final selected = otherOptions.take(4).map((c) => {c.glyph: c.meaning}).toList();

    selected.add({correct.glyph: correct.meaning});

    return selected..shuffle();
  }
}

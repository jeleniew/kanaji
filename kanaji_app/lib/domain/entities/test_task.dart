import 'package:kanaji/domain/entities/test_task_type.dart';

class TestTask {
  final TestTaskType type;
  final List<String> characters;

  final String? correctAnswer;
  final int correctCharacterId;
  final List<String>? options;
  final Map<String, String>? correctPairs;
  final List<Map<String, String>>? matchingOptions;

  TestTask({
    required this.type,
    required this.characters,
    this.correctAnswer,
    required this.correctCharacterId,
    this.options,
    this.correctPairs,
    this.matchingOptions,
  });
}

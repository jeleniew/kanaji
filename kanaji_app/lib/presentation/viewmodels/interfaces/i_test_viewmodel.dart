import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/test_task.dart';

abstract class ITestViewmodel extends ChangeNotifier {
  bool get isLoading;
  void load(int setId);
  List<TestTask> get tasks;
  bool get isFinished;
  void setAnswer(int taskIndex, int characterId, bool isCorrect);
  void submitAnswer(dynamic answer);
}
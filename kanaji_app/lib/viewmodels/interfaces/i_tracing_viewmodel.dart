import 'package:flutter/material.dart';

abstract class ITracingViewModel extends ChangeNotifier {
  String get currentCharacter;
  void clear();
  void previous();
  void next();
  void check(List<Offset?> points);
  void checkAI(List<Offset?> points);
  void font();
}
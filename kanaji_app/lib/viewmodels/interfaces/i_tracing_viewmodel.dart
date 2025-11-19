import 'package:flutter/material.dart';

abstract class ITracingViewModel extends ChangeNotifier {
  String get currentCharacter;
  String? get font;
  void previous();
  void next();
  void check(List<List<Offset?>> points);
  void checkAI(List<List<Offset?>> points);
  void changeFont();
}
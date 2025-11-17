import 'package:flutter/material.dart';

abstract class IDrawingCanvasViewModel extends ChangeNotifier {
  List<List<Offset?>> get strokes;
  void addPoints(Offset localPosition);
  void endStroke();
  void clear();
}
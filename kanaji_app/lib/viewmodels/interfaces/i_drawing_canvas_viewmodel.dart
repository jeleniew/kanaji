import 'package:flutter/material.dart';

abstract class IDrawingCanvasViewModel extends ChangeNotifier {
  List<Offset?> get points;

  void addPoints(Offset localPosition);
}
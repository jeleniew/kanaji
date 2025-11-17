// i_flashcards_viewmodel.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

abstract class IFlashcardsViewModel extends ChangeNotifier{
  String get currentCard;
  void toggleSign();
  void onHorizontalDragEnd(DragEndDetails details);
}
// i_flashcards_viewmodel.dart
import 'package:flutter/gestures.dart';

abstract class IFlashcardsViewModel {
  String get currentCard;
  void toggleSign();
  void onHorizontalDragEnd(DragEndDetails details);
}
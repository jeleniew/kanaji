// flashcards_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:kanaji/viewmodels/interfaces/i_flashcards_viewmodel.dart';

class FlashcardsViewModel extends ChangeNotifier
  implements IFlashcardsViewModel {
    
  final List<String> hiragana = ['あ', 'い', 'う', 'え', 'お'];
  final List<String> polish = ['a', 'i', 'u', 'e', 'o'];

  int _currentIndex = 0;
  bool _showingHiragana = true;

  @override
  String get currentCard =>
      _showingHiragana ? hiragana[_currentIndex] : polish[_currentIndex];

  void _nextCard() {
    _currentIndex = (_currentIndex + 1) % hiragana.length;
    _showingHiragana = false;
    
    notifyListeners();
  }

  void _previousCard() {
    _currentIndex = (hiragana.length + _currentIndex - 1) % hiragana.length;
    _showingHiragana = false;
    
    notifyListeners();
  }


  @override
  void toggleSign() {
    _showingHiragana = !_showingHiragana;
    notifyListeners();
  }

  @override
  void onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      _nextCard();
    } else if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
      _previousCard();
    }
  }
}
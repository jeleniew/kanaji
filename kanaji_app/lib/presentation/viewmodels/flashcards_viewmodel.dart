// flashcards_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_flashcards_viewmodel.dart';

class FlashcardsViewModel extends IFlashcardsViewModel {
  final ICharacterRepository _characterRepository;

  FlashcardsViewModel({required ICharacterRepository characterRepository})
    : _characterRepository = characterRepository;

  int _currentIndex = 0;
  bool _showingHiragana = true;

  @override
  String get currentCard =>
    _showingHiragana
    ? _characterRepository.getCharacterByIndex(_currentIndex).glyph
    : _characterRepository.getCharacterByIndex(_currentIndex).definition;

  void _nextCard() {
    final length = _characterRepository.getCharacters().length;
    _currentIndex = (_currentIndex + 1) % length;
    _showingHiragana = false;
    
    notifyListeners();
  }

  void _previousCard() {
    final length = _characterRepository.getCharacters().length;
    _currentIndex = (length + _currentIndex - 1) % length;
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
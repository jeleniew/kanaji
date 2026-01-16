// flashcards_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_flashcards_viewmodel.dart';

class FlashcardsViewModel extends IFlashcardsViewModel {
  final ICharacterRepository _characterRepository;

  FlashcardsViewModel({required ICharacterRepository characterRepository})
    : _characterRepository = characterRepository {
      _loadSetLength();
    }

  int _currentIndex = 0;
  bool _showingCharacter = true;
  int _characterLength = 0;

  Future<void> _loadSetLength() async {
    final characters = await _characterRepository.getCharacters();
    _characterLength = characters.length;
  }

  @override
  Future<String> get currentCard async =>
    _showingCharacter
    ? (await _characterRepository.getCharacterByIndex(_currentIndex)).glyph
    : (await _characterRepository.getCharacterByIndex(_currentIndex)).meaning
      .replaceAll('|', ', ');

  void _nextCard() {
    _currentIndex = (_currentIndex + 1) % _characterLength;
    _showingCharacter = false;
    
    notifyListeners();
  }

  void _previousCard() {
    _currentIndex = (_characterLength + _currentIndex - 1) % _characterLength;
    _showingCharacter = false;
    
    notifyListeners();
  }

  @override
  void toggleSign() {
    _showingCharacter = !_showingCharacter;
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
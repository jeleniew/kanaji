// flashcards_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_flashcards_viewmodel.dart';

class FlashcardsViewModel extends IFlashcardsViewModel {
  final ICharacterRepository _characterRepository;
  final IConfigurationService _configurationService;

  FlashcardsViewModel({
    required ICharacterRepository characterRepository,
    required IConfigurationService configurationService,
  }) :
    _characterRepository = characterRepository,
    _configurationService = configurationService {
      _loadCharacters();
    }

  int _currentIndex = 0;
  bool _showingCharacter = true;
  int _characterLength = 0;
  late List<Character> _characters;

  
  Future<void> _loadCharacters() async {
    if (_configurationService.selectedSet == null) {
      throw Exception('No character set selected');
    }
    _characters = await _characterRepository.getCharactersBySet(
      _configurationService.selectedSet!);
    _characterLength = _characters.length;
  }

  @override
  Future<String> get currentCard async =>
    _showingCharacter
    ? _characters[_currentIndex].glyph
    : _characters[_currentIndex].meaning
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
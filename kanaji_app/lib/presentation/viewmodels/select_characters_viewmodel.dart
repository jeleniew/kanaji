import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_select_characters_viewmodel.dart';

class SelectCharactersViewModel extends ISelectCharactersViewmodel {
  final ICharacterRepository characterRepository;
  final List<String> _selectedCharacters = [];

  @override
  String? datasetTitle;
  @override
  String? _datasetDescription;
  @override
  CharacterType? characterType;

  SelectCharactersViewModel({
    required this.characterRepository
  });

  @override
  Future<List<Character>> get availableCharacters async =>
    await characterRepository.getCharactersByType(characterType!);

  @override
  void setDatasetInfo({required String title, required String? description, required CharacterType characterType}) {
    datasetTitle = title;
    _datasetDescription = description;
    this.characterType = characterType;
    notifyListeners();
  }

  @override
  void saveSet() async {
    characterRepository.saveCharacterSet(
      datasetTitle!,
      _datasetDescription,
      characterType!,
      _selectedCharacters.toList(),
    );
  }

  @override
  void toggleCharacterSelection(Character character) {
    _selectedCharacters.contains(character.glyph)
      ? _selectedCharacters.remove(character.glyph)
      : _selectedCharacters.add(character.glyph);

    print(_selectedCharacters.map((e) => e).toList());
    notifyListeners();
  }

  @override
  bool checkIfSelected(Character character) {
    return _selectedCharacters.contains(character.glyph);
  }
}
import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_datasets_viewmodel.dart';

class DatasetsViewmodel extends IDatasetsViewmodel {
  final ICharacterRepository _characterRepository;

  DatasetsViewmodel({required ICharacterRepository characterRepository})
    : _characterRepository = characterRepository;

  @override
  Future<List<CharacterSet>> getAvailableCharacterSets() {
    return _characterRepository.getAvailableCharacterSets();
  }
}
import 'package:kanaji/domain/repositories/i_character_repository.dart';

class DatasetsViewmodel {
  final ICharacterRepository _characterRepository;

  DatasetsViewmodel({required ICharacterRepository characterRepository})
    : _characterRepository = characterRepository;

  
}
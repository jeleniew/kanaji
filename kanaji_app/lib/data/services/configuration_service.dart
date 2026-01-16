// configuration_service.dart

import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';

class ConfigurationService implements IConfigurationService {
  CharacterType? _selectedMode;

  @override
  CharacterType? get selectedCharacterType => _selectedMode;

  @override
  void selectMode(CharacterType mode) {
    _selectedMode = mode;
  }
}
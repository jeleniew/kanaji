// configuration_service.dart

import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';

class ConfigurationService implements IConfigurationService {
  CharacterSet? _selectedSet;

  @override
  CharacterSet? get selectedSet => _selectedSet;

  @override
  void selectSet(CharacterSet set) {
    _selectedSet = set;
  }
}
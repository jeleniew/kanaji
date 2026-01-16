// i_configuration_service.dart

import 'package:kanaji/domain/entities/character_type.dart';

abstract class IConfigurationService {
  CharacterType? get selectedCharacterType;
  void selectMode(CharacterType mode);
}
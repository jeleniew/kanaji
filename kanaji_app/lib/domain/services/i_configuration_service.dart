// i_configuration_service.dart

import 'package:kanaji/domain/entities/character_set.dart';

abstract class IConfigurationService {
  CharacterSet? get selectedSet;
  void selectSet(CharacterSet set);
}
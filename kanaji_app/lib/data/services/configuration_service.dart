// configuration_service.dart

import 'package:kanaji/domain/entities/training_mode.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';

class ConfigurationService implements IConfigurationService {
  TrainingMode? _selectedMode;

  @override
  TrainingMode? get selectedMode => _selectedMode;

  @override
  void selectMode(TrainingMode mode) {
    _selectedMode = mode;
  }
}
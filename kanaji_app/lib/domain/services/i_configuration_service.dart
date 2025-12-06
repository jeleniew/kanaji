// i_configuration_service.dart

import 'package:kanaji/domain/entities/training_mode.dart';

abstract class IConfigurationService {
  TrainingMode? get selectedMode;
  void selectMode(TrainingMode mode);
}
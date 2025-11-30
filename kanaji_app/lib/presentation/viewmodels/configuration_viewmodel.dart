// tracing_configuration_viewmodel.dart

import 'package:flutter/widgets.dart';
import 'package:kanaji/domain/entities/training_mode.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_configuration_viewmodel.dart';

class ConfigurationViewModel extends IConfigurationViewModel {

  final IConfigurationService _configurationService;

  ConfigurationViewModel({required IConfigurationService configurationService})
      : _configurationService = configurationService;

  @override
  TrainingMode? get selectedMode => _configurationService.selectedMode;

  @override
  void selectMode(TrainingMode mode) {
    _configurationService.selectMode(mode);
    notifyListeners();
  }

  @override
  void startTraining(BuildContext context, String nextRoute) {
    Navigator.of(context).pushNamed(nextRoute);
  }
}
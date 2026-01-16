// tracing_configuration_viewmodel.dart

import 'package:flutter/widgets.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_configuration_viewmodel.dart';

class ConfigurationViewModel extends IConfigurationViewModel {

  final IConfigurationService _configurationService;

  ConfigurationViewModel({required IConfigurationService configurationService})
      : _configurationService = configurationService;

  @override
  CharacterType? get selectedMode => _configurationService.selectedCharacterType;

  @override
  void selectMode(CharacterType mode) {
    _configurationService.selectMode(mode);
    notifyListeners();
  }

  @override
  void startTraining(BuildContext context, String nextRoute) {
    Navigator.of(context).pushNamed(nextRoute);
  }
}
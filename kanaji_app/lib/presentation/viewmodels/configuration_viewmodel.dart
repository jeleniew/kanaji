// tracing_configuration_viewmodel.dart

import 'package:flutter/widgets.dart';
import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_configuration_viewmodel.dart';

class ConfigurationViewModel extends IConfigurationViewModel {

  final IConfigurationService _configurationService;
  final ICharacterRepository _characterRepository;

  ConfigurationViewModel({
    required IConfigurationService configurationService,
    required ICharacterRepository characterRepository,})
      : _configurationService = configurationService,
        _characterRepository = characterRepository;

  @override
  CharacterSet? get selectedSet => _configurationService.selectedSet;

  @override
  void selectSet(CharacterSet set) {
    _configurationService.selectSet(set);
    notifyListeners();
  }

  @override
  Future<List<CharacterSet>> get allSets async => await _characterRepository.getAvailableCharacterSets();

  @override
  void startTraining(BuildContext context, String nextRoute) {
    Navigator.of(context).pushNamed(nextRoute);
  }
}
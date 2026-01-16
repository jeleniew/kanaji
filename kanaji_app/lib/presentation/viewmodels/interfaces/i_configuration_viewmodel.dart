// i_configuration_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character_type.dart';

abstract class IConfigurationViewModel extends ChangeNotifier {
  CharacterType? get selectedMode;
  void selectMode(CharacterType mode);
  void startTraining(BuildContext context, String nextRoute);
}
// i_configuration_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character_set.dart';

abstract class IConfigurationViewModel extends ChangeNotifier {
  CharacterSet? get selectedSet;
  void selectSet(CharacterSet set);
  void startTraining(BuildContext context, String nextRoute);
  Future<List<CharacterSet>> get allSets;
}
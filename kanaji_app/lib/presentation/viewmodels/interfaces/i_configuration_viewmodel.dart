// i_configuration_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/training_mode.dart';

abstract class IConfigurationViewModel extends ChangeNotifier {
  TrainingMode? get selectedMode;
  void selectMode(TrainingMode mode);
  void startTraining(BuildContext context, String nextRoute);
}
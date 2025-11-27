import 'dart:typed_data';

import 'package:kanaji/domain/entities/model.dart';

abstract class IModelRunner {
  Future<void> loadModel(Model model);
  Future<int> predict(Float32List inputData);
}
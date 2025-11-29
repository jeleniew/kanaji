import 'dart:typed_data';

import 'package:kanaji/domain/services/i_image_processing_service.dart';

abstract class IModelPredictionService {
  Future<void> init(IImageProcessingService imageProcessingService);
  Future<List<dynamic>> predictAllModels(Float32List input);
}
// model_service.dart

import 'package:kanaji/model_runner.dart';

class ModelService {
  static final ModelService _instance = ModelService._internal();
  factory ModelService() => _instance;
  ModelService._internal();
  
  late ModelRunner model1;
  late ModelRunner model2;
  late ModelRunner model3;
  late ModelRunner model4;
  late ModelRunner model5;
  late ModelRunner model6;
  late ModelRunner model7;
  late ModelRunner model8;

  Future<void> init() async {
    try {
      model1 = ModelRunner('assets/ml_models/cnn_etl9b_4s_20e_rev.tflite');
      model2 = ModelRunner('assets/ml_models/cnn_etl9b_4s_20e_rev_cut.tflite');
      model3 = ModelRunner('assets/ml_models/cnn_etl9b_4s_20e_rev_cut_bw.tflite');
      model4 = ModelRunner('assets/ml_models/cnn_etl9b_4s_20e.tflite');
      model5 = ModelRunner('assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth.tflite');
      model6 = ModelRunner('assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth_2v.tflite');
      model7 = ModelRunner('assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth_simple.tflite');
      model8 = ModelRunner('assets/ml_models/cnn_etl9g_5s_50e_nomargin_smooth_simple.tflite');

      await Future.wait([
        // model1.loadModel(),
        model2.loadModel(),
        model3.loadModel(),
        // model4.loadModel(),
        model5.loadModel(),
        model6.loadModel(),
        model7.loadModel(),
        model8.loadModel(),
      ]);
    } catch (e, stackTrace) {
      print("Nieudane inicjowanie modeli: $e");
    }
  }

  
  List<ModelRunner> get allModels => [
    // model1,
    model2,
    model3,
    // model4,
    model5,
    model6,
    model7,
    model8,
  ];
}
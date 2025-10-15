import 'package:kanaji/model_runner.dart';

class ModelService {
  static final ModelService _instance = ModelService._internal();
  factory ModelService() => _instance;
  ModelService._internal();
  
  late ModelRunner model1;
  late ModelRunner model2;
  late ModelRunner model3;
  late ModelRunner model4;

  Future<void> init() async {
    try {
      model1 = ModelRunner('assets/models/cnn_etl9b_4s_20e_rev.tflite');
      model2 = ModelRunner('assets/models/cnn_etl9b_4s_20e_rev_cut.tflite');
      model3 = ModelRunner('assets/models/cnn_etl9b_4s_20e_rev_cut_bw.tflite');
      model4 = ModelRunner('assets/models/cnn_etl9b_4s_20e.tflite');

      await Future.wait([
        // model1.loadModel(),
        model2.loadModel(),
        model3.loadModel(),
        // model4.loadModel(),
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
  ];
}
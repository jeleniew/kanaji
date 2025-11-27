// model_static_data_source.dart

import 'package:kanaji/domain/entities/model.dart';

class ModelDataSource {
  List<Model> get models => [
    // Model(name: "model1", assetPath: 'assets/ml_models/cnn_etl9b_4s_20e_rev.tflite'),
    Model(name: "model2", assetPath: 'assets/ml_models/cnn_etl9b_4s_20e_rev_cut.tflite'),
    Model(name: "model3", assetPath: 'assets/ml_models/cnn_etl9b_4s_20e_rev_cut_bw.tflite'),
    // Model(name: "model4", assetPath: 'assets/ml_models/cnn_etl9b_4s_20e.tflite'),
    Model(name: "model5", assetPath: 'assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth.tflite'),
    Model(name: "model6", assetPath: 'assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth_2v.tflite'),
    Model(name: "model7", assetPath: 'assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth_simple.tflite'),
    Model(name: "model8", assetPath: 'assets/ml_models/cnn_etl9g_5s_50e_nomargin_smooth_simple.tflite'),
  ];
}
// model_static_data_source.dart

import 'package:kanaji/domain/entities/model.dart';

class ModelDataSource {
  List<Model> get models => [
    // Model(
      // name: "model1",
      // assetPath: 'assets/ml_models/cnn_etl9b_4s_20e_rev.tflite'),
    Model(
      name: "model2",
      type: "etl9b",
      numClasses: 5,
      assetPath: 'assets/ml_models/cnn_etl9b_4s_20e_rev_cut.tflite'
    ),
    Model(
      name: "model3",
      type: "etl9b",
      numClasses: 5,
      assetPath: 'assets/ml_models/cnn_etl9b_4s_20e_rev_cut_bw.tflite'
    ),
    // Model(
      // name: "model4",
      // assetPath: 'assets/ml_models/cnn_etl9b_4s_20e.tflite'),
    Model(
      name: "model5",
      type: "etl9g",
      numClasses: 5,
      assetPath: 'assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth.tflite'
    ),
    Model(
      name: "model6",
      type: "etl9g",
      numClasses: 5,
      assetPath: 'assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth_2v.tflite'
    ),
    Model(
      name: "model7",
      type: "etl9g",
      numClasses: 5,
      assetPath: 'assets/ml_models/cnn_etl9g_5s_20e_nomargin_smooth_simple.tflite'
    ),
    Model(
      name: "model8",
      type: "etl9g",
      numClasses: 5,
      assetPath: 'assets/ml_models/cnn_etl9g_5s_50e_nomargin_smooth_simple.tflite'
    ),
    // Model(
    //   name: "r_model1",
    //   type: "resnet50",
    //   assetPath: 'assets/ml_models/cnn_resnet50_5s_50e_nomargin_smooth_simple.tflite'
    // ),
    // Model(
    //   name: "r_model2",
    //   type: "resnet50",
      // numClasses: 5,
    //   assetPath: 'assets/ml_models/cnn_resnet50_5s_50e_nomargin_smooth_simple2.tflite'
    // ),
    // Model(
    //   name: "r_model224",
    //   type: "resnet50",
      // numClasses: 5,
    //   assetPath: 'assets/ml_models/cnn_resnet50_5s_50e_nomargin_smooth_simple224.tflite'
    // ),
    Model(
      name: "model9",
      type: "etl9g",
      numClasses: 5,
      assetPath: 'assets/ml_models/cnn_etl9g_hiragana_50e_nomargin_smooth_simple.tflite'
    ),
  ];
}
// model_static_data_source.dart

import 'package:kanaji/domain/entities/model.dart';
import 'package:kanaji/domain/entities/character_type.dart';

class ModelDataSource {
  List<Model> get models => [
    Model(name: "hiragana", assetPath: 'assets/ml_models/cnn_etl9g_hiragana_50e_nomargin_smooth_simple.tflite', numClasses: 46, trainingMode: CharacterType.hiragana),
    Model(name: "katakana", assetPath: 'assets/ml_models/cnn_etl9g_katakana_50e_nomargin_smooth_simple.tflite', numClasses: 46),
    Model(name: "kanji_grade1_missing", assetPath: 'assets/ml_models/cnn_etl9g_79s_50e_nomargin_smooth_simple.tflite', numClasses: 79, trainingMode: CharacterType.kanji), // works but character for 'right' is missing
    Model(name: "kanji_grade1", assetPath: 'assets/ml_models/cnn_etl9g_80s_50e_nomargin_smooth_simple.tflite', numClasses: 80, trainingMode: CharacterType.kanji),
  ];
}
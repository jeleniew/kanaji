// model_runner.dart
import 'dart:typed_data';

import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/services/i_model_runner.dart';
import 'package:kanaji/domain/entities/model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelRunner implements IModelRunner {
  late Interpreter _interpreter;
  late Model _model;

  Model get model => _model;

  @override
  Future<void> loadModel(Model model) async {
    try {
      _model = model;
      _interpreter = await Interpreter.fromAsset(model.assetPath);
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Leaving those for detailed output during prediction

  static const hiraganaLabels = [
    'あ','い','う','え','お',
    'か','き','く','け','こ',
    'さ','し','す','せ','そ',
    'た','ち','つ','て','と',
    'な','に','ぬ','ね','の',
    'は','ひ','ふ','へ','ほ',
    'ま','み','む','め','も',
    'や','ゆ','よ',
    'ら','り','る','れ','ろ',
    'わ','を','ん'
  ];

  static const kanjiLabels = [
    '一', '二', '三', '四', '五',
    '六', '七', '八', '九', '十',
    '百', '千', '上', '下', '左',
    '右', '中', '大', '小', '月',
    '日', '年', '早', '木', '林',
    '山', '川', '土', '空', '田',
    '天', '生', '花', '草', '虫',
    '犬', '人', '名', '女', '男',
    '子', '目', '耳', '口', '手',
    '足', '見', '音', '力', '気',
    '円', '入', '出', '立', '休',
    '先', '夕', '本', '文', '字',
    '学', '校', '村', '町', '森',
    '正', '水', '火', '玉', '王',
    '石', '竹', '糸', '貝', '車',
    '金', '雨', '赤', '青', '白',
  ];


  @override
  Future<int> predict(Float32List inputData, CharacterType? trainingMode) async {
    var inputTensor = List.generate(
      1,
      (_) => List.generate(
        127,
        (y) => List.generate(
          128,
          (x) => [inputData[y * 128 + x].toDouble()],
        ),
      ),
    );

    var output = List.generate(1, (_) => List.filled(_model.numClasses, 0.0));
    _interpreter.run(inputTensor, output);
    final scores = output[0];
    if (trainingMode == CharacterType.hiragana) {
      for (int i = 0; i < scores.length; i++) {
        final label = i < hiraganaLabels.length ? hiraganaLabels[i] : "?";
        print("$label: ${scores[i].toStringAsFixed(5)}");
      }
    } else if (trainingMode == CharacterType.kanji) {
      for (int i = 0; i < scores.length; i++) {
        final label = i < kanjiLabels.length ? kanjiLabels[i] : "?";
        print("$label: ${scores[i].toStringAsFixed(5)}");
      }
    } else {
      print("Unknown training mode for detailed output.");
    }
    final maxScore = scores.reduce((a, b) => a > b ? a : b);
    final predictedIdx = scores.indexOf(maxScore);
    return predictedIdx;
  }
}
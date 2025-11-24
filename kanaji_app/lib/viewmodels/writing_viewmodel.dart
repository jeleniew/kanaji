// writing_viewmodel.dart
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kanaji/services/character_repository.dart';
import 'package:kanaji/services/drawing_analyzer_service.dart';
import 'package:kanaji/services/image_processing.dart' as image_processing;
import 'package:kanaji/services/prediction_service.dart';
import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_writing_viewmodel.dart';
import 'package:kanaji/viewmodels/tracing_viewmodel.dart';

class WritingViewModel extends IWritingViewModel {
  int _currentIndex = 0;
  late IDrawingCanvasViewModel _drawingCanvasViewModel;
  final CharacterRepository _characterRepository = CharacterRepository();
  TracingResult _tracingResult = TracingResult.none;
  String _hint = "";

  @override
  void attachDrawingVM(IDrawingCanvasViewModel vm) {
    _drawingCanvasViewModel = vm;
  }

  @override
  String get currentCharacter => _characterRepository.getCharacterByIndex(_currentIndex).glyph;

  @override
  TracingResult get tracingResult => _tracingResult;

  @override
  String get hint => _hint;

  @override
  void previous() {
    clear();
    int charactersLength = _characterRepository.characters.length;
    _currentIndex = (_currentIndex - 1 + charactersLength) % charactersLength;
    notifyListeners();
  }

  @override
  void next() {
    clear();
    int charactersLength = _characterRepository.characters.length;
    _currentIndex = (_currentIndex + 1) % charactersLength;
    notifyListeners();
  }

  @override
  void check() {
    List<List<Offset>> expectedStrokes = _drawingCanvasViewModel.strokes;

    final character = _characterRepository.getCharacterByIndex(_currentIndex);
    final result =  DrawingAnalyzerService().compare(expectedStrokes, character);

    if (result) {
      _tracingResult = TracingResult.correct;
    } else {
      _tracingResult = TracingResult.incorrect;
    }
    notifyListeners();
  }

  @override
  void checkAI() async {
    final predictionService = PredictionService();
    List<List<Offset>> strokes = _drawingCanvasViewModel.strokes;
    final image = await image_processing.convertPointsToImage(strokes, Size(128, 127));
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Float32List floatInput =
      await image_processing.processImage(byteData!);

    final result = predictionService.predictAllModels(floatInput);

    final character = _characterRepository.getCharacterByIndex(_currentIndex);
    int maches = 0;
    for (var prediction in await result) {
      var predictedLabel = prediction['prediction'];
      if (predictedLabel == character.glyph) {
        maches += 1;
      }
    }
    print('AI Prediction matches: $maches out of ${(await result).length}');
    print('Expected character: ${character.glyph}');
    final predictions = (await result).map((e) => e['prediction']).toList();
    print('Predicted characters: $predictions');
    if (maches >= (await result).length / 2) {
      _tracingResult = TracingResult.correct;
    } else {
      _tracingResult = TracingResult.incorrect;
    }
    
    notifyListeners();
  }

  @override
  void clear() {
    _tracingResult = TracingResult.none;
    _drawingCanvasViewModel.clear();
    notifyListeners();
  }

  @override
  void showHint() {
    _hint = _characterRepository.getCharacterByIndex(_currentIndex).glyph;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _hint = "";
      notifyListeners();
    });
  }
}
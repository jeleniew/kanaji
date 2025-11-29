// writing_viewmodel.dart

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/tracing_result.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';

class WritingViewModel extends IWritingViewModel {
  final ICharacterRepository _characterRepository;
  final IModelPredictionService _modelService;
  final IImageProcessingService _imageProcessingService;
  final IDrawingAnalyzerService _drawingAnalyzerService;
  final IKanjiRepository _kanjiRepository;

  int _currentIndex = 0;
  late IDrawingCanvasViewModel _drawingCanvasViewModel;
  TracingResult _tracingResult = TracingResult.none;
  String _hint = "";
  late Future<String> _currentCharacterSvg;

  WritingViewModel({
    required ICharacterRepository characterRepository,
    required IModelPredictionService modelService,
    required IImageProcessingService imageProcessingService,
    required IDrawingAnalyzerService drawingAnalyzerService,
    required IKanjiRepository kanjiRepository,
  }) :
    _characterRepository = characterRepository,
    _modelService = modelService,
    _imageProcessingService = imageProcessingService,
    _drawingAnalyzerService = drawingAnalyzerService,
    _kanjiRepository = kanjiRepository;

  @override
  void attachDrawingVM(IDrawingCanvasViewModel vm) {
    _drawingCanvasViewModel = vm;
  }

  @override
  String get currentCharacter =>
    _characterRepository.getCharacterByIndex(_currentIndex).glyph;

  @override
  TracingResult get tracingResult => _tracingResult;

  @override
  String get hint => _hint;

  @override
  Future<String> get currentCharacterSvg {
    _currentCharacterSvg = _kanjiRepository.getSvgByKanji(currentCharacter);
    return _currentCharacterSvg;
  }

  @override
  void previous() {
    clear();
    int charactersLength = _characterRepository.getCharacters().length;
    _currentIndex = (_currentIndex - 1 + charactersLength) % charactersLength;
    notifyListeners();
  }

  @override
  void next() {
    clear();
    int charactersLength = _characterRepository.getCharacters().length;
    _currentIndex = (_currentIndex + 1) % charactersLength;
    notifyListeners();
  }

  @override
  void check() async {
    List<List<Offset>> expectedStrokes = _drawingCanvasViewModel.strokes;

    final character = _characterRepository.getCharacterByIndex(_currentIndex);
    final svgPathData = await _kanjiRepository.getSvgByKanji(character.glyph);
    final result =  _drawingAnalyzerService.comapre2(expectedStrokes, svgPathData);

    if (result) {
      _tracingResult = TracingResult.correct;
    } else {
      _tracingResult = TracingResult.incorrect;
    }
    notifyListeners();
  }

  @override
  void checkAI() async {
    List<List<Offset>> strokes = _drawingCanvasViewModel.strokes;
    final image = await _imageProcessingService.convertPointsToImage(strokes, Size(128, 127));
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Float32List floatInput =
      await _imageProcessingService.processImage(byteData!);

    final result = _modelService.predictAllModels(floatInput);

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

    Future.delayed(const Duration(milliseconds: 1000), () {
      _hint = "";
      notifyListeners();
    });
  }
}
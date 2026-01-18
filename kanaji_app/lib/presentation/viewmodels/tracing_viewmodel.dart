// tracing_viewmodel.dart

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/tracing_result.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';


class TracingViewModel extends IWritingViewModel {
  final ICharacterRepository _characterRepository;
  final IModelPredictionService _modelService;
  final IImageProcessingService _imageProcessingService;
  final IDrawingAnalyzerService _drawingAnalyzerService;
  final IKanjiRepository _kanjiRepository;
  final IConfigurationService _configurationService;
  
  late IDrawingCanvasViewModel _drawingCanvasViewModel;
  TracingResult _tracingResult = TracingResult.none;
  ui.Image? _processedImage;
  int _currentIndex = 0;
  late Future<String> _currentCharacterSvg;
  int _characterLength = 0;
  late List<Character> _characters;

  TracingViewModel({
    required ICharacterRepository characterRepository,
    required IModelPredictionService modelService,
    required IImageProcessingService imageProcessingService,
    required IDrawingAnalyzerService drawingAnalyzerService,
    required IKanjiRepository kanjiRepository,
    required IConfigurationService configurationService,
  }) :
    _characterRepository = characterRepository,
    _modelService = modelService,
    _imageProcessingService = imageProcessingService,
    _drawingAnalyzerService = drawingAnalyzerService,
    _kanjiRepository = kanjiRepository,
    _configurationService = configurationService;

  @override
  Future<void> init() async {
    if (_configurationService.selectedSet == null) {
      throw Exception('No character set selected');
    }
    _characters = await _characterRepository.getCharactersBySet(
      _configurationService.selectedSet!
    );
    _characterLength = _characters.length;
  }

  @override
  void attachDrawingVM(IDrawingCanvasViewModel vm) {
    _drawingCanvasViewModel = vm;
  }

  @override
  String get currentCharacter => _characters[_currentIndex].glyph;

  @override
  String get currentMeaning =>
    _characters[_currentIndex].meaning.replaceAll('|', ', ');

  Future<String> get currentCharacterSvg async {
    _currentCharacterSvg = _kanjiRepository.getSvgByKanji(currentCharacter);
    return _currentCharacterSvg;
  }

  @override
  TracingResult get tracingResult => _tracingResult;

  // TODO: use only for debugging
  ui.Image? get processedImage => _processedImage;
  
  @override
  void previous() {
    // TODO: notifyListeners is invoked twice here
    clear();
    _currentIndex = (_currentIndex - 1 + _characterLength) % _characterLength;
    print('Previous index: $_currentIndex');
    notifyListeners();
  }

  @override
  void next() {
    clear();
    _currentIndex = (_currentIndex + 1) % _characterLength;
    print('Next index: $_currentIndex');
    notifyListeners();
  }

  @override
  void check() async{
    List<List<Offset>> expectedStrokes = _drawingCanvasViewModel.strokes;

    final character = _characters[_currentIndex];
    print('Checking character: ${character.glyph}');
    final svgPathData = await _kanjiRepository.getSvgByKanji(character.glyph);
    final result = _drawingAnalyzerService.compare(expectedStrokes, svgPathData);

    if (result) {
      _tracingResult = TracingResult.correct;
    } else {
      _tracingResult = TracingResult.incorrect;
    }
    print('Result: $_tracingResult');
    notifyListeners();
  }

  @override
  void checkAI() async {
    List<List<Offset>> strokes = _drawingCanvasViewModel.strokes;
    final image = await _imageProcessingService.convertPointsToImage(strokes, Size(128, 127));
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Float32List floatInput =
      await _imageProcessingService.processImage(byteData!);

    final result = _modelService.predictAllModels(
      floatInput,
      _characterRepository.getCurrentCharacterType()
    );

    final character = _characters[_currentIndex];
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
    if (kDebugMode) {
      _processedImage =
      await _imageProcessingService.float32ListToImage(floatInput, 128, 127);
    }
    notifyListeners();
  }

  @override
  void showHint() {
    // TODO
    notifyListeners();
  }

  @override
  void clear() {
    _tracingResult = TracingResult.none;
    _drawingCanvasViewModel.clear();
    notifyListeners();
  }
}
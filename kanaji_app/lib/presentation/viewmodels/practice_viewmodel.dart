// writing_viewmodel.dart

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kanaji/data/repositories/user_progress_repository.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/progress_mode.dart';
import 'package:kanaji/domain/entities/result.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';

class PracticeViewModel extends IWritingViewModel {
  final ICharacterRepository _characterRepository;
  final IModelPredictionService _modelService;
  final IImageProcessingService _imageProcessingService;
  final IDrawingAnalyzerService _drawingAnalyzerService;
  final IKanjiRepository _kanjiRepository;
  final IConfigurationService _configurationService;
  final UserProgressRepository _userProgressRepository;

  int _currentIndex = 0;
  late IDrawingCanvasViewModel _drawingCanvasViewModel;
  Result _tracingResult = Result.none;
  Future<String>? _currentCharacterSvg;
  int _characterLength = 0;
  late List<Character> _characters;
  final List<Result> _results = [];

  PracticeViewModel({
    required ICharacterRepository characterRepository,
    required IModelPredictionService modelService,
    required IImageProcessingService imageProcessingService,
    required IDrawingAnalyzerService drawingAnalyzerService,
    required IKanjiRepository kanjiRepository,
    required IConfigurationService configurationService,
    required UserProgressRepository userProgressRepository,
  }) :
    _characterRepository = characterRepository,
    _modelService = modelService,
    _imageProcessingService = imageProcessingService,
    _drawingAnalyzerService = drawingAnalyzerService,
    _kanjiRepository = kanjiRepository,
    _configurationService = configurationService,
    _userProgressRepository = userProgressRepository;
  
  @override
  Future<void> init() async {
    if (_configurationService.selectedSet == null) {
      throw Exception('No character set selected');
    }
    _characters = await _characterRepository.getCharactersBySetId(
      _configurationService.selectedSet!.id
    );
    _characterLength = _characters.length;
  }

  @override
  void attachDrawingVM(IDrawingCanvasViewModel vm) {
    _drawingCanvasViewModel = vm;
  }

  @override
  String get currentCharacter =>
   _characters[_currentIndex].glyph;

  @override
  String get currentMeaning =>
    _characters[_currentIndex].meaning.replaceAll('|', ', ');

  @override
  Result get tracingResult => _tracingResult;

  Future<String>? get currentCharacterSvg => _currentCharacterSvg;

  @override
  void previous() async {
    clear();
    _currentIndex = (_currentIndex - 1 + _characterLength) % _characterLength;
    notifyListeners();
  }

  @override
  void next(BuildContext context) async {
    clear();

    if (_currentIndex + 1 >= _characterLength) {
      await _userProgressRepository.addUserProgress(
        _characters,
        _results,
        _configurationService.selectedSet!.id,
        ProgressMode.practice,
        
      );
      // _currentIndex = 0;
      // _results.clear();

      goToResults(context);
    } else {
      _currentIndex++;
    }

    notifyListeners();
  }

  void goToResults(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/results',
      arguments: {
        'setId': _configurationService.selectedSet!.id,
        'mode': ProgressMode.practice,
      },
    );
  }

  @override
  void check() async {
    List<List<Offset>> expectedStrokes = _drawingCanvasViewModel.strokes;

    final character = _characters[_currentIndex];
    final svgPathData = await _kanjiRepository.getSvgByKanji(character.glyph);
    final result =  _drawingAnalyzerService.compare(expectedStrokes, svgPathData);

    _tracingResult = result ? Result.correct : Result.incorrect;

    _results.add(_tracingResult);
  
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
      _tracingResult = Result.correct;
    } else {
      _tracingResult = Result.incorrect;
    }
    
    notifyListeners();
  }

  @override
  void clear() {
    _tracingResult = Result.none;
    _drawingCanvasViewModel.clear();
    notifyListeners();
  }

  @override
  void showHint() async {
    _currentCharacterSvg =
      _kanjiRepository.getSvgByKanji(currentCharacter);
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1000), () {
      _currentCharacterSvg = null;
      notifyListeners();
    });
  }
}
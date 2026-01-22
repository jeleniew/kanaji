import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kanaji/domain/entities/character.dart';
import 'package:kanaji/domain/entities/result.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';
import 'package:path_provider/path_provider.dart';


class CompareViewmodel extends IWritingViewModel{
  final ICharacterRepository _characterRepository;
  final IModelPredictionService _modelService;
  final IImageProcessingService _imageProcessingService;
  final IDrawingAnalyzerService _drawingAnalyzerService;
  final IKanjiRepository _kanjiRepository;
  final IConfigurationService _configurationService;
  
  late IDrawingCanvasViewModel _drawingCanvasViewModel;
  Result _tracingResult = Result.none;
  int _currentIndex = 0;
  late Future<String> _currentCharacterSvg;
  int _characterLength = 0;
  late List<Character> _characters;

  
  CompareViewmodel({
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
  Result get tracingResult => _tracingResult;

  @override
  void previous() {
    clear();
    _currentIndex = (_currentIndex - 1 + _characterLength) % _characterLength;
    print('Previous index: $_currentIndex');
    notifyListeners();
  }

  @override
  void next(BuildContext context) {
    clear();
    _currentIndex = (_currentIndex + 1) % _characterLength;
    print('Next index: $_currentIndex');
    notifyListeners();
  }

  @override
  void check() async {
    bool analyticResult = await analytic();
    String aiResult = await ai();

    String line = '$currentCharacter,$analyticResult,$aiResult\n';

    // Pobranie folderu aplikacji
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/results.csv';

    // Zapis do pliku (dopisywanie na końcu)
    final file = File(path);
    await file.writeAsString(line, mode: FileMode.append);

    print('Expected: $currentCharacter, Analytic result: $analyticResult, AI result: $aiResult');
    print('Saved to $path');

    if (analyticResult && aiResult == currentCharacter) {
      _tracingResult = Result.correct;
    } else {
      _tracingResult = Result.incorrect;
    }
    
    print('Analytic result: $analyticResult, AI result: $aiResult');
    notifyListeners();
  }

  Future<bool> analytic() async {
    List<List<Offset>> expectedStrokes = _drawingCanvasViewModel.strokes;

    final character = _characters[_currentIndex];
    print('Checking character: ${character.glyph}');
    final svgPathData = await _kanjiRepository.getSvgByKanji(character.glyph);
    final result = _drawingAnalyzerService.compare(expectedStrokes, svgPathData);

    return result;
  }

  Future<String> ai() async {
    List<List<Offset>> strokes = _drawingCanvasViewModel.strokes;
    final image = await _imageProcessingService.convertPointsToImage(strokes, Size(128, 127));
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Float32List floatInput =
      await _imageProcessingService.processImage(byteData!);

    final result = _modelService.predictAllModels(
      floatInput,
      _characterRepository.getCurrentCharacterType()
    );

    return (await result)[0];
  }


  @override
  void checkAI() async {
  }

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
  void showHint() {
    clear();
    _currentIndex = (_currentIndex + 1) % _characterLength;
    print('Next index: $_currentIndex');
    notifyListeners();
  }

  @override
  void clear() {
    _tracingResult = Result.none;
    _drawingCanvasViewModel.clear();
    notifyListeners();
  }
}
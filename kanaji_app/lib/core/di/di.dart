// di.dart

import 'package:get_it/get_it.dart';
import 'package:kanaji/data/repositories/kanji_repository.dart';
import 'package:kanaji/data/services/configuration_service.dart';
import 'package:kanaji/data/services/drawing_analyzer_service.dart';
import 'package:kanaji/data/services/image_processing_service.dart';
import 'package:kanaji/data/services/model_service.dart';
import 'package:kanaji/data/repositories/character_repository.dart';
import 'package:kanaji/data/repositories/route_repository.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';

class DI {
  final getIt = GetIt.instance;

  void initDI() {
    getIt.registerLazySingleton<IRouteRepository>(() => RouteRepository());
    getIt.registerLazySingleton<ICharacterRepository>(() => CharacterRepository());
    getIt.registerLazySingleton<IModelPredictionService>(() => ModelPredictionService());
    getIt.registerLazySingleton<IImageProcessingService>(() => ImageProcessingService());
    getIt.registerLazySingleton<IDrawingAnalyzerService>(() => DrawingAnalyzerService());
    getIt.registerLazySingleton<IKanjiRepository>(() => KanjiRepository());
    getIt.registerLazySingleton<IConfigurationService>(() => ConfigurationService());
  }
}
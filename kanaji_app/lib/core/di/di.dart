// di.dart

import 'package:get_it/get_it.dart';
import 'package:kanaji/data/datasources/character_data_source.dart';
import 'package:kanaji/data/helpers/database_helper.dart';
import 'package:kanaji/data/repositories/kanji_repository.dart';
import 'package:kanaji/data/repositories/user_progress_repository.dart';
import 'package:kanaji/data/services/configuration_service.dart';
import 'package:kanaji/data/services/drawing_analyzer_service.dart';
import 'package:kanaji/data/services/image_processing_service.dart';
import 'package:kanaji/data/services/model_service.dart';
import 'package:kanaji/data/repositories/character_repository.dart';
import 'package:kanaji/data/repositories/route_repository.dart';
import 'package:kanaji/data/services/strokes_analyzer_service.dart';
import 'package:kanaji/domain/helpers/i_database_helper.dart';
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

    getIt.registerLazySingleton<IConfigurationService>(() => ConfigurationService());
    getIt.registerLazySingleton<IRouteRepository>(() => RouteRepository());
    
    getIt.registerLazySingleton<IDatabaseHelper>(() => DatabaseHelper());
    getIt.registerLazySingleton<UserProgressRepository>(() => UserProgressRepository(
      getIt<IDatabaseHelper>(),
      getIt<IConfigurationService>(),
    ));
    getIt.registerLazySingleton<ICharacterRepository>(() => CharacterRepository(
      configurationService: getIt<IConfigurationService>(),
      databaseHelper: getIt<IDatabaseHelper>(),
    ));
    getIt.registerLazySingleton<IModelPredictionService>(() => ModelPredictionService());
    getIt.registerLazySingleton<IImageProcessingService>(() => ImageProcessingService());
    // getIt.registerLazySingleton<IDrawingAnalyzerService>(() => DrawingAnalyzerService());
    getIt.registerLazySingleton<IDrawingAnalyzerService>(() => StrokesAnalyzerService());
    getIt.registerLazySingleton<IKanjiRepository>(() => KanjiRepository());
  }
}
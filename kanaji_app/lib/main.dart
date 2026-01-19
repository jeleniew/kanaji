// main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanaji/core/di/di.dart';
import 'package:kanaji/data/repositories/user_progress_repository.dart';
import 'package:kanaji/data/services/model_service.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';
import 'package:kanaji/presentation/viewmodels/app_drawer_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/create_dataset_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/datasets_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/flashcards_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_configuration_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_create_dataset_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_datasets_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_flashcards_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_home_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/home_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/configuration_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_select_characters_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_test_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/result_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/select_characters_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/test_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/tracing_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/practice_viewmodel.dart';
import 'package:kanaji/presentation/views/create_dataset_page.dart';
import 'package:kanaji/presentation/views/datasets_page.dart';
import 'package:kanaji/presentation/views/home_page.dart';
import 'package:kanaji/presentation/views/configuration_page.dart';
import 'package:kanaji/presentation/views/result_page.dart';
import 'package:kanaji/presentation/views/select_characters_page.dart';
import 'package:kanaji/presentation/views/test_page.dart';
import 'package:kanaji/presentation/views/tracing_page.dart';
import 'package:kanaji/presentation/views/practice_page.dart';
import 'package:provider/provider.dart';
import 'presentation/views/flashcards_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await ModelPredictionService().init();
  } else {
    print("AI does not work on desktop.");
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  DI().initDI();

  runApp(
    // TODO: user context.watch insead of provider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppDrawerViewModel(
            routeRepository: DI().getIt<IRouteRepository>()
          ),
        ),
        ChangeNotifierProvider<IHomeViewModel>(
          create: (_) => HomeViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            userProgressRepository: DI().getIt<UserProgressRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider<IFlashcardsViewModel>(
          create: (_) => FlashcardsViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            configurationService: DI().getIt<IConfigurationService>(),
          ),
        ),
        ChangeNotifierProvider<IConfigurationViewModel>(
          create: (_) => ConfigurationViewModel(
            configurationService: DI().getIt<IConfigurationService>(),
            characterRepository: DI().getIt<ICharacterRepository>(),
          ),
        ),
        ChangeNotifierProvider<TracingViewModel>(
          create: (_) => TracingViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            modelService: DI().getIt<IModelPredictionService>(),
            imageProcessingService: DI().getIt<IImageProcessingService>(),
            drawingAnalyzerService: DI().getIt<IDrawingAnalyzerService>(),
            kanjiRepository: DI().getIt<IKanjiRepository>(),
            configurationService: DI().getIt<IConfigurationService>(),
          ),
        ),
        ChangeNotifierProvider<PracticeViewModel>(
          create: (_) => PracticeViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            modelService: DI().getIt<IModelPredictionService>(),
            imageProcessingService: DI().getIt<IImageProcessingService>(),
            drawingAnalyzerService: DI().getIt<IDrawingAnalyzerService>(),
            kanjiRepository: DI().getIt<IKanjiRepository>(),
            configurationService: DI().getIt<IConfigurationService>(),
            userProgressRepository: DI().getIt<UserProgressRepository>(),
          ),
        ),
        ChangeNotifierProvider<IDatasetsViewmodel>(
          create: (_) => DatasetsViewmodel(
            characterRepository: DI().getIt<ICharacterRepository>(),
          ),
        ),
        ChangeNotifierProvider<ICreateDatasetViewModel>(
          create: (_) => CreateDatasetViewmodel(
            characterRepository: DI().getIt<ICharacterRepository>(),
          ),
        ),
        ChangeNotifierProvider<ISelectCharactersViewmodel>(
          create: (_) => SelectCharactersViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
          ),
        ),
        ChangeNotifierProvider<ResultViewmodel>(
          create: (_) => ResultViewmodel(
            DI().getIt<UserProgressRepository>(),
          ),
        ),
        ChangeNotifierProvider<ITestViewmodel>(
          create: (_) => TestViewmodel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            userProgressRepository: DI().getIt<UserProgressRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final set = context.watch<IConfigurationViewModel>().selectedSet;
    final title = switch (set?.type) {
      CharacterType.hiragana => ' - Hiragana',
      CharacterType.katakana => ' - Katakana',
      CharacterType.kanji => ' - Kanji',
      null => '',
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'Home'),
        '/tracing_configuration': (context) => ConfigurationPage(
          "Tracing",
          '/tracing',
        ),  // TODO: title
        '/tracing': (context) => TracingPage(title: 'Tracing$title'),
        '/flashcards_configuration': (context) => ConfigurationPage(
          "Flashcards",
          '/flashcards',
        ),
        '/flashcards': (context) => FlashcardsPage(title: 'Flashcards$title'),
        '/memory_practice_configuration': (context) => ConfigurationPage(
          "Memory Practice",
          '/memory_practice',
        ),
        '/memory_practice': (context) => PracticePage(title: 'Memory Practice$title'),
        '/datasets': (context) => DatasetsPage(title: 'Datasets'),
        '/create-dataset': (context) => const CreateDatasetPage(),
        '/select_characters': (context) => const SelectCharactersPage(),
        '/results': (context) => ResultPage(),
        '/test_configuration': (context) => ConfigurationPage(
          "Test",
          '/test',
        ),
        '/test': (context) => TestPage(),
      },
    );
  }
}

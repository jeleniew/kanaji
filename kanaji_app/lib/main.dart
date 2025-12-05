// main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanaji/core/di/di.dart';
import 'package:kanaji/data/services/model_service.dart';
import 'package:kanaji/domain/entities/training_mode.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/repositories/i_kanji_repository.dart';
import 'package:kanaji/domain/services/i_configuration_service.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';
import 'package:kanaji/presentation/viewmodels/app_drawer_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/flashcards_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_configuration_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_flashcards_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_home_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_tracing_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/home_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/configuration_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/tracing_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/writing_viewmodel.dart';
import 'package:kanaji/presentation/views/home_page.dart';
import 'package:kanaji/presentation/views/configuration_page.dart';
import 'package:kanaji/presentation/views/tracing_page.dart';
import 'package:kanaji/presentation/views/writing_page.dart';
import 'package:provider/provider.dart';
import 'presentation/views/flashcards_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await ModelPredictionService().init();
    DI().initDI();
  } else {
    print("AI does not work on desktop.");
  }

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
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider<IFlashcardsViewModel>(
          create: (_) => FlashcardsViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
          ),
        ),
        ChangeNotifierProvider<IConfigurationViewModel>(
          create: (_) => ConfigurationViewModel(
            configurationService: DI().getIt<IConfigurationService>(),
          ),
        ),
        ChangeNotifierProvider<ITracingViewModel>(
          create: (_) => TracingViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            modelService: DI().getIt<IModelPredictionService>(),
            imageProcessingService: DI().getIt<IImageProcessingService>(),
            drawingAnalyzerService: DI().getIt<IDrawingAnalyzerService>(),
            kanjiRepository: DI().getIt<IKanjiRepository>(),
          ),
        ),
        ChangeNotifierProvider<IDrawingCanvasViewModel>(
          create: (_) => DrawingCanvasViewModel()
        ),
        ChangeNotifierProvider<IWritingViewModel>(
          create: (_) => WritingViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            modelService: DI().getIt<IModelPredictionService>(),
            imageProcessingService: DI().getIt<IImageProcessingService>(),
            drawingAnalyzerService: DI().getIt<IDrawingAnalyzerService>(),
            kanjiRepository: DI().getIt<IKanjiRepository>(),
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
    final mode = context.watch<IConfigurationViewModel>().selectedMode;
    final title = switch (mode) {
      TrainingMode.hiragana => ' - Hiragana',
      TrainingMode.katakana => ' - Katakana',
      TrainingMode.kanji => ' - Kanji',
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
          "Writing Practice",
          '/writing',
        ),
        '/memory_practice': (context) => WritingPage(title: 'Memory Practice$title'),
        // '/quiz': (context) => QuizPage(title: 'Quiz Page'),
      },
    );
  }
}

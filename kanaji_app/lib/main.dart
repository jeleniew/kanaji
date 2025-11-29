// main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanaji/core/di/di.dart';
import 'package:kanaji/data/services/model_service.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/domain/services/i_drawing_analyzer_service.dart';
import 'package:kanaji/domain/services/i_image_processing_service.dart';
import 'package:kanaji/domain/services/i_model_prediction_service.dart';
import 'package:kanaji/domain/repositories/i_route_repository.dart';
import 'package:kanaji/presentation/viewmodels/app_drawer_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/flashcards_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_flashcards_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_home_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_tracing_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_writing_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/home_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/tracing_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/writing_viewmodel.dart';
import 'package:kanaji/presentation/views/home_page.dart';
import 'package:kanaji/presentation/views/tracing_page.dart';
import 'package:kanaji/presentation/views/writing_page.dart';
import 'package:provider/provider.dart';
import 'presentation/views/flashcards_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    DI().initDI();
    await ModelPredictionService().init(DI().getIt<IImageProcessingService>());
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
        ChangeNotifierProvider<ITracingViewModel>(
          create: (_) => TracingViewModel(
            characterRepository: DI().getIt<ICharacterRepository>(),
            modelService: DI().getIt<IModelPredictionService>(),
            imageProcessingService: DI().getIt<IImageProcessingService>(),
            drawingAnalyzerService: DI().getIt<IDrawingAnalyzerService>(),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'Home'),
        '/tracing': (context) => TracingPage(title: 'Tracing Page'),
        '/flashcards': (context) => FlashcardsPage(title: 'FlashCards'),
        '/memory_practice': (context) => WritingPage(title: 'Writing Practice'),
      },
    );
  }
}

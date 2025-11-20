// main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanaji/services/model_service.dart';
import 'package:kanaji/viewmodels/drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/flashcards_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_drawing_canvas_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_flashcards_viewmodel.dart';
import 'package:kanaji/viewmodels/interfaces/i_tracing_viewmodel.dart';
import 'package:kanaji/viewmodels/tracing_viewmodel.dart';
import 'package:kanaji/views/tracing_page.dart';
import 'package:kanaji/views/widgets/drawing_canvas.dart';
import 'package:provider/provider.dart';
import 'views/flashcards_page.dart';
import 'package:kanaji/pages/memory_practice_page.dart';
// import 'package:kanaji/pages/second_page.dart';

import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await ModelService().init();
  } else {
    print("AI does not work on desktop.");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<IFlashcardsViewModel>(
          create: (_) => FlashcardsViewModel(),
        ),
        ChangeNotifierProvider<ITracingViewModel>(
          create: (_) => TracingViewModel(),
        ),
        ChangeNotifierProvider<IDrawingCanvasViewModel>(
          create: (_) => DrawingCanvasViewModel()
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
        '/': (context) => HomePage(),
        '/tracing': (context) => TracingPage(),
        '/flashcards': (context) => FlashcardsPage(),
        '/memory_practice': (context) => MemoryPracticePage(),
      },
      builder: (context, child) {
        return SafeArea(
          bottom: true,
          top: false,
          child: child!,
          );
      },
    );
  }
}

// main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kanaji/model_service.dart';
import 'package:kanaji/pages/flashcards_page.dart';
import 'package:kanaji/pages/memory_practice_page.dart';
import 'package:kanaji/pages/second_page.dart';

import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await ModelService().init();
  } else {
    print("AI does not work on desktop.");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/second': (context) => SecondPage(),
        '/flashcards': (context) => FlashcardsPage(),
        '/memory_practice': (context) => MemoryPracticePage(),
      },
    );
  }
}

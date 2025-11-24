// home_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/pages/base_page.dart';

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      body: const Center(
        child: Text(
          '世こそ!',
          style: TextStyle(
            fontSize: 64,
          ),
        ),
      ),
    );
  }
}
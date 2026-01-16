// base_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/presentation/views/app_drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  const BasePage({super.key, required this.title, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: body,
      ),
      drawer: const AppDrawer(),
      floatingActionButton: floatingActionButton,
    );
  }
}
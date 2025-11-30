// base_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/presentation/views/app_drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget body;
  const BasePage({super.key, required this.title, required this.body});

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
    );
  }
}
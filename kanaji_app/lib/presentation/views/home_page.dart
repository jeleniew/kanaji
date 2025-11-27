// home_page.dart
import 'package:flutter/material.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_home_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IHomeViewModel>(context);

    return BasePage(
      title: title,
      body: Center(
        child: Text(
          vm.greeting,
          style: const TextStyle(
            fontSize: 64,
          ),
        ),
      ),
    );
  }
}
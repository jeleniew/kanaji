// configuration_page.dart

import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/training_mode.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_configuration_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatelessWidget {
  final String title;
  final String nextRoute;
  const ConfigurationPage(this.title, this.nextRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IConfigurationViewModel>(context);
    
    return BasePage(
      // TODO: maybe show title of next view
      title: title,
      body: Column(
        children: [
          Expanded(
            child: 
            ListView(
              children: [
                ...TrainingMode.values.map((mode) {
                  return RadioListTile<TrainingMode>(
                      title: Text(mode.displayName),
                      value: mode,
                      groupValue: vm.selectedMode,
                      onChanged: (selectedMode) => vm.selectMode(selectedMode!),
                    );
                }),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => vm.startTraining(context, nextRoute),
            child: Text('Start'),
          ),
        ],
      ),
    );
  }
}
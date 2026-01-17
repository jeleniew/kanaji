// configuration_page.dart

import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character_set.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_configuration_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatefulWidget {
  final String title;
  final String nextRoute;

  const ConfigurationPage(this.title, this.nextRoute, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ConfigurationPageState();
  }
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  late Future<List<CharacterSet>> _setsFuture;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<IConfigurationViewModel>(context, listen: false);
    _setsFuture = vm.allSets;
  }
  
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IConfigurationViewModel>(context, listen: false);
    
    return BasePage(
      title: widget.title,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<CharacterSet>>(
              future: _setsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final sets = snapshot.data;

                if (sets == null || sets.isEmpty) {
                  return const Center(
                    child: Text('No character sets available.'),
                  );
                }
                 
                return ListView.builder(
                  itemCount: sets.length,
                  itemBuilder: (context, snapshot) {
                    final set = sets[snapshot];
                    return RadioListTile<CharacterSet>(
                      title: Text(set.name),
                      value: set,
                      groupValue: vm.selectedSet,
                      onChanged: (selectedSet) => vm.selectSet(selectedSet!),
                    );
                  },
                );
              }
            ),
          ),
          ElevatedButton(
            onPressed: () => vm.startTraining(context, widget.nextRoute),
            child: Text('Start'),
          ),
        ],
      ),
    );
  }
}
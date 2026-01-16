import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_create_dataset_viewmodel.dart';
import 'package:kanaji/presentation/views/base_page.dart';
import 'package:provider/provider.dart';

class CreateDatasetPage extends StatelessWidget {
  const CreateDatasetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ICreateDatasetViewModel>(context);

    return BasePage(
      title: 'Create Dataset',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Dataset Title'),
            TextField(
              decoration: InputDecoration(hintText: 'Title'),
              onChanged: vm.setDatasetTitle,
            ),
            Text('Dataset Description'),
            TextField(
              decoration: InputDecoration(hintText: 'Description'),
              onChanged: vm.setDatasetDescription,
            ),
            Column(
              children: CharacterType.values.map((type) {
                return RadioListTile<CharacterType>(
                  title: Text(type.displayName),
                  value: type,
                  groupValue: vm.selectedType,
                  onChanged: (selectedType) =>
                      vm.setSelectedType(selectedType!),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: vm.createDataset,
              child: Text('Create Dataset'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_create_dataset_viewmodel.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_select_characters_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateDatasetViewmodel extends ICreateDatasetViewModel {
  String _datasetTitle = '';
  String _datasetDescription = '';
  CharacterType? _selectedType;

  CreateDatasetViewmodel({
    required ICharacterRepository characterRepository,
  });

  @override
  String get datasetTitle => _datasetTitle;

  @override
  void setDatasetTitle(String title) {
    _datasetTitle = title;
    notifyListeners();
  }

  @override
  String get datasetDescription => _datasetDescription;

  @override
  void setDatasetDescription(String description) {
    _datasetDescription = description;
    notifyListeners();
  }

  @override
  CharacterType? get selectedType => _selectedType;

  @override
  void setSelectedType(CharacterType selectedType) {
    _selectedType = selectedType;
    notifyListeners();
  }

  @override
  void createDataset(BuildContext context) {
    if (_datasetTitle.isEmpty || _selectedType == null) {
      // TODO: handle this
      throw Exception('Dataset title and type must be provided.');
    }

    final selectVM = Provider.of<ISelectCharactersViewmodel>(context, listen: false);
    selectVM.setDatasetInfo(
      title: _datasetTitle,
      description: _datasetDescription,
      characterType: _selectedType!,
    );

    Navigator.of(context).pushNamed('/select_characters');
  }
}


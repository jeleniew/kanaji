import 'package:kanaji/domain/entities/character_type.dart';
import 'package:kanaji/domain/repositories/i_character_repository.dart';
import 'package:kanaji/presentation/viewmodels/interfaces/i_create_dataset_viewmodel.dart';

class CreateDatasetViewmodel extends ICreateDatasetViewModel {
  final ICharacterRepository _characterRepository;
  String _datasetTitle = '';
  String _datasetDescription = '';
  CharacterType? _selectedType;

  CreateDatasetViewmodel({
    required ICharacterRepository characterRepository,
  }) : _characterRepository = characterRepository;

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
  void createDataset() {
    if (_datasetTitle.isEmpty || _selectedType == null) {
      // TODO: handle this
      throw Exception('Dataset title and type must be provided.');
    }

    // _characterRepository.createCharacterSet(
    //   title: _datasetTitle,
    //   description: _datasetDescription,
    //   type: _selectedType!,
    // );

// TODO: navigate to next page
  }
}


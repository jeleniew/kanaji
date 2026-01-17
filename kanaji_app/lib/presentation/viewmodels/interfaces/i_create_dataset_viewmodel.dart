import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character_type.dart';

abstract class ICreateDatasetViewModel extends ChangeNotifier {
  String get datasetTitle;
  void setDatasetTitle(String title);
  String get datasetDescription;
  void setDatasetDescription(String description);
  CharacterType? get selectedType;
  void setSelectedType(CharacterType selectedType);
  void createDataset(BuildContext context);
}
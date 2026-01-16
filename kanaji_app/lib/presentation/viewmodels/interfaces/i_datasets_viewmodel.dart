import 'package:flutter/material.dart';
import 'package:kanaji/domain/entities/character_set.dart';

abstract class IDatasetsViewmodel extends ChangeNotifier {
  Future<List<CharacterSet>> getAvailableCharacterSets();
}
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/kanaji.db';
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE characters (
        id INTEGER PRIMARY KEY,
        glyph TEXT UNIQUE NOT NULL,
        meaning TEXT NOT NULL,
        readings TEXT,
        type TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE character_sets (
        id INTEGER PRIMARY KEY,
        name TEXT UNIQUE NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE character_set_items (
        id INTEGER PRIMARY KEY,
        character_set_id INTEGER NOT NULL,
        character_id INTEGER NOT NULL,
        FOREIGN KEY (character_set_id) REFERENCES character_sets(id),
        FOREIGN KEY (character_id) REFERENCES characters(id)
      )
    ''');

    await _insertInitialSets(db);
  }

  Future<void> _insertInitialSets(Database db) async {
    final sets = [
      {'name': 'Hiragana', 'file': 'assets/initial_data/hiragana.json', 'type': 'hiragana'},
      {'name': 'Katakana', 'file': 'assets/initial_data/katakana.json', 'type': 'katakana'},
      {'name': 'Kanji', 'file': 'assets/initial_data/kanji.json', 'type': 'kanji'},
    ];

    for (var set in sets) {
      final name = set['name']!;
      final file = set['file']!;
      final type = set['type']!;

      final setId = await db.insert('character_sets', {
        'name': name,
        'description': 'Initial $name set',
      });

      final jsonString = await rootBundle.loadString(file);
      final List<dynamic> characters = json.decode(jsonString);

      for (var char in characters) {
        final charId = await db.insert('characters', {
          'glyph': char['glyph'],
          'meaning': char['meaning'],
          'readings': char['readings'] != null ? json.encode(char['readings']) : null,
          'type': type,
        });

        await db.insert('character_set_items', {
          'character_set_id': setId,
          'character_id': charId,
        });
      }
    }
  }
}
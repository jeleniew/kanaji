import 'package:sqflite/sqflite.dart';

abstract class IDatabaseHelper {
  Future<Database> get database; 
}
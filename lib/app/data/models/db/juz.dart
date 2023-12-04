import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseManager {
  DatabaseManager._private();

  static DatabaseManager instance = DatabaseManager._private();

  Database? _dbJuz;

  Future<Database> get db async {
    _dbJuz ??= await _initDB();

    return _dbJuz!;
  }

  Future _initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();

    String path = join(docDir.path, "juz.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        return await database.execute('''
            CREATE TABLE bookmark (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              juz INT NOT NULL,
              start_surah TEXT NOT NULL,
              start_ayat INTEGER NOT NULL,
              end_surah TEXT NOT NULL,
              end_ayat INTEGER NOT NULL
            )
          ''');
      },
    );
  }

  Future closeDB() async {
    _dbJuz = await instance.db;
    _dbJuz!.close();
  }
}

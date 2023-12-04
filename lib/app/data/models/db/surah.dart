import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseManager {
  DatabaseManager._private();

  static DatabaseManager instance = DatabaseManager._private();

  Database? _dbSurah;

  Future<Database> get db async {
    _dbSurah ??= await _initDB();

    return _dbSurah!;
  }

  Future _initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();

    String path = join(docDir.path, "surah.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        return await database.execute('''
            CREATE TABLE bookmark (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              surah TEXT NOT NULL,
              number_surah INTEGER NOT NULL,
              number_of_verse INTEGER NOT NULL,
              revelation TEXT NOT NULL
            )
          ''');
      },
    );
  }

  Future closeDB() async {
    _dbSurah = await instance.db;
    _dbSurah!.close();
  }
}

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stocks/screen/search/sql/Suggestions/suggestions_model_class.dart';

final container = ProviderContainer();

class SuggestionsDBHelper {
  static const _databaseName = "flutDB.db";
  static const _databaseVersion = 1;
  static const table = 'tbl_search_history';

  static const id = 1;
  static const stCol1 = "company_symbol";
  static const stCol2 = "company_name";

  // make this a singleton class
  SuggestionsDBHelper._privateConstructor();
  static final SuggestionsDBHelper instance =
      SuggestionsDBHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id TEXT PRIMARY KEY, $stCol1 TEXT,$stCol2 TEXT
           )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.

  Future<bool> insert(SuggestionsModelClass row) async {
    // Get a reference to the database.
    final Database db = await database;
    log('reached here');
    try {
      await db.insert(
        table,
        row.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log('Db Inserted');
      return true;
    } catch (e) {
      log('DbException$e');
      return false;
    }
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryFilterRows() async {
    Database db = await instance.database;
    return await db.rawQuery("select * from $table where stCol2='111'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $table')) ??
        0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   int id = row[columnId];
  //   return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}

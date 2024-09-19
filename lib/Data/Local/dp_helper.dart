import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper _instance = DBHelper._();

  static DBHelper getInstance() {
    return _instance;
  }

  static const String tableName = "note";
  static const String columnNoteSNo = "s_no";
  static const String columnNoteTitle = "title";
  static const String columnNoteDesc = "desc";

  Database? _database;

  Future<Database> getDb() async {
    _database ??= await _openDB();
    return _database!;
  }

  Future<Database> _openDB() async {
    Directory appPath = await getApplicationDocumentsDirectory();
    String dbPath = join(appPath.path, "noteDB.db");
    return await openDatabase(dbPath, version: 1,
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE $tableName($columnNoteSNo INTEGER PRIMARY KEY AUTOINCREMENT, $columnNoteTitle TEXT, $columnNoteDesc TEXT)");
    });
  }

  Future<bool> addNote({
    required String mTitle,
    required String mDescribe,
  }) async {
    final db = await getDb();
    int rowEffected = await db.insert(tableName, {
      columnNoteTitle: mTitle,
      columnNoteDesc: mDescribe,
    });
    return rowEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await getDb();
    return await db.query(tableName);
  }

  Future<void> deleteDatabaseFile() async {
    Directory appPath = await getApplicationDocumentsDirectory();
    String dbPath = join(appPath.path, "noteDB.db");
    await deleteDatabase(dbPath);
  }

  Future<bool> update(
      {required String mTitle, required String mDes, required int sNo}) async {
    var db = await getDb();
    int rowEffected = await db.update(
        tableName, {columnNoteTitle: mTitle, columnNoteDesc: mDes},
        where: "$columnNoteSNo= ?", whereArgs: ["$sNo"]);
    return rowEffected > 0;
  }

  Future<bool> delete({required int sNo}) async {
    var db = await getDb();
    int rowEffected = await db
        .delete(tableName, where: "$columnNoteSNo= ?", whereArgs: ["$sNo"]);
    return rowEffected > 0;
  }
}

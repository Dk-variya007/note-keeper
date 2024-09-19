import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  //singleton
  static DBHelper getInstance() {
    return DBHelper._();
  }

  //table note
  static String tableName = "note";
  static String columnNoteSNo = "s_no";
  static String columnNoteTitle = "title";
  static String columnNoteDesc = "desc";

  //db open( path ->  if exits then open else create
  Database? myDB;

  //get database
  Future<Database> getDb() async {
    //myDB=myDB ?? await openDB();
    myDB ??= await openDB();
    return myDB!;
  }

  //open database
  Future<Database> openDB() async {
    Directory appPath = await getApplicationDocumentsDirectory();
    String dbPath = join(appPath.path, "noteDB.db");
    return await openDatabase(dbPath, onCreate: (db, version) {
      //create all your tables here
      db.execute(
          "create table $tableName($columnNoteSNo integer primary key autoincrement ,$columnNoteTitle text, $columnNoteDesc text ");
    }, version: 1);
  }

  //add value in table
  Future<bool> addNote(
      {required String mTitle, required String mDescribe}) async {
    var db = await getDb();
    int rowEffected = await db.insert(
        tableName, {columnNoteTitle: mTitle, columnNoteDesc: mDescribe});
    return rowEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDb();
    List<Map<String, dynamic>> mData = await db.query(tableName);
    return mData;
  }
}

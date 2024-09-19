import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notekepeer_using_sqllite/Data/Local/dp_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  late DBHelper dbRef;

  @override
  void initState() {
    super.initState();
    //deleteDatabaseFile(); // Call this only for debugging purposes
    dbRef = DBHelper.getInstance();
    getNotes();
  }

  // Future<void> deleteDatabaseFile() async {
  //   Directory appPath = await getApplicationDocumentsDirectory();
  //   String dbPath = join(appPath.path, "noteDB.db");
  //   await deleteDatabase(dbPath);
  // }

  // Fetch notes from the database
  void getNotes() async {
    allNotes = await dbRef.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: allNotes.isEmpty
          ? const Center(
              child: Text("NO Notes"),
            )
          : ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(allNotes[index][DBHelper.columnNoteTitle]),
                  leading:
                      Text(allNotes[index][DBHelper.columnNoteSNo].toString()),
                  subtitle: Text(allNotes[index][DBHelper.columnNoteDesc]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool check = await dbRef.addNote(
              mTitle: "Divyesh", mDescribe: "I am pursuing my BTech from AU");
          if (check) {
            getNotes(); // Refresh the list after adding a new note
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

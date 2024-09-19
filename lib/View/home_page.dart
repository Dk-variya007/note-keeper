import 'package:flutter/material.dart';
import 'package:notekepeer_using_sqllite/Data/Local/dp_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance();
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: allNotes.isNotEmpty
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
          bool check = await dbRef!.addNote(
              mTitle: "Divyesh", mDescribe: "I pursuing my BTech Form AU");
          if (check) {
            getNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

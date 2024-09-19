import 'package:flutter/material.dart';
import 'package:notekepeer_using_sqllite/Data/Local/dp_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  late DBHelper dbRef;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
          showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Allows the modal to resize with the keyboard
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Adjusts for the keyboard
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Ensures the modal adjusts to content size
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Add Note",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  label: const Text("Title"),
                                  hintText: "Enter Title Here",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11))),
                            ),
                          ),
                          const SizedBox(
                            height: 11,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextField(
                              maxLines: 4,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                  label: const Text("Description"),
                                  hintText: "Enter Description Here",
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11))),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    bool check = await dbRef.addNote(
                                        mTitle: titleController.text,
                                        mDescribe: descriptionController.text);
                                    if (check) {
                                      getNotes(); // Refresh the list after adding a new note
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    elevation: 4,
                                    // Control the shadow/elevation of the button
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12), // Adjust padding
                                  ),
                                  child: const Text("Add"),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../journal_entry.dart';

void main() {
  runApp(MaterialApp(
    home: JournalPage(),
  ));
}

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  void initState() {
    super.initState();
    journalBox = Hive.box<JournalEntry>('journalEntries');
  }

  late Box<JournalEntry> journalBox;
  Map<int, bool> showImageMap = {};

  TextEditingController opponentController = TextEditingController();
  TextEditingController winnerController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  File? image;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void addEntry() {
    final newEntry = JournalEntry(
      opponent: opponentController.text,
      winner: winnerController.text,
      notes: notesController.text,
      imagePath: image?.path,
    );
    journalBox.add(newEntry);

    opponentController.clear();
    winnerController.clear();
    notesController.clear();
    image = null;

    Navigator.of(context).pop();
    setState(() {}); // Refresh UI after adding an entry
  }


  @override
  Widget build(BuildContext context) {
    // Map to track visibility of each entry's image
    Map<int, bool> showImageMap = {};

    return Scaffold(
      appBar: AppBar(title: Text('Wizard Journal')),
      body: ListView.builder(
        itemCount: journalBox.length,
        itemBuilder: (context, index) {
          final entry = journalBox.getAt(index) as JournalEntry;

          // Ensure visibility state exists for this index
          if (!showImageMap.containsKey(index)) {
            showImageMap[index] = false;
          }

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Opponent: ${entry.opponent}', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Winner: ${entry.winner}'),
                  Text('Notes: ${entry.notes}'),
                  if (entry.imagePath != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showImageMap[index] = !(showImageMap[index] ?? false);
                        });
                      },
                      child: Text(showImageMap[index]! ? 'Hide Image' : 'Show Image'),
                    ),
                  if (entry.imagePath != null && (showImageMap[index] ?? false))
                    Image.file(File(entry.imagePath!)),
                ],
              ),
            ),
          );
        },
      ),

        floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Add Journal Entry'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: opponentController,
                          decoration: InputDecoration(labelText: 'Opponent')),
                      TextField(controller: winnerController,
                          decoration: InputDecoration(labelText: 'Winner')),
                      TextField(controller: notesController,
                          decoration: InputDecoration(labelText: 'Notes')),
                      SizedBox(height: 10),
                      image != null ? Image.file(image!) : SizedBox(),
                      ElevatedButton(
                          onPressed: pickImage, child: Text('Take Picture')),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel')),
                    TextButton(onPressed: addEntry, child: Text('Save')),
                  ],
                ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

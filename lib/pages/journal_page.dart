import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  List<Map<String, dynamic>> entries = [];
  TextEditingController opponentController = TextEditingController();
  TextEditingController winnerController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  File? image;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void addEntry() {
    setState(() {
      entries.add({
        'opponent': opponentController.text,
        'winner': winnerController.text,
        'notes': notesController.text,
        'image': image,
        'showImage': false, // Ensure this is always a boolean
      });
      opponentController.clear();
      winnerController.clear();
      notesController.clear();
      image = null;
    });
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wizard Journal')),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Opponent: ${entries[index]['opponent']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Winner: ${entries[index]['winner']}'),
                  Text('Notes: ${entries[index]['notes']}'),
                  if (entries[index]['image'] != null)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          entries[index]['showImage'] = !entries[index]['showImage'];
                        });
                      },
                      child: Text(entries[index]['showImage'] ? 'Hide Image' : 'Show Image'),
                    ),
                  if (entries[index]['image'] != null && entries[index]['showImage'])
                    Image.file(entries[index]['image']),
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
            builder: (context) => AlertDialog(
              title: Text('Add Journal Entry'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: opponentController, decoration: InputDecoration(labelText: 'Opponent')),
                  TextField(controller: winnerController, decoration: InputDecoration(labelText: 'Winner')),
                  TextField(controller: notesController, decoration: InputDecoration(labelText: 'Notes')),
                  SizedBox(height: 10),
                  image != null ? Image.file(image!) : SizedBox(),
                  ElevatedButton(onPressed: pickImage, child: Text('Take Picture')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
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

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';
import 'pages/chessboard_page.dart';
import 'pages/journal_page.dart';
import 'journal_entry.dart';

void main() async {
  // Ensure widgets are initialized properly
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open the box
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter()); // Register the adapter
  await Hive.openBox<JournalEntry>('journalEntries'); // Open the Hive box

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chizard',
      theme: ThemeData.dark(), // Preserve the dark theme
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => HomePage(), // Home page route
        '/chessboard': (context) => ChessboardPage(), // Chessboard page route
        '/journal': (context) => JournalPage(), // Journal page route
      },
    );
  }
}

class ChessboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Digital Chessboard")),
      body: Center(child: Text("Chessboard UI will be here")),
    );
  }
}
import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Import the new home page
import 'pages/chessboard_page.dart'; // You'll create this later
import 'pages/journal_page.dart'; // You'll create this later

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chizard',
      theme: ThemeData.dark(), // Apply dark theme
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/chessboard': (context) => ChessboardPage(),
        '/journal': (context) => new JournalPage(),
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
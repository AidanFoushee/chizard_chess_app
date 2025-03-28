import 'package:flutter/material.dart';

class ChessboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wizard Board")),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wizard_background.jpg"), // Ensure this image is in your assets
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Choose Your Magic:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text("Manually Create Chessboard"),
                onPressed: () {
                  Navigator.pushNamed(context, '/manualChessboard');
                },
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("Detect Board from Image"),
                onPressed: () {
                  Navigator.pushNamed(context, '/detectBoard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

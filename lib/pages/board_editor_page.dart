import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class BoardEditorPage extends StatefulWidget {
  const BoardEditorPage({super.key});

  @override
  _BoardEditorPageState createState() => _BoardEditorPageState();
}

class _BoardEditorPageState extends State<BoardEditorPage> {
  List<List<String>> board = List.generate(8, (_) => List.filled(8, ''));  // Empty board
  String currentFEN = "";  // Declare the FEN string

  final Map<String, String> pieceImages = {
    'K': 'assets/chess_pieces/wK.svg',
    'Q': 'assets/chess_pieces/wQ.svg',
    'R': 'assets/chess_pieces/wR.svg',
    'B': 'assets/chess_pieces/wB.svg',
    'N': 'assets/chess_pieces/wN.svg',
    'P': 'assets/chess_pieces/wP.svg',
    'k': 'assets/chess_pieces/bK.svg',
    'q': 'assets/chess_pieces/bQ.svg',
    'r': 'assets/chess_pieces/bR.svg',
    'b': 'assets/chess_pieces/bB.svg',
    'n': 'assets/chess_pieces/bN.svg',
    'p': 'assets/chess_pieces/bP.svg',
  };

  final List<String> whitePieces = ['K', 'Q', 'R', 'B', 'N', 'P'];
  final List<String> blackPieces = ['k', 'q', 'r', 'b', 'n', 'p'];

  @override
  void initState() {
    super.initState();
    board[0] = ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r']; // Black pieces
    board[1] = List.filled(8, 'p'); // Black pawns
    board[6] = List.filled(8, 'P'); // White pawns
    board[7] = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']; // White pieces
    updateFEN(); // Initialize FEN at startup
  }

  // Convert the board to a FEN string
  void updateFEN() {
    String fen = '';
    for (var row in board) {
      int emptyCount = 0;
      for (var square in row) {
        if (square.isEmpty) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            fen += emptyCount.toString();
            emptyCount = 0;
          }
          fen += square;
        }
      }
      if (emptyCount > 0) fen += emptyCount.toString();
      fen += '/';
    }
    setState(() {
      currentFEN = fen.substring(0, fen.length - 1); // Remove last "/"
    });
  }

  // Handle tap on a square to add, replace, or delete a piece
  void onSquareTap(int row, int col) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Piece'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("White Pieces", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                children: pieceImages.entries
                    .where((entry) => entry.key.toUpperCase() == entry.key) // White pieces
                    .map((entry) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        board[row][col] = entry.key;
                      });
                      updateFEN();
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      entry.value,
                      width: 40,
                      height: 40,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Text("Black Pieces", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                children: pieceImages.entries
                    .where((entry) => entry.key.toLowerCase() == entry.key) // Black pieces
                    .map((entry) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        board[row][col] = entry.key;
                      });
                      updateFEN();
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      entry.value,
                      width: 40,
                      height: 40,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    board[row][col] = ''; // Remove piece
                  });
                  updateFEN();
                  Navigator.pop(context);
                },
                child: const Text("Remove Piece", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    ); // <-- This closing parenthesis was missing
  }



  // Display the chessboard
  Widget buildBoard() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
      ),
      itemCount: 64,
      itemBuilder: (context, index) {
        final row = index ~/ 8;
        final col = index % 8;
        final piece = board[row][col];

        return GestureDetector(
          onTap: () => onSquareTap(row, col),
          child: Container(
            decoration: BoxDecoration(
              color: (row + col) % 2 == 0 ? Colors.white : Colors.black,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: piece.isNotEmpty && pieceImages.containsKey(piece)
                  ? SvgPicture.asset(
                pieceImages[piece]!,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              )

                  : null,
            ),
          ),
        );
      },
    );
  }

  // Send the FEN string to the backend (placeholder function)
  void sendFENToBackend() async {
    final url = Uri.parse(
        "http://10.0.2.2:8000/analyze_fen"); // Update with your actual backend URL

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fen": currentFEN}),
      );

      if (response.statusCode == 200) {
        print("✅ FEN successfully sent: ${response.body}");
      } else {
        print("❌ Failed to send FEN: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error sending FEN: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chessboard Editor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              height: 400,
              child: buildBoard(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendFENToBackend,
              child: const Text('Send FEN to Backend'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Current FEN: $currentFEN'),
            ),
          ],
        ),
      ),
    );
  }
}

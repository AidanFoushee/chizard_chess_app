import 'package:flutter/material.dart';

class BoardEditorPage extends StatefulWidget {
  const BoardEditorPage({super.key});

  @override
  _BoardEditorPageState createState() => _BoardEditorPageState();
}

class _BoardEditorPageState extends State<BoardEditorPage> {
  List<List<String>> board = List.generate(8, (_) => List.filled(8, '')); // Empty board
  String currentFEN = '';

  // The pieces for FEN notation
  final List<String> whitePieces = ['K', 'Q', 'R', 'B', 'N', 'P'];
  final List<String> blackPieces = ['k', 'q', 'r', 'b', 'n', 'p'];

  @override
  void initState() {
    super.initState();
    // Initialize the board with default pieces
    board[0] = ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r']; // Black pieces
    board[1] = List.filled(8, 'p'); // Black pawns
    board[6] = List.filled(8, 'P'); // White pawns
    board[7] = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']; // White pieces
    updateFEN();
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
                children: whitePieces.map((piece) {
                  return TextButton(
                    onPressed: () {
                      setState(() {
                        board[row][col] = piece;
                      });
                      updateFEN();
                      Navigator.pop(context);
                    },
                    child: Text(piece, style: const TextStyle(fontSize: 20)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Text("Black Pieces", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                children: blackPieces.map((piece) {
                  return TextButton(
                    onPressed: () {
                      setState(() {
                        board[row][col] = piece;
                      });
                      updateFEN();
                      Navigator.pop(context);
                    },
                    child: Text(piece, style: const TextStyle(fontSize: 20)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    board[row][col] = ''; // Delete piece
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
    );
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
              child: Text(
                piece,
                style: TextStyle(
                  color: piece == piece.toUpperCase() ? Colors.white : Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Send the FEN string to the backend (placeholder function)
  void sendFENToBackend() {
    print("Sending FEN to backend: $currentFEN");
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

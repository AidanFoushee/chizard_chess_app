import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DetectBoardPage extends StatefulWidget {
  @override
  _DetectBoardPageState createState() => _DetectBoardPageState();
}

class _DetectBoardPageState extends State<DetectBoardPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _uploadMessage = "";

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _uploadMessage = "Uploading...";
      });
      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.12:8000/upload/'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      setState(() {
        if (response.statusCode == 200) {
          _uploadMessage = "✅ Image uploaded successfully!";
        } else {
          _uploadMessage = "❌ Upload failed! Status: ${response.statusCode}\nResponse: $responseBody";
        }
      });

      print(_uploadMessage);
    } catch (e) {
      setState(() {
        _uploadMessage = "❌ Error uploading image: $e";
      });
      print(_uploadMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detect Board from Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!)
                : const Text("No image taken"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openCamera,
              child: const Text("Open Camera"),
            ),
            const SizedBox(height: 20),
            Text(
              _uploadMessage,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(),
    );
  }
}

Future<void> _uploadImage(File imageFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.1.3:8000/upload/'),
  );

  var file = await http.MultipartFile.fromPath('file', imageFile.path);
  request.files.add(file);

  try {
    // Send the request
    var response = await request.send();

    // success and error handling
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}


class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    // allows user to pick an image from their gallery rather than only allowing them to use the picture they take with their camera
    //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      _uploadImage(_image!); // send the image to upload image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!)  // Display the image
                : const Text("No image taken"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openCamera,
              child: const Text("Open Camera"),
            ),
          ],
        ),
      ),
    );
  }
}

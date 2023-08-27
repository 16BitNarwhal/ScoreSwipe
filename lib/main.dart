import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Player Dev',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fileText = "";

  final faceDetector =
      FaceDetector(options: FaceDetectorOptions(enableClassification: true));

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg'],
        allowMultiple: false);

    if (result != null && result.files.single.path != null) {
      // PlatformFile file = result.files.first;
      // print(file.name);
      // print(file.size);
      // print(file.extension);
      // print(file.path);

      File _file = File(result.files.single.path!);

      if (_file.path.endsWith('.png') || _file.path.endsWith('.jpg')) {
        InputImage _inputImage = InputImage.fromFile(_file);
        final List<Face> faces = await faceDetector.processImage(_inputImage);

        for (Face face in faces) {
          final double? rotX =
              face.headEulerAngleX; // Head is tilted up and down rotX degrees
          final double? rotY =
              face.headEulerAngleY; // Head is rotated to the right rotY degrees
          final double? rotZ =
              face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

          print('X: $rotX, Y: $rotY, Z: $rotZ');

          // If classification was enabled with FaceDetectorOptions:
          if (face.smilingProbability != null) {
            final double? smileProb = face.smilingProbability;
            print('Smile: $smileProb');
          }
        }
      }

      setState(() {
        _fileText = _file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _fileText == "" // TODO: make into separate widgets?
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Pick a file below:',
                  ),
                  ElevatedButton(
                      onPressed: _pickFile, child: const Text('Pick File')),
                  Text(_fileText),
                ],
              )
            : (_fileText.endsWith('.pdf')
                ? SfPdfViewer.file(File(_fileText))
                : Image.file(File(_fileText))),
      ),
    );
  }
}

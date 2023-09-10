import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:file_picker/file_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<CameraDescription> cameras;

  String fileText = "";
  bool turningPage = false;

  final faceDetector = FaceDetector(options: FaceDetectorOptions());

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result != null && result.files.single.path != null) {
      // PlatformFile file = result.files.first;

      File file = File(result.files.single.path!);
      fileText = file.path;

      if (context.mounted) {
        Navigator.pushNamed(context, '/pdfscreen',
            arguments: {'fileText': fileText});
      }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/configscreen');
            },
          ),
        ],
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: _pickFile, child: const Text('Pick File'))),
    );
  }
}

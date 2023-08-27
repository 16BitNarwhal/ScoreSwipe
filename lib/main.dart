import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result != null && result.files.single.path != null) {
      // PlatformFile file = result.files.first;
      // print(file.name);
      // print(file.size);
      // print(file.extension);
      // print(file.path);

      File _file = File(result.files.single.path!);
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
            : SfPdfViewer.file(File(_fileText)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfplayer/features/score_browser/data/local_score_datasource.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import './features/score_browser/models/score_model.dart';

import 'package:logger/logger.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  String base64 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Screen'),
      ),
      body: Center(
          child: base64 == ""
              ? ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result == null || result.files.isEmpty) {
                      print('No files selected');
                      return;
                    }

                    File file = File(result.files.single.path!);
                    ScoreModel? score = ScoreModel.fromPdfFile(file);
                    await LocalScoreDataSource.openDatabase();
                    await LocalScoreDataSource.insertScore(score);
                    score = await LocalScoreDataSource.getScore(score.id);

                    Logger().i(base64);
                    setState(() {
                      base64 = score!.pdfFile;
                    });
                  },
                  child: const Text('Button'),
                )
              : SfPdfViewer.memory(
                  Uint8List.fromList(base64Decode(base64)),
                )),
    );
  }
}

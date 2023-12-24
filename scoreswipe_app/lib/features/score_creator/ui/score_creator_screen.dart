import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_render/pdf_render.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:edge_detection/edge_detection.dart';

import 'package:pdfplayer/features/score_browser/bloc/score_browser_bloc.dart';

import 'package:logger/logger.dart';

class ScoreCreatorScreen extends StatefulWidget {
  const ScoreCreatorScreen({super.key});

  @override
  _ScoreCreatorScreenState createState() => _ScoreCreatorScreenState();
}

class _ScoreCreatorScreenState extends State<ScoreCreatorScreen> {
  List<File> images = [];
  int currentPage = 0;
  String scoreName = '';
  late Directory dir;

  @override
  void initState() {
    super.initState();
    dir = Directory.systemTemp.createTempSync();
  }

  @override
  void dispose() {
    super.dispose();
    dir.delete(recursive: true);
  }

  Future<void> openCamera() async {
    String imagePath = '${dir.path}/camera.jpeg';
    bool success = await EdgeDetection.detectEdge(
      imagePath,
      canUseGallery: true,
      androidScanTitle: 'Scanning', // use custom localizations for android
      androidCropTitle: 'Crop',
      androidCropBlackWhiteTitle: 'Black White',
      androidCropReset: 'Reset',
    );
    if (!success) return;
    setState(() {
      images.add(File(imagePath));
    });
  }

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;
    List<File> pickedImages = result.paths.map((path) => File(path!)).toList();
    setState(() {
      images.addAll(pickedImages);
    });
  }

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    File pdfFile = File(result.files.single.path!);
    PdfDocument pdfDocument = await PdfDocument.openFile(pdfFile.path);
    List<File> pickedImages = [];

    for (int i = 1; i <= pdfDocument.pageCount; i++) {
      PdfPage page = await pdfDocument.getPage(i);
      PdfPageImage pdfImage = await page.render();
      ui.Image image = await pdfImage.createImageDetached();
      ByteData? imgBytes =
          await image.toByteData(format: ui.ImageByteFormat.png);
      File imageFile = File('${dir.path}/$i.png');
      await imageFile.writeAsBytes(imgBytes!.buffer.asUint8List());
      pickedImages.add(imageFile);
    }

    setState(() {
      images.addAll(pickedImages);
    });
  }

  bool isValid() {
    return images.isNotEmpty && scoreName.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              color: const Color.fromARGB(255, 231, 238, 243),
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    controller: PageController(initialPage: currentPage),
                    onPageChanged: (int page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.file(images[index]);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        images.removeAt(currentPage);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete Page'),
                  ),
                ],
              ),
            ),
            PageIndicator(
              currentPage: currentPage,
              totalPages: images.length,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: openCamera,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Add From Camera'),
                ),
                ElevatedButton(
                  onPressed: pickImages,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Add Images'),
                ),
                ElevatedButton(
                  onPressed: pickPdf,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Import PDF'),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    scoreName = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Score Name',
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!isValid()) {
                  return;
                }

                if (context.mounted) {
                  BlocProvider.of<ScoreBrowserBloc>(context)
                      .add(AddScore(images, scoreName));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: (isValid() ? Colors.blue : Colors.grey),
              ),
              child: const Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          margin: const EdgeInsets.all(4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}

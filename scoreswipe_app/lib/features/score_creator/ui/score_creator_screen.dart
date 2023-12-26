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
import 'action_button.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              // height: double.infinity,
              child: Container(
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
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  PageIndicator(
                    currentPage: currentPage,
                    totalPages: images.length,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ActionButton(
                          onPressed: openCamera, text: 'Add From Camera'),
                      ActionButton(onPressed: pickImages, text: 'Add Images'),
                      ActionButton(onPressed: pickPdf, text: 'Import PDF'),
                      ActionButton(
                        onPressed: () {
                          setState(() {
                            images.removeAt(currentPage);
                          });
                        },
                        text: 'Delete Current Page',
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        backgroundColor: Theme.of(context).colorScheme.error,
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
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (!isValid()) {
                            return;
                          }

                          if (context.mounted) {
                            BlocProvider.of<ScoreBrowserBloc>(context)
                                .add(AddScore(images, scoreName));
                            // TODO: kind of temporary fix, it's better to use some navigation bloc or callback
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/mainscreen');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: (isValid()
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey),
                        ),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
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
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => Container(
            margin: const EdgeInsets.all(4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentPage
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

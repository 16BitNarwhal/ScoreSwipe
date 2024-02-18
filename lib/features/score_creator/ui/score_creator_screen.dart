import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_render/pdf_render.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:uuid/uuid.dart';

import 'package:score_swipe/features/score_browser/bloc/score_browser_bloc.dart';
import 'package:score_swipe/features/showcase/showcase_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'action_button.dart';

import 'package:logger/logger.dart';

class ScoreCreatorScreen extends StatefulWidget {
  const ScoreCreatorScreen({super.key});

  @override
  State<ScoreCreatorScreen> createState() => _ScoreCreatorScreenState();
}

class _ScoreCreatorScreenState extends State<ScoreCreatorScreen> {
  List<File> images = [];
  int currentPage = 0;
  String scoreName = '';
  bool isloading = false;
  bool isCreating = false;
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
    if (isCreating || isloading) return;
    setState(() {
      isloading = true;
    });
    String uuid = const Uuid().v4();
    String imagePath = '${dir.path}/$uuid.jpeg';
    bool success = await EdgeDetection.detectEdge(
      imagePath,
      canUseGallery: true,
      androidScanTitle: 'Scanning',
      androidCropTitle: 'Crop',
      androidCropBlackWhiteTitle: 'Black White',
      androidCropReset: 'Reset',
    );
    if (!success) {
      setState(() {
        isloading = false;
      });
      return;
    }
    setState(() {
      isloading = false;
      images.add(File(imagePath));
    });
  }

  Future<void> pickImages() async {
    if (isCreating || isloading) return;
    setState(() {
      isloading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) {
      setState(() {
        isloading = false;
      });
      return;
    }
    List<File> pickedImages = result.paths.map((path) => File(path!)).toList();
    setState(() {
      isloading = false;
      images.addAll(pickedImages);
    });
  }

  Future<void> pickPdf() async {
    if (isCreating || isloading) return;
    setState(() {
      isloading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      setState(() {
        isloading = false;
      });
      return;
    }

    File pdfFile = File(result.files.single.path!);
    PdfDocument pdfDocument = await PdfDocument.openFile(pdfFile.path);
    List<File> pickedImages = [];

    for (int i = 1; i <= pdfDocument.pageCount; i++) {
      PdfPage page = await pdfDocument.getPage(i);
      PdfPageImage pdfImage = await page.render();
      ui.Image image = await pdfImage.createImageDetached();
      ByteData? imgBytes =
          await image.toByteData(format: ui.ImageByteFormat.png);
      String uuid = const Uuid().v4();
      File imageFile = File('${dir.path}/$uuid}.png');
      await imageFile.writeAsBytes(imgBytes!.buffer.asUint8List());
      pickedImages.add(imageFile);
    }

    setState(() {
      isloading = false;
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    child: isloading
                        ? Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                                strokeWidth: 16.0,
                              ),
                            ),
                          )
                        : PageView.builder(
                            itemCount: images.length,
                            controller:
                                PageController(initialPage: currentPage),
                            onPageChanged: (int page) {
                              setState(() {
                                currentPage = page;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.file(images[index]);
                            },
                          ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    children: [
                      PageIndicator(
                        currentPage: currentPage,
                        totalPages: images.length,
                      ),
                      Showcase(
                        key: context.read<ShowcaseBloc>().keys[3],
                        description:
                            'Add pages to your score with any of the following methods',
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            ActionButton(
                                onPressed: openCamera, text: 'Add From Camera'),
                            ActionButton(
                                onPressed: pickImages, text: 'Add Images'),
                            ActionButton(
                                onPressed: pickPdf, text: 'Import PDF'),
                            ActionButton(
                              onPressed: () {
                                setState(() {
                                  if (images.isEmpty) return;
                                  images.removeAt(currentPage);
                                });
                              },
                              text: 'Delete Current Page',
                              foregroundColor:
                                  Theme.of(context).colorScheme.onError,
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          ],
                        ),
                      ),
                      Showcase(
                        key: context.read<ShowcaseBloc>().keys[4],
                        description: 'Give your score a name',
                        child: Container(
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (isCreating) return;
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/mainscreen', (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onError,
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          Showcase(
                            key: context.read<ShowcaseBloc>().keys[5],
                            description:
                                'Once you\'re finished, submit your score! It will show up in the Score Browser',
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!isValid() || isCreating) {
                                  return;
                                }

                                if (context.mounted) {
                                  setState(() {
                                    isCreating = true;
                                  });
                                  BlocProvider.of<ScoreBrowserBloc>(context)
                                      .add(AddScore(images, scoreName,
                                          finishCallback: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/mainscreen', (route) => false);
                                  }));
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isCreating
                ? Container(
                    color: const Color.fromARGB(137, 104, 104, 104),
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          strokeWidth: 16.0,
                        ),
                      ),
                    ),
                  )
                : Container(),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: totalPages == 0
          ? const Text('Add your first page')
          : Row(
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

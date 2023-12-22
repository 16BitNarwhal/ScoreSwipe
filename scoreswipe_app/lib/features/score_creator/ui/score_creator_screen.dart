import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../common/models/score_model.dart';
import '../../../common/data/local_score_datasource.dart';

class ScoreCreatorScreen extends StatefulWidget {
  const ScoreCreatorScreen({super.key});

  @override
  _ScoreCreatorScreenState createState() => _ScoreCreatorScreenState();
}

class _ScoreCreatorScreenState extends State<ScoreCreatorScreen> {
  List<File> images = [];
  int currentPage = 0;
  String scoreName = '';

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      List<File> pickedImages =
          result.paths.map((path) => File(path!)).toList();
      setState(() {
        images.addAll(pickedImages);
      });
    }
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
            // add from camera, add from gallery, import pdf
            ElevatedButton(
              onPressed: pickImages,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Add Images'),
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
                // images to pdf
                pw.Document pdf = pw.Document();
                for (File image in images) {
                  pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                        child:
                            pw.Image(pw.MemoryImage(image.readAsBytesSync())),
                      );
                    },
                  ));
                }
                Directory dir = await getApplicationSupportDirectory();
                final file = File('${dir.path}/$scoreName.pdf');
                file.writeAsBytesSync(await pdf.save());
                ScoreModel score = ScoreModel.fromPdfFile(file);
                await LocalScoreDataSource.openDatabase();
                await LocalScoreDataSource.insertScore(score);
                await LocalScoreDataSource.closeDatabase();
                file.delete();
                if (context.mounted) {
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

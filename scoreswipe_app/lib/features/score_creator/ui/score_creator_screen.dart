import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ScoreCreatorScreen extends StatefulWidget {
  const ScoreCreatorScreen({super.key});

  @override
  _ScoreCreatorScreenState createState() => _ScoreCreatorScreenState();
}

// TODO: delete page button, add page button, "finish" button
// implement with BLoC?

class _ScoreCreatorScreenState extends State<ScoreCreatorScreen> {
  List<File> images = [];
  int currentPage = 0;

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
            ElevatedButton(
              onPressed: pickImages,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Add Images'),
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

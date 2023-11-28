// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:file_picker/file_picker.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key, this.title = ""}) : super(key: key);

//   final String title;

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   late List<CameraDescription> cameras;

//   String fileText = "";
//   bool turningPage = false;

//   final faceDetector = FaceDetector(options: FaceDetectorOptions());

//   void _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         allowMultiple: false);

//     if (result != null && result.files.single.path != null) {
//       // PlatformFile file = result.files.first;

//       File file = File(result.files.single.path!);
//       fileText = file.path;

//       if (context.mounted) {
//         Navigator.pushNamed(context, '/pdfscreen',
//             arguments: {'fileText': fileText});
//       }
//     } else {
//       // User canceled the picker
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.secondary,
//       // appBar: AppBar(
//       //   toolbarHeight: 200,
//       //   backgroundColor: Theme.of(context).colorScheme.secondary,
//       //   actionsIconTheme: IconThemeData(
//       //       color: Theme.of(context).colorScheme.onBackground, size: 36),
//       // ),
//       body: Column(
//         children: [
//           const MainHeader(),
//           Container(
//             color: Theme.of(context).colorScheme.background,
//             height: MediaQuery.of(context).size.height - 300,
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: _pickFile,
//                 child: Text(
//                   'Pick File',
//                   style: TextStyle(
//                       color: Theme.of(context).colorScheme.onBackground),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MainHeader extends StatelessWidget {
//   const MainHeader({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 64, right: 32, left: 32),
//       height: 300,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               Text(
//                 'Score Swipe',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: Theme.of(context).colorScheme.onBackground),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: const Icon(size: 36, Icons.search_outlined),
//                 color: Theme.of(context).colorScheme.onBackground,
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/configscreen');
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(size: 36, Icons.account_circle_outlined),
//                 color: Theme.of(context).colorScheme.onBackground,
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/configscreen');
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'filemanager.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  final String title;

  const MainScreen({Key? key, this.title = ""}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double tabHeight = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        tabHeight = MediaQuery.of(context).size.height * 0.75;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SafeArea(
        child: Stack(
          children: [
            AppBarView(),
            MusicSheetsView(tabHeight: tabHeight),
          ],
        ),
      ),
    );
  }
}

class AppBarView extends StatelessWidget {
  final int tabHeight;
  const AppBarView({super.key, this.tabHeight = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      height: MediaQuery.of(context).size.height - tabHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Some',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          height: 0.3),
                    ),
                    Text(
                      'Music',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Handle search icon tap
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () {
                        // Handle account icon tap
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MusicSheetsView extends StatefulWidget {
  final double tabHeight;
  const MusicSheetsView({super.key, this.tabHeight = 0});

  @override
  _MusicSheetsViewState createState() => _MusicSheetsViewState();
}

class _MusicSheetsViewState extends State<MusicSheetsView> {
  late List<File> scoreFiles = [];

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      bottom: 0,
      left: 0,
      right: 0,
      height: widget.tabHeight,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: EdgeInsets.all(32),
          child: FutureBuilder(
            future: FileManager.listAllPdfFiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              scoreFiles = snapshot.data as List<File>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        'Music',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                      Text(
                        'Sort Most Recent',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w400),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down,
                            size: 32,
                            color: Theme.of(context).colorScheme.onBackground),
                        onPressed: () {
                          // Handle sort icon tap
                        },
                      ),
                    ],
                  ),
                  for (File scoreFile in scoreFiles)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MusicSheetCard(scoreFile: scoreFile),
                    ),
                  // expand to leftover screen size in vertical scrolling
                  SizedBox(
                      height: widget.tabHeight -
                          64 -
                          32 -
                          scoreFiles.length * (200 + 8 * 2)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MusicSheetCard extends StatelessWidget {
  const MusicSheetCard({
    super.key,
    // required this.i,
    required this.scoreFile,
  });

  final File scoreFile;

  Widget deleteDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${scoreFile.path.split('/').last}?"),
      content: Text(
        "This action cannot be undone.",
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Delete"),
          onPressed: () {
            FileManager.systemDeleteFile(scoreFile);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (context.mounted) {
          Navigator.pushNamed(context, '/pdfscreen',
              arguments: {'file': scoreFile});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 2,
          ),
        ),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // image with top borders
            Image.asset(
              'assets/images/placeholder.png',
              fit: BoxFit.cover,
              height: 160,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                scoreFile.path.split('/').last,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

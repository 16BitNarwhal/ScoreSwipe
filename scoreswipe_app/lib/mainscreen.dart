import 'package:flutter/material.dart';
import 'filemanager.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  final String title;

  const MainScreen({Key? key, this.title = ""}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
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
            ActionsButton(),
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
  State<MusicSheetsView> createState() => _MusicSheetsViewState();
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

class ActionsButton extends StatefulWidget {
  const ActionsButton({super.key});

  @override
  State<ActionsButton> createState() => _ActionsButtonState();
}

class _ActionsButtonState extends State<ActionsButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      right: 32,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(32),
        ),
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              elevation: 500,
              builder: (context) {
                return SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.file_upload),
                        title: Text('Upload PDF'),
                        onTap: () {
                          FileManager.systemPickAndUploadFile();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Take Photo'),
                        onTap: () {
                          // TODO: photos feature
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

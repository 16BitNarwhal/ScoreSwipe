import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'filemanager.dart';
import 'scoredata.dart';
import 'editform.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double tabHeight = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
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
            const AppBarView(),
            MusicSheetsView(tabHeight: tabHeight),
          ],
        ),
      ),
      floatingActionButton: const ActionsButton(),
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
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
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
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Handle search icon tap
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.account_circle),
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
  late List<ScoreData> scores = [];

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      bottom: 0,
      left: 0,
      right: 0,
      height: widget.tabHeight,
      child: RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: const EdgeInsets.all(32),
            child: FutureBuilder(
              future: ScoreData.getAllScores(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                scores = snapshot.data as List<ScoreData>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Scores',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
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
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          onPressed: () {
                            // Handle sort icon tap
                          },
                        ),
                      ],
                    ),
                    for (ScoreData scoreData in scores)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MusicSheetCard(
                            scoreData: scoreData, refresh: refresh),
                      ),
                    // TODO: super hacky solution
                    (widget.tabHeight -
                                64 -
                                32 -
                                scores.length * (200 + 8 * 2) >
                            0)
                        ? SizedBox(
                            height: widget.tabHeight -
                                64 -
                                32 -
                                scores.length * (200 + 8 * 2))
                        : Container(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MusicSheetCard extends StatelessWidget {
  const MusicSheetCard({
    super.key,
    required this.scoreData,
    required this.refresh,
  });

  final ScoreData scoreData;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            if (context.mounted) {
              scoreData.setLastOpened();
              Navigator.pushNamed(context, '/pdfscreen',
                  arguments: {'file': scoreData.pdfFile});
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
                Expanded(
                  child: FutureBuilder(
                      // TODO: put this into scoreData?
                      future: FileManager.getThumbnail(scoreData.pdfFile,
                          width: 100, height: 160),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? snapshot.data as RawImage
                            : Container();
                      }),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    scoreData.title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
        FavoriteButton(scoreData: scoreData),
        EditButton(scoreData: scoreData, refresh: refresh),
      ],
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.scoreData});

  final ScoreData scoreData;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.scoreData.toggleFavorite();
          });
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
          height: 40,
          width: 40,
          child: Icon(
            widget.scoreData.isFavorite ? Icons.star : Icons.star_border,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final ScoreData scoreData;
  final Function refresh;

  const EditButton({Key? key, required this.scoreData, required this.refresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                  child: EditForm(scoreData: scoreData, refresh: refresh));
            },
          );
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
          height: 40,
          width: 40,
          child: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

// class EditButton extends StatefulWidget {
//   const EditButton({super.key, required this.scoreData});

//   final ScoreData scoreData;

//   @override
//   State<EditButton> createState() => _EditButtonState();
// }

// class _EditButtonState extends State<EditButton> {
//   String titleController = "";
//   List<String> genresController = [];

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 8,
//       right: 8,
//       child: GestureDetector(
//         onTap: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text(
//                   'Edit Score',
//                   style:
//                       TextStyle(color: Theme.of(context).colorScheme.primary),
//                 ),
//                 backgroundColor: Theme.of(context).colorScheme.background,
//                 content: SingleChildScrollView(
//                   child: ListBody(
//                     children: <Widget>[
//                       TextField(
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).colorScheme.primary),
//                           ),
//                           labelText: 'Title',
//                           labelStyle: TextStyle(
//                               color: Theme.of(context).colorScheme.primary),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             titleController = value;
//                           });
//                         },
//                         style: TextStyle(
//                             color: Theme.of(context).colorScheme.primary),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).colorScheme.primary),
//                           ),
//                           labelText: 'Genres',
//                           labelStyle: TextStyle(
//                               color: Theme.of(context).colorScheme.primary),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             genresController =
//                                 value.split(',').map((e) => e.trim()).toList();
//                           });
//                         },
//                         style: TextStyle(
//                             color: Theme.of(context).colorScheme.primary),
//                       ),
//                     ],
//                   ),
//                 ),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       widget.scoreData.deleteScore();
//                       Navigator.of(context).pop();
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: Theme.of(context).colorScheme.error,
//                     ),
//                     child: const Text('Delete', style: TextStyle(fontSize: 20)),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: Theme.of(context).colorScheme.primary,
//                     ),
//                     child: const Text('Cancel', style: TextStyle(fontSize: 20)),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       widget.scoreData.title = titleController;
//                       widget.scoreData.genres = genresController;
//                       widget.scoreData.saveMetadata();
//                       Navigator.of(context).pop();
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: Theme.of(context).colorScheme.primary,
//                     ),
//                     child: const Text('Save', style: TextStyle(fontSize: 20)),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class ActionsButton extends StatefulWidget {
  const ActionsButton({super.key});

  @override
  State<ActionsButton> createState() => _ActionsButtonState();
}

class _ActionsButtonState extends State<ActionsButton> {
  SpeedDialChild buildSpeedDialChild({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SpeedDialChild(
      child: Icon(icon),
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      labelBackgroundColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      label: label,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      animatedIcon: AnimatedIcons.menu_close, // custom add_close?
      animatedIconTheme: const IconThemeData(size: 28.0),
      curve: Curves.easeInOut,
      tooltip: 'Add Score',
      spaceBetweenChildren: 8.0,
      childrenButtonSize: const Size(64, 64),
      buttonSize: const Size(80, 80),
      children: [
        buildSpeedDialChild(
          icon: Icons.upload_file,
          label: 'Upload PDF',
          onTap: () {
            FileManager.systemPickAndUploadFile();
            Navigator.pop(context);
          },
        ),
        buildSpeedDialChild(
          icon: Icons.photo_library,
          label: 'Upload Photos',
          onTap: () {
            // TODO: photos feature
          },
        ),
        buildSpeedDialChild(
          icon: Icons.camera_alt,
          label: 'Take Photos',
          onTap: () {
            // TODO: photos feature
          },
        ),
      ],
    );
  }
}

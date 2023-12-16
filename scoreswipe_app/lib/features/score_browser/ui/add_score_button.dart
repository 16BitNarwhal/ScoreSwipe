part of 'score_browser_screen.dart';

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

  // TODO: move to a separate class / make it work in the BLoC
  void addFileFromPicker() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (file == null || file.files.isEmpty) {
      Logger().i('No files selected');
      return;
    }

    List<Future<void>> futures = [];
    for (PlatformFile platformFile in file.files) {
      final score = ScoreModel.fromPdfFile(File(platformFile.path!));
      futures
          .add(score.createThumbnailImage()); // TODO: move to a separate class
      if (context.mounted) {
        BlocProvider.of<ScoreBrowserBloc>(context).add(AddScore(score));
      }
    }
    await Future.wait(futures);
    Logger().i('Added ${file.files.length} scores');
    if (context.mounted) {
      BlocProvider.of<ScoreBrowserBloc>(context).add(LoadScores());
    }
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
            addFileFromPicker();
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

part of 'score_browser_screen.dart';

class MusicSheetCard extends StatelessWidget {
  const MusicSheetCard({
    super.key,
    required this.score,
    required this.refresh,
  });

  final ScoreModel score;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            if (context.mounted) {
              // TODO: open pdf BlocProvider.of<ScoreBrowserBloc>(context).add(OpenPdf(score));
              // Logger().i('Opening ${score.scoreName} ${score.pdfFile.path}');
              Navigator.pushNamed(context, '/pdfscreen',
                  arguments: {'file': score.pdfFile});
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
                      future: FileManager.getThumbnail(score.pdfFile,
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
                    score.scoreName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
        FavoriteButton(score: score),
        EditButton(score: score, refresh: refresh),
      ],
    );
  }
}

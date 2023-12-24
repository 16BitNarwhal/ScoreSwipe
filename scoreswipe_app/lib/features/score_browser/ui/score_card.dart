part of 'score_browser_screen.dart';

class MusicSheetCard extends StatelessWidget {
  const MusicSheetCard({
    super.key,
    required this.score,
  });

  final ScoreModel score;

  @override
  Widget build(BuildContext context) {
    Logger().i('Building MusicSheetCard for ${score.scoreName}');
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            if (context.mounted) {
              // TODO: open pdf BlocProvider.of<ScoreBrowserBloc>(context).add(OpenPdf(score));

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
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.file(
                      score.thumbnailImage,
                      fit: BoxFit.cover,
                    ),
                  ),
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
        EditButton(score: score),
      ],
    );
  }
}

part of 'score_browser_screen.dart';

class MusicSheetCard extends StatelessWidget {
  const MusicSheetCard({
    super.key,
    required this.score,
  });

  final ScoreModel score;

  void _openPdf(BuildContext context) {
    if (context.mounted) {
      // TODO: open pdf BlocProvider.of<ScoreBrowserBloc>(context).add(OpenPdf(score));

      Navigator.pushNamed(context, '/pdfscreen',
          arguments: {'file': score.pdfFile});
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger().i('Building MusicSheetCard for ${score.scoreName}');
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
          ),
          height: 240,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 240,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      _openPdf(context);
                    },
                    child: Image.file(
                      score.thumbnailImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                child: Text(
                  score.scoreName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Row(
            children: [
              CardButton(
                score: score,
                icon: const Icon(Icons.open_in_new),
                onTap: () async {
                  _openPdf(context);
                },
              ),
              CardButton(
                score: score,
                icon: Icon(score.isFavorite ? Icons.star : Icons.star_border),
                onTap: () {
                  BlocProvider.of<ScoreBrowserBloc>(context)
                      .add(ToggleFavorite(score));
                },
              ),
              CardButton(
                score: score,
                icon: const Icon(Icons.more_vert),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(child: EditForm(score: score));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

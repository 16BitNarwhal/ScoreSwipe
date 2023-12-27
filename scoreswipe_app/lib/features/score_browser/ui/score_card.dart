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

      Navigator.pushNamed(context, '/pdfscreen', arguments: {'score': score});
    }
  }

  @override
  Widget build(BuildContext context) {
    // convert lastOpened to local time and format it
    score.lastOpened = score.lastOpened.toLocal();
    String lastOpened =
        "Last Opened: ${DateFormat.yMd().add_jm().format(score.lastOpened)}";

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              score.scoreName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              lastOpened,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ],
      ),
    );
  }
}

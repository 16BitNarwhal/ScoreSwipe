part of 'score_browser_screen.dart';

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

part of 'score_browser_screen.dart';

class MusicSheetsView extends StatefulWidget {
  const MusicSheetsView({super.key});

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
    return RefreshIndicator(
      onRefresh: () async {
        refresh();
      },
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                            color: Theme.of(context).colorScheme.onBackground),
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

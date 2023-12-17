part of 'score_browser_screen.dart';

class MusicSheetsView extends StatelessWidget {
  const MusicSheetsView({super.key});

  void refresh(context) {
    BlocProvider.of<ScoreBrowserBloc>(context).add(LoadScores());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        refresh(context);
        Logger().i('Refreshed');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
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
                BlocBuilder<ScoreBrowserBloc, ScoreBrowserState>(
                  bloc: BlocProvider.of<ScoreBrowserBloc>(context)
                    ..add(LoadScores()),
                  builder: (context, state) {
                    return state.scores.isEmpty
                        ? const Center(
                            child: Text(
                              'No scores found',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : Column(
                            children: [
                              for (ScoreModel score in state.scores)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: MusicSheetCard(score: score),
                                ),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

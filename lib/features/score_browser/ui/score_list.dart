part of 'score_browser_screen.dart';

class MusicSheetsView extends StatelessWidget {
  const MusicSheetsView({super.key});

  void refresh(context) {
    BlocProvider.of<ScoreBrowserBloc>(context).add(LoadScores());
  }

  Widget _sortWidget(BuildContext context) {
    String sortText = 'Sort by Last Opened';

    SortBy sortBy = BlocProvider.of<ScoreBrowserBloc>(context).state.sortBy;
    switch (sortBy) {
      case SortBy.name:
        sortText = 'Sort by Name';
        break;
      case SortBy.lastOpened:
        sortText = 'Sort by Last Opened';
        break;
      case SortBy.uploaded:
        sortText = 'Sort by Uploaded';
        break;
    }

    IconData sortIcon = BlocProvider.of<ScoreBrowserBloc>(context).state.reverse
        ? Icons.arrow_drop_down
        : Icons.arrow_drop_up;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            SortBy sortBy =
                BlocProvider.of<ScoreBrowserBloc>(context).state.sortBy;
            switch (sortBy) {
              case SortBy.name:
                BlocProvider.of<ScoreBrowserBloc>(context)
                    .add(const SortScores(SortBy.lastOpened));
                break;
              case SortBy.lastOpened:
                BlocProvider.of<ScoreBrowserBloc>(context)
                    .add(const SortScores(SortBy.uploaded));
                break;
              case SortBy.uploaded:
                BlocProvider.of<ScoreBrowserBloc>(context)
                    .add(const SortScores(SortBy.name));
                break;
            }
          },
          child: Text(
            sortText,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            BlocProvider.of<ScoreBrowserBloc>(context)
                .add(const ReverseScores());
          },
          icon: Icon(sortIcon,
              size: 32, color: Theme.of(context).colorScheme.onBackground),
        ),
      ],
    );
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
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      'Scores',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    BlocBuilder<ScoreBrowserBloc, ScoreBrowserState>(
                      builder: (context, state) {
                        return _sortWidget(context);
                      },
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                sliver: BlocBuilder<ScoreBrowserBloc, ScoreBrowserState>(
                  bloc: BlocProvider.of<ScoreBrowserBloc>(context)
                    ..add(LoadScores()),
                  builder: (context, state) {
                    return state.scores.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: Text(
                                'No scores found',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                        : SliverGrid.count(
                            crossAxisCount:
                                MediaQuery.of(context).size.width ~/ 280,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                            children: [
                              for (ScoreModel score in state.scores)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MusicSheetCard(score: score),
                                ),
                            ],
                          );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

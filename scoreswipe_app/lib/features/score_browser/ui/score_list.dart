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
      case SortBy.name || SortBy.nameReverse:
        sortText = 'Sort by Name';
        break;
      case SortBy.lastOpened || SortBy.lastOpenedReverse:
        sortText = 'Sort by Last Opened';
        break;
      case SortBy.uploaded || SortBy.uploadedReverse:
        sortText = 'Sort by Uploaded';
        break;
    }

    IconData sortIcon = sortBy.toString().contains('Reverse')
        ? Icons.arrow_drop_down
        : Icons.arrow_drop_up;

    return GestureDetector(
      onTap: () {
        SortBy sortBy = BlocProvider.of<ScoreBrowserBloc>(context).state.sortBy;
        switch (sortBy) {
          case SortBy.name:
            BlocProvider.of<ScoreBrowserBloc>(context)
                .add(const SortScores(SortBy.nameReverse));
            break;
          case SortBy.nameReverse:
            BlocProvider.of<ScoreBrowserBloc>(context)
                .add(const SortScores(SortBy.lastOpened));
            break;
          case SortBy.lastOpened:
            BlocProvider.of<ScoreBrowserBloc>(context)
                .add(const SortScores(SortBy.lastOpenedReverse));
            break;
          case SortBy.lastOpenedReverse:
            BlocProvider.of<ScoreBrowserBloc>(context)
                .add(const SortScores(SortBy.uploaded));
            break;
          case SortBy.uploaded:
            BlocProvider.of<ScoreBrowserBloc>(context)
                .add(const SortScores(SortBy.uploadedReverse));
            break;
          case SortBy.uploadedReverse:
            BlocProvider.of<ScoreBrowserBloc>(context)
                .add(const SortScores(SortBy.name));
            break;
        }
      },
      child: Row(
        children: [
          Text(
            sortText,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(width: 8),
          Icon(sortIcon,
              size: 32, color: Theme.of(context).colorScheme.onBackground),
        ],
      ),
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
            // crossAxisAlignment: CrossAxisAlignment.stretch,
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
              SliverToBoxAdapter(
                child: BlocBuilder<ScoreBrowserBloc, ScoreBrowserState>(
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
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
